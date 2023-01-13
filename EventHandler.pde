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
      if(status == "paused" && trialCount < NTRIALS){
        status = "ongoing";
        String fileName = colPath + DIRDELIM + currentGest + trialCount + AUDIOEXT;
        recorder = minim.createRecorder(in, fileName);
        recorder.beginRecord();
        
        //set up a new timer
        timeStamp = millis();
      }
    }
    if(button == rec_restart){
      if(status == "ongoing"){
        //clean finish recorder's process
        recorder.endRecord();
        recorder.save();
        //reset some variables
        status = "paused";
        timeElapsed = 0;
        //delete the saved file
        deleteCurrentFile();
      }
      else if(status == "paused"){
        //retract counter
        trialCount--;
        if(trialCount >= 0){
          // if sessionCount valid, delete the pointed file
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

void deleteCurrentFile(){
  String fileName = colPath + DIRDELIM + currentGest + trialCount + AUDIOEXT;
  File toBeDeleted = new File(fileName);
  if(toBeDeleted.exists()) toBeDeleted.delete();
}
