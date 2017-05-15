PImage source, destination;  
float threshold;
int mode;

int[] hueDomain;
int[] hsbDomain;

void setup() {
  size(400, 300);
  source = loadImage("https://" + "processing.org/img/processing3-logo.png");
  source.resize(400, 300); 
  destination = createImage(source.width, source.height, RGB);
  colorMode(HSB, 255);
  hueDomain=new int[256];
  hsbDomain=new int[256];
  threshold = 170;

  //source.loadPixels();
  //for (int x = 0; x < source.width; x++) {
  //  for (int y = 0; y < source.height; y++ ) {
  //    float v=map(((int)source.pixels[x + y*source.width])&0xffffff, 0, (float)(0xffffff), 0, 255);
  //    hsbDomain[((int)v)]++;
  //  }
  //}

  println("Done @"+millis()/1000);
  noLoop();
}

void draw() {
  background(0);
  source.loadPixels();
  destination.loadPixels();

  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {

      int loc = x + y*source.width;

      if (mode==0 && brightness(source.pixels[loc]) > threshold) {
        destination.pixels[loc]  = source.pixels[loc];
      } else if (mode==1 && hueClose((hue(source.pixels[loc])), threshold, 255, 20) && saturation(source.pixels[loc]) > 32) {
        destination.pixels[loc]  = source.pixels[loc];
      } else {
        destination.pixels[loc] = color(0, 0, 0);
      }

      //int h=(source.pixels[loc]>>16)&0xff;
      //int s=(source.pixels[loc]>>8)&0xff;
      //int b=(source.pixels[loc]>>0)&0xff;
      //println(((h<<16)|(s<<8)|b)+" : "+hex((h<<16)|(s<<8)|b));
      //hsbDomain[(h<<16)|(s<<8)|b]++;
      //hsbDomain[((int)source.pixels[loc])&0xffffff]++;

      float v=map(((int)source.pixels[x + y*source.width])&0xffffff, 0, (float)(0xffffff), 0, 255);
      hsbDomain[((int)v)]++;

      hueDomain[(int)hue(source.pixels[loc])]++;
    } // End for loop
  }// End for loop

  destination.updatePixels();
  
  plotColorDomain(hsbDomain, true);
  plotColorDomain(hueDomain, false);
  //image(destination, 0, 0);

  println("Done @"+millis()/1000);
}

void keyPressed() {
  if (key == 'A' || key == 'a')
    threshold = threshold + 10;

  if (key == 'D' || key == 'd')
    threshold = threshold - 10;

  if (key == 'B' || key == 'b')
    mode = 0;

  if (key == 'H' || key == 'h')
    mode = 1;

  println(threshold);
}

boolean hueClose(float a, float b, float max, float close) {
  if (hueDist(a, b, max)<close) {
    return true;
  } else {
    return false;
  }
}

float hueDist(float a, float b, float max) {
  return ((a - b) + (max/2))%max - (max/2);
}




void plotColorDomain(int[] colDomain, boolean logSc) {
  int maxY=max(colDomain);
  int r=3;  //Marker's radius
  float vmargin=0.05;  //in percentage

  pushStyle();  

  for (int i=0; i<colDomain.length-1; i++) {
    float y1=0, y2=0;
    float x1=map(i, 0, colDomain.length, 0, width);
    float x2=map(i+1, 0, colDomain.length, 0, width);   
    if (logSc==true) {
      y1=map(colDomain[i]==0?0:log(colDomain[i]), 0, log(maxY), (1-vmargin)*height, vmargin*height );
      y2=map(colDomain[i+1]==0?0:log(colDomain[i+1]), 0, log(maxY), (1-vmargin)*height, vmargin*height );
    } else {
      y1=map(colDomain[i], 0, maxY, (1-vmargin)*height, vmargin*height );
      y2=map(colDomain[i+1], 0, maxY, (1-vmargin)*height, vmargin*height );
    }
    stroke(255);
    line(x1, y1, x2, y2); 
    noStroke();
    fill(color(i, 255, 255));
    ellipse(x1, y1, r, r);
    ellipse(x2, y2, r, r);
  }
  popStyle();
}