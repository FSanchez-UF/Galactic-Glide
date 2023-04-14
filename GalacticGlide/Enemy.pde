// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Enemy.pde
// Description: Enemy.pde extends the Entity class and defines how enemy
//              ships spawn and behave.

class Enemy extends Entity {
  boolean collidedPlayer; // Tracks whether this enemy has collided with the player before
  boolean isBoss;         // Tracks whether this is a boss
  
  /**
   * Constructor
   */
  Enemy(PApplet app, String imgFilename, int cols, int rows, int zOrder) {
    super(app, imgFilename, cols, rows, zOrder);
    setXY(app.width+width, random((float)height/2, (float)(app.height-height/2)));
    collidedPlayer = false;
  }
  
  /**
   * Handles collision when one happens.
   */
  void handleCollision(Entity e) {
    if (e instanceof Player)
      collidedPlayer = true;      
    if (e instanceof Obstacle) {
      Obstacle o = (Obstacle) e;
      if (!o.isEnemy)
        takeDamage(game.p.power);
    }
  }
  
  /**
   * Called when object is set to dead after taking damage.
   * Useful for score adjusting and death sprite spawning!
   * TODO: scale score with game.currScale too somehow
   */
  void onDeath() {
    if (isBoss) {
      game.updateScale(game.currScale+1);
      game.score += 500;
    }
    else
      game.score += 100;
      
    float rand = random(1);
    if (rand < 0.4) { // 40% chance of powerup
      PowerupType randPower = PowerupType.values()[int(random(PowerupType.values().length))];
      game.queuePowerup(randPower, this);
    }
  }
}
