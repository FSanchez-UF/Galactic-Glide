// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Enemy.pde
// Description: Enemy.pde extends the Entity class and defines how enemy
//              ships spawn and behave.

class Enemy extends Entity {
  
  /**
   * Constructor
   */
  Enemy(PApplet app, String imgFilename, int cols, int rows, int zOrder) {
    super(app, imgFilename, cols, rows, zOrder);
    setXY(app.width+width, random((float)height/2, (float)(app.height-height/2)));
  }
  
  /**
   * Handles collision when one happens.
   */
  void handleCollision(Entity e) {
    if (e instanceof Obstacle) {
      Obstacle o = (Obstacle) e;
      if (!o.isEnemy)
        takeDamage(game.p.power);
    }
  }
  
  /**
   * Called when object is set to dead after taking damage.
   * Useful for score adjusting and death sprite spawning!
   */
  void onDeath() {
    game.score += 100;
  }
}
