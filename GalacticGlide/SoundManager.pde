// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: SoundManager.pde
// Description: SoundManager.pde handles all in game sounds including
//              loading sounds, and playing them when called.

import processing.sound.*;

class SoundManager {
  HashMap<String, SoundFile> sounds;
  
  /**
   * Constructor: load sounds.
   */
  SoundManager(PApplet app) {
    sounds = createMap(app);
  }
  
  /**
   * Helper to create the sound map and initialize sound files.
   */
  private HashMap<String, SoundFile> createMap(PApplet app) {
    HashMap<String, SoundFile> map = new HashMap<String, SoundFile>();
    
    // Example: map.put("soundName", new SoundFile(app, "sound.mp3"));
    
    return map;
  }
  
  /**
   * Plays a sound. Will print a warning instead if sound doesn't exist.
   */
  void play(String soundName) {
    if (!sounds.containsKey(soundName)) {
      println("WARNING: Sound " + soundName + " doesn't exist. Skipping play().");
      return;
    }
    sounds.get(soundName).play();
  }
  
  /**
   * Plays and loops a sound. Will print a warning instead if sound doesn't exist.
   */
  void loop(String soundName) {
    if (!sounds.containsKey(soundName)) {
      println("WARNING: Sound " + soundName + " doesn't exist. Skipping loop().");
      return;
    }
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
