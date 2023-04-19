// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: GalacticGlide.pde
// Description: GalacticGlide.pde is the central component of the "Galactic Glide"
//              game, as it contains all the code necessary to run the 
//              game. It acts as a bridge between the user interface and 
//              the game logic, and handles various tasks such as initializing 
//              the game world, loading game assets, and managing game events.
//
// NOTE: This game requires the below libraries to run. All of them can be downloaded
// from the default library browser (Sketch > Import Library > Manage Libraries...).
//  - ControlP5
//  - Sound
//  - Sprites

final boolean DEBUG = false; // Set in code, displays extra info
boolean ready = false;       // Whether the game is ready
int difficulty = 1;          // Which difficulty the game is set to; 0-easy, 1-normal, 2-hard
int difficulty_score = 1;    // Which difficulty score menu will be seen (normal by default)

Game game;
SoundManager sound;
ImageManager images;
MenuScreen menu;
StringList highScores_easy, highScores_norm, highScores_hard;
Boolean submitted = false;

ControlP5 cp5;
String screen;

void setup() {
  size(1000, 800);
  background(loadImage("Sprites/menu_background1.png"));
  textFont(createFont("Goudy Stout", 55));
  textAlign(CENTER);
  text("LOADING...", width/2, height/2);
  screen = "main";
  
  cp5 = new ControlP5(this);
  cp5.setUpdate(false);
  cp5.setAutoDraw(false);
  thread("init");
  
  frameRate(60);
}

void draw() {
  if (ready) { // Allow thread init to finish before starting game
    if (screen == "main") {
      menu.display();
    } 
    else if (screen == "settings") {
      menu.displaySettings();
    }
    else if (screen == "difficulty") {
      menu.displayDifficulty(); 
    }
    else if (screen == "scores") {
      menu.displayScores(); 
    }
      
    if (game != null && game.active) {
      menu.hide();
      game.update();
      game.display();   
    }
  }
}

/**
 * Uses threading to load all assets
 */
void init() {
  images = new ImageManager();
  images.Load("menu_backgrd", "menu_background1.png");
  images.Load("game_backgrd", "gameplay_background.png");
  
  sound = new SoundManager(this);
  menu = new MenuScreen();
  sound.loop("Theme");
  sound.sounds.get("Theme").amp(0.2 * menu.music.getValue()/100);
  loadScores();
  
  ready = true;
  cp5.setUpdate(true);
  cp5.setAutoDraw(true);
}

/**
 * Handles all key presses from player
 */
void keyPressed() {
  if (game != null && !game.endGame) game.handleKeyPress();
}

/**
 * Handles all key releases from player
 */
void keyReleased() {
  if (game != null && !game.endGame) game.handleKeyRelease();
}

/**
 * Handles all cp5 button clicks
 */
void controlEvent(ControlEvent theEvent) {
  if (!ready)
    return;
  
  String eventType = theEvent.getController().getName();
  
  switch (eventType) {
    case("START"):               // Start game
      screen = "difficulty";
      menu.hide();
      sound.playSFX("Button");
      break;
    case("SCORES"):              // Show scores
      menu.hide();
      menu.displayScores();
      screen = "scores";
      sound.playSFX("Button");
      break;
    case("EXIT"):                // Exit game
      exit();
      sound.playSFX("Button");
      break;
    case("back"):                // Go Back
      menu.hideScores();
      menu.hideSettings();
      menu.hideHelp();
      menu.hideDifficulty();
      screen = "main";
      sound.playSFX("Button");
      break;
    case("settings"):            // Show settings
      menu.hide();
      menu.displaySettings();
      screen = "settings";
      sound.playSFX("Button");
      break;
    case("help"):                // Show help
      menu.hide();
      menu.displayHelp();
      screen = "help";
      sound.playSFX("Button");
      break;
    case("resume"):              // Close pause menu
      menu.hidePause();
      game.sw.reset();
      game.gameClock.start();
      game.bossClock.start();
      sound.playSFX("Button");
      break;
    case("restart"):             // Restart game
      sound.playSFX("Button");
      submitted = false;
      game.quitGame();
      menu.hidePause();
      menu.hideEndgame();
      game = null;
      game = new Game(this);
      game.startGame();
      break;
    case("quit"):                // Quit game
      sound.playSFX("Button");
      submitted = false;
      menu.hidePause();
      menu.hideEndgame();
      game.quitGame();
      game = null;
      screen = "main";
      break;
    case("easy"):                // Choose easy difficulty
      chooseDifficulty(0);
      break;
    case("normal"):              // Choose normal difficulty
      chooseDifficulty(1); 
      break;
    case("hard"):                // Choose hard difficulty
      chooseDifficulty(2);
      break;
    case("easy_score"):          // View easy mode scores
      sound.playSFX("Button");
      difficulty_score = 0;
      break;
    case("normal_score"):        // View normal mode scores
      sound.playSFX("Button");
      difficulty_score = 1;
      break;
    case("hard_score"):          // View hard mode scores
      sound.playSFX("Button");
      difficulty_score = 2;
      break;
    case("Submit"):              // Submit score
      sound.playSFX("Button");
      String in = cp5.get(Textfield.class,"Enter Initials").getText();
      saveScores(in, game.score, game.convertSecondsToText());
      loadScores();
      break;
  }
}

/**
 * Helper function for setting difficulty based on player input
 */
void chooseDifficulty(int diff) {
  sound.playSFX("Button");
  difficulty = diff;
  menu.hideDifficulty();
  screen = "main";
  game = new Game(this);
  game.startGame();
}

/**
 * Saves a new high score to Scores.txt in the proper position 
 */
void saveScores(String initial, int newScore, String time) {
  if (initial.length() > 2) initial = initial.substring(0, 2);
  initial.toUpperCase();
  
  String newInput = initial + " " + newScore + " " + time;
  StringList highScores = chooseByDiff(highScores_easy, highScores_norm, highScores_hard);
  
  for (int i = 0; i < highScores.size(); i++) {
    if (newInput.equals(highScores.get(i))) return;
  }
  
  if (highScores.size() < 5) highScores.append(newInput);
  
  if (highScores.size() > 1) {
    highScores.set(highScores.size()-1, newInput);
    for (int i = 0; i < highScores.size(); i++) {
      for (int j = i + 1; j < highScores.size(); j++) {
        // Checking elements
        String temp;
        String[] tmpi = split(highScores.get(i), ' ');
        String[] tmpj = split(highScores.get(j), ' ');
        if (int(tmpj[1]) > int(tmpi[1])) {
          // Swapping
          temp = highScores.get(i);
          highScores.set(i, highScores.get(j));
          highScores.set(j, temp);
        }
      }
    }
  } //<>//
  
  String file = chooseByDiff("Scores_easy", "Scores_normal", "Scores_hard");
  saveStrings(dataPath(file + ".txt"), highScores.toArray(new String[highScores.size()]));
}

/**
 * Loads Scores files for high score displaying 
 */
void loadScores() {
  try {
    highScores_easy = new StringList(loadStrings("Scores_easy.txt"));   // Load easy scores from txt file
  } catch(Exception e) {
    createWriter("data/Scores_easy.txt");
  }
  
  try {
    highScores_norm = new StringList(loadStrings("Scores_normal.txt")); // Load normal scores from txt file
  } catch(Exception e) {
    createWriter("data/Scores_normal.txt");
  }
  
  try {
    highScores_hard = new StringList(loadStrings("Scores_hard.txt"));   // Load easy scores from txt file
  } catch(Exception e) {
    createWriter("data/Scores_hard.txt");
  }
}
