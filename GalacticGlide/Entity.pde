// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Entity.pde
// Description: Entity.pde is the base class for the main moving objects in
//              the game including the player, enemies, and obstacles. 

abstract class Entity {
  float x, y;          // Center position
  float vx, vy;        // Velocity
  float sx, sy;        // Size of hitbox (rectangular)
  PImage img;          // Image representing entity sprite
  
  /**
   * Constructor.
   */
  Entity(String imgFilename, float x, float y, float vx, float vy, float sx, float sy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.sx = sx;
    this.sy = sy;
    img = loadImage(imgFilename);
  }
  
  /**
   * Updates entity's variables such as position.
   */
  void update() {
    x += vx;
    y += vy;
    collide();
  }
  
  /**
   * Draws the entity's sprite to the screen.
   */
  void display() {
    // Display image
    imageMode(CENTER);
    image(img, x, y);
    
    // Display debug hitbox
    if (DEBUG) {
      strokeWeight(2);
      stroke(#FFFFFF);
      fill(#FFFFFF, 150);
      rectMode(CENTER);
      rect(x, y, sx, sy);
    }      
  }
  
  /**
   * Checks and handles collisions.
   */
  abstract void collide();
}
