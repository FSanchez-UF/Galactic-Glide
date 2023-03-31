// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: GalacticGlide.pde
// Description: GalacticGlide.pde is the central component of the "Galactic Glide"
//              game, as it contains all the code necessary to run the 
//              game. It acts as a bridge between the user interface and 
//              the game logic, and handles various tasks such as initializing 
//              the game world, loading game assets, and managing game events.

// Debug mode: display extra information
final boolean DEBUG = true;

Game game;
// Player is only here for test purposes; should be moved to Game class.
Player p;

ControlP5 cp5;
MenuScreen menu;
PImage backgrd;

void setup() {
  size(1000, 800);
  backgrd = loadImage("space_background.png");
  game = new Game();
  p = new Player("test.png", 100, 100, 0, 0, 50, 50);
  cp5 = new ControlP5(this);
  menu = new MenuScreen();
}

void draw() {
  background(backgrd);
  menu.display();
  p.update();
  p.display();
}

void keyPressed() {
  p.handleKeyPress();
}

void keyReleased() {
  p.handleKeyRelease();
}
