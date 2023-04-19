// Galactic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: MenuScreen.pde
// Description: MenuScreen.pde handles the main menu and input related to it.

import controlP5.*;

class MenuScreen {
  
  Button start, scores, exit;   // Main menu
  Button resume, restart, quit; // Pause menu
  Button easy, normal, hard;    // Difficulty selection menu
  Button easy_score, normal_score, hard_score; // Scores selection for each mode
  Button settings;
  Button help;
  Button back;
  Button submitScore;
  Slider music, sfx, fRate;     // Settings sliders
  Textlabel title, scoresLabel, settingsLabel, helpLabel, musicLabel, sfxLabel, fRateLabel, difficultyLabel, endLabel;
  Textfield initials;
  ControlFont cf1 = new ControlFont(createFont("Goudy Stout", 24));
  ControlFont cf2 = new ControlFont(createFont("Goudy Stout", 55));
  ControlFont cf3 = new ControlFont(createFont("Cooper-Black-Regular.ttf", 35));
  
  //--------------------------------- Function: Constructor --------------------------------//
  /**
   * Creates class object and intializes relevant variables
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
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;
    
    scores = cp5.addButton("SCORES") // Scoreboard button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 500)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;
    
    exit = cp5.addButton("EXIT") // quit button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 600)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf3)
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
    
    title = cp5.addTextlabel("Galactic Glide") // Game title
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
    
    music = cp5.addSlider("music") // music volume slider
     .setPosition(width/2-200, 275)
     .setSize(400, 30)
     .setRange(0, 100)
     .setValue(50)
     .setDecimalPrecision(0)
     .hide();
    ;
    music.getValueLabel().setFont(createFont("Arial", 24));
    music.getCaptionLabel().setVisible(false);
    
    musicLabel = cp5.addTextlabel("MUSICLABEL")
       .setText("MUSIC")
       .setPosition(width/2-62, 225)
       .setFont(cf3)
       .hide();
    ;
    
    sfx = cp5.addSlider("sfx") // Sound effects volume slider
     .setPosition(width/2-200, 385)
     .setSize(400, 30)
     .setRange(0, 100)
     .setValue(50)
     .setDecimalPrecision(0)
     .hide();
    ;
    sfx.getValueLabel().setFont(createFont("Arial", 24));
    sfx.getCaptionLabel().setVisible(false);
    
    sfxLabel = cp5.addTextlabel("SFXLABEL")
       .setText("SFX")
       .setPosition(width/2-39, 335)
       .setFont(cf3)
       .hide();
    ;
    
    fRate = cp5.addSlider("fRate") // Framerate slider
     .setPosition(width/2-200, 495)
     .setSize(400, 30)
     .setRange(60, 144)
     .setValue(60)
     .setDecimalPrecision(0)
     .hide();
    ;
    fRate.getValueLabel().setFont(createFont("Arial", 24));
    fRate.getCaptionLabel().setVisible(false);
    
    fRateLabel = cp5.addTextlabel("FRATELABEL")
       .setText("FRAMERATE")
       .setPosition(width/2-120, 445)
       .setFont(cf3)
       .hide();
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
    
    resume = cp5.addButton("resume") // resume nutton
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 265)
      .setColorBackground(color(0, 130, 0))
      .setSize(300, 50)
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;
    
    restart = cp5.addButton("restart") // restart button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 375)
      .setColorBackground(color(0, 130, 0))
      .setSize(300, 50)
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;

    quit = cp5.addButton("quit") // quit button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 485)
      .setColorBackground(color(0, 130, 0))
      .setSize(300, 50)
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;
    
    difficultyLabel = cp5.addTextlabel("DIFFLABEL")
      .setText("Choose Difficulty")
      .setPosition(width/2-440, 50)
      .setFont(createFont("Goudy Stout", 45))
      .hide()
    ;
    
    easy = cp5.addButton("easy") // Difficulty easy button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 265)
      .setColorBackground(color(0, 130, 0))
      .setSize(300, 50)
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;
    
    normal = cp5.addButton("normal") // Difficulty normal button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 375)
      .setColorBackground(color(0, 130, 0))
      .setSize(300, 50)
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;
    
    hard = cp5.addButton("hard") // Difficulty hard button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 485)
      .setColorBackground(color(0, 130, 0))
      .setSize(300, 50)
      .setFont(cf3)
      .setBroadcast(true)
      .hide()
    ;
    
    endLabel = cp5.addTextlabel("Lose")
      .setText("GAME OVER")
      .setPosition(width/2-250, 80)
      .setFont(createFont("Goudy Stout", 45))
      .hide()
    ;

    initials = cp5.addTextfield("Enter Initials")
      .setBroadcast(false)
      .setPosition(width/2-150, 300)
      .setSize(180,50)
      .setFont(createFont("Cooper-Black-Regular.ttf", 20))
      .setAutoClear(true)
      .setBroadcast(true)
      .setInputFilter(ControlP5.STRING)
      .hide()
    ;
    
    submitScore = cp5.addButton("Submit") // quit button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2+50, 300)
      .setSize(100, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(createFont("Cooper-Black-Regular.ttf", 20))
      .setBroadcast(true)
      .hide()
    ;
    
    easy_score = cp5.addButton("easy_score") // Easy mode score selection button
      .setBroadcast(false)
      .setValue(0)
      .setCaptionLabel("Easy")
      .setPosition(width/2-305, 610)
      .setSize(200, 40)
      .setColorBackground(color(0, 0, 0))
      .setFont(createFont("Cooper-Black-Regular.ttf", 20))
      .setBroadcast(true)
      .hide()
    ;
    
    normal_score = cp5.addButton("normal_score") // Normal mode score selection button
      .setBroadcast(false)
      .setValue(0)
      .setCaptionLabel("Normal")
      .setPosition(width/2-100, 610)
      .setSize(200, 40)
      .setColorBackground(color(0, 0, 0))
      .setFont(createFont("Cooper-Black-Regular.ttf", 20))
      .setBroadcast(true)
      .hide()
    ;
    
    hard_score = cp5.addButton("hard_score") // Hard mode score selection button
      .setBroadcast(false)
      .setValue(0)
      .setCaptionLabel("Hard")
      .setPosition(width/2+105, 610)
      .setSize(200, 40)
      .setColorBackground(color(0, 0, 0))
      .setFont(createFont("Cooper-Black-Regular.ttf", 20))
      .setBroadcast(true)
      .hide()
    ;
    
  }
  //------------------------------------ Constructor End -----------------------------------//
  
  
  //-------------------------------- Functions: Display/Hide -------------------------------//
  /**
   * Displays the menu buttons
   */
  void display() {
    background(images.Get("menu_backgrd"));
    start.show();
    scores.show();
    exit.show();
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
    exit.hide();
    title.hide();
    help.hide();
    settings.hide();
  }
  //------------------------------------ Display/Hide End ----------------------------------//
  
  
  //-------------------------- Functions: DisplayScores/HideScores -------------------------//
  /**
   * Displays the high scores menu
   */
  void displayScores() {
    background(images.Get("menu_backgrd"));
    back.show();
    scoresLabel.show();
    easy_score.show();
    normal_score.show();
    hard_score.show();
    
    // Semi transparent rectangle
    fill(0, 0, 0, 192);  
    stroke(255);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2-25, 800, 450);
    
    // Grid lines
    fill(255);
    line(width/2-400, height/2-200, width/2+400, height/2-200); // Top bar
    line(width/2-205, height/2-250, width/2-205, height/2+200); // Rank/Score separator
    line(width/2+190, height/2-250, width/2+190, height/2+200); // Score/Time separator
    
    // Titles
    textFont(createFont("Cooper-Black-Regular.ttf", 45));
    text("Rank", width/2-300, height/2-210);
    text("Score", width/2, height/2-210);
    text("Time", width/2+295, height/2-210);
    
    // Values
    noStroke();
    int y = 0;
    int rank = 1;
    loadScores();
    String[] highScores = highScores_norm.toArray(new String[highScores_norm.size()]);
    
    easy_score.setColorBackground(color(0, 0, 0));
    normal_score.setColorBackground(color(0, 0, 0));
    hard_score.setColorBackground(color(0, 0, 0));
    
    switch(difficulty_score) {
      case 0: 
        highScores = highScores_easy.toArray(new String[highScores_easy.size()]);
        easy_score.setColorBackground(color(0, 0, 217));
        break;
      case 1:
        normal_score.setColorBackground(color(0, 0, 217));
        break;
      case 2: 
        highScores = highScores_hard.toArray(new String[highScores_hard.size()]);
        hard_score.setColorBackground(color(0, 0, 217));
        break;
    }

    if (highScores.length > 0) {
      for (String highScore : highScores) {
        String[] section = split(highScore, ' ');
        textAlign(LEFT);
        text("#" + rank++ + "  " + section[0], width/2-375, 255+y);
        text(section[2], width/2+200, 255+y);
        textAlign(CENTER);
        text(section[1], width/2, 255+y);
        y += 80;
      }
    }
    
    for (int i = rank; i < 6; i++) {
      textAlign(LEFT);
      text("#" + i, width/2-335, 255+y);
      y += 80;
    }
    textAlign(CENTER); // reset
  }

  /**
   * Hides the scores menu
   */
  void hideScores() {
    back.hide();
    scoresLabel.hide();
    easy_score.hide();
    normal_score.hide();
    hard_score.hide();
  }
  //----------------------------- DisplayScores/HideScores End -----------------------------//
  
  
  //------------------------ Functions: DisplaySettings/HideSettings -----------------------//
  /**
   * Display the settings menu
   */
  void displaySettings() {
    background(images.Get("menu_backgrd"));
    back.show();
    settingsLabel.show();
    music.show();
    musicLabel.show();
    sfx.show();
    sfxLabel.show();
    fRate.show();
    fRateLabel.show();
    frameRate(fRate.getValue());                                    // Set framerate to value of slider
    sound.sounds.get("Theme").amp(0.2 * menu.music.getValue()/100); // Set music volume to value of slider
    
    // Semi transparent rectangle
    fill(0, 0, 0, 192);
    stroke(255);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2, 600, 500);
    noStroke();
  }
  
  /**
   * Hides the settings menu
   */
  void hideSettings() {
    back.hide();
    settingsLabel.hide();
    music.hide();
    musicLabel.hide();
    sfx.hide();
    sfxLabel.hide();
    fRate.hide();
    fRateLabel.hide();
  }
  //--------------------------- DisplaySettings/HideSettings End ---------------------------//
  
  
  //---------------------------- Functions: DisplayHelp/HideHelp ---------------------------//
  /**
   * Display the help menu
   */
  void displayHelp() {
    back.show();
    helpLabel.show();
    
    // Semi transparent rectangle
    fill(0, 0, 0, 192);  
    stroke(255);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2, 800, 500);
    
    // Read help guide from file
    String[] helpGuide = loadStrings("Help.txt");
    int[] line = {140, 35, 35, 35, 70, 105, 70};
    int[] title = {225, 315, 351, 385, 436, 525, 618};
    int y = 0;
    strokeWeight(1);
    fill(255);
    rect(width/2-200, height/2, 3, 500);
    textFont(createFont("Cooper-Black-Regular.ttf", 27));
    
    // Draw text
    for (int i = 0; i < 14; i+=2) {
      fill(0, 200, 0);
      text(helpGuide[i], width/2-300, title[i/2]);
      // Text cell lines
      y += line[i/2];
      fill(255);
      if (i/2 < 6) rect(width/2, 150+y, 800, 3);
      
    }
    
    // Description positions and box sizes
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
    noStroke();
  }
  
  /**
   * Hide the help menu
   */
  void hideHelp() {
    back.hide();
    helpLabel.hide();
  }
  //------------------------------- DisplayHelp/HideHelp End -------------------------------//
  
  
  //--------------------------- Functions: DisplayPause/HidePause --------------------------//
  /**
   * Display the pause menu
   */
  void displayPause() {
    game.paused = true;
    resume.show();
    restart.show();
    quit.show();
    
    // Semi transparent rectangle
    fill(0, 0, 0, 192);
    stroke(255);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2, 600, 500);
    noStroke();
  }
  
  /**
   * Hide the pause menu
   */
  void hidePause() {
    resume.hide();
    restart.hide();
    quit.hide();
    game.paused = false;
  }
  //------------------------------ DisplayPause/HidePause End ------------------------------//
  
  
  //---------------------- Functions: DisplayDifficulty/HideDifficulty ---------------------//
  /**
   * Display difficulty selection menu
   */
  void displayDifficulty() {
    background(images.Get("menu_backgrd"));
    difficultyLabel.show();
    easy.show();
    normal.show();
    hard.show();
    back.show();
    
    // Semi transparent rectangle
    fill(0, 0, 0, 192);
    stroke(255);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2, 600, 500);
    noStroke();
  }
  
  /**
   * Hide difficulty selection menu
   */
  void hideDifficulty() {
    difficultyLabel.hide();
    easy.hide();
    normal.hide();
    hard.hide();
    back.hide();
  }
  //------------------------- DisplayDifficulty/HideDifficulty End -------------------------//
  
  
  //------------------------- Functions: DisplayEndgame/HideEndgame ------------------------//
  /**
   * Display the pause menu
   */
  void displayEndgame() {
    hide();
    restart.show();
    quit.show();
    endLabel.show();
    
    // Semi transparent rectangle
    fill(0, 0, 0, 192);
    stroke(255);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2, 600, 500);
    noStroke();
    
    textAlign(CENTER);
    textFont(createFont("Goudy Stout", 40));
    fill(255);

    restart.setPosition(width/2-150, 415);
    quit.setPosition(width/2-150, 525);
    
    String[] highScores = chooseByDiff(highScores_easy, highScores_norm, highScores_hard).toArray();
    String[] lastScore = { "0 0 0" };
    if (highScores.length > 0) 
      lastScore = split(highScores[highScores.length-1], ' ');
    
    if (highScores.length < 5 || game.score > int(lastScore[1]) || submitted) {
      if (game.highScore == false) { 
        sound.playSFX("Highscore");
        game.highScore = true;
      }
      textFont(createFont("Goudy Stout", 35));
      text("NEW HIGH SCORE", width/2, 200);
      textFont(createFont("Goudy Stout", 40));
      text(game.score, width/2, 260);
      submitted = true;
      submitScore.show();
      initials.show();
    } else {
      text("SCORE", width/2, 280);
      text(game.score, width/2, 340);
    }
  }
  
  /**
   * Hide the pause menu
   */
  void hideEndgame() {
    restart.hide();
    quit.hide();
    endLabel.hide();
    submitScore.hide();
    initials.hide();
  }
  //---------------------------- DisplayEndgame/HideEndgame End ----------------------------//
}
