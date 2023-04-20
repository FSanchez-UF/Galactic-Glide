// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Animation.pde
// Description: Animation.pde is an object that holds the frame for each
//              animation in Galactic Glide.

class Animation {
  ArrayList<PImage> frames;
  int currentFrame;
  Clock frameTime;
  float posX;
  float posY;
  boolean type;       // Defines whether this animation is for enemy/player or laser
  boolean isPlaying;
  
  //--------------------- Function: Constructor ---------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  Animation(String name, float posX, float posY, boolean type) {
    frames = images.getAnimation(name);
    currentFrame = 0;
    this.posX = posX;
    this.posY = posY;
    isPlaying = false;
    frameTime = new Clock();
    this.type = type;
  }
  //------------------------ Constructor End ------------------------//
  
  //--------------------- Function: isAnimating ---------------------//
  /**
   * Plays animation frame by frame
   */
  void isAnimating() {
      frameTime.start();
      if (currentFrame < frames.size()) {
        image(frames.get(currentFrame), posX, posY);
        if (!type && frameTime.time() >= (int)(0.333 * frameRate)) {
          currentFrame++;
          frameTime.reset();
        }
        else if (type && frameTime.time() >= 500/frames.size()){
          currentFrame++;
          frameTime.reset();
        }
      }
      else {
        isPlaying = false;
        frameTime.stop();
      }
  }
  //------------------------ isAnimating End ------------------------//
}
