class Ball {

  float r;   // radius
  float x, y; // location
  float xspeed, yspeed; // speed
  float angle = 0.0;
  float paddingPct = 0.2;
  float noiseScale = 0.0002;    
  color c;
  // Constructor
  Ball(float tempR, color tempC) {
    r = tempR;
    x = random(width);
    y = random(height);
    xspeed = random( - 5, 5);
    yspeed = random( - 5, 5);
    c =tempC;
    angle = random(0,360);
  }

  void move() {
    x += xspeed; // Increment x
    y += yspeed; // Increment y
    
    angle = map(noise(millis()*noiseScale),0,1.0,-PI,PI);
    // Check horizontal edges
    if (x > width+width*paddingPct || x < 0- width*paddingPct) {
      xspeed *= -1;
    }
    //Check vertical edges
    if (y > height+ height*paddingPct || y < 0 - height*paddingPct) {
      yspeed *= -1;
    }
  }

  // Draw the ball
  void display() {
    noStroke();
    fill(c);
    rectMode(CENTER);
    pushMatrix();
    translate(x,y);
    rotate(angle);
    rect(0, 0, r*2, r*2);
    popMatrix();
  }
}
