
import processing.video.*;
Movie myMovie;
float scale = 0.25;
static final int w = 1280;
static final int h = 720;
int ww = int(w*scale);
int hh = int(h*scale);
String[] timelines_raw;
float[] times;
float offset =0.0; //30.5;//32.5
int index = 0;
void setup() {
  times = new float[2000];
  size(320, 180);
  frameRate(30);
  myMovie = new Movie(this, "test.mp4");
  myMovie.play();
  myMovie.pause();
  timelines_raw = loadStrings("test.txt");


  for (String item : timelines_raw) {
    //System.out.println(item);
    if (item.indexOf(" --> ")!= -1) {
      String[] ss = split(item, " --> ");
      float[] seconds = new float[2];
      for (int i = 0; i<2; i++) {
        println(ss[i]);
        String[] t = splitTokens(ss[i], ":,");
        seconds[i] = int(t[0])*60*60+int(t[1])*60+int(t[2]);
      }
      float second = (seconds[0]+seconds[1])/2.0f;
      times[index] = second;
      index++;
    }
  }
  for (int i = 0; i<=index; i++) {
    times[i]+=offset;
    println(times[i]);
  }
}
int ii = 0;

void draw() {
  //for (int i =0; i<=index; i++) {
  //  myMovie.jump(times[i]);
  //  myMovie.read();
  //  image(myMovie, 0, 0, w*scale, h*scale);

  //  //save(i+".jpg");
  //}
  if (myMovie.available() ) {
    myMovie.read();
    image(myMovie, 0, 0,ww, hh);
    String padding;
    if (ii<10)
      padding = "000";
    else if (ii<100)
      padding = "00";
    else if (ii<1000)
      padding = "0";
    else 
    padding = "";
    save(padding+ii+".jpg");
    mousePressed();
  }
}

void mousePressed() {
  if (ii>index)
    exit(); 
  myMovie.jump(times[ii]);
  myMovie.play();
  myMovie.pause();
  ii++;
}
