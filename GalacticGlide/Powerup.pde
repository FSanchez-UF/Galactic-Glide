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
}

Map<PowerupType, String> powerupMap = Map.of(
  PowerupType.SPEED,     "Sprites/Powerups/speed.png",
  PowerupType.POWER,     "Sprites/Powerups/power.png",
  PowerupType.FIRERATE,  "Sprites/Powerups/firerate.png"
);

class Powerup extends Entity {
  PowerupType type;
  
  /**
   * Constructor.
   */
  Powerup(PApplet app, PowerupType type, Entity e) {
    super(app, powerupMap.get(type), 1, 1, 300);
    this.type = type;
    setXY(e.getX(), e.getY());
    setVelXY(-150, 0);
  }
  
  /**
   * Allows updates player stats when collecting a powerup
   */
  void handleCollision(Entity e) {
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
      }
      p.updateStats();
      // TODO: visual indicator for which powerup was gotten
      // TODO: powerup UI
      setDead(true);
    }
  }
}
