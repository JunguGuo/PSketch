import g4p_controls.*;

import processing.video.*;

Capture video;


float[] offsets = new float[240]; 
float noiseScale = 0.02;
float noiseHeight = 100;
void setup(){
  size(740,240);
  video = new Capture(this,320,240);
  video.start();
    createGUI();
  for (int x=0; x < 240; x++) {
    float noiseVal = noise(x*noiseScale)*noiseHeight;
    offsets[x] = noiseVal;
  }
}

void captureEvent(Capture video){
  video.read();

}


void draw(){
  noiseScale = map(mouseX,0,640,0,0.2);
  noiseHeight = map(mouseY,0,640,240,240);
    for (int x=0; x < 240; x++) {
    float noiseVal = noise(x*noiseScale,millis()/4000.0)*noiseHeight;
    offsets[x] = noiseVal;
  }
  image(video,0,0);
    for(int y =0;y<240;y++){
  copy(video,0,y,320,1,int(320+offsets[y]),y,320,1);
  }
}
