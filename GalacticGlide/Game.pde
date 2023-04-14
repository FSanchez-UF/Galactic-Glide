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
  
  StopWatch sw;                // StopWatch provided by Sprite library
  Player p;                    // Player entity
  ArrayList<Entity> entities;  // All entities including player
  ArrayList<Button> hearts;
  int score;                   // Score tracker
  boolean active;              // Tells whether the game is running or not
  boolean paused;              // Tells whether game is paused or not
  boolean endGame;
  
  Textlabel fps;
  Textlabel displayScore;
  
  int timeSinceEnemy;          // Time since the last enemy spawn occurred
  int timeSinceObstacle;       // Time since the last obstacle spawn occurred
  int timeSinceBoss;           // Time since the last boss spawn occurred
  int timeSinceScale;          // Time since the last enemy stat scale occurred
  
  int gameTime, lastUnpauseTime;      // Keeps game state from changing while paused
  
  int currScale = 0;                  // Current enemy stat scale
  final float SCALE_INTERVAL = 60;    // How long to wait before scaling automatically (or defeat boss)
  final int MAX_SCALE_TIMES = 10;     // Maximum number of times to scale
  
  final float MIN_HP_SCALE = 1.0f;    // Minimum HP scale
  final float MAX_HP_SCALE = 5.0f;    // Maximum HP scale
  float hpScale = MIN_HP_SCALE;       // Current HP scale
  
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
    fps =  cp5.addTextlabel("fps")
      .setText("FPS: " + (int)frameRate)
      .setPosition(10, 10)
      .setFont(createFont("Arial", 16))
      .hide();
    ;
    this.app = app;
    sw = new StopWatch();
    p = new Player(app, "Sprites/player1.png", 1, 1, 1000);
    entities = new ArrayList<Entity>();
    entities.add(p);
    score = 0;
    displayScore = cp5.addTextlabel("score")
                   .setText("Score: " + score)
                   .setPosition(10,25)
                   .setFont(createFont("Arial", 16))
                   .hide();
    ;
    S4P.collisionAreasVisible = DEBUG;
    
    powerupQ = new LinkedList<Powerup>();
    
    hearts = new ArrayList<Button>();
    
    images.Load("heart", "heart-sprite.png");
    for(int i = 0; i < p.playerHealth; i++) {
      hearts.add(cp5.addButton("heart"+i)
            .setImage(images.Get("heart"))
            .setPosition((i*40)+5, (int)height-60)
            .setSize(50, 50)
            .hide()
            );
    }
  }
  
  void restart() {
    entities.clear();
    entities.add(p);
    score = 0;
    S4P.collisionAreasVisible = DEBUG;
    powerupQ.clear();
    hearts.clear();
    for(int i = 0; i < p.playerHealth; i++) {
      hearts.add(cp5.addButton("heart"+i)
            .setImage(images.Get("heart"))
            .setPosition((i*40)+5, (int)height-60)
            .setSize(50, 50)
            .hide()
            );
    }
    active = false;
    currScale = 0;
    hpScale = MIN_HP_SCALE;
  }
  
  /**
   * Updates the game state frame by frame.
   */
  void update() {
    if (!active || paused) {
      return;
    }
    gameTime += millis() - lastUnpauseTime;
    
    background(images.Get("game_backgrd"));
    p.handleSpaceBar();
    if (frameCount % 20 == 0) {
      fps.show();
      fps.setText("FPS: " + (int)frameRate);
    }
    displayScore.show();
    displayScore.setText("Score: " + score);
    if (!active || paused)
      return;
    enemyAI();
    handleSpawns();
    processCollisions();
    S4P.updateSprites(sw.getElapsedTime());
    
    // Clear dead entities every 30 seconds
    if (frameCount % (30*frameRate) == 0)
      cleanDeadEntities();
      
    while (!powerupQ.isEmpty()) {
      entities.add(powerupQ.remove());
    }
      
    for(int i = 0; i < p.playerHealth; i++) {
      hearts.get(i).show();
    }
    
    if (gameTime - timeSinceScale >= 60*1000) {
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
    if (paused) {
      menu.displayPause();  
    }
    else {
      lastUnpauseTime = millis();
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
  }
  
  /** 
   * Quits the game.
   */
  void quitGame() {
    active = false;
  }
  
  /**
   * Spawns obstacles/enemies over a gradually steeper interval.
   */
  void handleSpawns() {
    if (gameTime - timeSinceEnemy >= 3*1000) {
      int numEnemies = (int)random(1,3);
      for (int i = 0; i < numEnemies; ++i)
        spawnRandomEnemy();
      timeSinceEnemy = gameTime;
    }
    
    if (gameTime - timeSinceObstacle >= 5*1000) {
      int numObstacles = (int)random(1,3);
      for (int i = 0; i < numObstacles; ++i)
        spawnRandomObstacle();
      timeSinceObstacle = gameTime;
    }
    
    if (gameTime - timeSinceBoss >= 30*1000) {
      spawnRandomBoss();
      timeSinceBoss = gameTime;
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
    Obstacle o = new Obstacle(app, imgFilename, 1, 1, 600, isEnemy);
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
    
    spawnEnemy(enemyFiles[rand], hp, minVel, maxVel, false);
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
    
    spawnEnemy(bossFiles[rand], hp, minVel, maxVel, true);
  }
  
  /** 
   * Spawns an enemy.
   */
  void spawnEnemy(String imgFilename, float hp, float minVel, float maxVel, boolean isBoss) {
    Enemy e = new Enemy(app, imgFilename, 1, 1, 750);
    e.setHp(hp*hpScale);
    e.setVelXY(-random(minVel, maxVel), 0);
    e.isBoss = isBoss;
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
   * Cleans the entities list of all dead or not visible entities.
   */
  void cleanDeadEntities() {
    entities.removeIf(entity -> (entity.isDead() || !entity.isVisible()));
  }
  
  /**
   * Sets the scale
   */
  void updateScale(int newScale) {
    currScale = constrain(newScale, 0, MAX_SCALE_TIMES);
    println("Setting the scale to " + currScale + "!");
    hpScale = map(currScale, 0, MAX_SCALE_TIMES, MIN_HP_SCALE, MAX_HP_SCALE);
    timeSinceScale = gameTime;
  }
  
  // TO DO: Scale based on enemy type
  void enemyAI() {
    // Track the player
    double playerY = height/2;
    for (int i = 0; i < entities.size(); i++) {
      Entity e = entities.get(i);;
      if (e instanceof Player) {
        Player pl = (Player) e;
        playerY = pl.getY();
      }
      if (e instanceof Enemy && !e.isDead()) {
        Enemy en = (Enemy) e;
        if (en.getY() < playerY) {
          en.setVelY(40);
        } 
        else if (en.getY() > playerY) {
          en.setVelY(-40);
        }
        
        // Shoot randomly every 4-8 sec
        if (millis() - en.timeSinceShoot >= int(random(4,6))*1000) {
          en.spawnProjectile();
          en.timeSinceShoot = millis();
        }
      }
    }
  }
  
  
}

// NOTE: use saveStrings() to save scores across different opens (persistent)
