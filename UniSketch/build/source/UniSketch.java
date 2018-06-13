import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.pdf.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class UniSketch extends PApplet {



// LIBRARIES



// GLOBAL VARIABLES
PShape baseMap;
String csv[];
String myData[][];
PFont f;


// SETUP
public void setup() {
  
  noLoop();
  f = createFont("Avenir-Medium", 12);
  baseMap = loadShape("WorldMap.svg");
  csv = loadStrings("MeteorStrikes.csv");
  myData = new String[csv.length][6];
  for(int i=0; i<csv.length; i++) {
    myData[i] = csv[i].split(",");
  }
}


// DRAW
public void draw() {
  beginRecord(PDF, "meteorStrikes.pdf");
  shape(baseMap, 0, 0, width, height);
  noStroke();

  for(int i=0; i<myData.length; i++){
    fill(255, 0, 0, 50);
    textMode(MODEL);
    noStroke();
    if( Float.isNaN(PApplet.parseFloat(myData[i][3])))
      println(i);
    float graphLong = map(PApplet.parseFloat(myData[i][3]), -180, 180, 0, width);
    float graphLat = map(PApplet.parseFloat(myData[i][4]), 90, -90, 0, height);
    float markerSize = 0.05f*sqrt(PApplet.parseFloat(myData[i][2]))/PI;
    ellipse(graphLong, graphLat, markerSize, markerSize);

    if(i<20){
      fill(0);
      textFont(f);
      text(myData[i][0], graphLong + markerSize + 5, graphLat + 4);
      noFill();
      stroke(0);
      line(graphLong+markerSize/2, graphLat, graphLong+markerSize, graphLat);
    }
  }
  endRecord();
  println("PDF Saved!");
}
  public void settings() {  size(1800, 900); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "UniSketch" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
