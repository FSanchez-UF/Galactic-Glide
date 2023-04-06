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

// Debug mode: display extra information
final boolean DEBUG = false;
boolean ready = false;

Game game;
SoundManager sound;
ImageManager images;
MenuScreen menu;

ControlP5 cp5;
PImage backgrd;
String screen;

void setup() {
  size(1000, 800);
  thread("init");
  backgrd = loadImage("Sprites/menu_background.png");
  background(backgrd);
  textFont(createFont("Goudy Stout", 55));
  textAlign(CENTER);
  text("LOADING...", width/2, height/2);
  screen = "main";
  frameRate(120);
}

void draw() {
  if (ready) {
    if (screen == "main") {
      menu.display();
    }
    if (game.active) {
      menu.hide();
      game.update();
      game.display();
    }
  }
}

void init() {
  images = new ImageManager();
  images.Load("menu_backgrd", "menu_background.png");
  images.Load("game_backgrd", "gameplay_background.png");
  cp5 = new ControlP5(this);
  game = new Game(this);
  sound = new SoundManager(this);
  sound.loop("Theme");
  menu = new MenuScreen();
  ready = true;
}

void keyPressed() {
  game.handleKeyPress();
}

void keyReleased() {
  game.handleKeyRelease();
}

void mousePressed() {
  
}

// Menu Clicks
void controlEvent(ControlEvent theEvent) {
  if (!ready)
    return;
  
  String eventType = theEvent.getController().getName();
  sound.play("Button");
  switch (eventType) {
    case("START"): // Start game
      game.startGame();
      break;
    case("SCORES"): // Show scores
      menu.hide();
      background(backgrd);
      menu.displayScores();
      screen = "scores";
      break;
    case("back"): // Go Back
      menu.hideScores();
      menu.hideSettings();
      menu.hideHelp();
      background(backgrd);
      menu.display();
      break;
    case("settings"): // Show settings
      menu.hide();
      background(backgrd);
      menu.displaySettings();
      screen = "settings";
      break;
    case("help"): // Show help
      menu.hide();
      background(backgrd);
      menu.displayHelp();
      screen = "help";
      break;
    case("EXIT"): // Exit game
      exit();
      break;
  }
}
