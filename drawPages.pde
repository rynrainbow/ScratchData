public void drawWelcome(){
  // title
  textSize(30);
  fill(0, 0, 0);
  text("Subtle Sound Collection", 350, 100);
}

public void drawLearn(){
  // title
  textFont(bold);
  textSize(30);
  fill(0, 0, 0);
  text("Learning gestures...", 350, 30);
  
  // prompt
  textFont(light);
  textSize(20);
  text("Please watch the video and practice gesture ", 200, 70);
  fill(255, 0, 0);
  text(currentGest, 600, 70);
  fill(0, 0, 0);
  // need a way to teach
  text(instructionCompose(currentGest), 100, 100);
  
  // present gesture videos
  // rotate the image by 90 degree
  imageMode(CENTER);
  translate(width/2, height/2);
  if(currentGest != "NK_flick" && currentGest != "NK_click"){
    rotate(PI/2);
    image(myMovie, 0, 0, 400, 300);
    // reverse the operations, otherwise the latter drawing may fail
    rotate(-PI/2);
  }else{
    image(myMovie, 0, 0, 300, 400);
  }
  translate(-width/2, -height/2);
}

public void drawRecord(){
  mProgressBar.draw(nGestPast);
  
  // gesture instruction
  textSize(20);
  fill(0, 0, 0);
  if(trialCount < NTRIALS){
    String trialProgress = trialCount + "/" + NTRIALS;
    text("Trial "+ trialProgress +":please repeat gesture " + currentGest + " for " + DURATION/1000 + " seconds", 250, 90);
  }else text("You can click next now!", 250, 90);
  
  // status
  textSize(15);
  text("status: ", 10, 670);
  textSize(15);
  if(status == "ongoing") fill(0, 255, 0);
  if(status == "paused") fill(255, 0, 0);
  text(status, 60, 670);
  
  // trial time
  textSize(15);
  fill(0, 0, 0);
  int transformed = timeElapsed / 1000;
  text("session time: "+ transformed, 850, 670);
  
  // display wave form
  if(status.equals("ongoing")){
    displayShape();
  }
  // display threshold result
  if(currentGest.equals("Background")){
    String threshold = String.format("%.6f", bckThreshold);
    textSize(15);
    fill(0, 0, 0);
    text("Background threshold: "+ threshold, 450, 670);
  }
}

void displayShape(){
  stroke(0);
  strokeWeight(1.5);
  noFill();
  
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
    vertex(
      map(i, 0, plotSize, 0.1*width, 0.9*width),
      map(dataPlot[i], 3000, 500, height*0.3, height*0.7)
    );
  }
  endShape();
}

void drawEnd(){
  mProgressBar.draw(nGestPast);
  textSize(30);
  fill(0, 0, 0);
  text("Thanks for participation!", 300, 250);
}

String instructionCompose(String gest){
  if(gest.equals("Background")){
    return "Move your hand(thumb) freely with no interactions. Avoid bending your thumb's remote knuckle.";
  }
  else{
    String fingers = gest.split("_", 0)[0];
    String action = gest.split("_", 0)[1];
    String thumb = "";
    String other = "";
    switch(fingers.substring(0, 1)){
      case "K": 
        thumb = "knuckle";
        break;
      case "N":
        thumb = "Nail";
        break;
      case "P":
        thumb = "Pad";
      default:
        break;
    }
    switch(fingers.substring(1, 2)){
      case "K": 
        other = "knuckle";
        break;
      case "N":
        other = "Nail";
        break;
      case "P":
        other = "Pad";
      default:
        break;
    }
    String general = String.format("It is done by interaction of two parts on your hand - thumb's %s and another finger's %s", thumb, other);
    String how = "";
    switch(action){
      case "rub":
        how = "Please rub the two parts gently, making a friction sound.";
        break;
      case "flick":
        how = "Please flick promptly, making a sound of burst.";
        break;
      case "click":
        how = "Please make the two parts collide, making a clicking sound.";
      default:
        break;
    }
    return general + "\n" + how;
  }
}
