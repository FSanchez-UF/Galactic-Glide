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
  Clock gameClock;             // Handles game
  Clock bossClock;             // Keeps track of when a boss should spawn
  Clock deathClock;            // Delay for game to play player death
  
  StopWatch sw;                // StopWatch provided by Sprite library
  Player p;                    // Player entity
  ArrayList<Entity> entities;  // All entities including player
  
  int score;                   // Score tracker
  boolean active;              // Tells whether the game is running or not
  boolean paused;              // Tells whether game is paused or not
  boolean endGame;             // Used to display end game state
  boolean highScore;           // Plays high score sound when a new high score is achieved
  
  Textlabel displayFps;        // Displays FPS
  Textlabel displayScore;      // Displays current score
  Textlabel displayTime;       // Displays current score
  
  Textlabel pSpeed;            // Displays player speed
  Textlabel pPower;            // Displays player power
  Textlabel pFireRate;         // Displays player fire rate
  Textlabel pScoreMult;        // Displays player score multiplier
  Textlabel pShots;            // Displays number of shots when doing limited shots
  
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
  ArrayList<Animation> animations;
  
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
  

  //-------------------------------- Function: Constructor ---------------------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  Game(PApplet app) {
    images.Load("heart", "heart-sprite.png");
    images.Load("speed", "Powerups/speed.png");
    images.Load("power", "Powerups/power.png");
    images.Load("firerate", "Powerups/firerate.png");
    images.Load("score", "Powerups/score.png");
    images.Load("shot", "Lasers/01.png");
    this.app = app;
    sw = new StopWatch();
    gameClock = new Clock();
    bossClock = new Clock();
    deathClock = new Clock();
    p = new Player(app, "Sprites/player1.png", 1, 1, 1000);
    entities = new ArrayList<Entity>();
    entities.add(p);
    score = 0;
    S4P.collisionAreasVisible = DEBUG;
    powerupQ = new LinkedList<Powerup>(); 
    cp5();
    endGame = false;
    highScore = false;
    animations = new ArrayList<Animation>();
  }
  //----------------------------------- Constructor End ------------------------------------//
  
  
  //----------------------------------- Function: Update -----------------------------------//
  /**
   * Updates the game state frame by frame.
   */
  void update() {
    // Update fps every 20 frames
    if (frameCount % 20 == 0) {
      displayFps.setText("FPS: " + (int)frameRate);
    }
    displayScore.setText("Score: " + score);                // Update score
    displayTime.setText("Time: " + convertSecondsToText()); // Update time

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
  //-------------------------------------- Update End --------------------------------------//
  
  
  //----------------------------------- Function: Display ----------------------------------//
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
      image(images.Get("score"), pScoreMult.getPosition()[0]/0.6 - 35, pScoreMult.getPosition()[1] + 30);
    popMatrix();
    if (p.doLimitedShots)
      image(images.Get("shot"), pShots.getPosition()[0] - 20, pShots.getPosition()[1] + 12);
      
    // Display player lives
    for(int i = 0; i < p.playerHealth; i++) {
      image(images.Get("heart"), (i*40)+30, (int)height-30);
    }
    
    for (int i = 0; i < animations.size(); i++) {
       animations.get(i).isAnimating();
       if(!animations.get(i).isPlaying) {
         animations.remove(i);
       }
    }
    
    if (endGame && animations.size() == 0 && deathClock.time() >= 2500) {
      menu.displayEndgame();
      deathClock.stop();
    }
    else if (paused) {
      menu.displayPause();  
    }
    
  }
  //------------------------------------- Display End --------------------------------------//
  
  
  //------------------------------ Function: ProcessCollisions -----------------------------//
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
  //--------------------------------- ProcessCollisions End --------------------------------//
  
  
  //------------------------------- Function: HandleKeyPress -------------------------------//
  /** 
   * Handles key presses. To be called by keyPressed().
   */
  void handleKeyPress() {
    if (!active)
      return;
    p.handleKeyPress();
  }
  //---------------------------------- HandleKeyPress End ----------------------------------//
  
  
  //------------------------------ Function: HandleKeyRelease ------------------------------//
  /** 
   * Handles key releases. To be called by keyReleased().
   */
  void handleKeyRelease() {
    if (!active)
      return;
    p.handleKeyRelease();
  }
  //--------------------------------- HandleKeyRelease End ---------------------------------//
  
  
  //---------------------------------- Function: StartGame ---------------------------------//
  /** 
   * Starts the game.
   */
  void startGame() {
    active = true;
    displayFps.show();
    displayScore.show();
    displayTime.show();
    pSpeed.show();
    pPower.show();
    pFireRate.show();
    pScoreMult.show();
    if (p.doLimitedShots)
      pShots.show();
    gameClock.start();
    bossClock.start();
  }
  //------------------------------------- StartGame End ------------------------------------//
  
  
  //----------------------------------- Function: QuitGame ---------------------------------//
  /** 
   * Quits the game.
   */
  void quitGame() {
    active = false;
    gameClock.stop();
    bossClock.stop();
    hideCP5();
    app.tint(255); 
    for (Entity entity : entities) {
      S4P.deregisterSprite(entity);  
    }
  }
  //------------------------------------- QuitGame End -------------------------------------//
  
  
  //----------------------------------- Function: HideCP5 ----------------------------------//
  /** 
   * Hide game cp5 elements
   */
  void hideCP5() {
    displayFps.hide();
    displayScore.hide();
    displayTime.hide();
    pSpeed.hide();
    pPower.hide();
    pFireRate.hide();
    pScoreMult.hide();
    pShots.hide();
    menu.restart.setPosition(width/2-150, 375);
    menu.quit.setPosition(width/2-150, 485);
  }
  //-------------------------------------- HideCP5 End -------------------------------------//
  
  
  //--------------------------------- Function: HandleSpawns -------------------------------//
  /**
   * Spawns obstacles/enemies over a gradually steeper interval.
   */
  void handleSpawns() {
    // Spawn 1-3 enemies every 3-5 seconds based on difficulty
    if (gameClock.time() - timeSinceEnemy >= chooseByDiff(4, 3, 2)*1000) {
      int numEnemies = (int)random(1,3);
      for (int i = 0; i < numEnemies; ++i)
        spawnRandomEnemy();
      timeSinceEnemy = gameClock.time();
    }
    
    // Spawn 1-3 obstacles every 5-7 seconds based on difficulty
    if (gameClock.time() - timeSinceObstacle >= chooseByDiff(7, 6, 5)*1000) {
      int numObstacles = (int)random(1,3);
      for (int i = 0; i < numObstacles; ++i)
        spawnRandomObstacle();
      timeSinceObstacle = gameClock.time();
    }
    
    // Spawn a boss every 30 seconds
    if (bossClock.time() >= 30*1000) {
      spawnRandomBoss();
      bossClock.reset();
      bossClock.stop();
    }    
  }
  //------------------------------------ HandleSpawns End ----------------------------------//
  
  
  //----------------------------- Function: SpawnRandomObstacle ----------------------------//
  /**
   * Spawns a random obstacle.
   * Should take into account difficulty and time elapsed.
   */
  void spawnRandomObstacle() {
    int rand = (int)random(0, obstacleFiles.length);
    spawnObstacle(obstacleFiles[rand], 5, 30, 50, true);
  }
  //-------------------------------- SpawnRandomObstacle End -------------------------------//
  
  
  //-------------------------------- Function: SpawnObstacle -------------------------------//
  /** 
   * Spawns an obstacle.
   */
  void spawnObstacle(String imgFilename, float hp, float minVel, float maxVel, boolean isEnemy) {
    Obstacle o = new Obstacle(app, imgFilename, 1, 1, 600, isEnemy, false);
    o.setHp(hp*hpScale);
    o.setVelXY(-random(minVel, maxVel), 0);
    entities.add(o);
  }
  //----------------------------------- SpawnObstacle End ----------------------------------//
  
  
  //------------------------------ Function: SpawnRandomEnemy ------------------------------//
  /**
   * Spawns a random enemy.
   * Should take into account difficulty and time elapsed. 
   */
  void spawnRandomEnemy() {
    int rand = (int)random(0, enemyFiles.length);
    float hp = chooseByDiff(3f, 3.5f, 4f);
    float minVel = 120;
    float maxVel = 160;
    
    // Construct enemy
    switch(rand) {
      // Enemy 1: Fast
      case 0:
        hp = chooseByDiff(2f, 2.5f, 3f);
        minVel = 200;
        maxVel = 240;
        break;
      // Enemy 2: Average (use default)
      case 1:
        break;
      // Enemy 3: Heavy
      case 2:
        hp = chooseByDiff(4f, 4.5f, 5f);
        minVel = 80;
        maxVel = 100;
        break;
    }
    
    spawnEnemy(enemyFiles[rand], hp, minVel, maxVel, rand+1);
  }
  //--------------------------------- SpawnRandomEnemy End ---------------------------------//
  
  
  //------------------------------- Function: SpawnRandomBoss ------------------------------//
  /**
   * Spawns a random boss.
   * Should take into account difficulty and time elapsed. 
   */
  void spawnRandomBoss() {
    int rand = (int)random(0, bossFiles.length);
    float hp = chooseByDiff(15, 20, 25);
    float minVel = 80;
    float maxVel = 100;
    
    // Construct enemy
    switch(rand) {
      // Enemy 1: Fast
      case 0:
        hp = chooseByDiff(10, 15, 20);
        minVel = 120;
        maxVel = 140;
        break;
      // Enemy 2: Average (use default)
      case 1:
        break;
      // Enemy 3: Heavy
      case 2:
        hp = chooseByDiff(20, 25, 30);
        minVel = 40;
        maxVel = 60;
        break;
    }
    
    spawnEnemy(bossFiles[rand], hp, minVel, maxVel, rand+4);
  }
  //---------------------------------- SpawnRandomBoss End ---------------------------------//
  
  
  //---------------------------------- Function: SpawnEnemy --------------------------------//
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
  //------------------------------------- SpawnEnemy End -----------------------------------//
  
  
  //--------------------------------- Function: QueuePowerup -------------------------------//
  /**
   * Queues a powerup spawn at some enemy.
   * We need to queue because editing the entities array during collision checking
   * causes a ConcurrentModificationException.
   */
  void queuePowerup(PowerupType type, Entity e) {
    Powerup pow = new Powerup(app, type, e);
    powerupQ.add(pow);
  }
  //------------------------------------ QueuePowerup End ----------------------------------//
  
  
  //-------------------------------- Function: QueueAnimation ------------------------------//
  /**
   * Adds a new animation to the animations ArrayList
   */
  void queueAnimation(String ship, float posX, float posY) {
    Animation a = new Animation(ship, posX, posY);
    a.isPlaying = true;
    animations.add(a);
  }
  //----------------------------------- QueueAnimation End ---------------------------------//
  
  
  //------------------------------- Function: CleanDeadEntities ----------------------------//
  /** 
   * Cleans the entities list of all dead or off-screen entities.
   */
  void cleanDeadEntities() {
    entities.removeIf(entity -> (entity.isDead() || (entity.wasOnScreen && !entity.isOnScreen())));
  }
  //--------------------------------- CleanDeadEntities End --------------------------------//
  
  
  //--------------------------------- Function: UpdateScale --------------------------------//
  /**
   * Sets the scale/ difficulty of the game
   */
  void updateScale(int newScale) {
    currScale = constrain(newScale, 0, MAX_SCALE_TIMES);
    println("Setting the scale to " + currScale + "!");
    hpScale = map(currScale, 0, MAX_SCALE_TIMES, MIN_HP_SCALE, MAX_HP_SCALE);
    timeSinceScale = gameClock.time();
  }
  //------------------------------------ UpdateScale End -----------------------------------//
  
  
  //----------------------------------- Function: EnemyAI ----------------------------------//
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
  //-------------------------------------- EnemyAI End -------------------------------------//
  
  
  //-------------------------------- Function: ConstrainBoss -------------------------------//
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
  //----------------------------------- ConstrainBoss End ----------------------------------//
  
  
  //------------------------------------- Function: Cp5 ------------------------------------//
  /**
   * Checks if cp5 elements already exist, such as when the 
   * game has been restarted or quit during execution
   */
  void cp5() {
    if (cp5.getController("fps") == null) {
      displayFps =  cp5.addTextlabel("fps")
        .setText("Fps: " + (int)frameRate)
        .setPosition(10, 10)
        .setFont(createFont("Arial", 16))
        .hide();
      ;
    }
    else {
      displayFps = (Textlabel)cp5.getController("fps");
    }
    
    if (cp5.getController("score") == null) {
      displayScore = cp5.addTextlabel("score")
                     .setText("Score: " + score)
                     .setPosition(10,30)
                     .setFont(createFont("Arial", 16))
                     .hide();
      ;
    }
    else {
      displayScore = (Textlabel)cp5.getController("score");
    }
    
    if (cp5.getController("time") == null) {
      displayTime = cp5.addTextlabel("time")
                     .setText("Time: " + score)
                     .setPosition(10,50)
                     .setFont(createFont("Arial", 16))
                     .hide();
      ;
    }
    else {
      displayTime = (Textlabel)cp5.getController("time");
    }
    
    if (cp5.getController("pSpeed") == null) {
      pSpeed = cp5.addTextlabel("pSpeed")
        .setText("" + p.speed)
        .setPosition(width/2-270, 10)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pSpeed = (Textlabel)cp5.getController("pSpeed");
    }
    
    if (cp5.getController("pPower") == null) {
      pPower = cp5.addTextlabel("pPower")
        .setText("" + p.power)
        .setPosition(width/2-40, 10)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pPower = (Textlabel)cp5.getController("pPower");
    }
    
    if (cp5.getController("pFireRate") == null) {
      pFireRate = cp5.addTextlabel("pFireRate")
        .setText("" + p.fireRate)
        .setPosition(width/2+160, 10)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pFireRate = (Textlabel)cp5.getController("pFireRate");
    }
    
    if (cp5.getController("pScoreMult") == null) {
      pScoreMult = cp5.addTextlabel("pScoreMult")
        .setText("x" + p.scoreMult)
        .setPosition(width/2+360, 10)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pScoreMult = (Textlabel)cp5.getController("pScoreMult");
    }
    
    if (cp5.getController("pShots") == null) {
      pShots = cp5.addTextlabel("pShots")
        .setText("" + p.shots)
        .setPosition(width/2, app.height-40)
        .setFont(createFont("Arial", 24))
        .hide();
    }
    else {
      pShots = (Textlabel)cp5.getController("pShots");
    }
  }
  //---------------------------------------- Cp5 End ---------------------------------------//
  
  
  //---------------------------------- Function: AddScore ----------------------------------//
  /**
   * Add to the game score by some amount.
   * The base score is updated with multipliers, etc. before adding to the score.
   */
  void addScore(int baseScore) {
    score += baseScore * p.scoreMult;
  }
  //------------------------------------- AddScore End ------------------------------------//
  
  
  //---------------------------- Function: ConvertSecondsToText ---------------------------//
  /**
   * Convert game time to proper format
   */
  String convertSecondsToText() {
    int time = gameClock.time()/1000;
    int hours = time / 3600;          // calculate the hours
    int minutes = (time % 3600) / 60; // calculate the minutes
    int seconds = time % 60;          // calculate the seconds
    
    String timeText = nf(hours, 2) + ":" + nf(minutes, 2) + ":" + nf(seconds, 2); // format the time text
    
    return timeText;
  }
  //------------------------------- ConvertSecondsToText End -----------------------------//
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
