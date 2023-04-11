// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Game.pde
// Description: Game.pde is the game manager for Galactic Glide. It handles 
//              the game, player, enemy, obstacle, and collision logic. It 
//              also keeps track of scoring.

import sprites.utils.*;
import sprites.*;

class Game {
  PApplet app;                 // App the Game belongs to
  
  StopWatch sw;                // StopWatch provided by Sprite library
  Player p;                    // Player entity
  ArrayList<Entity> entities;  // All entities including player
  int score;                   // Score tracker
  boolean active;              // Tells whether the game is running or not
  boolean paused;              // Tells whether game is paused or not
  
  Textlabel fps;
  Textlabel displayScore;
  
  int timeSinceEnemy;          // Time since the last enemy spawn occurred
  int timeSinceObstacle;       // Time since the last obstacle spawn occurred
  
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
  }
  
  /**
   * Updates the game state frame by frame.
   */
  void update() {
    p.handleSpaceBar();
    if (frameCount % 20 == 0) {
      fps.show();
      fps.setText("FPS: " + (int)frameRate);
    }
    displayScore.show();
    displayScore.setText("Score: " + score);
    if (!active || paused)
      return;
    handleSpawns();
    processCollisions();
    S4P.updateSprites(sw.getElapsedTime());
    // Clear dead entities every 30 seconds
    if (frameCount % (30*frameRate) == 0)
      cleanDeadEntities();
  }
  
  /** 
   * Displays the game sprites
   */
  void display() {
    tint(255, 255, 255);
    background(images.Get("game_backgrd"));
    if (!active)
      return;
    S4P.drawSprites();
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
   * Spawns obstacles/enemies over a gradually steeper interval.
   */
  void handleSpawns() {
    if (millis() - timeSinceEnemy >= 3*1000) {
      int numEnemies = (int)random(1,3);
      for (int i = 0; i < numEnemies; ++i)
        spawnRandomEnemy();
      timeSinceEnemy = millis();
    }
    
    if (millis() - timeSinceObstacle >= 5*1000) {
      int numObstacles = (int)random(1,3);
      for (int i = 0; i < numObstacles; ++i)
        spawnRandomObstacle();
      timeSinceObstacle = millis();
    }
    
    // TODO: spawn boss every like 30 seconds 
  }
  
  /**
   * Spawns a random obstacle.
   * Should take into account difficulty and time elapsed.
   * TODO: implement difficulty/time elapse (hp here)
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
    o.setHp(hp);
    o.setVelXY(-random(minVel, maxVel), 0);
    entities.add(o);
  }
  
  /**
   * Spawns a random enemy.
   * Should take into account difficulty and time elapsed.
   * TODO: implement difficulty/time elapse (hp here)
   * TODO: make enemies have consistent scaling stats per ship type? (for user familiarity) 
   */
  void spawnRandomEnemy() {
    int rand = (int)random(0, enemyFiles.length);
    spawnEnemy(enemyFiles[rand], 3, 80, 120);
  }
  
  /** 
   * Spawns an enemy.
   */
  void spawnEnemy(String imgFilename, float hp, float minVel, float maxVel) {
    Enemy e = new Enemy(app, imgFilename, 1, 1, 750);
    e.setHp(hp);
    e.setVelXY(-random(minVel, maxVel), 0);
    entities.add(e);
  }
  
  /** 
   * Cleans the entities list of all dead or not visible entities.
   */
  void cleanDeadEntities() {
    entities.removeIf(entity -> (entity.isDead() || !entity.isVisible()));
  }
}

// NOTE: use saveStrings() to save scores across different opens (persistent)
