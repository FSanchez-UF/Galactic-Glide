// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: ImageManager.pde
// Description: ImageManager.pde handles all in game sprites including
//              menu icons, player sprite, and all others.

class ImageManager {
  HashMap<String, PImage> images;
  
  /**
   * Constructor: creates the hashmap to hold all game sprites.
   */
  ImageManager() {
    images = new HashMap();
  }
  
  /**
   * Loads an image into the hashmap with the specified key
   */
  void Load(String name, String fileName) {
    PImage image = loadImage("Sprites/" + fileName);
    images.put(name, image);
  }
  
  /**
   * Retrieves an image from the hashmap with the specified key
   */
  PImage Get(String name) {
    if (images.get(name) == null) {
      println("WARNING: PImage " + name + " doesn't exist. Load it first");
      return null;  
    }
    return images.get(name);
  }
}
