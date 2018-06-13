public int areaThreshold = 30;
public int areaMax = 200000;
public int geryThreshold = 100;
public int DensityInterval = 5;
public boolean usePhoto = true;
public boolean realTime = false;
public boolean showContourDebug = true;

OpenCV opencv;
Capture cam;
PImage src, dst;

ArrayList<Contour> contours;
ArrayList<Contour> validContours;
ArrayList<Contour> polygons;
ArrayList<PVector> outlines;

float maxCountourArea= 0;
float minCountourArea = 100000.0;
boolean hasOutlines = false;
void setupCamPho() {
  src = loadImage("photo.jpg"); 
  opencv = new OpenCV(this, src);
  /*Cam Setup*/
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    //println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, 640, 360, "1080p Pro Stream Webcam #2", 15);
    cam.start();
  }
}

void GrabContour() {
  //image(cam, 640, 0);
  if (usePhoto) {
    opencv.loadImage(src);
    image(src, 0, 0);
  } else {
    if (cam.available() == true) {
      cam.read();
      cam.save("photo1.jpg");
    }
    opencv.loadImage(cam);
    image(cam, 0, 0);
  }

  opencv.gray();
  opencv.threshold(geryThreshold);
  //dst = opencv.getOutput();
  contours = opencv.findContours();
  // image(dst, src.width, 0);

  if (contours == null) {
    println("find no contours!!!");
    return;
  }

  maxCountourArea= 0;
  minCountourArea = 100000.0;

  validContours = new ArrayList<Contour>();
  for (Contour contour : contours) {
    maxCountourArea = contour.area()>maxCountourArea?contour.area():maxCountourArea;
    minCountourArea = contour.area()<minCountourArea?contour.area():minCountourArea;

    if (contour.area()>areaThreshold && contour.area()<areaMax)
      validContours.add(contour);
  }
}

void showContour() {
  noFill();
  strokeWeight(3);
  stroke(255, 0, 0);
  for (Contour contour : validContours) {
    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape(CLOSE);
  }
  myTextlabelA.setText("Total:"+contours.size()+" Valid:"+validContours.size()+" : "+(validContours.size()==1? validContours.get(0).area():"")+" \n" + "min:"+minCountourArea+" " +"max:"+maxCountourArea);
}

void createOutlines(float densityInterval) {
  if (validContours.size()<1) {
    println("no valid contours to create outline from");
    return;
  } else if (validContours.size()>1) {
    println("more than one valid contours, create from the first one");
  }

  outlines = new ArrayList<PVector>();
  for (PVector point : validContours.get(0).getPolygonApproximation().getPoints()) {
    vertex(point.x, point.y);
    outlines.add(new PVector(point.x, point.y));
  }
  //duplicate first point to close the shape
  outlines.add(outlines.get(0).copy());

  Densify(outlines, densityInterval);
  
  hasOutlines = true;
}

void showOutlines() {
  if(outlines==null){
    println("outlines is null,cant show");
    return;
  }
  noFill();
  strokeWeight(3);
  stroke(0, 255, 0);
  
  for (PVector point : outlines) 
    point(point.x, point.y);
}
