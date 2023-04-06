// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: MenuScreen.pde
// Description: MenuScreen.pde handles the main menu and input related to it.

import controlP5.*;

class MenuScreen {
  
  Button start;
  Button scores;
  Button quit;
  Button settings;
  Button help;
  Button back;
  Textlabel title, scoresLabel, settingsLabel, helpLabel;
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
    
    title = cp5.addTextlabel("Galactic Glide")
      .setText("Galactic Glide")
      .setPosition(width/2-430, 200)
      .setFont(cf2)
      .hide()
    ;   
    
    back = cp5.addButton("back") // back button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 690)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf1)
      .setBroadcast(true)
      .hide()
    ;
    
    scoresLabel = cp5.addTextlabel("SCORELABEL")
      .setText("High Scores")
      .setPosition(width/2-345, 50)
      .setFont(cf2)
      .hide()
    ;
    
    settingsLabel = cp5.addTextlabel("SETTINGSLABEL")
      .setText("Settings")
      .setPosition(width/2-253, 50)
      .setFont(cf2)
      .hide()
    ;
    
    helpLabel = cp5.addTextlabel("HELPLABEL")
      .setText("Help")
      .setPosition(width/2-140, 50)
      .setFont(cf2)
      .hide()
    ;
    
  }
  
  /**
   * Displays the menu buttons
   */
  void display() {
    background(images.Get("menu_backgrd"));
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
  
  void displayScores() {
    back.show();
    scoresLabel.show();
    rectMode(CENTER);
    rect(width/2, 130, 700, 5);
    int y = 0;
    String[] highScores = loadStrings("Scores.txt");
    for (String highScore : highScores) {
      text(highScore,width/2, 230+y);
      y += 100;
    }
  }
  
  void hideScores() {
    back.hide();
    scoresLabel.hide();
  }
  
  void displaySettings() {
    back.show();
    settingsLabel.show();
    rectMode(CENTER);
    rect(width/2, 130, 500, 5);
  }
  
  void hideSettings() {
    back.hide();
    settingsLabel.hide();
  }
  
  void displayHelp() {
    // Show control p5 elements
    back.show();
    helpLabel.show();
    // Draw line to highlight help label
    rectMode(CENTER);
    rect(width/2, 120, 295, 5);
    
    
    // Semi transparent rectangle
    fill(0, 0, 0, 192);
    strokeWeight(4);
    stroke(255);
    rect(width/2, height/2, 800, 500);
    
    // Read help guide from file
    String[] helpGuide = loadStrings("Help.txt");
    int[] line = {140, 35, 35, 35, 70, 105, 70};
    int[] title = {225, 312, 348, 384, 435, 523, 615};
    int y = 0;
    strokeWeight(1);
    fill(255);
    rect(width/2-200, height/2, 3, 500);
    textSize(14);
    
    // Draw text
    for (int i = 0; i < 14; i+=2) {
      fill(0, 200, 0);
      text(helpGuide[i], width/2-300, title[i/2]);
      // Matrix lines
      y += line[i/2];
      fill(255);
      if (i/2 < 6) rect(width/2, 150+y, 800, 3);
      
    }
    
    // Descriptions
    int[] text = {233, 318, 353, 388, 446, 537, 627};
    int[] size = {150, 40, 40, 40, 80, 115, 80};
    noStroke();
    fill(255);
    textFont(createFont("Cinzel-SemiBold.ttf", 14));
    textSize(15);
    textAlign(LEFT);
    
    for (int i = 1; i < 14; i+=2) {
      text(helpGuide[i], width/2+105, text[(i-1)/2], 590, size[(i-1)/2]);
    }
    
    // Reset text properties
    textFont(createFont("Goudy Stout", 55));
    textAlign(CENTER);
  }
  
  void hideHelp() {
    back.hide();
    helpLabel.hide();
  }
}

// IDEA: show player rocket flying across main menu
