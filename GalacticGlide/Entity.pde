// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Entity.pde
// Description: Entity.pde is the base class for the main moving objects in
//              the game including the player, enemies, and obstacles. 
//              Most of the work is handled by the Sprite class, but we reserve
//              this class for functionality not included by Sprite.

abstract class Entity extends Sprite {
  float mhp;                     // Maximum health
  float hp;                      // Current health
  
  final int DAMAGE_FRAMES = 20;  // How many frames to spend doing damage 
  int currDamageFrame = 0;       // Current damage frame
  boolean doDamageFrame = false; // Show the damage frames on damage
  
  boolean wasOnScreen = false;   // Whether entity has been on screen yet
  
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
    mhp = 1;
    hp = mhp;
  }
  
  /**
   * Handles collision when one happens.
   */
  abstract void handleCollision(Entity e);
  
  /**
   * Override for Sprite.draw() to include taking damage.
   */
   void draw() {
     // Damage drawing
     if (doDamageFrame) {
       int clr = (int)map(currDamageFrame, 0, DAMAGE_FRAMES, 0, 255);  
       app.tint(255, clr, clr);
       if (currDamageFrame < DAMAGE_FRAMES) {
         currDamageFrame++;         
       }
       else {
         doDamageFrame = false;
         currDamageFrame = 0;
       }
     }
     else {
       app.tint(255, 255, 255);
     }
     
     // Update screen precense while we're here
     if (!wasOnScreen && isOnScreen())
       wasOnScreen = true;
     
     super.draw();
   }
  
  /**
   * Applies damage to the Entity, and kills it if fatal.
   * Can also be used to heal if dmg is negative.
   */
  void takeDamage(float dmg) {
    hp -= dmg;
    doDamageFrame = true;
    currDamageFrame = 0;
    if (hp <= 0)
      setDead(true);
    if (hp >= mhp)
      hp = mhp;
  }
  
  /**
   * Override for Sprite.setDead() to include parameter changes.
   */
  void setDead(boolean dead) {
    super.setDead(dead);
    hp = 0;
    onDeath();
  }
  
  /**
   * Called when object is set to dead after taking damage.
   * Useful for score adjusting and death sprite spawning!
   */
  void onDeath() {}
  
  /**
   * Sets max HP. Scales up current HP to match.
   */
  void setHp(float newHp) {
    mhp = newHp;
    hp = mhp;
  } 
  
  /**
   * Alias for isOnScreem, an official library typo.
   */
  boolean isOnScreen() {
    return isOnScreem();
  }
  
  /**
   * Returns whether the entity was on screen yet.
   */
  boolean wasOnScreen() {
    return wasOnScreen;
  }
}
