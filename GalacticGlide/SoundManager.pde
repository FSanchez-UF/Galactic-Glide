// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: SoundManager.pde
// Description: SoundManager.pde handles all in game sounds including
//              loading sounds, and playing them when called.

import processing.sound.*;

class SoundManager {
  HashMap<String, SoundFile> sounds;

  //------------------------ Function: Constructor -------------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  SoundManager(PApplet app) {
    sounds = createMap(app);
  }
  //--------------------------- Constructor End ----------------------------//
  
  
  //------------------------- Function: CreateMap --------------------------//
  /**
   * Helper to create the sound map and initialize sound files.
   */
  private HashMap<String, SoundFile> createMap(PApplet app) {
    HashMap<String, SoundFile> map = new HashMap<String, SoundFile>();
    map.put("Theme",        new SoundFile(app, "Sounds/Theme_Music.mp3"));
    map.put("Button",       new SoundFile(app, "Sounds/Button.mp3"));
    map.put("Win",          new SoundFile(app, "Sounds/Win.wav"));
    map.put("Lose",         new SoundFile(app, "Sounds/Lose.mp3"));
    map.put("Enemy_Death",  new SoundFile(app, "Sounds/Enemy_Destroyed.mp3"));
    map.put("Player_Death", new SoundFile(app, "Sounds/Player_Death.mp3"));
    map.put("Player_Hit",   new SoundFile(app, "Sounds/Player_Hit.wav"));
    map.put("Laser",        new SoundFile(app, "Sounds/Laser.mp3"));
    
    return map;
  }
  //---------------------------- CreateMap End -----------------------------//
  
  
  //-------------------------- Function: PlaySFX ---------------------------//
  /**
   * Plays a sound. Will print a warning instead if sound doesn't exist.
   * Example: soundManager.play("soundName");
   */
  void playSFX(String soundName) {
    if (!sounds.containsKey(soundName)) {
      println("WARNING: Sound " + soundName + " doesn't exist. Skipping play().");
      return;
    }
    sounds.get(soundName).amp(1 * menu.sfx.getValue()/100);
    sounds.get(soundName).play();
  }
  //----------------------------- PlaySFX End ------------------------------//
  
  
  //------------------------- Function: PlayMusic --------------------------//
  /**
   * Plays music. Will print a warning instead if sound doesn't exist. Allows for
   * music and sound effects to have separate volume
   * Example: soundManager.play("soundName");
   */
  void playMusic(String soundName) {
    if (!sounds.containsKey(soundName)) {
      println("WARNING: Sound " + soundName + " doesn't exist. Skipping play().");
      return;
    }
    sounds.get(soundName).amp(0.2 * menu.music.getValue()/100);
    sounds.get(soundName).play();
  }
  //---------------------------- PlayMusic End -----------------------------//
  
  
  //---------------------------- Function: Loop ----------------------------//
  /**
   * Plays and loops a sound. Will print a warning instead if sound doesn't exist.
   * Example: soundManager.loop("soundName");
   */
  void loop(String soundName) {
    if (!sounds.containsKey(soundName)) {
      println("WARNING: Sound " + soundName + " doesn't exist. Skipping loop().");
      return;
    }
    sounds.get(soundName).loop();
  }
  //------------------------------- Loop End -------------------------------//
  
  
  //-------------------------- Function: StopAll ---------------------------//
  /**
   * Stops playing all sounds.
   */
  void stopAll() {
    for (SoundFile s : sounds.values())
      s.stop();
  }
  //----------------------------- StopAll End ------------------------------//
}
