// Two ball variables
import processing.video.*;

Capture video;

Ball ball1;
Ball ball2;
Ball ball3;
Ball ball4;
void setup() {
  size(320, 240);
    video = new Capture(this,320,240);
  video.start();

  // Initialize balls
  ball1 = new Ball(200, color(123,45,100));
  ball2 = new Ball(300,color(45,100,123));
   ball3 = new Ball(200, color(123,200,100,90));
  ball4 = new Ball(300,color(245,100,123));
}
void captureEvent(Capture video){
  video.read();

}
void draw() {
  background(0);
  
  // Move and display balls
  blendMode(ADD);
  image(video,0,0);
  ball1.move();
  ball2.move();

  ball3.move();
  blendMode(ADD);
  ball1.display();
  blendMode(LIGHTEST);
  ball2.display();
  blendMode(MULTIPLY);
    ball3.display();
}
