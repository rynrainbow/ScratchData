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
      status = "paused";
      sessionCount = 0;
      mProgressBar = new ProgressBar(10, 20, 960, 10, sessionList.size(), SHORTHAND);
    }
    if(button == rec_resume){
      if(status == "paused" && sessionCount < sessionList.size()){
        status = "ongoing";
        //String fileName = colPath + DIRDELIM + sessionList.get(sessionCount) + AUDIOEXT;
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
      if(status == "ongoing"){
        //clean finish recorder's process
        //recorder.endRecord();
        //recorder.save();
        
        //stop recording
        start = false;
        //reset some variables
        status = "paused";
        timeElapsed = 0;
        //delete the saved file
        deleteCurrentFile();
      }
      else if(status == "paused"){
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

void deleteCurrentFile(){
  String fileName = colPath + DIRDELIM + sessionList.get(sessionCount) + AUDIOEXT;
  File toBeDeleted = new File(fileName);
  if(toBeDeleted.exists()) toBeDeleted.delete();
}

void recording(){
    mESP32.clear(); // clear all unusable data
    while(start){
      byte[] read = new byte[1024];  // may need to increase??
      int count = mESP32.readBytes(read);
      convertToInt(read, count);
  }
  //TODO: store the data into wav file
  
}

// TODO: synchronization with displayshape()
void convertToInt(byte[] bytes, int count){
  if(count > 0){ 
    for(int i=0; i<bytes.length; i+=2){
      Integer parsed = bytes[i] << 8 + bytes[i + 1];
      dataRec.add(parsed);
    }
  }
}
