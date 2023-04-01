// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: MenuScreen.pde
// Description: MenuScreen handles the main menu and input related to it.

import controlP5.*;

class MenuScreen {
  
  Button start;
  Button scores;
  Button quit;
  Button settings;
  Button help;
  Textlabel title;
  ControlFont cf1 = new ControlFont(createFont("Goudy Stout", 24));
  ControlFont cf2 = new ControlFont(createFont("Goudy Stout", 55));
  
  /**
   * Constructor: Loads relevant menu images and creates buttons
   */
  MenuScreen() {
    // Load images
    images.Load("help"          , "Help.png");
    images.Load("help_hover"    , "Help_Hover.png");
    images.Load("settings"      , "Settings.png");
    images.Load("settings_hover", "Settings_Hover.png");
    
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
    
    help = cp5.addButton("help") // help button
      .setBroadcast(false)
      .setValue(0)
      .setImages(images.Get("help"), images.Get("help_hover"), images.Get("help_hover"))
      .setPosition(width-60, height-60)
      .setSize(50, 50)
      .setBroadcast(true)
      .hide()
    ;
    
    settings = cp5.addButton("settings") // settings button
      .setBroadcast(false)
      .setImages(images.Get("settings"), images.Get("settings_hover"), images.Get("settings_hover"))
      .setValue(0)
      .setPosition(5, height-60)
      .setSize(50, 50)
      .setBroadcast(true)
      .hide()
    ;
    
    title = cp5.addTextlabel("Maximum Steps Label")
      .setText("Galactic Glide")
      .setPosition(width/2-430, 200)
      .setFont(cf2)
    ;   
    
  }
  
  /**
   * Displays the menu buttons
   */
  void display() {
    start.show();
    scores.show();
    quit.show();
    title.show();
    help.show();
    settings.show();
  }
  
  /**
   * Hides the menu buttons
   */
  void hide() {
    start.hide();
    scores.hide();
    quit.hide();
    title.hide();
    help.hide();
    settings.hide();
  }
  
  /**
   * Play button press sound when a menu button is clicked
   */
  void buttonSound() {
    if (start.isPressed() || scores.isPressed() || quit.isPressed() || settings.isPressed() || help.isPressed()) {
      sound.play("Button");
    }
  }
}

// IDEA: show player rocket flying across main menu
