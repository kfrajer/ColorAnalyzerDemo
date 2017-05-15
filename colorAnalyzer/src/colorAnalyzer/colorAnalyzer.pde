//REFERENCES: 
//REFERENCES: 
//REFERENCES:

//INSTRUCTIONS:
//         *--
//         *--
//         *--
//         *--

//===========================================================================
// IMPORTS:


//===========================================================================
// FINAL FIELDS:
final int SHOW_SRC=0;
final int SHOW_HUE=1;
final int SHOW_SAT=2;
final int SHOW_BRI=3;
final int SHOW_ALP=4;
final int SHOW_HSB=5;
final int SHOW_AHS=6;

//===========================================================================
// GLOBAL VARIABLES:
PImage source;
int state=SHOW_SRC;

boolean showMouse=false;

ArrayList<PImage> imgs; 
ArrayList<ColorSpectrumAnalyzer> cs;




//===========================================================================
// PROCESSING DEFAULT FUNCTIONS:

void settings() {
  source = loadImage("https://" + "processing.org/img/processing3-logo.png");
  source.resize(640, 0);   
  size(source.width, source.height);
}

void setup() {

  colorMode(HSB, 255);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);

  fill(255);
  strokeWeight(1);

  imgs=new ArrayList<PImage>(); 
  imgs.add(loadImage("cnh1.jpg"));
  imgs.add(loadImage("cnh2.jpg"));
  imgs.add(loadImage("pic1.jpg"));
  imgs.add(loadImage("pic2.jpg"));
  imgs.add(loadImage("pic3.jpg"));
  imgs.add(loadImage("pic4.jpg"));
  imgs.add(loadImage("flower.jpg"));
  imgs.add(loadImage("flower.png"));
  imgs.add(loadImage("isrc.png"));
  imgs.add(loadImage("https://" + "processing.org/img/processing3-logo.png"));

  for (PImage p : imgs)
    p.resize(width, height);

  cs = new ArrayList<ColorSpectrumAnalyzer>();


  //csargb1 = new ColorSpectrumAnalyzer(width, height, ColorSpectrumAnalyzer.cHUE);  
  //csargb1 = new ColorSpectrumAnalyzer(source, ColorSpectrumAnalyzer.cHUE);

  //csargb2 = new ColorSpectrumAnalyzer(width, height, ColorSpectrumAnalyzer.cHUE);
  //csargb2 = new ColorSpectrumAnalyzer(imgs.get(0), ColorSpectrumAnalyzer.cHUE);

  //cs.add(new ColorSpectrumAnalyzer(imgs.get(0), ColorSpectrumAnalyzer.cHUE));
  //cs.add(new ColorSpectrumAnalyzer(imgs.get(1), ColorSpectrumAnalyzer.cHUE));

  //cs.add(new ColorSpectrumAnalyzer(imgs.get(2), ColorSpectrumAnalyzer.cHUE));
  //cs.add(new ColorSpectrumAnalyzer(imgs.get(3), ColorSpectrumAnalyzer.cHUE));
  //cs.add(new ColorSpectrumAnalyzer(imgs.get(4), ColorSpectrumAnalyzer.cHUE));
  //cs.add(new ColorSpectrumAnalyzer(imgs.get(5), ColorSpectrumAnalyzer.cHUE));

  //cs.add(new ColorSpectrumAnalyzer(imgs.get(6), ColorSpectrumAnalyzer.cHUE));
  //cs.add(new ColorSpectrumAnalyzer(imgs.get(7), ColorSpectrumAnalyzer.cHUE));
  cs.add(new ColorSpectrumAnalyzer(imgs.get(8), ColorSpectrumAnalyzer.cHUE));
  cs.add(new ColorSpectrumAnalyzer(imgs.get(9), ColorSpectrumAnalyzer.cHUE));


  for (ColorSpectrumAnalyzer obj : cs)
    obj.setHorizontalMargin(0.15);

  noLoop();
}



void draw() {
  background(64);

  if (state==SHOW_SRC)
    image(cs.get(0).src, 0, 0);
  else {
    for (ColorSpectrumAnalyzer obj : cs)
      obj.plotColorDomain();
  }

  if (showMouse)
    text(mouseX+" "+mouseY, width*0.9, height*0.10);
}

void keyReleased() {

  println("Detected: "+ key +" "+int(key)+" "+(key-'0'));

  if (key>='0' && key<='6') {

    state=key-'0';
    int vmode=cs.get(0).getMode();

    switch(state) {
    case SHOW_SRC:
      surface.setTitle("SOURCE mode");
      break;
    case SHOW_HUE:
      surface.setTitle("HUE mode");
      vmode=(ColorSpectrumAnalyzer.cHUE);
      break;
    case SHOW_SAT:
      surface.setTitle("SAT mode");
      vmode=(ColorSpectrumAnalyzer.cSATURATION);      
      break;
    case SHOW_BRI:
      surface.setTitle("BRI mode");
      vmode=(ColorSpectrumAnalyzer.cBRIGHTNESS);
      break;
    case SHOW_ALP:
      surface.setTitle("ALP mode");
      vmode=(ColorSpectrumAnalyzer.cALPHA);
      break;
    case SHOW_HSB:
      surface.setTitle("HSB mode");
      vmode=(ColorSpectrumAnalyzer.FULL_RGB);
      break;
    case SHOW_AHS:
      surface.setTitle("AHSB mode");
      vmode=(ColorSpectrumAnalyzer.FULL_ARGB);
      break;
    }

    for (ColorSpectrumAnalyzer obj : cs)
      obj.setMode(vmode);

    println(cs.get(0).toString());
  } else if (key=='l') {
    for (ColorSpectrumAnalyzer obj : cs)
      obj.toggleLogFlag();
  } else if (key=='n') {
    for (ColorSpectrumAnalyzer obj : cs)
      obj.toggleNormFlag();
  } else if (key=='m') {
    showMouse=!showMouse;
  }

  redraw();
}

void mouseReleased() {
}



//===========================================================================
// OTHER FUNCTIONS:


class ColorSpectrumAnalyzer {

  final static float INVALID_LOG_VAL=1.0; 

  final static int MONOCOLOR_MIN_DFLT_RANGE=0;
  final static int MONOCOLOR_MAX_DFLT_RANGE=256;

  final static int MULTICOLOR_MIN_DFLT_RANGE=0x0;
  final static int MULTICOLOR_MAX_DFLT_RANGE=0xffffff;

  final static long MULTICOLORALPHA_MIN_DFLT_RANGE=0x0L;          // ## HRGB
  final static long MULTICOLORALPHA_MAX_DFLT_RANGE=0xffffffffL;   // ## HRGB

  final static int cALPHA=0;

  final static int cRED=1;
  final static int cGREEN=2;
  final static int cBLUE=3;
  final static int FULL_RGB=4;
  final static int FULL_ARGB=5;

  final static int cHUE=11;
  final static int cSATURATION=12;
  final static int cBRIGHTNESS=13;  
  final static int FULL_HSB=14;
  final static int FULL_AHSB=15;

  int mode;

  PImage src;
  //PImage dest;
  int w;
  int h;
  float[] colDomain;
  int nbins;
  private boolean normFlag;
  private boolean logFlag;
  private float maxValY;
  long colLowerRange;      // ## HRGB
  long colUpperRange;      // ## HRGB

  int mkRad;        //Marker's radius
  float vMarginPC;  //Vertical margin, in percentage
  float hMarginPC;  //Horizontal margin, in percentage
  float hGrid;
  float vGrid;




  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ColorSpectrumAnalyzer(int ww, int hh, int cmode) {
    loadSampleImage(ww, hh);
    init(null, cmode);
    updateObj();
  }

  ColorSpectrumAnalyzer(PImage img) {
    init(img, FULL_RGB);
    updateObj();
  }

  ColorSpectrumAnalyzer(PImage img, int cmode) {
    init(img, cmode);
    updateObj();
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void init(PImage img, int cmode ) {

    assignMode(cmode);

    if (img!=null)
      src=img.get();
    nbins=256;
    normFlag=false;
    logFlag=false;
    maxValY=Float.MIN_VALUE;

    mkRad=3;
    vMarginPC=0.05;
    hMarginPC=0.0;
    hGrid=25.0;
    vGrid=25.0;
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  //Only RGB codes are tested and HSB are equivalent to them
  void assignMode(int cmode) {

    boolean valid=false;

    if (cmode==cALPHA) {
      valid =true;
    }

    if (cmode==cRED || cmode==cGREEN || cmode==cBLUE ) {
      valid =true;
      colorMode(RGB, 255);
    }

    if (cmode==FULL_RGB || cmode==FULL_ARGB) {
      valid =true;
      colorMode(RGB, 255);
    }

    if (cmode==cHUE || cmode==cSATURATION || cmode==cBRIGHTNESS) {
      valid =true;
      colorMode(HSB, 255);
    }

    if (cmode==FULL_HSB || cmode==FULL_AHSB) {
      valid =true;
      colorMode(HSB, 255);
    }

    if (valid==false) {
      println("ERROR: Input mode not recognized: "+cmode);
      exit();
    }

    mode=cmode;

    if (mode==FULL_RGB || mode==FULL_HSB) {
      colLowerRange=MULTICOLOR_MIN_DFLT_RANGE;           
      colUpperRange=MULTICOLOR_MAX_DFLT_RANGE;
    } else if (mode==FULL_ARGB || mode==FULL_AHSB) {
      colLowerRange=MULTICOLORALPHA_MIN_DFLT_RANGE;       // ## HRGB
      colUpperRange=MULTICOLORALPHA_MAX_DFLT_RANGE;       // ## HRGB
    } else {
      colLowerRange=MONOCOLOR_MIN_DFLT_RANGE;
      colUpperRange=MONOCOLOR_MAX_DFLT_RANGE;
    }
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void updateObj() {
    updateObj(mode);
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void updateObj(int m) {
    w=src.width;
    h=src.height;

    maxValY=Float.MIN_VALUE;
    colDomain=new float[nbins];

    for (int i=0; i<nbins; i++) 
      colDomain[i]=0;

    assignMode(m);

    src.loadPixels();
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++ ) {

        int loc = x + y * w;
        float cpx=getColorValue(src.pixels[loc]);      // ## HRGB          

        int bn=(int)constrain(map(cpx, colLowerRange, colUpperRange, 0, nbins-1), 0, nbins-1);   // ## HRGB
        colDomain[bn]++;
      }
    }    

    maxValY=max(colDomain);

    if (logFlag) {
      for (int i=0; i<nbins; i++) {
        colDomain[i]=  colDomain[i]>0 ? log(colDomain[i]):INVALID_LOG_VAL;
      }

      if (maxValY>0)
        maxValY=log(maxValY);
      else
        maxValY=INVALID_LOG_VAL;
    }


    if (normFlag) {
      for (int i=0; i<nbins; i++) {
        colDomain[i]/=maxValY;
      }

      maxValY=1.0;
    }
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  float getColorValue(int icol) {
    float cc=-1;

    if (mode==cRED)
      cc=(icol >> 16) & 0xff;
    else if (mode==cGREEN)
      cc=(icol >> 8) & 0xff;
    else if (mode==cBLUE)
      cc=(icol >> 0) & 0xff;
    else if (mode==cALPHA)
      cc=(icol >> 24) & 0xff;
    else if (mode==cHUE)
      cc=hue(icol);
    else if (mode==cSATURATION)
      cc=saturation(icol);
    else if (mode==cBRIGHTNESS)
      cc=brightness(icol);
    else if (mode ==FULL_RGB ||mode ==FULL_HSB)
      cc=icol & 0xffffff;
    else
      cc=icol & 0xffffffff;

    return cc;
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void plotColorDomain() {
    plotColorDomain(0, width, 0, height);
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void plotColorDomain(float lowX, float highX, float lowY, float highY) {

    float lowPlotX=lowX+hMarginPC*(highX-lowX);
    float highPlotX=lowX+(1-hMarginPC)*(highX-lowX);

    float lowPlotY=lowY+(1-vMarginPC)*(highY-lowY);
    float highPlotY=lowY+vMarginPC*(highY-lowY);

    //println("lowX:"+lowX+"\t"+lowPlotX);
    //println("highX:"+highX+"\t"+highPlotX);
    //println("lowY:"+lowY+"\t"+lowPlotY);
    //println("highY:"+highY+"\t"+highPlotY);

    pushStyle();  

    for (int i=0; i<nbins-1; i++) {

      float x1=map(i, 0, nbins, lowPlotX, highPlotX);
      float x2=map(i+1, 0, nbins, lowPlotX, highPlotX);  

      float y1=map(colDomain[i], 0, maxValY, lowPlotY, highPlotY );
      float y2=map(colDomain[i+1], 0, maxValY, lowPlotY, highPlotY);


      stroke(255);
      line(x1, y1, x2, y2); 
      noStroke();
      fill(color(i, 255, 255));
      //fill(255);
      ellipse(x1, y1, mkRad, mkRad);
      ellipse(x2, y2, mkRad, mkRad);
    }

    if (hGrid>0) {
      stroke(255, 120);
      line(lowPlotX, lowY+vMarginPC*(highY-lowY) + (1-2*vMarginPC)*(highY-lowY)*0.25, highPlotX, lowY+vMarginPC*(highY-lowY) + (1-2*vMarginPC)*(highY-lowY)*0.25);
      line(lowPlotX, lowY+vMarginPC*(highY-lowY) + (1-2*vMarginPC)*(highY-lowY)*0.50, highPlotX, lowY+vMarginPC*(highY-lowY) + (1-2*vMarginPC)*(highY-lowY)*0.50);
      line(lowPlotX, lowY+vMarginPC*(highY-lowY) + (1-2*vMarginPC)*(highY-lowY)*0.75, highPlotX, lowY+vMarginPC*(highY-lowY) + (1-2*vMarginPC)*(highY-lowY)*0.75);
    }

    if (vGrid>0) {
      stroke(255, 120);
      line(lowX+hMarginPC*(highX-lowX) + (1-2*hMarginPC)*(highX-lowX)*0.25, lowPlotY, lowX+hMarginPC*(highX-lowX) + (1-2*hMarginPC)*(highX-lowX)*0.25, highPlotY);
      line(lowX+hMarginPC*(highX-lowX) + (1-2*hMarginPC)*(highX-lowX)*0.50, lowPlotY, lowX+hMarginPC*(highX-lowX) + (1-2*hMarginPC)*(highX-lowX)*0.50, highPlotY);
      line(lowX+hMarginPC*(highX-lowX) + (1-2*hMarginPC)*(highX-lowX)*0.75, lowPlotY, lowX+hMarginPC*(highX-lowX) + (1-2*hMarginPC)*(highX-lowX)*0.75, highPlotY);
    }



    popStyle();
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void setMode(int m) {
    updateObj(m);
  }

  int getMode() {
    return (mode);
  }

  void toggleLogFlag() {
    logFlag=!logFlag;
    updateObj();
  }

  void toggleNormFlag() {
    normFlag=!normFlag;
    updateObj();
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void setMarkerRadius(int v) {
    mkRad=v;
  }

  void setVerticalMargin(float v) {
    vMarginPC=v;
  }

  void setHorizontalMargin(float v) {
    hMarginPC=v;
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @Override
    String toString() {
    String str="====================";

    str+="\nWidth: "+src.width;
    str+="\t\tHeight: "+src.width;
    str+="\nMode: "+mode;
    str+="\t\tCurrent Max Y: " + maxValY;
    str+="\nLog: "+logFlag;
    str+="\t\tNormalized: "+normFlag;
    str+="\ncolLowerRange: "+colLowerRange +" (0x"+hex((int)colLowerRange)+")";
    str+="\ncolUpperRange: "+colUpperRange +" (0x"+hex((int)colUpperRange)+")";
    str+="\n";

    return str;
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  void loadSampleImage(final int ww, final int hh) {
    src=createImage(ww, hh, RGB);
    src.loadPixels();
    for (int i = 0; i < ww*hh; i++) {
      src.pixels[i] = color(random(0, 64), random(64, 128), random(128, 192), random(192, 250));
      //src.pixels[i] = color((int)random(63, 65), (int)random(127, 129), (int)random(191, 193), random(192, 250));
      //src.pixels[i] = color(0, 0, (int)random(191, 193), random(192, 250));
    }
    src.updatePixels();
  }
}