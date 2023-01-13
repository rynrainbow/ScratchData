/*----------------- util class ------------*/
public class Pos{
  public float X;
  public float Y;
  
  public Pos(float X, float Y){
    this.X = X;
    this.Y = Y;
  }
  public void changePos(float X, float Y){
    this.X = X;
    this.Y = Y;
  }
}

public class Bar{
  public Pos pos;
  public float len;
  public float wid;
  public int index;
  
  public Bar(float X, float Y, float len, float wid, int index){
    this.pos = new Pos(X, Y); this.len = len; this.wid = wid; this.index = index;
  }
  
  public void draw(boolean fill){
    if(fill) fill(0, 100, 200);
    else fill(255, 255, 255);
    rect(pos.X, pos.Y, len, wid);
  }
}

public class ProgressBar{
  private final float VERGAP = 20;
  private final float TXTSIZE = 15;
  
  public ArrayList<Bar> bars;
  public ArrayList<Pos> tags;
  public String[] phaseTags;
  public Pos pos;
  public float len;
  public float wid;
  
  public ProgressBar(float X, float Y, float len, float wid, int size, String[] phaseTags){
    this.pos = new Pos(X, Y); this.len = len; this.wid = wid; this.phaseTags = phaseTags;
    // init bars
    bars = new ArrayList<Bar>();
    float bLen = len / size;
    float bWid = wid;
    float bY = Y;
    for(int i=0; i<size; i++){
      float bX = X + i * bLen;
      bars.add(new Bar(bX, bY, bLen, bWid, i));
    }
    
    // init tags
    tags = new ArrayList<Pos>();
    float tY = bY + wid + VERGAP;
    float tLen = len / phaseTags.length;
    for(int i=0; i<phaseTags.length; i++){
      float tX = X + i * tLen;
      tags.add(new Pos(tX, tY));
    }
  }
  
  public void draw(int sessionCount){
    // draw progress bar
    stroke(0, 100, 200);
    strokeWeight(2);
    for(int i=0; i< bars.size(); i++){
      Bar bar = bars.get(i);
      if(bar.index < sessionCount)
        bar.draw(true);
      else
        bar.draw(false);
    }
    
    // draw a stationary tag
    textFont(bold);
    textSize(TXTSIZE);
    fill(0, 0, 0);
    text(sessionCount + "/" + phaseTags.length + " gestures done.", tags.get(0).X, tags.get(0).Y);
    
    // draw tags
    //textFont(bold);
    //textSize(TXTSIZE);
    //fill(0, 0, 0);
    //for(int i=0; i< tags.size(); i++){
    //  String phase = phaseTags[i];
    //  float tX = tags.get(i).X;
    //  float tY = tags.get(i).Y;
    //  text(phase, tX, tY);
    //}
    textFont(light);
  }
  
  public void changeDimension(float X, float Y, float len, float wid){
  }
}
