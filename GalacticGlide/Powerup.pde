// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Powerup.pde
// Description: Powerup.pde extends the Entity class and defines how player
//              powerup sprites should behave.

import java.util.Map;

enum PowerupType {
  SPEED,
  POWER,
  FIRERATE,
  HP,
  SCORE,
}

PowerupType[] commonPowerups = {
  PowerupType.SPEED,
  PowerupType.POWER,
  PowerupType.FIRERATE,
};

Map<PowerupType, String> powerupMap = Map.of(
  PowerupType.SPEED,     "Sprites/Powerups/speed.png",
  PowerupType.POWER,     "Sprites/Powerups/power.png",
  PowerupType.FIRERATE,  "Sprites/Powerups/firerate.png",
  PowerupType.HP,        "Sprites/heart-sprite.png",
  PowerupType.SCORE,     "Sprites/Powerups/score.png"
);

class Powerup extends Entity {
  PowerupType type;
  
  //------------------------- Function: Constructor -------------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  Powerup(PApplet app, PowerupType type, Entity e) {
    super(app, powerupMap.get(type), 1, 1, 300);
    this.type = type;
    setXY(e.getX(), e.getY());
    setVelXY(-150, 0);
  }
  //---------------------------- Constructor End ---------------------------//
  
  
  //----------------------- Function: HandleCollision ----------------------//
  /**
   * Allows updates player stats when collecting a powerup
   */
  void handleCollision(Entity e) {
    boolean doSetDead = true;
    if (e instanceof Player) {
      Player p = (Player) e;
      switch (type) {
        case SPEED:
          p.speedUps += (p.speedUps < p.MAX_SPEED_UPS)? 1 : 0;
          break;
        case POWER:
          p.powerUps += (p.powerUps < p.MAX_POWER_UPS)? 1 : 0;
          break;
        case FIRERATE:
          p.fireRateUps += (p.fireRateUps < p.MAX_FIRE_RATE_UPS)? 1 : 0;
          break;
        case HP:
          if (p.playerHealth < p.MAX_HP)
            p.playerHealth++;
          else
            doSetDead = false;
          break;
        case SCORE:
          p.scoreUps += (p.scoreUps < p.MAX_SCORE_UPS)? 1 : 0;
          break;
      }
      if (doSetDead) {
        setDead(true);
      }
    }
  }
  //-------------------------- HandleCollision End -------------------------//
}
