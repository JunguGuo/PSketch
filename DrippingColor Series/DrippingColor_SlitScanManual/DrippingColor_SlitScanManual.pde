int cx, cy;
int num = 3000;
float test, w, a;
PVector[] inkArray = new PVector[num];
PVector prevPos = new PVector(0,0);
float[] maxSize = new float[num];
color[] colors = new color[num];
int[] loops = new int[num];
PImage backgroundImage;

int High = 290;
float offsetY = 40;
float randomY = 30;
void setup() {
  size(600, 600);
  background(255);
    backgroundImage = loadImage("photo.jpg");
  cx = width/2;
  cy = height/2;
  for(int i=0; i<num; i++) {
    inkArray[i] = new PVector(random(-300, 300) + cx, random(0,randomY )+ offsetY);
    maxSize[i] = height;
    loops[i] = 0;
    colors[i]= backgroundImage.get(int(inkArray[i].x),int(inkArray[i].y));
  }

  //backgroundImage = createImage(width, height, RGB);
  //for (int i = 0; i < width; i++) {
  //  for (int j = 0; j < height; j++) {
  //    backgroundImage.pixels[i+j*width] = lerpColor(color(255), color(220), map(j, 0, width, 0, 1));
  //  }
  //}
  //image(backgroundImage, 0, 0);
}
boolean pause = false;
int count = 1;
int stepY = 20;
void keyPressed() {
  //press space repeatedly to simulate slitscan
  count++;
   for(int i=0; i<num; i++) {
    inkArray[i] = new PVector(random(-300, 300) + cx, random(0,randomY )+ offsetY+count*stepY);
    colors[i]= backgroundImage.get(int(inkArray[i].x),int(inkArray[i].y));
  }
}
void draw() {
  if(pause)
  return;
  for(int i=0; i<num; i++) {
    prevPos.x = inkArray[i].x;
    prevPos.y = inkArray[i].y;
    inkArray[i].x += random(-0.5, 0.5);
    inkArray[i].y += random(3);
    w = abs(maxSize[i] / (inkArray[i].y-count*stepY));
    a = map(inkArray[i].y, maxSize[i], 0, 0, 200);
    strokeWeight(w);
    stroke(colors[i], a);
    if (inkArray[i].y < maxSize[i]) {
      line(prevPos.x, prevPos.y, inkArray[i].x, inkArray[i].y);
    } else {
      //loops[i] ++;
      //inkArray[i] = new PVector(random(-300, 300) + cx, random(-High+i*10, High+i*10) + cy); 
      //colors[i]= backgroundImage.get(int(inkArray[i].x),int(inkArray[i].y));
      //maxSize[i] = random(height);
    }
  }
}
