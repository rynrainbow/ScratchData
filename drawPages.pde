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
  rotate(PI/2);
  image(myMovie, 0, 0, 400, 300);
  // reverse the operations, otherwise the latter drawing may fail
  rotate(-PI/2);
  translate(-width/2, -height/2);
}

public void drawRecord(){
  mProgressBar.draw(nGestPast);
  
  // gesture instruction
  textSize(20);
  fill(0, 0, 0);
  if(trialCount < NTRIALS){
    //String sessionName = sessionList.get(sessionCount);
    //String gesture = sessionName.substring(0, sessionName.length() - 1);
    String trialProgress = trialCount + "/" + NTRIALS;
    text("Trial "+ trialProgress +":please repeat gesture " + currentGest + " for 20 seconds", 250, 90);
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
  if(status == "ongoing"){
    displayShape();
    strokeWeight(1.5);
    stroke(0, 100, 200);
    line(0.2*width, 220, 0.8*width, 220);  // low bound
    line(0.2*width, 100, 0.8*width, 100);  // high bound
  }
}

void displayShape(){
  stroke(0);
  strokeWeight(1);
  noFill();
  beginShape();
  //float[] monoPiece = in.left.toArray();
  for(int i = 0; i < in.bufferSize(); i+=2)
  {
    vertex(
      map(i, 0, in.bufferSize(), 0.2*width, 0.8*width),
      map(in.left.get(i), -0.07, 0.07, height*0.25, height*0.75)
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
