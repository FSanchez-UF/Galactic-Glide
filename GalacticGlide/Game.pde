// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Game.pde
// Description: Game.pde is the game manager for Galactic Glide. It handles 
//              the game, player, enemy, obstacle, and collision logic. It 
//              also keeps track of scoring.

import sprites.utils.*;
import sprites.*;
import java.util.Queue;
import java.util.LinkedList;

class Game {
  PApplet app;                 // App the Game belongs to
  Clock gameClock;
  
  StopWatch sw;                // StopWatch provided by Sprite library
  Player p;                    // Player entity
  ArrayList<Entity> entities;  // All entities including player
  
  int score;                   // Score tracker
  boolean active;              // Tells whether the game is running or not
  boolean paused;              // Tells whether game is paused or not
  boolean endGame;
  
  Textlabel fps;               // Displays FPS
  Textlabel displayScore;      // Displays current score
  
  Textlabel pSpeed;            // Displays player speed
  Textlabel pPower;            // Displays player power
  Textlabel pFireRate;         // Displays player fire rate
  
  int timeSinceEnemy;          // Time since the last enemy spawn occurred
  int timeSinceObstacle;       // Time since the last obstacle spawn occurred
  int timeSinceBoss;           // Time since the last boss spawn occurred
  int timeSinceScale;          // Time since the last enemy stat scale occurred
  
  int currScale = 0;                                     // Current enemy stat scale
  final float SCALE_INTERVAL = chooseByDiff(80, 60, 40); // How long to wait before scaling automatically (or defeat boss)
  final int MAX_SCALE_TIMES = chooseByDiff(5, 10, 15);   // Maximum number of times to scale
  
  final float MIN_HP_SCALE = 1.0f;                           // Minimum HP scale
  final float MAX_HP_SCALE = chooseByDiff(3.0f, 5.0f, 7.0f); // Maximum HP scale
  float hpScale = MIN_HP_SCALE;                              // Current HP scale
  
  Queue<Powerup> powerupQ;
  
  // Filenames for obstacles
  final String[] obstacleFiles = {
    "Sprites/Asteroids/Asteroid.png", 
    "Sprites/Asteroids/Asteroid1.png",
    "Sprites/Asteroids/Asteroid2.png",
  };
  
  // Filenames for enemies
  final String[] enemyFiles = {
    "Sprites/Ships/Ship1.png",
    "Sprites/Ships/Ship2.png",
    "Sprites/Ships/Ship3.png",
  };
  
  // Filenames for bosses
  final String[] bossFiles = {
    "Sprites/Ships/Ship4.png",
    "Sprites/Ships/Ship5.png",
    "Sprites/Ships/Ship6.png",
  };
  
  /**
   * Constructor.
   */
  Game(PApplet app) {
    images.Load("heart", "heart-sprite.png");
    images.Load("speed", "Powerups/speed.png");
    images.Load("power", "Powerups/power.png");
    images.Load("firerate", "Powerups/firerate.png");
    this.app = app;
    sw = new StopWatch();
    gameClock = new Clock();
    p = new Player(app, "Sprites/player2.png", 1, 1, 1000);
    entities = new ArrayList<Entity>();
    entities.add(p);
    score = 0;
    S4P.collisionAreasVisible = DEBUG;
    powerupQ = new LinkedList<Powerup>(); 
    cp5();
    endGame = false;
  }
  
  /**
   * Updates the game state frame by frame.
   */
  void update() {
    // Update fps every 20 frames
    if (frameCount % 20 == 0) {
      fps.setText("FPS: " + (int)frameRate);
    }
    displayScore.setText("Score: " + score); // Update score

    if (!active || paused) {
      return;
    }
    p.handleSpaceBar();                      // Handle continuous shooting
    p.constraintMovement();                  // Constrain player movement within screen
    p.updateStats();                         // Update power up stats
    enemyAI();                               // Enemy AI track player and shoot
    handleSpawns();                          // Spawn enemies and obstacles
    processCollisions();
    S4P.updateSprites(sw.getElapsedTime());
    cleanDeadEntities();
      
    while (!powerupQ.isEmpty()) {
      entities.add(powerupQ.remove());
    }
    
    // Scale difficulty over time
    if (gameClock.time() - timeSinceScale >= 60*1000) {
      updateScale(currScale+1);
    }
  }
  
  /** 
   * Displays the game sprites
   */
  void display() {
    tint(255, 255, 255);
    background(images.Get("game_backgrd"));
    if (!active) {
      return;
    }
    S4P.drawSprites();
    pushMatrix();
      scale(0.6);
      tint(255, 255, 255);
      image(images.Get("speed"), pSpeed.getPosition()[0]/0.6 - 35, pSpeed.getPosition()[1] + 30);
      image(images.Get("power"), pPower.getPosition()[0]/0.6 - 35, pPower.getPosition()[1] + 30);
      image(images.Get("firerate"), pFireRate.getPosition()[0]/0.6 - 35, pFireRate.getPosition()[1] + 30);
    popMatrix();
    // Display player lives
    for(int i = 0; i < p.playerHealth; i++) {
      image(images.Get("heart"), (i*40)+30, (int)height-30);
    }
    
    if (endGame) {
      menu.displayEndgame();
    }
    else if (paused) {
      menu.displayPause();  
    }
  }
  
  /** 
   * Checks whether any collisions are occuring
   */
  void processCollisions() {
    for (Entity e1 : entities) {
      if (e1.isDead())
        continue;
      
      for (Entity e2 : entities) {
        if (e2.isDead())
          continue;
        
        if (e1 != e2 && e1.pp_collision(e2)) {
          e1.handleCollision(e2);
          e2.handleCollision(e1);
        }
      }
    }
  }
  
  /** 
   * Pauses game state
   */
  void setPause(boolean pause) {
    paused = pause;
  }
  
  /** 
   * Handles key presses. To be called by keyPressed().
   */
  void handleKeyPress() {
    if (!active)
      return;
    p.handleKeyPress();
  }
  
  /** 
   * Handles key releases. To be called by keyReleased().
   */
  void handleKeyRelease() {
    if (!active)
      return;
    p.handleKeyRelease();
  }
  
  /** 
   * Starts the game.
   */
  void startGame() {
    active = true;
    fps.show();
    displayScore.show();
    pSpeed.show();
    pPower.show();
    pFireRate.show();
    gameClock.start();
  }
  
  /** 
   * Quits the game.
   */
  void quitGame() {
    active = false;
    gameClock.stop();
    hideCP5();
    app.tint(255); 
    for (Entity entity : entities) {
      S4P.deregisterSprite(entity);  
    }
  }
  
  /** 
   * Hide game cp5 elements
   */
  void hideCP5() {
    fps.hide();
    displayScore.hide();
    pSpeed.hide();
    pPower.hide();
    pFireRate.hide();
    menu.restart.setPosition(width/2-150, 375);
    menu.quit.setPosition(width/2-150, 485);
  }
  
  /**
   * Spawns obstacles/enemies over a gradually steeper interval.
   */
  void handleSpawns() {
    // Spawn 1-3 enemies every 3 seconds
    if (gameClock.time() - timeSinceEnemy >= 3*1000) {
      int numEnemies = (int)random(1,3);
      for (int i = 0; i < numEnemies; ++i)
        spawnRandomEnemy();
      timeSinceEnemy = gameClock.time();
    }
    
    // Spawn 1-3 obstacles every 5 seconds
    if (gameClock.time() - timeSinceObstacle >= 5*1000) {
      int numObstacles = (int)random(1,3);
      for (int i = 0; i < numObstacles; ++i)
        spawnRandomObstacle();
      timeSinceObstacle = gameClock.time();
    }
    
    // Spawn a boss every 30 seconds
    if (gameClock.time() - timeSinceBoss >= 30*1000) {
      spawnRandomBoss();
      timeSinceBoss = gameClock.time();
    }    
  }
  
  /**
   * Spawns a random obstacle.
   * Should take into account difficulty and time elapsed.
   */
  void spawnRandomObstacle() {
    int rand = (int)random(0, obstacleFiles.length);
    spawnObstacle(obstacleFiles[rand], 5, 30, 50, true);
  }
  
  /** 
   * Spawns an obstacle.
   */
  void spawnObstacle(String imgFilename, float hp, float minVel, float maxVel, boolean isEnemy) {
    Obstacle o = new Obstacle(app, imgFilename, 1, 1, 600, isEnemy, false);
    o.setHp(hp*hpScale);
    o.setVelXY(-random(minVel, maxVel), 0);
    entities.add(o);
  }
  
  /**
   * Spawns a random enemy.
   * Should take into account difficulty and time elapsed. 
   */
  void spawnRandomEnemy() {
    int rand = (int)random(0, enemyFiles.length);
    float hp = 3;
    float minVel = 120;
    float maxVel = 160;
    
    // Construct enemy
    switch(rand) {
      // Enemy 1: Fast
      case 0:
        hp = 2;
        minVel = 200;
        maxVel = 240;
        break;
      // Enemy 2: Average (use default)
      case 1:
        break;
      // Enemy 3: Heavy
      case 2:
        hp = 5;
        minVel = 80;
        maxVel = 100;
        break;
    }
    
    spawnEnemy(enemyFiles[rand], hp, minVel, maxVel, rand+1);
  }
  
  /**
   * Spawns a random boss.
   * Should take into account difficulty and time elapsed. 
   */
  void spawnRandomBoss() {
    int rand = (int)random(0, bossFiles.length);
    float hp = 20;
    float minVel = 80;
    float maxVel = 100;
    
    // Construct enemy
    switch(rand) {
      // Enemy 1: Fast
      case 0:
        hp = 10;
        minVel = 120;
        maxVel = 140;
        break;
      // Enemy 2: Average (use default)
      case 1:
        break;
      // Enemy 3: Heavy
      case 2:
        hp = 30;
        minVel = 40;
        maxVel = 60;
        break;
    }
    
    spawnEnemy(bossFiles[rand], hp, minVel, maxVel, rand+4);
  }
  
  /** 
   * Spawns an enemy.
   */
  void spawnEnemy(String imgFilename, float hp, float minVel, float maxVel, int type) {
    Enemy e = new Enemy(app, imgFilename, 1, 1, 750);
    e.setHp(hp*hpScale);
    e.setVelXY(-random(minVel, maxVel), 0);
    e.type = type;
    entities.add(e);
  }
  
  /**
   * Queues a powerup spawn at some enemy.
   * We need to queue because editing the entities array during collision checking
   * causes a ConcurrentModificationException.
   */
  void queuePowerup(PowerupType type, Entity e) {
    Powerup pow = new Powerup(app, type, e);
    powerupQ.add(pow);
  }
  
  /** 
   * Cleans the entities list of all dead or off-screen entities.
   */
  void cleanDeadEntities() {
    entities.removeIf(entity -> (entity.isDead() || (entity.wasOnScreen && !entity.isOnScreen())));
  }
  
  /**
   * Sets the scale/ difficulty of the game
   */
  void updateScale(int newScale) {
    currScale = constrain(newScale, 0, MAX_SCALE_TIMES);
    println("Setting the scale to " + currScale + "!");
    hpScale = map(currScale, 0, MAX_SCALE_TIMES, MIN_HP_SCALE, MAX_HP_SCALE);
    timeSinceScale = gameClock.time();
  }
  
  /**
   * Defines behavior of enemy ships for tracking player and shooting
   */
  void enemyAI() {
    // Track the player
    for (int i = 0; i < entities.size(); i++) {
      Entity e = entities.get(i);
      if (e instanceof Enemy && !e.isDead()) {
        // Enemy flies toward player position at specified y velocity
        Enemy en = (Enemy) e;
        if (en.getY() < p.getY()) {
          en.setVelY(chooseByDiff(40, 60, 80));
        } 
        else if (en.getY() > p.getY()) {
          en.setVelY(chooseByDiff(-40, -60, -80));
        }
        
        // Boss patrols screen
        if (en.type > 3 && en.getX() < width-100) en.patrol = true;
        if (en.type > 3) constrainBoss(en);
        
        // Shoot randomly every min to max seconds (easy=5-7s, normal=4-6s, hard=3-5s)
        int min = chooseByDiff(5, 4, 3);
        int max = chooseByDiff(7, 6, 5);
        if (gameClock.time() - en.timeSinceShoot >= int(random(min,max))*1000) {
          en.spawnProjectile();
          en.timeSinceShoot = gameClock.time();
        }
      }
    }
  }
  
  /**
   * Defines boss behavior for patrolling the screen
   */
  void constrainBoss(Enemy en) {
    if (en.getX() < width-300 && en.patrol) {
      en.setVelX(-en.getVelX());
    }
    else if (en.getX() > width-100 && en.patrol) {
      en.setVelX(-en.getVelX());
    }
  }
  
  /**
   * Checks if cp5 elements already exist, such as when the 
   * game has been restarted or quit during execution
   */
  void cp5() {
    if (cp5.getController("fps") == null) {
      fps =  cp5.addTextlabel("fps")
        .setText("FPS: " + (int)frameRate)
        .setPosition(10, 10)
        .setFont(createFont("Arial", 16))
        .hide();
      ;
    }
    else {
      fps = (Textlabel)cp5.getController("fps");
    }
    
    if (cp5.getController("score") == null) {
      displayScore = cp5.addTextlabel("score")
                     .setText("Score: " + score)
                     .setPosition(10,25)
                     .setFont(createFont("Arial", 16))
                     .hide();
      ;
    }
    else {
      displayScore = (Textlabel)cp5.getController("score");
    }
    
    if (cp5.getController("pSpeed") == null) {
      pSpeed = cp5.addTextlabel("pSpeed")
        .setText("" + p.speed)
        .setPosition(width/2-230, 10)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pSpeed = (Textlabel)cp5.getController("pSpeed");
    }
    
    if (cp5.getController("pPower") == null) {
      pPower = cp5.addTextlabel("pPower")
        .setText("" + p.power)
        .setPosition(width/2, 10)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pPower = (Textlabel)cp5.getController("pPower");
    }
    
    if (cp5.getController("pFireRate") == null) {
      pFireRate = cp5.addTextlabel("pFireRate")
        .setText("" + p.fireRate)
        .setPosition(width/2+200, 10)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pFireRate = (Textlabel)cp5.getController("pFireRate");
    }
  }
}

/**
 * Choose a value by difficulty.
 * Useful for initializing game values based on difficulty.
 * Difficulty is set in GalacticGlide so that creating a new Game
 * updates the variables that depend on difficulty.
 */
<T> T chooseByDiff(T easy, T normal, T hard) {
  switch (difficulty) {
    case 0: return easy;
    case 1: return normal;
    case 2: return hard;
  }
  return normal;
}

// NOTE: use saveStrings() to save scores across different opens (persistent)
