ArrayList<Petardo> bomba = new ArrayList<Petardo>();

class Petardo {
  PVector pos;
  PVector vel;
  PVector acc;
  int counter;
  float max;
  float r, re, gr, bl;
  int n;
  float v;
  boolean isOrig = true;
  Petardo(float x_, float y_, float sx, float sy, float r, float ax, float ay, float max_, int n_, float re_, float gr_, float bl_) {
    pos = new PVector(x_, y_);
    vel = new PVector(sx, sy);
    acc = new PVector(ax, ay);
    this.r = r;
    re = re_;
    gr = gr_;
    bl = bl_;
    counter = 0;
    max = max_;
    n = n_;
    v = 6;
  }

  void tick() {
    counter+=2;
    pos.add(vel);
    vel.add(acc);
    if(isOrig){
    float ratio = map(pos.x,0,width,0,PI);
    pos.y = map(sin(ratio),0,1,0,spawnHeight);}
  }

  boolean touchCheck(PVector other) {
    float dis = PVector.dist(pos, other);
    if (dis<40)
      return true;
    else return false;
  }

  void show() {
    ellipseMode(CENTER);
    fill(re, gr, bl);
    noStroke();
    ellipse(pos.x, pos.y, r, r);
  }
  ArrayList<Petardo> explode(ArrayList<Petardo> bomba, int i) {
    Petardo p = bomba.get(i);
    bomba.remove(i);
    if (n==0 ||p.max<10.6) return bomba;
    for (int j = 0; j < 360; j+=floor(360/n)) {
      Petardo pe = new Petardo(p.pos.x, p.pos.y, cos(radians(j))*v, sin(radians(j))*v, p.r/2, cos(radians(j))/abs(cos(radians(j))) * 0.1, sin(radians(j))/abs(sin(radians(j))) * 0.1, p.max*0.75, p.n - 5, p.re+random(10, 30), p.gr+random(10, 30), p.bl+random(10, 30));
      pe.isOrig = false;
      bomba.add(pe);
    }

    return bomba;
  }
}

//-----
void mousePressed() {
  bomba.add(new Petardo(mouseX, mouseY, 0, -30, 25, 0, 0, 25, 20, random(100, 255), random(100, 255), random(100, 255)));
}

int savedTime;
float totalTime2 = 2000.0f;

void SpawnBomba() {
  int passedTime = millis() - savedTime;
  // Has 2 seconds passed?
  if (passedTime > totalTime2) {
    bomba.add(new Petardo(0, spawnHeight, 10, 0, 25, 0, 0, 25, 20, random(100, 255), random(100, 255), random(100, 255)));
    savedTime = millis();
  }
}

void updateBomba() {
  for (int i = 0; i < bomba.size(); i++) {
    Petardo d = bomba.get(i);
    if (d.pos.x > width || d.pos.y > height || d.pos.x < 0 || d.pos.y < 0) {
      bomba.remove(i);
      continue;
    }

    if (d.isOrig && d.touchCheck(new PVector(rx, ry))) {
      bomba = d.explode(bomba, i);
      count++;
      if(count<rowCount1)
        palyHitSound();
      if (count >= rowCount1 && count< rowCount2) {
        continousTimer = 0;
        lastSavedContinous = millis();
        continousTime = 200;
        palyRow1Sound();
      }
      if (count>=rowCount2) {
        continousTimer = 0;
        lastSavedContinous = millis();
        continousTime = 500;
        palyRow1Sound();
      }
    }

    if ((keyPressed && key == ' ')
      || continousTimer<continousTime) {
      if (!d.isOrig &&  d.counter > 20 )
        bomba = d.explode(bomba, i);
      continousTimer += millis()-lastSavedContinous;
      lastSavedContinous = millis();
    }
  }
  for (Petardo p : bomba) {
    p.tick();
    p.show();
  }
}
