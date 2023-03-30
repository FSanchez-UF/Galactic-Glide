import controlP5.*;

class MenuScreen {
  
  Button start;
  Button help;
  Button scores;
  Textlabel title;
  ControlFont cf1 = new ControlFont(createFont("Goudy Stout", 24));
  ControlFont cf2 = new ControlFont(createFont("Goudy Stout", 40));
  
  MenuScreen() {
    
    start = cp5.addButton("START GAME") // start button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 400)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf1)
      .setBroadcast(true)
      .hide()
    ;
    
    help = cp5.addButton("HELP") // start button
      .setBroadcast(false)
      .setValue(0)
      .setPosition(width/2-150, 500)
      .setSize(300, 50)
      .setColorBackground(color(0, 130, 0))
      .setFont(cf1)
      .setBroadcast(true)
      .hide()
    ;
    
    scores = cp5.addButton("SCORES") // start button
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
      .setPosition(width/2-300, 200)
      .setFont(cf2)
    ;
    
  }
  
  void display() {
    start.show();
    help.show();
    scores.show();
    title.show();
    
  }
  
  void hide() {
    start.hide();
    help.hide();
    scores.hide();
    title.hide();
    
  }
  
}
