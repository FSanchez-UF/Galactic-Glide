// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Player.pde
// Description: Player.pde extends the Entity class and defines player
//              behavior such as player movement, shooting, collisions,
//              and more.

import java.awt.event.KeyEvent;

class Player extends Entity {
  
  float speed = 250; // Speed measured in pixels per second
  float power = 1;   // How much damage to deal per shot
  boolean spaceBarPressed = false;
  int spaceBarTimeReleased = 0;
  
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
    if (e instanceof Obstacle) {
      Obstacle o = (Obstacle) e;
      if (o.isEnemy);
        // TODO: player should die here
    }
    else if (e instanceof Enemy) {
      Enemy en = (Enemy) e;
      // TODO: enemy things here
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
      case '.': game.spawnObstacle(); break;
    }
  }
  
  void handleSpaceBar() {
    if (spaceBarPressed && (millis() - spaceBarTimeReleased) >= 200) {
      spawnProjectile();
      spaceBarTimeReleased = millis();
    }
  }
}
