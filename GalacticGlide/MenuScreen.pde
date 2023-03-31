// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: MenuScreen.pde
// Description: MenuScreen handles the main menu and input related to it.

import controlP5.*;

class MenuScreen {
  
  Button start;
  Button scores;
  Button quit;
  Textlabel title;
  ControlFont cf1 = new ControlFont(createFont("Goudy Stout", 24));
  ControlFont cf2 = new ControlFont(createFont("Goudy Stout", 55));
  
  MenuScreen() {
    
    start = cp5.addButton("START") // start button
      .setLabel("START GAME")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 400)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf1)
      .setBroadcast(true)
      .hide()
    ;
    
    scores = cp5.addButton("SCORES") // Scoreboard button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 500)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf1)
      .setBroadcast(true)
      .hide()
    ;
    
    quit = cp5.addButton("EXIT") // quit button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 600)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf1)
      .setBroadcast(true)
      .hide()
    ;
    
    title = cp5.addTextlabel("Maximum Steps Label")
      .setText("Galactic Glide")
      .setPosition(width/2-430, 200)
      .setFont(cf2)
    ;   
    
  }
  
  void display() {
    start.show();
    scores.show();
    quit.show();
    title.show();
    
  }
  
  void hide() {
    start.hide();
    scores.hide();
    quit.hide();
    title.hide();
    
  }
  
  void buttonSound() {
    if (start.isPressed() || scores.isPressed() || quit.isPressed()) {
      sound.play("Button");
    }
  }
}

// IDEA: show player rocket flying across main menu
