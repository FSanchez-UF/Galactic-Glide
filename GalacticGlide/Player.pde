// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Player.pde
// Description: Player.pde extends the Entity class and defines player
//              behavior such as player movement, shooting, collisions,
//              and more.

import java.awt.event.KeyEvent;

class Player extends Entity {
  
  float speed = 250;    // Speed measured in pixels per second
  float power = 1;      // How much damage to deal per shot
  float fireRate = 5;   // Fire rate (in shots per second)
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
  }
  
  /**
   * Handles collisions.
   */
  void handleCollision(Entity e) {
    if (e instanceof Obstacle && !game.endGame) { // Remove bool variable to finish end game
      Obstacle o = (Obstacle) e;
      if (o.isEnemy) {
        // TODO: player should die here
        playerHealth-=1;
        cp5.remove("heart"+playerHealth);
        game.hearts.remove(game.hearts.size() - 1);
        if (playerHealth == 0) {
          game.endGame = true;
        }
      }
    }
    else if (e instanceof Enemy && !game.endGame) { // Remove bool variable to finish end game
      Enemy en = (Enemy) e;
      // TODO: enemy things here
      if(!en.collidedPlayer) {
        playerHealth-=1;
        cp5.remove("heart"+playerHealth);
        game.hearts.remove(game.hearts.size() - 1);
        if (playerHealth == 0) {
          game.endGame = true;
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
      case '.': game.spawnRandomObstacle(); break;
      case ',': game.spawnRandomEnemy(); break;
      case '/': game.spawnRandomBoss(); break;
    }
  }
  
  void handleSpaceBar() {
    if (spaceBarPressed && (millis() - spaceBarTimeReleased) >= 1000.0/fireRate) {
      spawnProjectile();
      spaceBarTimeReleased = millis();
    }
  }
}
