// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Obstacle.pde
// Description: Obstacle.pde extends the Entity class and defines how 
//              obstacles spawn and behave.

class Obstacle extends Entity {
  boolean isEnemy;      // Describes whether the obstacle belongs to the enemy; false if owned by player
  
  /**
   * Constructor
   */
  Obstacle(PApplet app, String imgFilename, int cols, int rows, int zOrder, boolean isEnemy) {
    super(app, imgFilename, cols, rows, zOrder);
    this.isEnemy = isEnemy;
    setXY(app.width+width, random((float)height/2, (float)(app.height-height/2)));
    setVelXY(-random(30, 50), 0);
  }
  
  /**
   * Handles collision when one happens.
   * This handler mostly deals with when to despawn the Obstacle.
   */
  void handleCollision(Entity e) {
    if (e instanceof Player && this.isEnemy)
      setDead(true);
    else if (e instanceof Enemy && !this.isEnemy)
      setDead(true);
    else if (e instanceof Obstacle) {
      Obstacle o = (Obstacle) e;
       if (this.isEnemy != o.isEnemy)
        setDead(true);
    }
  }
}
