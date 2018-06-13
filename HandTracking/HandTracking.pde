// Daniel Shiffman
// Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original example by Elie Zananiri
// http://www.silentlycrashing.net

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import oscP5.*;
import netP5.*;
import codeanticode.syphon.*;
SyphonServer server;
int HighestScore = 10;
OscP5 oscP5;
NetAddress myRemoteLocation;
Kinect kinect;
int xMin = 0;
int xMax = 0;
int yMin = 0;
int yMax = 0;
float continousTime = 600;
float lastSavedContinous;
float continousTimer = 10000;
// Depth image
PImage depthImg;
int count=0;
int rowCount1 = 5;
int rowCount2 = 10;
// Which pixels do we care about?
int minDepth =  60;
int maxDepth = 910;
  int rx = 0;
  int ry = 0;
// What is the kinect's angle
float angle;
float spawnHeight = 240;
void setup() {
  size(640, 480,P3D);
  oscP5 = new OscP5(this,13000);
  server = new SyphonServer(this, "ProcessingSyphon");
  myRemoteLocation = new NetAddress("127.0.0.1",13000);
  
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  angle = kinect.getTilt();

  // Blank image
  depthImg = new PImage(kinect.width, kinect.height);
  
  
  savedTime = millis();
  
  setupSound();
}

void draw() {
  // Draw the raw image
  //image(kinect.getDepthImage(), 0, 0);

  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();

  int record = kinect.height;

  boolean flag= false;
  for (int x=0; x < kinect.width; x++) {
    for (int y = 0; y<kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = rawDepth[offset];

      if (d >= minDepth && d <= maxDepth && y< height - 40) {
        depthImg.pixels[offset] = color(255, 0, 150);
        if (y<record) {
          flag = true;
          record = y;
          rx = x;
          ry = y;
        }
      } else {
        
        depthImg.pixels[offset] = color(0, 0);
      }
    }
  }
  if(!flag){
    rx = -100;
        ry = -100;
      }
  //blendMode(ADD);
  // Draw the thresholded image
  depthImg.updatePixels();
  //image(kinect.getVideoImage(), kinect.width, 0);
  image(depthImg, 0, 0);
  //blendMode(NORMAL);
  //fill(0);
  //text("TILT: " + angle, 10, 20);
  //text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  fill(255);
  showUI();
 //   text("TILT: " + angle, 10, 20);
  text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  rx = (int)map(rx,0,640,0,640);
  ry = (int)map(ry,0,480,0,480);
  
  ellipse(rx,ry,20,20);
  //sendPos();
  stroke(255);
  line(0,spawnHeight, width,spawnHeight);
  
  
  
  SpawnBomba();
  updateBomba();
  
  server.sendScreen();
}

// Adjust the angle and the depth threshold min and max
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      spawnHeight-=5;
    } else if (keyCode == DOWN) {
      spawnHeight+=5;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  } else if (key == 'a') {
    minDepth = constrain(minDepth+5, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-5, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+5, minDepth, 2047);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-5, minDepth, 2047);
  }
}

void sendPos() {
  OscMessage myMessage = new OscMessage("/hand");
  myMessage.add((float)ry);
  myMessage.add((float)rx); /* add an int to the osc message */
  
  
  oscP5.send(myMessage, myRemoteLocation); 
  

  
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
