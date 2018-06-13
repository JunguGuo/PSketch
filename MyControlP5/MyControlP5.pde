
public int myColor = color(0, 0, 0);
public int sliderValue = 100;
public int sliderTicks1 = 100;
public int sliderTicks2 = 30;
public boolean toggle = false;

void setup() {
  size(700, 400);
  noStroke();
  SetupGUI();
}

void draw() {
  background(sliderTicks1);

  fill(sliderValue);
  rect(0, 0, width, 100);

  fill(myColor);
  rect(0, 300, width, 70);

  fill(sliderTicks2);
  rect(0, 370, width, 30);
  myTextlabelA.setText("Timer:"+millis()+"");
  if(toggle){
    fill(255);
    ellipse(width/2,height/2,100,100);
  }
}
