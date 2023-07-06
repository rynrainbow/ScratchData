import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;

public void handleTextEvents(GEditableTextControl textcontrol, GEvent event){
}

synchronized public void handleButtonEvents(GButton button, GEvent event){
  if(event == GEvent.CLICKED){
    if(button == wel_confirm || button == wel_learn){
      if(button == wel_learn) DURATION = REDUCED;
      // read info from textArea
      // create a subfolder according to userTag
      userTag = wel_ID.getText(0) + DELIMITER + wel_gender.getText(0) + DELIMITER + wel_age.getText(0);
      colPath = SAVEPATH + DIRDELIM + userTag;
      File directory = new File(colPath);
      if(!directory.exists()) directory.mkdir();
      
      // go to gesture learn page
      pageIdx = 1;
      welcomePage.setVisible(false);
      learnPage.setVisible(true);
      // init first movie object
      currentGest = GESTURES[gestOrder.get(nGestPast)];
      myMovie = new Movie(this, currentGest + VIDEOEXT);  
      myMovie.loop();
    }
    if(button == lea_ready){
      // stop movie
      if(myMovie != null){
        myMovie.stop();
        myMovie = null;
      }
      // go to record page
      pageIdx = 2;
      learnPage.setVisible(false);
      recordPage.setVisible(true);
      trialCount = 0;
      status = "paused";
    }
    if(button == rec_resume){
      if(status.equals("paused") && trialCount < NTRIALS && mESP32 != null){
        status = "ongoing";
        //fileName = colPath + DIRDELIM + currentGest + trialCount + AUDIOEXT;
        fileName = colPath + DIRDELIM + currentGest + AUDIOEXT;
        
        // create and start recording thread
        // start recording
        start = true;
        thread("recording");
        //set up a new timer
        timeStamp = millis();
      }
    }
    if(button == rec_restart){
      if(status.equals("ongoing")){        
        //stop recording
        start = false;
        //reset some variables
        status = "paused";
        timeElapsed = 0;
        //delete the saved file
        //ensure the recording finishes first
        while(!deleteCurrentFile());
      }
      else if(status.equals("paused")){
        //retract counter
        trialCount--;
        if(trialCount >= 0){
          // if trialCount valid, delete the pointed file
          // Cannot redo a previously completed gesture!!
          deleteCurrentFile();
        }else{
          // illegal, reset to 0
          trialCount = 0;
        }
      }
    }
    if(button == rec_next){
      nGestPast++;
      recordPage.setVisible(false);
      if(nGestPast < GESTURES.length){
        // if gestures are not done, go to gesture learn page
        pageIdx = 1;
        learnPage.setVisible(true);
        // init movie object
        currentGest = GESTURES[gestOrder.get(nGestPast)];
        myMovie = new Movie(this, currentGest + VIDEOEXT);  
        myMovie.loop();
      }
      else
        // if gestures are all done
        pageIdx = 3;
    }
  }
}

boolean deleteCurrentFile(){
  //String fileName = colPath + DIRDELIM + currentGest + trialCount + AUDIOEXT;
  String fileName = colPath + DIRDELIM + currentGest + AUDIOEXT;
  File toBeDeleted = new File(fileName);
  if(toBeDeleted.exists()) {
    toBeDeleted.delete();
    return true;
  }
  else return false;
}

void recording(){
  mESP32.clear(); // clear all unusable data
  dataRec.clear();  // clear old data
  while(start){
    int count = 0;
    byte[] read = new byte[1024];  // may need to increase??
    // ensure the WIFI connnection is still on
    if(mESP32 != null)
      count = mESP32.readBytes(read);
    // synchronization with displayshape()
    synchronized (lock){
      savingBytes(read, count);
    }
  }
  // convert back to byte array
  byte[] byteBuffer = new byte[dataRec.size()];
  for(int i=0; i<dataRec.size(); i++) byteBuffer[i] = dataRec.get(i);
  
  try{
    File out = new File(fileName); // use the file nanme determined by button callback function
    AudioFormat format = new AudioFormat((float)sampleRate, bitWidth, channelNum, signed, bigEndian); // 
    ByteArrayInputStream bais = new ByteArrayInputStream(byteBuffer);
    AudioInputStream audioInputStream = new AudioInputStream(bais, format, (int)(dataRec.size()/2));  // sample length of the data
    AudioSystem.write(audioInputStream, AudioFileFormat.Type.WAVE, out);
    audioInputStream.close();
  }catch(Exception e){
    print(e.toString());
  }
  
  // extra work to show background threshold
  if(currentGest.equals("Background") && new File(fileName).exists()){ //<>//
    SoundFile back = new SoundFile(this, fileName, false);
    Threshold thr = new Threshold(back, (float)sampleRate);
    bckThreshold = thr.returnThreshold();
    println(String.format("%.6f", bckThreshold));
  }
}

void savingBytes(byte[] bytes, int count){
  if(count > 0){ 
    for(int i=0; i<count; i++){
      dataRec.add(bytes[i]);
    }
  }
}
