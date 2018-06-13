//based on:https://www.openprocessing.org/sketch/156580

PImage photo;
ArrayList <Mover> bouncers;

int bewegungsModus = 1;
PVector candyJar = new PVector(489,466);
boolean transparentBG = true;
void setup() {
  size(1152, 720);
  photo = loadImage("photo.jpg");
  

  smooth();

  bouncers = new ArrayList();

  for (int i = 0; i < 20; i++)
  {
    Mover m = new Mover();
    bouncers.add (m);
  }

  //background (#57385c);
  //frameRate (30);
}

void draw() {
  blendMode(BLEND);
  image(photo, 0, 0);

   float sumDist = 0;
  for(Mover m : bouncers){
    sumDist +=  PVector.sub(m.location, candyJar).mag();
  }  
    println(sumDist);
    blendMode(MULTIPLY);
  float val = map(sumDist,0,8000,255,0);
  fill(17,40,88,val);
  rect(0,0,width,height);
  
  
    blendMode(BLEND);
  int i = 0;
 
  while (i < bouncers.size () )
  {
    Mover m = bouncers.get(i);
    if (bewegungsModus != 5) {
    //println("haha");
    m.update (bewegungsModus);}
    else
    {
      println("agaga");
      m.flock (bouncers);
      m.move();
      m.checkEdges();
      m.display();
      
    }
  
    i = i + 1;
  }
  

}



class Mover
{
  PVector[] traces;
  PVector direction;
  PVector location;

  float speed;
  float SPEED;

  float noiseScale;
  float noiseStrength;
  float forceStrength;

  float ellipseSize;
  
  color c;


  Mover () // Konstruktor = setup der Mover Klasse
  {
    setRandomValues();
    traces = new PVector[30];
       for(int i = 0;i<traces.length;i++){
      traces[i] = new PVector(0,0);
    }
  }

  Mover (float x, float y) // Konstruktor = setup der Mover Klasse
  {
    setRandomValues ();
    traces = new PVector[10];
    for(int i = 0;i<traces.length;i++){
      traces[i] = new PVector(x,y);
    }
  }

  // SET ---------------------------

  void setRandomValues ()
  {
    location = new PVector (random (width), random (height));
    ellipseSize = random (4, 15);

    float angle = random (TWO_PI);
    direction = new PVector (cos (angle), sin (angle));

    speed = random (4, 7);
    SPEED = speed;
    noiseScale = 80;
    noiseStrength = 1;
    forceStrength = random (0.1, 0.2);
    
    setRandomColor();
  }

  void setRandomColor ()
  {
    int colorDice = (int) random (4);

    if (colorDice == 0) c = #ffedbc;
    else if (colorDice == 1) c = #FA9D62;
    else if (colorDice == 2) c = #F27227;
    else c = #febe7e;
  }

  // GENEREL ------------------------------

  void update ()
  {
    update (0);
  }

  void update (int mode)
  {
    //println(mode);
    if (mode == 0) // bouncing ball
    {
      speed = SPEED * 0.7;
      move();
      checkEdgesAndBounce();
    }
    else if (mode == 1) // noise
    {
      speed = SPEED * 0.7;
      addNoise ();
      move();
      checkEdgesAndRelocate ();
    }
    else if (mode == 2) // steer
    {
      steer (candyJar.x, candyJar.y);
      move();
    }
    else if (mode == 3) // seek
    {
      speed = SPEED * 0.2;
      seek (candyJar.x, candyJar.y);
      move();
    }
    else // radial
    {
      speed = SPEED * 0.7;
      addRadial ();
      move();
      checkEdges();
    }

    display();
  }

  // FLOCK ------------------------------

  void flock (ArrayList <Mover> boids)
  {

    PVector other;
    float otherSize ;

    PVector cohesionSum = new PVector (0, 0);
    float cohesionCount = 0;

    PVector seperationSum = new PVector (0, 0);
    float seperationCount = 0;

    PVector alignSum = new PVector (0, 0);
    float speedSum = 0;
    float alignCount = 0;

    for (int i = 0; i < boids.size(); i++)
    {
      other = boids.get(i).location;
      otherSize = boids.get(i).ellipseSize;

      float distance = PVector.dist (other, location);


      if (distance > 0 && distance <70) //align + cohesion
      {
        cohesionSum.add (other);
        cohesionCount++;

        alignSum.add (boids.get(i).direction);
        speedSum += boids.get(i).speed;
        alignCount++;
      }

      if (distance > 0 && distance < (ellipseSize+otherSize)*1.2) // seperate bei collision
      {
        float angle = atan2 (location.y-other.y, location.x-other.x);

        seperationSum.add (cos (angle), sin (angle), 0);
        seperationCount++;
      }

      if (alignCount > 8 && seperationCount > 12) break;
    }

    // cohesion: bewege dich in die Mitte deiner Nachbarn
    // seperation: renne nicht in andere hinein
    // align: bewege dich in die Richtung deiner Nachbarn

    if (cohesionCount > 0)
    {
      cohesionSum.div (cohesionCount);
      cohesion (cohesionSum, 1);
    }

    if (alignCount > 0)
    {
      speedSum /= alignCount;
      alignSum.div (alignCount);
      align (alignSum, speedSum, 1.3);
    }

    if (seperationCount > 0)
    {
      seperationSum.div (seperationCount);
      seperation (seperationSum, 2);
    }
  }

  void cohesion (PVector force, float strength)
  {
    steer (force.x, force.y, strength);
  }

  void seperation (PVector force, float strength)
  {
    force.limit (strength*forceStrength);

    direction.add (force);
    direction.normalize();

    speed *= 1.1;
    speed = constrain (speed, 0, SPEED * 1.5);
  }

  void align (PVector force, float forceSpeed, float strength)
  {
    speed = lerp (speed, forceSpeed, strength*forceStrength);

    force.normalize();
    force.mult (strength*forceStrength);

    direction.add (force);
    direction.normalize();
  }

  // HOW TO MOVE ----------------------------

  void steer (float x, float y)
  {
    steer (x, y, 1);
  }

  void steer (float x, float y, float strength)
  {

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();

    float currentDistance = dist (x, y, location.x, location.y);

    if (currentDistance < 70)
    {
      speed = map (currentDistance, 0, 70, 0, SPEED);
    }
    else speed = SPEED;
  }

  void seek (float x, float y)
  {
    seek (x, y, 1);
  }

  void seek (float x, float y, float strength)
  {

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();
  }

  void addRadial ()
  {

    float m = noise (frameCount / (2*noiseScale));
    m = map (m, 0, 1, - 1.2, 1.2);

    float maxDistance = m * dist (0, 0, width/2, height/2);
    float distance = dist (location.x, location.y, width/2, height/2);

    float angle = map (distance, 0, maxDistance, 0, TWO_PI);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength);

    direction.add (force);
    direction.normalize();
  }

  void addNoise ()
  {

    float noiseValue = noise (location.x /noiseScale, location.y / noiseScale, frameCount / noiseScale);
    noiseValue*= TWO_PI * noiseStrength;

    PVector force = new PVector (cos (noiseValue), sin (noiseValue));
    //Processing 2.0:
    //PVector force = PVector.fromAngle (noiseValue);
    force.mult (forceStrength);
    direction.add (force);
    direction.normalize();
  }

  // MOVE -----------------------------------------

  void move ()
  {
    for(int i =traces.length-1; i>=1;i--){
      traces[i] = traces[i-1];
    }
    PVector velocity = direction.get();
    velocity.mult (speed);
    location.add (velocity);
    for(int i =traces.length-1; i>=1;i--){
      traces[i] = traces[i-1].copy();
    }
    traces[0] = location.copy();
  }

  // CHECK --------------------------------------------------------

  void checkEdgesAndRelocate ()
  {
    float diameter = ellipseSize;

    if (location.x < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }
    else if (location.x > width+diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }

    if (location.y < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }
    else if (location.y > height + diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }
  }


  void checkEdges ()
  {
    float diameter = ellipseSize;

    if (location.x < -diameter / 2)
    {
      location.x = width+diameter /2;
    }
    else if (location.x > width+diameter /2)
    {
      location.x = -diameter /2;
    }

    if (location.y < -diameter /2)
    {
      location.y = height+diameter /2;
    }
    else if (location.y > height+diameter /2)
    {
      location.y = -diameter /2;
    }
  }

  void checkEdgesAndBounce ()
  {
    float radius = ellipseSize / 2;

    if (location.x < radius )
    {
      location.x = radius ;
      direction.x = direction.x * -1;
    }
    else if (location.x > width-radius )
    {
      location.x = width-radius ;
      direction.x *= -1;
    }

    if (location.y < radius )
    {
      location.y = radius ;
      direction.y *= -1;
    }
    else if (location.y > height-radius )
    {
      location.y = height-radius ;
      direction.y *= -1;
    }
  }

  // DISPLAY ---------------------------------------------------------------

  void display ()
  {
  noStroke();
    //fill (c);
    for(int i =0;i<traces.length;i++){
      float size = map(i,0,traces.length-1,ellipseSize,ellipseSize*0.7);
      float alpha = 200-i*35;
      fill (c,alpha);
      ellipse(traces[i].x, traces[i].y, size, size);
      
      //drawglow
      if(i == 0){
        for(int j = 0 ; j<(9 - ellipseSize*0.4); j++){
          fill (c,alpha-j*80);
          ellipse(traces[i].x, traces[i].y, size+j*7, size+j*7);
        }
      }
      
    //println(traces[i].x);  
  }
    //ellipse (location.x, location.y, ellipseSize, ellipseSize);
  }
}

void keyPressed ()
{
  if (key == ' ') transparentBG = !transparentBG;
  if (key == 'n')
  {
    float noiseScale = random (5, 400);
    float noiseStrength = random (0.5, 6);
    float forceStrength = random (0.5, 4);

    for (int i = 0; i < bouncers.size(); i++)
    {
      Mover currentMover = bouncers.get(i);
      currentMover.noiseScale = noiseScale;
      currentMover.noiseStrength = noiseStrength;
      currentMover.forceStrength = forceStrength;
    }
  }
  if(key == '0'){
    bewegungsModus = 0;
  }
    if(key == '2'){
    bewegungsModus = 2;
  }
    if(key == '4'){
    bewegungsModus = 4;
  }
}

void mousePressed ()
{
  if (mouseButton == LEFT)
  {
    bewegungsModus++;
    bewegungsModus%=5;
    
  }
}
