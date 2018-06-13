import ddf.minim.*;
AudioPlayer[] mplayer;
Minim minim;
 
//String[] songs={"cr1.mp3", "co2.mp3", "dj3.mp3"};
String[] songs={"hit.mp3","ding8.mp3"};
 
 
void setupSound() {

  minim = new Minim(this);
  mplayer=new AudioPlayer[3];
 
  for (int i=0; i<songs.length; i++) {
    mplayer[i] = minim.loadFile(songs[i]);
    //mplayer[i].play();
  }
}
 

 
void palyHitSound() {
 
  //int v=int(random(songs.length));
  mplayer[0].rewind();
  mplayer[0].play();
}

void palyRow1Sound() {
 
  //int v=int(random(songs.length));
  mplayer[1].rewind();
  mplayer[1].play();
}
