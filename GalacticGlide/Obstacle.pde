// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Obstacle.pde
// Description: Obstacle.pde extends the Entity class and defines how 
//              obstacles spawn and behave.

class Obstacle extends Entity {
  boolean isEnemy;       // Describes whether the obstacle belongs to the enemy; false if owned by player
  boolean isProjectile;  // Describes whether the obstacle is a projectile (fired by enemy or player)

  //---------------------------------- Function: Constructor -------------------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  Obstacle(PApplet app, String imgFilename, int cols, int rows, int zOrder, boolean isEnemy, boolean isProjectile) {
    super(app, imgFilename, cols, rows, zOrder);
    this.isEnemy = isEnemy;
    this.isProjectile = isProjectile;
    setXY(app.width+width, random((float)height/2, (float)(app.height-height/2)));
  }
  //------------------------------------- Constructor End ----------------------------------//
  
  
  //-------------------------------- Function: HandleCollision -----------------------------//
  /**
   * Handles collision when one happens.
   * This handler mostly deals with when to despawn the Obstacle.
   */
  void handleCollision(Entity e) {
    if (e instanceof Player && this.isEnemy) { // Collision with player destroys obstacle
      if (this.type > 0) game.queueAnimation("shot" + this.type + "_exp", (float)getX(), (float)getY(), true);
      setDead(true);
    }
    else if (e instanceof Enemy && !this.isEnemy) { // Destroy player laser on impact with enemy 
      setDead(true);
    }
    else if (e instanceof Obstacle) { // Handle obstacle collision 
      Obstacle o = (Obstacle) e;
      if (this.isProjectile && o.isProjectile) { // Projectiles ignore each other
        return;
      }
      else if (this.isEnemy != o.isEnemy) { // If teams mismatch, deal damage to this entity
        takeDamage(game.p.power);
        if (game.p.doLimitedShots && (game.p.shots < game.p.MAX_SHOTS))
          game.p.shots++;
      }
    }
  }
  //----------------------------------- HandleCollision End --------------------------------//
  
  
  //------------------------------------ Function: OnDeath ---------------------------------//
  /**
   * Called when object is set to dead after taking damage.
   * Useful for score adjusting and death sprite spawning!
   */
  void onDeath() {
    if (isEnemy && !isProjectile) {
      game.addScore(50);
      sound.playSFX("Meteor_Death");
    }
  }
  //------------------------------------- OnDeath End -------------------------------------//
}
