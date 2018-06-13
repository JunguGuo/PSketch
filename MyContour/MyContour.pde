import gab.opencv.*;
import processing.video.*;
//GUI
public int myColor = color(0, 0, 0);

void setup() {
  size(1400, 360);
  setupCamPho();
  /*GUI*/
  SetupGUI();
}


void draw() {
  if (realTime)
    GrabContour();

  if (showContourDebug)
    showContour();

  if (hasOutlines)
    showOutlines();

}


void keyPressed() {
  if (key == ' ') {
    //GrabContour();
    createOutlines(DensityInterval);
  }
}
