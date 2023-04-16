// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Player.pde
// Description: Player.pde extends the Entity class and defines player
//              behavior such as player movement, shooting, collisions,
//              and more.

class Player extends Entity {
  
  // Speed: Measured in pixels per second
  final float MAX_SPEED_UPS = 10;
  final float MIN_SPEED = 250;
  final float MAX_SPEED = 400;
  int speedUps = 0;
  float speed = MIN_SPEED;
  
  // Power: How much damage to deal per shot
  final float MAX_POWER_UPS = 10;
  final float MIN_POWER = 1;
  final float MAX_POWER = 5;
  int powerUps = 0;
  float power = MIN_POWER;
  
  // Fire rate (in shots per second)
  final float MAX_FIRE_RATE_UPS = 10;
  final float MIN_FIRE_RATE = 5;
  final float MAX_FIRE_RATE = 10;
  int fireRateUps = 0;
  float fireRate = MIN_FIRE_RATE;
  
  int playerHealth = 3; // How many hits the player can take from enemies and obstacles
  
  boolean spaceBarPressed = false;  // Tracks whether the shoot button is pressed
  int spaceBarTimeReleased = 0;     // Timestamp of last shoot button release
  
  /**
   * Constructor.
   */
  Player(PApplet app, String imgFilename, int cols, int rows, int zOrder) {
    super(app, imgFilename, cols, rows, zOrder);
    setXY(100, app.height/2);
    setDomain(-getWidth()/2, -getHeight()/2, app.width+getWidth()/2, app.height+getHeight()/2, HALT);
    DAMAGE_MILLIS = 1500;
    isPlayer = true;
  }
  
  /**
   * Handles collisions.
   */
  void handleCollision(Entity e) {
    if (e instanceof Obstacle && !game.endGame) { // TO DO: Remove bool variable to finish end game
      Obstacle o = (Obstacle) e;
      // If obstacle hits player and player is not currently in damage animation, do damage
      if (o.isEnemy && !doDamage) { 
        takeDamage();
      }
    }
    else if (e instanceof Enemy && !game.endGame) { // Remove bool variable to finish end game
      Enemy en = (Enemy) e;
      // If enemy hits player for the first time and player is not currently in damage animation, do damage
      if(!en.collidedPlayer  && !doDamage) {
        takeDamage();
      }
    }
  }
  
  /**
   * Spawns player laser on spacebar press
   */
  void spawnProjectile() {
    Obstacle o = new Obstacle(app, "Sprites/Lasers/01.png", 1, 1, 500, false);
    o.setXY(getX()+width/4, getY());
    o.setVelX(400);
    game.entities.add(o);
    sound.playSFX("Laser");
  }
  
  /**
   * Handles input on keyPressed()
   */
  void handleKeyPress() {
    switch (keyCode) {
      case 'W': case UP:    setVelY(-speed); break;
      case 'A': case LEFT:  setVelX(-speed); break;
      case 'S': case DOWN:  setVelY(speed);  break;
      case 'D': case RIGHT: setVelX(speed);  break;
      case ' ':
        spaceBarPressed = true;
        break;
     }
  }
  
  /**
   * Handles input on keyReleased()
   */
  void handleKeyRelease() {
    switch (keyCode) {
      case 'W': case UP:    setVelY(0); break;
      case 'A': case LEFT:  setVelX(0); break;
      case 'S': case DOWN:  setVelY(0); break;
      case 'D': case RIGHT: setVelX(0); break;
      case ' ':      
        spaceBarPressed = false;
        break;
      case 'P':
        game.paused = true;
        game.gameClock.stop();
        break;
      // TODO: Delete these when game is finished
      case '.': game.spawnRandomObstacle(); break;
      case ',': game.spawnRandomEnemy(); break;
      case '/': game.spawnRandomBoss(); break;
    }
  }
  
  /**
   * Handles continuous press of space bar to shoot. Controls fire rate
   */
  void handleSpaceBar() {
    if (spaceBarPressed && (game.gameClock.time() - spaceBarTimeReleased) >= 1500.0/fireRate) {
      spawnProjectile();
      spaceBarTimeReleased = game.gameClock.time();
    }
  }
  
  /**
   * Update stats based on the current number of powerups collected
   */
  void updateStats() {
    speed = map(speedUps, 0, MAX_SPEED_UPS, MIN_SPEED, MAX_SPEED);
    power = map(powerUps, 0, MAX_POWER_UPS, MIN_POWER, MAX_POWER);
    fireRate = map(fireRateUps, 0, MAX_FIRE_RATE_UPS, MIN_FIRE_RATE, MAX_FIRE_RATE);
  }
  
  /**
   * Override of Entity takeDamage() to handle player lives and sound effects
   */
  void takeDamage() {
    // Start damage animation. Player is invulnerable for 1.5s
    doDamage = true;
    dmgStartTime = game.gameClock.time();
    
    // Remove player life
    playerHealth-=1;
    cp5.remove("heart"+playerHealth);
    game.hearts.remove(game.hearts.size() - 1);
    if (playerHealth > 0) {
      sound.playSFX("Player_Hit");      
    }
    else {
      game.endGame = true;
      sound.playSFX("Player_Death");
    }
  } 
}
