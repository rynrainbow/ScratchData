// controllers in welcome page
GGroup welcomePage;
GLabel wel_ID_lab;
GLabel wel_age_lab;
GLabel wel_gender_lab;
GTextArea wel_ID;
GTextArea wel_age;
GTextArea wel_gender;
GButton wel_confirm;

// controllers in recording page
GGroup recordPage;
GButton rec_restart;
GButton rec_resume;
GButton rec_next;

// controllers in Learn page
GGroup learnPage;
GButton lea_ready;

public void initAllControls(){
  wel_ID = new GTextArea(this, 400, 150, 100, 40);
  wel_age = new GTextArea(this, 400, 210, 100, 40);
  wel_gender = new GTextArea(this, 400, 270, 100, 40);
  wel_ID_lab = new GLabel(this, 350, 150, 50, 40, "user ID:");
  wel_age_lab = new GLabel(this, 350, 210, 50, 40, "age:");
  wel_gender_lab = new GLabel(this, 350, 270, 50, 40, "gender:");
  
  wel_confirm = new GButton(this, 450, 350, 100, 30, "confirm");
  welcomePage = new GGroup(this);
  welcomePage.addControls(wel_ID, wel_age, wel_gender,
                          wel_ID_lab, wel_age_lab, wel_gender_lab, wel_confirm);
  
  lea_ready = new GButton(this, 450, 650, 100, 30, "ready");
  learnPage = new GGroup(this);
  learnPage.addControls(lea_ready);
  
  rec_restart = new GButton(this, 900, 60, 70, 30, "restart");
  rec_resume = new GButton(this, 900, 100, 70, 30, "resume");
  rec_next = new GButton(this, 900, 600, 70, 30, "next");
  recordPage = new GGroup(this);
  recordPage.addControls(rec_restart, rec_resume, rec_next);
}

public void initOthers(){
  mProgressBar = new ProgressBar(10, 20, 960, 10, GESTURES.length, GESTURES);
  // random generators here
  // init a gesture order
  gestOrder = new ArrayList<Integer>();
  for(int i=1; i<GESTURES.length; i++) gestOrder.add(i);
  Collections.shuffle(gestOrder);
  gestOrder.add(0, 0); // guarantee to collect background first
}
