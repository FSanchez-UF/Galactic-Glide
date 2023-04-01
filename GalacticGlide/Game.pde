// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Game.pde
// Description: Game.pde is the game manager for Galactic Glide. It handles 
//              the game, player, enemy, obstacle, and collision logic. It 
//              also keeps track of scoring.

import sprites.utils.*;
import sprites.*;

class Game {
  PApplet app;                 // App the Game belongs to
  
  StopWatch sw;                // StopWatch provided by Sprite library
  Player p;                    // Player entity
  ArrayList<Entity> entities;  // All other entities 
  boolean active;              // Tells whether the game is running or not
  boolean paused;              // Tells whether game is paused or not
  
  /**
   * Constructor.
   */
  Game(PApplet app) {
    this.app = app;
    sw = new StopWatch();
    p = new Player(app, "Sprites/test.png", 1, 1, 0);
    S4P.collisionAreasVisible = DEBUG;
  }
  
  /**
   * Updates the game state frame by frame.
   */
  void update() {
    if (paused)
      return;
    processCollisions();
    S4P.updateSprites(sw.getElapsedTime());
  }
  
  /** 
   * Displays the game sprites
   */
  void display() {
    S4P.drawSprites();
  }
  
  /** 
   * Checks whether any collisions are occuring
   */
  void processCollisions() {
    // TODO: check for collisions, then call entity1.handleCollision(entity2);
  }
  
  /** 
   * Pauses game state
   */
  void setPause(boolean pause) {
    paused = pause;
  }
  
  void handleKeyPress() {
    p.handleKeyPress();
  }
  
  void handleKeyRelease() {
    p.handleKeyRelease();
  }
}

// NOTE: use saveStrings() to save scores across different opens (persistent)
