// Gelatic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Player.pde
// Description: Player.pde extends the Entity class and defines player
//              behavior such as player movement, shooting, collisions,
//              and more.

import java.awt.event.KeyEvent;

class Player extends Entity {
  
  float speed = 1;
  
  /**
   * Constructor.
   */
  Player(float x, float y, float vx, float vy, float sx, float sy, String imgFilename) {
    super(x, y, vx, vy, sx, sy, imgFilename);
  }
  
  /**
   * Checks and handles collisions.
   */
  void collide() {
    // TODO: get all entities and check for hitbox collision
    // TODO: handle each collision based on entity type (instanceof)
  }
  
  /**
   * Handles input on keyPressed()
   */
  void handleKeyPress() {
    switch (keyCode) {
      case 'W': vy = -speed; break;
      case 'A': vx = -speed; break;
      case 'S': vy = speed; break;
      case 'D': vx = speed; break;
    }
  }
  
  /**
   * Handles input on keyReleased()
   */
  void handleKeyRelease() {
    switch (keyCode) {
      case 'W': vy = 0; break;
      case 'A': vx = 0; break;
      case 'S': vy = 0; break;
      case 'D': vx = 0; break;
    }
  }
}
