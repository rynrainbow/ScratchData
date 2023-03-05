import g4p_controls.*;
import ddf.minim.*;
import java.io.*;
//import processing.sound.*;
import processing.net.*;

// for progressing
final int DURATION = 10000; // 30 seconds
final String AUDIOEXT = ".wav";
final String DELIMITER = "_";
final String DIRDELIM = "/";
final String SAVEPATH = "/Users/rylan.reborn/Processing/ScratchData/Data Collection";
final String[] GESTURES = {"background", "indexf", "pinch", "flick", "kclick", "nclick", "frub", "claw", "snap", "aflick", "kflick", "nkclk"}; 
final String[] SHORTHAND = {"bg","idf","pch","flk","kclk","nclk","frb","clw","snp", "aflk", "kflk", "nkk"};
final int NSESSIONS = 2;

PFont light;
PFont bold;

ArrayList<String> sessionList;
int sessionCount = 0;  // act as index of sessionList

int pageIdx;
Server mServer;
int PORT = 2333;
String HOST = "192.168.0.162";
Client mESP32 = null;
boolean start;

// audio data related
ArrayList<Byte> dataRec;
int sampleRate = 12000;
int bitWidth = 16;
int channelNum = 1;
boolean signed = true;
boolean bigEndian = true;
String fileName= "";

//Minim minim;
//AudioInput in;
//AudioRecorder recorder;

String colPath;
String userTag;

// plotting related
int timeStamp;
int timeElapsed;
ProgressBar mProgressBar;
String status;
int plotSize = sampleRate / 2;
int[] dataPlot;

// a lock between data collection and plotting
Object lock = new Object();

public void setup(){
  size(1000, 500);
  frameRate(60);
  // create fonts
  light = createFont("Roboto-Light.ttf", 10);
  bold = createFont("Roboto-Bold.ttf", 10);
  textFont(light); // set initial font
  
  // init sessionList
  initSessionList();
  
  // config WIFI
  mServer = new Server(this, PORT, HOST);
  while(mESP32 == null){
    mESP32 = mServer.available();
  }
  start = false;
  
  // config data collection and plotting
  dataRec = new ArrayList<Byte>(0);
  dataPlot = new int[plotSize];
  status = "paused";
  
  // config Audio input
  //minim = new Minim(this);
  //in = minim.getLineIn(Minim.MONO, 9600, 96000, 16);  // a big buffer size?
  
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

public void keyPressed(){
  //if(key == 'c' || key == 'C'){ 
  //  if(status == null || status == "paused") {
  //    println("exit the program!");
  //    exit();
  //  }
  //}
}

public void timerCheck(){
  if(status.equals( "ongoing")){
    timeElapsed = millis() - timeStamp;
    if(timeElapsed > DURATION){
        //recorder.endRecord();
        //recorder.save();
        start = false;
        status= "paused";
        sessionCount++;
        timeElapsed = 0;
    }
  }
}
