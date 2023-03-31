// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Player.pde
// Description: Player.pde extends the Entity class and defines player
//              behavior such as player movement, shooting, collisions,
//              and more.

import java.awt.event.KeyEvent;

class Player extends Entity {
  
  float speed = 250;    // Speed measured in pixels per second
  
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
        
  }
  
  /**
   * Handles input on keyPressed()
   */
  void handleKeyPress() {
    switch (keyCode) {
      case 'W': setVelY(-speed); break;
      case 'A': setVelX(-speed); break;
      case 'S': setVelY(speed); break;
      case 'D': setVelX(speed); break;
    }
  }
  
  /**
   * Handles input on keyReleased()
   */
  void handleKeyRelease() {
    switch (keyCode) {
      case 'W': setVelY(0); break;
      case 'A': setVelX(0); break;
      case 'S': setVelY(0); break;
      case 'D': setVelX(0); break;
    }
  }
}
