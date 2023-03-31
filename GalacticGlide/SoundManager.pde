// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: SoundManager.pde
// Description: SoundManager.pde handles all in game sounds including
//              loading sounds, and playing them when called.

import processing.sound.*;

class SoundManager {
  HashMap<String, SoundFile> sounds;
  
  /**
   * Constructor: creates the hashmap to hold all game sounds.
   */
  SoundManager(PApplet app) {
    sounds = createMap(app);
  }
  
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
    map.put("Laser",        new SoundFile(app, "Sounds/Laser.mp3"));
    
    return map;
  }
  
  /**
   * Plays a sound. Will print a warning instead if sound doesn't exist.
   * Example: soundManager.play("soundName");
   */
  void play(String soundName) {
    if (!sounds.containsKey(soundName)) {
      println("WARNING: Sound " + soundName + " doesn't exist. Skipping play().");
      return;
    }
    sounds.get(soundName).amp(0.2);
    sounds.get(soundName).play();
  }
  
  /**
   * Plays and loops a sound. Will print a warning instead if sound doesn't exist.
   * Example: soundManager.loop("soundName");
   */
  void loop(String soundName) {
    if (!sounds.containsKey(soundName)) {
      println("WARNING: Sound " + soundName + " doesn't exist. Skipping loop().");
      return;
    }
    sounds.get(soundName).amp(0.2);
    sounds.get(soundName).loop();
  }
  
  /**
   * Stops playing all sounds.
   */
  void stopAll() {
    for (SoundFile s : sounds.values())
      s.stop();
  }
}
