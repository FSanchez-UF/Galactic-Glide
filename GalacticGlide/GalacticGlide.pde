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

Game game;

ControlP5 cp5;
MenuScreen menu;
PImage backgrd;

void setup() {
  size(1000, 800);
  backgrd = loadImage("space_background.png");
  game = new Game(this);
  
  cp5 = new ControlP5(this);
  menu = new MenuScreen();
}

void draw() {
  background(backgrd);
  menu.display();
  game.update();
  game.display();
}

void keyPressed() {
  game.handleKeyPress();
}

void keyReleased() {
  game.handleKeyRelease();
}
