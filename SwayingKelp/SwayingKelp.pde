int x = 0;

void setup() {
  size(200, 600);
}

void circle(float x, float y, float r) {
  ellipse(x, y, r, r);
}

void drawSineCircle(int n) {
  int circleSize = 20;

  for (int i = 0; i < n; i = i + 1) {
    float circlePositionX = map(sin(2*(x / 100.0 + i / 10.0)),-1,1,-(n-1-i)/float(n-1),(n-1-i)/float(n-1)) * width / 2 + width / 2;
    float circlePositionY = (height / (n + 1)) * (i + 1);

    circle(circlePositionX, circlePositionY, circleSize);
  }

  x = x + 1;
}

void draw() {
  background(255);

  drawSineCircle(20);
}
