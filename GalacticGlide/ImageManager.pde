// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: ImageManager.pde
// Description: ImageManager.pde handles all in game sprites including
//              menu icons, player sprite, and all others.

class ImageManager {
  HashMap<String, ArrayList<PImage>> images;

  //--------------------------------- Function: Constructor --------------------------------//
  /**
   * Creates class object and intializes relevant variables
   */
  ImageManager() {
    images = new HashMap<String, ArrayList<PImage>>();
    loadAnimationSequences();
  }
  //------------------------------------ Constructor End -----------------------------------//
  
  
  //------------------------------------ Function: Load ------------------------------------//
  /**
   * Load image into the hashmap with the specified key
   */
  void Load(String name, String fileName) {
    PImage image = loadImage("Sprites/" + fileName);
    ArrayList<PImage> imageList = new ArrayList<PImage>();
    imageList.add(image);
    images.put(name, imageList);
  }
  
  /**
   * Loads an array of images into the hashmap with the specified key
   */
  void Load(String name, String fileName, int size) {
    for (int i = 0; i < size; i++) {
      PImage image = loadImage("Sprites/" + fileName + i + ".png");
      if (images.containsKey(name)) {
          images.get(name).add(image);
      } else {
          ArrayList<PImage> imageList = new ArrayList<PImage>();
          imageList.add(image);
          images.put(name, imageList);
      }
    }
  }
  //--------------------------------------- Load End ---------------------------------------//
  
  
  //------------------------------------- Function: Get ------------------------------------//
  /**
   * Retrieves the first image from the ArrayList in the hashmap with the specified key
   */
  PImage Get(String name) {
    // Check if the key exists
    if (images.get(name) == null) {
      println("WARNING: PImage " + name + " doesn't exist. Load it first");
      return null;  
    }
    return images.get(name).get(0);
  }

  /**
   * Retrieves either part or all of the ArrayList in the hashmap with the specified key
   */
  ArrayList<PImage> getAnimation(String name) {
    // Check if the key exists
    if (images.get(name) == null) {
        System.out.println("WARNING: PImage ArrayList " + name + " doesn't exist. Load it first");
        return null;
    }
    
    // Get the ArrayList<PImage> for the given name
    return images.get(name);
  }
  //--------------------------------------- Get End ----------------------------------------//
  
  
  //--------------------------- Function: LoadAnimationSequences ---------------------------//
  /**
   * Initializes all animation sequences used by the game
   */
  void loadAnimationSequences() {
    // Load enemy ship explosion animation sequences
    this.Load("ship1_exp", "PNG_Animations/Explosions/Ship1_Explosion/Ship1_Explosion_00", 9);
    this.Load("ship2_exp", "PNG_Animations/Explosions/Ship2_Explosion/Ship2_Explosion_00", 10);
    this.Load("ship3_exp", "PNG_Animations/Explosions/Ship3_Explosion/Ship3_Explosion_00", 10);
    this.Load("ship4_exp", "PNG_Animations/Explosions/Ship4_Explosion/Ship4_Explosion_00", 10);
    this.Load("ship5_exp", "PNG_Animations/Explosions/Ship5_Explosion/Ship5_Explosion_00", 10);
    this.Load("ship6_exp", "PNG_Animations/Explosions/Ship6_Explosion/Ship6_Explosion_00", 10);
    
    // Load player ship explosion animation sequences
    this.Load("shipPlayer_exp", "/Player_Explosion/player1_exp_", 10);
    
    // Load enemy laser/bullet animation sequences
    this.Load("shot1", "PNG_Animations/Shots/Shot1/shot1_", 5);
    this.Load("shot2", "PNG_Animations/Shots/Shot2/shot2_", 6);
    this.Load("shot3", "PNG_Animations/Shots/Shot3/shot3_", 4);
    this.Load("shot4", "PNG_Animations/Shots/Shot4/shot4_", 5);
    this.Load("shot5", "PNG_Animations/Shots/Shot5/shot5_", 6);
    this.Load("shot6", "PNG_Animations/Shots/Shot6/shot6_", 4);
    
    // Load enemy laser/bullet explosion animation sequences
    this.Load("shot1_exp", "PNG_Animations/Shots/Shot1/shot1_exp", 5);
    this.Load("shot2_exp", "PNG_Animations/Shots/Shot2/shot2_exp", 5);
    this.Load("shot3_exp", "PNG_Animations/Shots/Shot3/shot3_exp", 4);
    this.Load("shot4_exp", "PNG_Animations/Shots/Shot4/shot4_exp", 8);
    this.Load("shot5_exp", "PNG_Animations/Shots/Shot5/shot5_exp", 8);
    this.Load("shot6_exp", "PNG_Animations/Shots/Shot6/shot6_exp", 10);
  }
  //------------------------------ LoadAnimationSequences End ------------------------------//
}
