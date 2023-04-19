// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Player.pde
// Description: Player.pde extends the Entity class and defines player
//              behavior such as player movement, shooting, collisions,
//              and more.

class Player extends Entity {
  
  // Speed: Measured in pixels per second
  final int MAX_SPEED_UPS = 10;
  final float MIN_SPEED = 250;
  final float MAX_SPEED = 400;
  int speedUps = 0;
  float speed = MIN_SPEED;
  
  // Power: How much damage to deal per shot
  final int MAX_POWER_UPS = 10;
  final float MIN_POWER = 1;
  final float MAX_POWER = 5;
  int powerUps = 0;
  float power = MIN_POWER;
  
  // Fire rate (in shots per second)
  final int MAX_FIRE_RATE_UPS = 10;
  final float MIN_FIRE_RATE = 5;
  final float MAX_FIRE_RATE = 10;
  int fireRateUps = 0;
  float fireRate = MIN_FIRE_RATE;
  
  // Score multiplier
  final int MAX_SCORE_UPS = 5;
  final float MIN_SCORE_MULT = 1.0f;
  final float MAX_SCORE_MULT = 3.0f;
  int scoreUps = 0;
  float scoreMult = MIN_SCORE_MULT;
  
  final int MAX_HP = 3;      // Player-exclusive HP
  int playerHealth = MAX_HP; // How many hits the player can take from enemies and obstacles
  
  boolean spaceBarPressed = false;  // Tracks whether the shoot button is pressed
  int spaceBarTimeReleased = 0;     // Timestamp of last shoot button release
  
  // In hard mode, player only gets a limited number of shots
  // These shots regenerate over time or by hitting an enemy
  boolean doLimitedShots = chooseByDiff(false, false, true);
  final int MAX_SHOTS = 20;
  final float SHOT_REGEN_TIME = 1.0f; // in seconds
  int shots = MAX_SHOTS;
  int timeSinceShot;
  
  //------------------------------------------ Function: Constructor -----------------------------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  Player(PApplet app, String imgFilename, int cols, int rows, int zOrder) {
    super(app, imgFilename, cols, rows, zOrder);
    setXY(100, app.height/2);
    setDomain(-getWidth()/2, -getHeight()/2, app.width+getWidth()/2-10, app.height+getHeight()/2, HALT);
    DAMAGE_MILLIS = 1500;
  }
  //-------------------------------------------- Constructor End ---------------------------------------------//
  
  
  //-------------------------------------------- Function: Update --------------------------------------------//
  /**
   * Override for Sprite.update().
   * Handles shot regeneration when doing limited shots.
   */
  void update(double deltaTime) {
    super.update(deltaTime);
    if (doLimitedShots && shots < MAX_SHOTS && game.gameClock.time() - timeSinceShot >= 1000*SHOT_REGEN_TIME) {
      timeSinceShot = game.gameClock.time();
      shots++;
    }
  }
  //----------------------------------------------- Update End -----------------------------------------------//
  
  
  //--------------------------------------- Function: HandleCollision ----------------------------------------//
  /**
   * Handles collisions.
   */
  void handleCollision(Entity e) {
    if (e instanceof Obstacle && !game.endGame) { // TO DO: Remove bool variable to finish end game
      Obstacle o = (Obstacle) e;
      // If obstacle hits player and player is not currently in damage animation, do damage
      if (o.isEnemy && !doDamage) { 
        takeDamage();
      }
    }
    else if (e instanceof Enemy && !game.endGame) { // Remove bool variable to finish end game
      Enemy en = (Enemy) e;
      // If enemy hits player for the first time and player is not currently in damage animation, do damage
      if(!en.collidedPlayer  && !doDamage) {
        takeDamage();
      }
    }
  }
  //------------------------------------------ HandleCollision End -------------------------------------------//
  
  
  //--------------------------------------- Function: SpawnProjectile ----------------------------------------//
  /**
   * Spawns player laser on spacebar press
   */
  void spawnProjectile() {
    Obstacle o = new Obstacle(app, "Sprites/Lasers/01.png", 1, 1, 500, false, true);
    o.setXY(getX()+width/4, getY());
    o.setVelX(400);
    game.entities.add(o);
    sound.playSFX("Laser");
  }
  //------------------------------------------ SpawnProjectile End -------------------------------------------//
  
  
  //------------------------------------- Function: ConstraintMovement ---------------------------------------//
  /**
   * Constrains player movement within the screen.
   * Override for sprite domain constraint since HALT and REBOUND
   * are the only options for collision and cause issues.
   */
  void constraintMovement() {
    int edgeBuffer = 50;             // Pixels
    float x = (float)getX();         // Player x
    float y = (float)getY();         // Player y
    float hw = (float)getWidth()/2;  // Half width
    float hh = (float)getHeight()/2; // Half height
    Domain d = getDomain();

    if (x - hw < d.left + edgeBuffer) { // Left edge collision
      setXY(d.left + hw + edgeBuffer, y);
      setVelX(0);
    } 
    else if (x + hw > d.right - edgeBuffer) { // Right edge collision
      setXY(d.right - hw - edgeBuffer, y);
      setVelX(0);
    }
    
    if (y - hh < d.top + edgeBuffer) { // Top collision
      setXY(x, d.top + hh + edgeBuffer);
      setVelY(0);
    } 
    else if (y + hh > d.bottom - edgeBuffer) { // Bottom collision
      setXY(x, d.bottom - hh - edgeBuffer);
      setVelY(0);
    }
  }
  //---------------------------------------- ConstraintMovement End ------------------------------------------//
  
  
  //--------------------------------------- Function: HandleKeyPress -----------------------------------------//
  /**
   * Handles input on keyPressed()
   */
  void handleKeyPress() {
    switch (keyCode) {
      case 'W': case UP:    setVelY(-speed); break;
      case 'A': case LEFT:  setVelX(-speed); break;
      case 'S': case DOWN:  setVelY(speed);  break;
      case 'D': case RIGHT: setVelX(speed);  break;
      case ' ':
        spaceBarPressed = true;
        break;
     }
  }
  //------------------------------------------ HandleKeyPress End --------------------------------------------//
  
  
  //-------------------------------------- Function: HandleKeyRelease ----------------------------------------//
  /**
   * Handles input on keyReleased()
   */
  void handleKeyRelease() {
    switch (keyCode) {
      case 'W': case UP:    setVelY(0); break;
      case 'A': case LEFT:  setVelX(0); break;
      case 'S': case DOWN:  setVelY(0); break;
      case 'D': case RIGHT: setVelX(0); break;
      case ' ':      
        spaceBarPressed = false;
        break;
      case 'P':
        game.paused = true;
        game.gameClock.stop();
        game.bossClock.stop();
        break;
      // TODO: Delete these when game is finished (or just comment out)
      case '.': game.spawnRandomObstacle(); break;
      case ',': game.spawnRandomEnemy(); break;
      case '/': game.spawnRandomBoss(); break;
      case ';':
        speedUps = MAX_SPEED_UPS;
        powerUps = MAX_POWER_UPS;
        fireRateUps = MAX_FIRE_RATE_UPS;
        scoreUps = MAX_SCORE_UPS;
        updateStats();
        break;
    }
  }
  //----------------------------------------- HandleKeyRelease End -------------------------------------------//
  
  
  //--------------------------------------- Function: HandleSpaceBar -----------------------------------------//
  /**
   * Handles continuous press of space bar to shoot. Controls fire rate
   */
  void handleSpaceBar() {
    if (doLimitedShots && shots <= 0)
      return;
    
    if (spaceBarPressed && (game.gameClock.time() - spaceBarTimeReleased) >= 1500.0/fireRate) {
      spawnProjectile();
      spaceBarTimeReleased = game.gameClock.time();
      if (doLimitedShots && shots > 0) {
        shots--;
        timeSinceShot = game.gameClock.time();
      }
    }
  }
  //------------------------------------------ HandleSpaceBar End --------------------------------------------//
  
  
  //----------------------------------------- Function: UpdateStats ------------------------------------------//
  /**
   * Update stats based on the current number of powerups collected
   * Also updates the Game's text displays.
   */
  void updateStats() {
    speed = map(speedUps, 0, MAX_SPEED_UPS, MIN_SPEED, MAX_SPEED);
    power = map(powerUps, 0, MAX_POWER_UPS, MIN_POWER, MAX_POWER);
    fireRate = map(fireRateUps, 0, MAX_FIRE_RATE_UPS, MIN_FIRE_RATE, MAX_FIRE_RATE);
    scoreMult = map(scoreUps, 0, MAX_SCORE_UPS, MIN_SCORE_MULT, MAX_SCORE_MULT);
    
    game.pSpeed.setText(speed + ((speed == MAX_SPEED)? " (MAX)" : ""));
    game.pPower.setText(power + ((power == MAX_POWER)? " (MAX)" : ""));
    game.pFireRate.setText(fireRate + ((fireRate == MAX_FIRE_RATE)? " (MAX)" : ""));
    game.pScoreMult.setText("x" + scoreMult + ((scoreMult == MAX_SCORE_MULT)? " (MAX)" : ""));
    game.pShots.setText("" + shots);
  }
  //-------------------------------------------- UpdateStats End ---------------------------------------------//
  
  
  //------------------------------------------ Function: TakeDamage ------------------------------------------//
  /**
   * Override of Entity takeDamage() to handle player lives and sound effects
   */
  void takeDamage() {
    // Start damage animation. Player is invulnerable for 1.5s
    doDamage = true;
    dmgStartTime = game.gameClock.time();
    
    // Remove player life
    playerHealth-=1;
    if (playerHealth > 0) {
      sound.playSFX("Player_Hit");      
    }
    else {
      game.deathClock.start();
      game.queueAnimation("Player", (float)getX(), (float)getY());
      setDead(true);
      game.endGame = true;
      sound.playSFX("Player_Death");
    }
  }
  //-------------------------------------------- TakeDamage End --------------------------------------------//
}
