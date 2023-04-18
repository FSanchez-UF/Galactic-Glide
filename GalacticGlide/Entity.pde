// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Entity.pde
// Description: Entity.pde is the base class for the main moving objects in
//              the game including the player, enemies, and obstacles. 
//              Most of the work is handled by the Sprite class, but we reserve
//              this class for functionality not included by Sprite.

abstract class Entity extends Sprite {
  float mhp;                   // Maximum health
  float hp;                    // Current health
  
  int DAMAGE_MILLIS = 333;     // How many milliseconds to spend doing damage (only update in player class)
  int dmgStartTime = 0;        // Track when damage started
  boolean doDamage = false;    // Show the damage frames on damage
  boolean isPlayer = false;
  
  boolean wasOnScreen = false; // Whether entity has been on screen yet
  
  //-------------------------------- Function: Constructor ---------------------------------//
  /**
   *   Creates class object and intializes relevant variables
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
  //----------------------------------- Constructor End -----------------------------------//
  
  
  //------------------------------ Function: HandleCollision-------------------------------//
  /**
   * Handles collision when one happens.
   */
  abstract void handleCollision(Entity e);
  //--------------------------------- HandleCollision End ---------------------------------//
  
  
  //----------------------------------- Function: Draw ------------------------------------//
  /**
   * Override for Sprite.draw() to include taking damage.
   */
   void draw() {
     // Damage drawing
     if (doDamage) {
       int clr = (int)map(game.gameClock.time() - dmgStartTime, 0, DAMAGE_MILLIS, 0, 255);
       if (!isPlayer) { // Flash enemies and obstacles red
         app.tint(255, clr, clr); 
       }
       else { // Flash player blue
         app.tint(clr, clr, 255); 
       }
       
       // End condition for damage animation duration
       if (game.gameClock.time() >= dmgStartTime + DAMAGE_MILLIS) {
         doDamage = false;         
       }
     }
     else { // Draws sprite with no tint
       app.tint(255, 255, 255);
     }
     
     // Update screen presence while we're here
     if (!wasOnScreen && isOnScreen()) {
       wasOnScreen = true;
     }
     super.draw(); // Draw sprites as defined in sprite library
  }
  //-------------------------------------- Draw End ---------------------------------------//
  
  
  //-------------------------------- Function: TakeDamage ---------------------------------//
  /**
   * Applies damage to the Entity, and kills it if fatal.
   * Can also be used to heal if dmg is negative.
   */
  void takeDamage(float dmg) {
    hp -= dmg;
    doDamage = true; // Start damage animation
    dmgStartTime = game.gameClock.time();
    if (hp <= 0)
      setDead(true);
    if (hp >= mhp)
      hp = mhp;
  }
  //----------------------------------- TakeDamage End ------------------------------------//
  
  
  //---------------------------------- Function: SetDead ----------------------------------//
  /**
   * Override for Sprite.setDead() to include parameter changes.
   */
  void setDead(boolean dead) {
    super.setDead(dead);
    hp = 0;
    onDeath();
  }
  //------------------------------------- SetDead End -------------------------------------//
  
  
  //---------------------------------- Function: OnDeath ----------------------------------//
  /**
   * Called when object is set to dead after taking damage.
   * Useful for score adjusting and death sprite spawning!
   */
  void onDeath() {}
  //------------------------------------- OnDeath End -------------------------------------//
  
  
  //----------------------------------- Function: SetHp -----------------------------------//
  /**
   * Sets max HP. Scales up current HP to match.
   */
  void setHp(float newHp) {
    mhp = newHp;
    hp = mhp;
  }
  //-------------------------------------- SetHp End --------------------------------------//
  
  
  //--------------------------------- Function: IsOnScreen --------------------------------//
  /**
   * Alias for isOnScreem, an official library typo.
   */
  boolean isOnScreen() {
    return isOnScreem();
  }
  //----------------------------------- IsOnScreen End -----------------------------------//
}
