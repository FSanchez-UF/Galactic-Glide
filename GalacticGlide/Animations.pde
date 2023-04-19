

class Animations {
  ArrayList<PImage> frames;
  int currentFrame;
  int lastFrameTime;
  int counter;
  float posX;
  float posY;
  boolean isPlaying;
  
  Animations() {};
  
  Animations(String type, float posX, float posY) {
    frames = images.getAnimation("ship" + type + "_exp");
    currentFrame = 0;
    lastFrameTime = 0;
    counter = 0;
    this.posX = posX;
    this.posY = posY;
    isPlaying = false;
  }
  
  void isAnimating() {
      if (currentFrame < frames.size()) {
        image(frames.get(currentFrame), posX, posY);
        currentFrame++;
      }
      else {
        isPlaying = false;
      }
  }
}
