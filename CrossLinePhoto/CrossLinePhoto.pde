PImage photo;
int index = 0;
int randomness = 20;
void setup() {
  size(600, 600);
  photo = loadImage("photo.jpg");
  
  
}


void draw() {
  //image(photo, 0, 0);
  

  for(int x = 0 ; x<= index; x++){
   int y = index - x;
   if(x> width || y>height)
     continue;
   DrawCrossLineAt(x,y);
  }


  
  if(index < width*2)
    index ++;
  //if(index==width)
  //  reverse = true;
  //if(reverse && index>=0)
  //  index --;
   //println(index);
  
  //DrawCrossLineAt(mouseX,mouseY);
}
boolean reverse = false;
void DrawCrossLineAt(int x, int y){
  color c = photo.get(x, y);
  stroke(c);
 // strokeWeight(2);
  if(reverse){
  //line(x, y, width, y);
   int r = int(random(-randomness,randomness));
   
  //line(x, y, x, height);
  line(x, y+r, x, height);
  
}
  else{
     //line(x, y, x, height);
      int r = int(random(-randomness,randomness));
    //line(x, y, width, y);
    line(x+r, y, width, y);
  }
  reverse = !reverse;
  
}
