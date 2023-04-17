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
int difficulty = 1;  // Which difficulty the game is set to; 0-easy, 1-normal, 2-hard

Game game;
SoundManager sound;
ImageManager images;
MenuScreen menu;
String[] highScores;
Boolean submitted = false;

ControlP5 cp5;
String screen;

void setup() {
  size(1000, 800);
  background(loadImage("Sprites/menu_background.png"));
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
  images.Load("menu_backgrd", "menu_background.png");
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

void keyPressed() {
  if (game != null && !game.endGame) game.handleKeyPress();
}

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
    case("back"): // Go Back
      menu.hideScores();
      menu.hideSettings();
      menu.hideHelp();
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
    case("easy"):
      chooseDifficulty(0);
      break;
    case("normal"):
      chooseDifficulty(1);
      break;
    case("hard"):
      chooseDifficulty(2);
      break;
    case("Submit"):                // Submit score
      sound.playSFX("Button");
      String in = cp5.get(Textfield.class,"Enter Initials").getText();
      saveScores(in, game.score);
      loadScores();
      break;
  }
}

void chooseDifficulty(int diff) {
  sound.playSFX("Button");
  difficulty = diff;
  menu.hideDifficulty();
  screen = "main";
  game = new Game(this);
  game.startGame();
}

void saveScores(String initial, int newScore) {
  if (initial.length() > 3) initial=initial.substring(0,3);
  String newInput = initial + " " + newScore;
  for (int i = 0; i < highScores.length; i++) {
    if (newInput.equals(highScores[i])) return;
  }
  
  highScores[highScores.length-1] = newInput;
  for (int i = 0; i < highScores.length; i++) {
    for (int j = i + 1; j < highScores.length; j++) {
      // Checking elements
      String temp;
      String[] tmpi = split(highScores[i], ' ');
      String[] tmpj = split(highScores[j], ' ');
      if (int(tmpj[1]) > int(tmpi[1])) {
        // Swapping
        temp = highScores[i];
        highScores[i] = highScores[j];
        highScores[j] = temp;
      }
    }
  }
  saveStrings(dataPath("Scores.txt"), highScores);
}

void loadScores() {
  highScores = loadStrings("Scores.txt"); // Load scores from txt file
}
