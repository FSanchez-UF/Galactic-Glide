// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Animation.pde
// Description: Animation.pde is an object that holds the frame for each
//              animation in Galactic Glide.

class Animation {
  ArrayList<PImage> frames;
  int currentFrame;
  int counter;
  float posX;
  float posY;
  boolean isPlaying;
  
  //--------------------- Function: Constructor ---------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  Animation(String type, float posX, float posY) {
    frames = images.getAnimation("ship" + type + "_exp");
    currentFrame = 0;
    counter = 0;
    this.posX = posX;
    this.posY = posY;
    isPlaying = false;
  }
  //------------------------ Constructor End ------------------------//
  
  //--------------------- Function: isAnimating ---------------------//
  /**
   * Plays animation frame by frame
   */
  void isAnimating() {
      if (currentFrame < frames.size()) {
        image(frames.get(currentFrame), posX, posY);
        currentFrame++;
      }
      else {
        isPlaying = false;
      }
  }
  //------------------------ isAnimating End ------------------------//
}
