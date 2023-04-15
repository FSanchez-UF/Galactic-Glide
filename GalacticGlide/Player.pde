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
  
  final int DAMAGE_FRAMES = 20;  // How many frames to spend doing damage 
  int currDamageFrame = 0;       // Current damage frame
  boolean doDamageFrame = false; // Show the damage frames on damage
  
  /**
   * Constructor.
   */
  Player(PApplet app, String imgFilename, int cols, int rows, int zOrder) {
    super(app, imgFilename, cols, rows, zOrder);
    setXY(100, app.height/2);
    setDomain(-getWidth()/2, -getHeight()/2, app.width+getWidth()/2, app.height+getHeight()/2, HALT);
  }
  
  /**
   * Handles collisions.
   */
  void handleCollision(Entity e) {
    if (e instanceof Obstacle && !game.endGame) { // TO DO: Remove bool variable to finish end game
      Obstacle o = (Obstacle) e;
      if (o.isEnemy) {
        playerHealth-=1;
        takeDamage();
        // TO DO: Add invulnerability for a few sec after getting hit, change sound and add sprite
        cp5.remove("heart"+playerHealth);
        game.hearts.remove(game.hearts.size() - 1);
        if (playerHealth == 0) {
          game.endGame = true;
          sound.playSFX("Player_Death");
        }
        else {
          sound.playSFX("Player_Hit");
        }
      }
    }
    else if (e instanceof Enemy && !game.endGame) { // Remove bool variable to finish end game
      Enemy en = (Enemy) e;
      if(!en.collidedPlayer) {
        playerHealth-=1;
        takeDamage();
        cp5.remove("heart"+playerHealth);
        game.hearts.remove(game.hearts.size() - 1);
        if (playerHealth == 0) {
          game.endGame = true;
          sound.playSFX("Player_Death");
        }
        else {
          sound.playSFX("Player_Hit");
        }
      }
    }
  }
  
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
        break;
      case '.': game.spawnRandomObstacle(); break;
      case ',': game.spawnRandomEnemy(); break;
      case '/': game.spawnRandomBoss(); break;
    }
  }
  
  void handleSpaceBar() {
    if (spaceBarPressed && (millis() - spaceBarTimeReleased) >= 1500.0/fireRate) {
      spawnProjectile();
      spaceBarTimeReleased = millis();
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
  
  void damageAnimation() {
    if (doDamageFrame) {
       int clr = (int)map(currDamageFrame, 0, DAMAGE_FRAMES, 0, 255);  
       app.tint(255, clr, clr);
       if (currDamageFrame < DAMAGE_FRAMES) {
         currDamageFrame++;         
       }
       else {
         doDamageFrame = false;
         currDamageFrame = 0;
       }
     }
     else {
       app.tint(255, 255, 255);
     }
  }
  
  void takeDamage() {
    doDamageFrame = true;
    currDamageFrame = 0;
  }
}
