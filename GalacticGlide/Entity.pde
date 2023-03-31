// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Entity.pde
// Description: Entity.pde is the base class for the main moving objects in
//              the game including the player, enemies, and obstacles. 
//              Most of the work is handled by the Sprite class, but we reserve
//              this class for functionality not included by Sprite.

abstract class Entity extends Sprite {
  
  /**
   * Constructor.
   *   app: The invoking application (usually just "this")
   *   imgFilename: The filename of the image to use as the Sprite.
   *   cols: How many columns of animation are in the img's spritesheet.
   *   rows: How many rows of animation are in the img's spritesheet.
   *   zOrder: Priority for display.
   */
  Entity(PApplet app, String imgFilename, int cols, int rows, int zOrder) {
    super(app, imgFilename, cols, rows, zOrder);
  }
  
  /**
   * Handles collision when one happens.
   */
  abstract void handleCollision(Entity e);
}
