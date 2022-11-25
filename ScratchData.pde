import g4p_controls.*;
import ddf.minim.*;
import java.io.*;
import processing.sound.*;

// for progressing
final int DURATION = 30000; // 30 seconds
final String AUDIOEXT = ".wav";
final String DELIMITER = "_";
final String DIRDELIM = "/";
final String SAVEPATH = "/Users/rylan.reborn/Processing/ScratchData/Data Collection";
final String[] GESTURES = {"snap", "aflick", "kflick", "nkclk", "claw"}; 
final String[] SHORTHAND = {"snp", "aflk", "kflk", "nkk", "clw"};
final int NSESSIONS = 2;

PFont light;
PFont bold;

ArrayList<String> sessionList;
int sessionCount = 0;  // act as index of sessionList

int pageIdx;
Minim minim;
AudioInput in;
AudioRecorder recorder;
String colPath;
String userTag;

int timeStamp;
int timeElapsed;
ProgressBar mProgressBar;
String status;

public void setup(){
  size(1000, 500);
  // create fonts
  light = createFont("Roboto-Light.ttf", 10);
  bold = createFont("Roboto-Bold.ttf", 10);
  textFont(light); // set initial font
  
  // init sessionList
  initSessionList();
  
  // config Audio input
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 9600, 96000, 16);  // a big buffer size?
  
  // init all controllers
  initAllControls();
  
  // enter welcome page
  pageIdx = 0;
  welcomePage.setVisible(true);
  recordPage.setVisible(false);
}

public void draw(){
  background(255, 255, 255);
  timerCheck();
  if(pageIdx == 0) drawWelcome();
  if(pageIdx == 1) drawRecord();
}

public void initSessionList(){
  sessionList = new ArrayList<String>();
  for(String phase : GESTURES){
    for(int i=0; i<NSESSIONS; i++){
      sessionList.add(phase + i);
    }
  }
}

public void timerCheck(){
  if(status == "ongoing"){
    timeElapsed = millis() - timeStamp;
    if(timeElapsed > DURATION){
        recorder.endRecord();
        recorder.save();
        status= "paused";
        sessionCount++;
        timeElapsed = 0;
    }
  }
}

public void keyPressed(){
  //if(key == 'c' || key == 'C'){ 
  //  if(status == null || status == "paused") {
  //    println("exit the program!");
  //    exit();
  //  }
  //}
}
