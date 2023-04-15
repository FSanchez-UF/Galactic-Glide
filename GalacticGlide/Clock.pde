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
  
  Clock() {
    startTime = 0;
    elapsedTime = 0;
    isRunning = false;
  }
  
  void start() {
    if (!isRunning) {
      startTime = millis();
      isRunning = true;
    }
  }
  
  void stop() {
    if (isRunning) {
      elapsedTime += millis() - startTime;
      isRunning = false;
    }
  }
  
  void reset() {
    startTime = 0;
    elapsedTime = 0;
    isRunning = false;
  }
  
  int time() {
    if (isRunning) {
      return millis() - startTime + elapsedTime;
    } else {
      return elapsedTime;
    }
  }
}
