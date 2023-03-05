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
    if(button == wel_confirm){
      // read info from textArea
      userTag = wel_ID.getText(0) + DELIMITER + wel_gender.getText(0) + DELIMITER + wel_age.getText(0);
      // create a subfolder according to userTag
      colPath = SAVEPATH + DIRDELIM + userTag;
      File directory = new File(colPath);
      if(!directory.exists()) directory.mkdir();
      
      // visibility will be affected after next frame refreshing
      pageIdx = 1;
      welcomePage.setVisible(false);
      recordPage.setVisible(true);
      //status = "paused";
      sessionCount = 0;
      mProgressBar = new ProgressBar(10, 20, 960, 10, sessionList.size(), SHORTHAND);
    }
    if(button == rec_resume){
      if(status.equals("paused") && sessionCount < sessionList.size()){
        status = "ongoing";
        fileName = colPath + DIRDELIM + sessionList.get(sessionCount) + AUDIOEXT;
        //recorder = minim.createRecorder(in, fileName);
        //recorder.beginRecord();
        
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
        //clean finish recorder's process
        //recorder.endRecord();
        //recorder.save();
        
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
        sessionCount--;
        if(sessionCount >= 0){
          // if sessionCount valid, delete the pointed file
          deleteCurrentFile();
        }else{
          // illegal, reset to 0
          sessionCount = 0;
        }
      }
    }
  }
}

boolean deleteCurrentFile(){
  String fileName = colPath + DIRDELIM + sessionList.get(sessionCount) + AUDIOEXT;
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
    byte[] read = new byte[1024];  // may need to increase??
    int count = mESP32.readBytes(read);
    // synchronization with displayshape()
    synchronized (lock){
      savingBytes(read, count);
    }
  }
  // convert back to byte array
  byte[] byteBuffer = new byte[dataRec.size()];
  for(int i=0; i<dataRec.size(); i++) byteBuffer[i] = dataRec.get(i);
  
  //TODO: store the data into wav file
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
}

void savingBytes(byte[] bytes, int count){
  if(count > 0){ 
    for(int i=0; i<count; i++){
      dataRec.add(bytes[i]);
    }
  }
}
