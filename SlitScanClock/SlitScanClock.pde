import processing.video.*;

Movie movie;
int w = 1280;
int h = 720;
int divider = 2;
void setup() {
  size(1280, 1440);
  movie = new Movie(this, "dubai.mp4");
  movie.play();
}

// Step 4. Read new frames from movie
void movieEvent(Movie movie) {
  movie.read();
}
float x = 0;
int rectx,recty,recth,rectw = 1;
void draw() {
  // Step 5. Display movie.
  image(movie, 0, 0, w/divider,h/divider);
  rectx =  w/(divider*2);
  recty = 0;
  recth = h/divider;
  copy(movie, rectx,recty, rectw, recth , int(x), h/divider, 1 , h/divider );
  x+=0.2;
} 
