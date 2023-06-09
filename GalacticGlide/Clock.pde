// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Clock.pde
// Description: Clock.pde is a custom game clock that allow starting,
//              stopping, and resetting the clock. This allows the
//              game state to not be updated while pausing the game.

class Clock {
  int startTime;     // The time the clock started running
  int elapsedTime;   // The elapsed time since the clock started running
  boolean isRunning; // Whether the clock is currently running
  
  //--------------------- Function: Constructor ---------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  Clock() {
    startTime = 0;
    elapsedTime = 0;
    isRunning = false;
  }
  //------------------------ Constructor End ------------------------//
  
  
  //------------------------ Function: Start ------------------------//
  /**
   * Starts the clock at the current time value of millis()
   */
  void start() {
    if (!isRunning) {
      startTime = millis();
      isRunning = true;
    }
  }
  //--------------------------- Start End ---------------------------//
  
  
  //------------------------ Function: Stop -------------------------//
  /**
   * Stops the clock and updates how long the clock has been running
   */
  void stop() {
    if (isRunning) {
      elapsedTime += millis() - startTime;
      isRunning = false;
    }
  }
  //--------------------------- Stop End ----------------------------//
  
  
  //------------------------ Function: Reset ------------------------//
  /**
   * Resets all clock values to zero
   */
  void reset() {
    startTime = 0;
    elapsedTime = 0;
    isRunning = false;
  }
  //--------------------------- Reset End ---------------------------//
  
  
  //------------------------ Function: Time -------------------------//
  /**
   * Returns the current time of the clock whether it is running or not
   */
  int time() {
    if (isRunning) {
      return millis() - startTime + elapsedTime;
    } else {
      return elapsedTime;
    }
  }
  //--------------------------- Time End ---------------------------//
}
