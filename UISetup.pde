// controllers in welcome page
GGroup welcomePage;
GLabel wel_ID_lab;
GLabel wel_age_lab;
GLabel wel_gender_lab;
GTextArea wel_ID;
GTextArea wel_age;
GTextArea wel_gender;
GButton wel_confirm;

// controllers in recording page
GGroup recordPage;
GButton rec_restart;
GButton rec_resume;

public void initAllControls(){
  wel_ID = new GTextArea(this, 400, 150, 100, 40);
  wel_age = new GTextArea(this, 400, 210, 100, 40);
  wel_gender = new GTextArea(this, 400, 270, 100, 40);
  wel_ID_lab = new GLabel(this, 350, 150, 50, 40, "user ID:");
  wel_age_lab = new GLabel(this, 350, 210, 50, 40, "age:");
  wel_gender_lab = new GLabel(this, 350, 270, 50, 40, "gender:");
  
  wel_confirm = new GButton(this, 450, 350, 100, 30, "confirm");
  welcomePage = new GGroup(this);
  welcomePage.addControls(wel_ID, wel_age, wel_gender,
                          wel_ID_lab, wel_age_lab, wel_gender_lab, wel_confirm);
  
  rec_restart = new GButton(this, 900, 60, 70, 30, "restart");
  rec_resume = new GButton(this, 900, 100, 70, 30, "resume");
  recordPage = new GGroup(this);
  recordPage.addControls(rec_restart, rec_resume);
}

public void drawWelcome(){
  // title
  textSize(30);
  text("Subtle Sound Collection", 350, 100);
  fill(0, 0, 0);
}

public void drawRecord(){
  mProgressBar.draw(sessionCount);
  
  // gesture instruction
  textSize(20);
  fill(0, 0, 0);
  if(sessionCount < sessionList.size()){
    String sessionName = sessionList.get(sessionCount);
    String gesture = sessionName.substring(0, sessionName.length() - 1);
    text("please repeat gesture " + gesture + " for 30 seconds", 250, 90);
  }else text("Thanks for your participation!", 250, 90);
  
  // status
  textSize(15);
  text("status: ", 10, 470);
  textSize(15);
  if(status == "ongoing") fill(0, 255, 0);
  if(status == "paused") fill(255, 0, 0);
  text(status, 60, 470);
  
  // session time
  textSize(15);
  fill(0, 0, 0);
  int transformed = timeElapsed / 1000;
  text("session time: "+ transformed, 850, 470);
  
  // display wave form
  if(status.equals("ongoing")){
    displayShape();
    //strokeWeight(1.5);
    //stroke(0, 100, 200);
    //line(0.2*width, 220, 0.8*width, 220);  // low bound
    //line(0.2*width, 100, 0.8*width, 100);  // high bound
  }
}

void displayShape(){
  stroke(0);
  strokeWeight(1.5);
  noFill();
  //TODO: parse dataRec to plot
  //TODO: synchronization with recording()
  synchronized (lock){
    int bufferSize = dataRec.size();
    if(bufferSize > (plotSize * 2)){ // 16bit int
      for(int i=0; i < plotSize; i++){
        byte MSB = dataRec.get(bufferSize - 2 * (plotSize - i));
        byte LSB = dataRec.get(bufferSize - 2 * (plotSize - i) + 1);
        dataPlot[i] = ((MSB & 0xff)<< 8) + (LSB & 0xff);   // to get unsigned int!!!
      }
    }
  }
  
  // draw a incomplete dataPlot array?
  beginShape();  
  for(int i = 0; i< plotSize; i++){
    //println(dataPlot[i]);
    //println(map(dataPlot[i], 0, 3000, height*0.3, height*0.7));
    vertex(
      map(i, 0, plotSize, 0.1*width, 0.9*width),
      map(dataPlot[i], 0, 3000, height*0.3, height*0.7)
    );
  }
  endShape();
  
  //float[] monoPiece = in.left.toArray();
  //for(int i = 0; i < in.bufferSize(); i+=2)
  //{
  //  vertex(
  //    map(i, 0, in.bufferSize(), 0.2*width, 0.8*width),
  //    map(in.left.get(i), -0.07, 0.07, height*0.25, height*0.75)
  //  );
  //}
}
