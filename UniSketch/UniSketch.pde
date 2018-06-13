

// LIBRARIES
import processing.pdf.*;


// GLOBAL VARIABLES
PShape baseMap;
PFont f;

JSONObject json;
University[] universities;
void loadData( ) {
  // Load JSON file
  json = loadJSONObject("university_location.json");

  JSONArray uniData = json.getJSONArray("university");

  // The size of the array of Bubble objects is determined by the total XML elements named "bubble"
  universities = new University[uniData.size()];

  for (int i = 0; i < uniData.size(); i++) {
    // Get each object in the array
    JSONObject uinversity = uniData.getJSONObject(i);
    // Get a position object
    JSONObject location = uinversity.getJSONObject("location");
    // Get x,y from position
    float lat = location.getFloat("lat");
    float lng = location.getFloat("lng");

    // Get diamter and label
    int rank = uinversity.getInt("rank");
    String name = uinversity.getString("name");

    // Put object in array
    universities[i] = new University(lat, lng, rank, name);
  }

}

// SETUP
void setup() {
  size(1800, 900);
  noLoop();
  f = createFont("Avenir-Medium", 12);
  baseMap = loadShape("WorldMap.svg");
  loadData();
  //colorMode(HSB,360,100,100);
}


// DRAW
void draw() {
  beginRecord(PDF, "Uni.pdf");
  shape(baseMap, 0, 0, width, height);
  noStroke();
  

  for(int i=universities.length-1; i>=0; i--){
    
    textMode(MODEL);
    noStroke();

    float graphLong = map(universities[i].lng, -180, 180, 0, width);
    float graphLat = map(universities[i].lat, 90, -90, 0, height);
    float markerSize = 5;
    int hue;
    if(universities[i].rank < 100)
      fill(#B40000);
    else if(universities[i].rank < 300)
     fill(#A8B400);
    else if(universities[i].rank < 500)
     fill(#00B40D);
    else 
     fill(#0043B4);

    ellipse(graphLong, graphLat, markerSize, markerSize);
    
    /*draw label*/
    if(universities[i].rank<50){
      fill(0);
      textFont(f);
      text(universities[i].name, graphLong + markerSize*10 + 5, graphLat + 4);
      noFill();
      stroke(0);
      line(graphLong+markerSize/2, graphLat, graphLong+markerSize*10, graphLat);
    }
  }
  endRecord();
  println("PDF Saved!");
}
