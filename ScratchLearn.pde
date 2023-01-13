import g4p_controls.*;
import ddf.minim.*;
import java.io.*;
import processing.sound.*;
import processing.video.*;
import java.util.*;

// for progressing
Minim minim;
AudioInput in;
AudioRecorder recorder;
Movie myMovie;
final int DURATION = 20000; // 20 seconds
final String AUDIOEXT = ".wav";
final String VIDEOEXT = ".mp4";
final String DELIMITER = "_";
final String DIRDELIM = "/";
final String SAVEPATH = "/Users/rylan.reborn/Processing/ScratchLearn/Data Collection";
final String[] GESTURES = {"KK_rub", "KK_flick", "KK_click", "KN_rub", "KN_flick", "KN_click",
                           "KP_rub", "KP_flick", "KP_click", "NK_rub", "NK_flick", "NK_click",
                           "NN_rub", "NN_flick", "NN_click", "NP_rub", "NP_flick", "NP_click",
                           "PK_rub", "PK_flick", "PK_click", "PN_rub", "PN_flick", "PN_click",
                           "PP_rub", "PP_flick", "PP_click"}; 
//final String[] SHORTHAND = {"idf", "snp", "aflk"};
final int NTRIALS = 1;
PFont light;
PFont bold;

ArrayList<Integer> gestOrder;
int nGestPast = 0;
String currentGest;
int pageIdx;
String colPath;
String userTag;

int timeStamp;
int timeElapsed;
//ArrayList<String> sessionList;
int trialCount = 0;  // counting how many trials have been done
ProgressBar mProgressBar;
String status;

public void setup(){
  size(1000, 700);
  // create fonts
  light = createFont("Roboto-Light.ttf", 10);
  bold = createFont("Roboto-Bold.ttf", 10);
  textFont(light); // set initial font
  
  // init sessionList
  //initSessionList();
  
  // config Audio input
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 9600, 96000, 16);  // a big buffer size?
  
  // init all controllers
  initAllControls();
  initOthers();
  
  // enter welcome page
  pageIdx = 0;
  welcomePage.setVisible(true);
  recordPage.setVisible(false);
  learnPage.setVisible(false);
}

public void draw(){
  background(255, 255, 255);
  timerCheck();
  if(pageIdx == 0) drawWelcome();
  // for testing, play a test video
  if(pageIdx == 1) drawLearn();
  if(pageIdx == 2) drawRecord();
  if(pageIdx == 3) drawEnd();
}

public void timerCheck(){
  if(status == "ongoing"){
    timeElapsed = millis() - timeStamp;
    if(timeElapsed > DURATION){
        recorder.endRecord();
        recorder.save();
        status= "paused";
        trialCount++;
        timeElapsed = 0;
    }
  }
}

public void movieEvent(Movie movie) {
  movie.read();
}

public void keyPressed(){
  //if(key == 'c' || key == 'C'){ 
  //  if(status == null || status == "paused") {
  //    println("exit the program!");
  //    exit();
  //  }
  //}
}
