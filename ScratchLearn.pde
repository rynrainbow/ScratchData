import g4p_controls.*;
import java.io.*;
import processing.video.*;
import java.util.*;
import processing.net.*;

// network related
Server mServer;
int PORT = 2333;
//String HOST = "192.168.0.162";
String HOST = "192.168.0.24";
Client mESP32 = null;
boolean start;

// audio data related
ArrayList<Byte> dataRec;
int sampleRate = 8000;   // previously 12000
int bitWidth = 16;
int channelNum = 1;
boolean signed = true;
boolean bigEndian = true;
String fileName= "";

// UI related
int timeStamp;
int timeElapsed;
int trialCount = 0;  // counting how many trials have been done
ProgressBar mProgressBar;
String status;
int plotSize = sampleRate / 2;
int[] dataPlot;
Movie myMovie;
float bckThreshold = 0;

int DURATION = 15000; // 15 seconds
final int REDUCED = 10000; // 10 seconds for learning
final String AUDIOEXT = ".wav";
final String VIDEOEXT = ".mp4";
final String DELIMITER = "_";
final String DIRDELIM = "/";
final String SAVEPATH = "/Users/rylan.reborn/Processing/ScratchLearn/Data Collection";
//final String[] GESTURES = {"Background", "PP_click", "KN_click", "NN_rub", 
//                          "NP_flick", "NP_click", "PN_rub", "PN_flick", 
//                          "PN_click", "PP_rub", "PP_flick"}; 

final String[] GESTURES = {"Background", "PP_click", "PP_rub", "PP_flick", "PN_click", "PK_click",
                          "NP_rub", "NN_rub", "KP_rub", "KP_click", "KN_flick", "KN_click", "PK_rub",
                          "PN_rub", "PN_flick", "NP_flick", "NP_click", "NN_click"};
final int NTRIALS = 1;
PFont light;
PFont bold;

ArrayList<Integer> gestOrder;
int nGestPast = 0; 
String currentGest;
int pageIdx;
String colPath;
String userTag;

// a lock between data collection and plotting
Object lock = new Object();

public void setup(){
  size(1000, 700);
  // create fonts
  light = createFont("Roboto-Light.ttf", 10);
  bold = createFont("Roboto-Bold.ttf", 10);
  textFont(light); // set initial font
  
    // config WIFI
  mServer = new Server(this, PORT, HOST);
  start = false;
  //connected =false;
  
  // config data collection and plotting
  dataRec = new ArrayList<Byte>(0);
  dataPlot = new int[plotSize];
  status = "paused";
  
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
  clientCheck();
  timerCheck();
  if(pageIdx == 0) drawWelcome();
  // for testing, play a test video
  if(pageIdx == 1) drawLearn();
  if(pageIdx == 2) drawRecord();
  if(pageIdx == 3) drawEnd();
}

public void timerCheck(){
  if(status.equals("ongoing")){
    timeElapsed = millis() - timeStamp;
    // recording timeout or WIFI connection down
    if(timeElapsed > DURATION || mESP32 == null){
        //recorder.endRecord();
        //recorder.save();
        start = false;
        status= "paused";
        trialCount++;
        timeElapsed = 0;
    }
  }
}

public void clientCheck(){
  if(mESP32 == null){
    Client poClient = mServer.available();
    // Any incoming client will overwrite the client socket "mESP32"
    // Thus after a connection is down, the next will replace
    if(poClient != null){
      mESP32 = poClient;
    }
  }
  else{
    if(!mESP32.active()) mESP32 = null;
  }
}

public void movieEvent(Movie movie) {
  movie.read();
   if (movie.time() == movie.duration()) {
    movie.jump(0);  // Jump to the beginning when the video reaches the end
  }
}

public void exit(){
  if(mServer != null){
    mServer.stop();
    mServer = null;
  }
  println("properly closed!");
  super.exit();
}
