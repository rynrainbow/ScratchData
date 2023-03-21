import processing.sound.*;

// a background processing part
class Threshold{
  private final float calib = 2100;
  private final float scaler = 4096;
  private final int frame = 240;
  private final int overlap = 120;
  private final float startTime = 0.5;
  private final float nSigma = 3;
  private float[] rms;
  private final float[][] sos = {{0.98305942f, -0.98305942f, 0f, 1f, -0.99242492f,          0f},
                                 {         1f,  -1.9999971f, 1f, 1f, -1.98633141f, 0.98639172f},
                                 {         1f, -1.99999057f, 1f, 1f, -1.99049609f, 0.99056302f},
                                 {         1f, -1.99998534f, 1f, 1f, -1.99654938f, 0.99662173f}};
  public float[] bg;
  public float fs;
  
  // read the float data and scale
  public Threshold(SoundFile bgFile, float fs){
    this.fs = fs;
    int numFrames = bgFile.frames();
    bg = new float[numFrames];
    bgFile.read(bg);
    // do scaling based on calib
    for(int i=0; i<numFrames; i++){
      bg[i] = (bg[i] * 32768f - this.calib) / this.scaler;
    }
  }
  
  public float returnThreshold(){
    float[] filterBg = iirFilter(this.bg);
    shortRms(filterBg);
    return mean(this.rms) + nSigma * std(this. rms);
  }
  
  // iir filter
  public float[] iirFilter(float[] x){
    int N = x.length;
    float[] y = new float[N];
    // Transposed direct form II    
    for(int or=0; or < sos.length; or++){
      float[] s1 = new float[N];
      float[] s2 = new float[N];
      float b0 = sos[or][0]; float b1 = sos[or][1]; float b2 = sos[or][2];
      float a0 = sos[or][3]; float a1 = sos[or][4]; float a2 = sos[or][5];
      for(int i=0 ; i < N; i++){
        if(i == 0){
          y[i] = b0 * x[i];
          s1[i] = b1 * x[i] - a1 * y[i];
          s2[i] = b2 * x[i] - a2 * y[i];
        } 
        else{
          y[i] = b0 * x[i] + s1[i - 1];
          s1[i] = s2[i - 1] + b1 * x[i] - a1 * y[i];
          s2[i] = b2 * x[i] - a2 * y[i];
        }
      }
      // start the next biquad filter
      // shallow copy messes up
      x = Arrays.copyOf(y, N);
    }
    // cut the first seconds of dynamics
    int sIdx = (int)(startTime * this.fs);
    y = Arrays.copyOfRange(y, sIdx, N);
    return y;
  }
  
  // compute rms
  public void shortRms(float[] x){
      int step = this.frame - this.overlap;
      int ncompute = (int)(x.length / step);
      this.rms = new float[ncompute];
      for(int i=0;i<ncompute;i++){
        int sind = i * step;
        int eind = sind + frame;
        float[] sample = Arrays.copyOfRange(x, sind, eind);
        this.rms[i] = 0;
        for(int j=0;j<sample.length;j++){
          this.rms[i] += pow(sample[j], 2);
        }
        this.rms[i] /= frame;
        this.rms[i] = sqrt(rms[i]);
      }
  }
  
  /** some simple utilities **/
  public float mean(float[] x){
    float mean = 0;
    for(int i=0; i<x.length; i++){
      mean += x[i];
    }
    return mean / x.length;
  }
  
  public float std(float[] x){
    float std = 0;
    float mean = mean(x);
    for(int i=0; i<x.length; i++){
      std += pow(x[i] - mean, 2);
    }
    return sqrt(std /= x.length);
  }
}
