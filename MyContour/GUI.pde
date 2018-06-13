/**
Key-commands
ALT-mouseMove move controllers
ALT-shift-h show and hide controllers
ALT-shift-s save controller setup in an properties-document
ALT-shift-l load a controller setup from a properties-document
 * www.sojamo.de/libraries/controlp5
 *
 */

import controlP5.*;

ControlP5 cp5;

Slider2D slider2D;
Textlabel myTextlabelA;

void SetupGUI(){
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  //broadcast could trigger callback, notice it was set to false first and then ture later so that the 'set range', 'set value' would not trigger the callback
  
  cp5.begin(cp5.addBackground("abc"));
  cp5.addSlider("slider")
     .setBroadcast(false)
     .setRange(0, 200)
     .setPosition(10, 100)
     .setSize(10, 100)
     .setValue(100)
     .setBroadcast(true)
     ;
  
  cp5.addSlider("DensityInterval")
     .setRange(0, 20)
     .setPosition(45, 100)
     .setSize(10, 100)
     .setNumberOfTickMarks(10)
     ;

  cp5.addSlider("geryThreshold")
     .setRange(0, 255)
     .setValue(128)
     .setPosition(10, 230)
     .setSize(100, 10)
     ;
     
  cp5.addSlider("areaThreshold")
     .setRange(1000, 20000)
     .setValue(10000)
     .setPosition(10, 250)
     .setSize(100, 10)
     ;
   cp5.addSlider("areaMax")
     .setRange(50000, 300000)
     .setValue(200000)
     .setPosition(10, 270)
     .setSize(100, 10)
     ;
  
  //buttonbar
  ButtonBar b = cp5.addButtonBar("bar")
     .setPosition(0, 0)
     .setSize(200, 20)
     .addItems(split("0 1 2 3 4 5"," "))
     ;
  //println(b.getItem("a"));
  b.changeItem("0","text","zero");
  //b.onMove(new CallbackListener(){
  //  public void controlEvent(CallbackEvent ev) {
  //    ButtonBar bar = (ButtonBar)ev.getController();
  //    println("hello ",bar.hover());
  //  }
  //});
  
  //button
   // create a new button with name 'buttonA'
  cp5.addButton("ButtonA")
     .setBroadcast(false)
     .setValue(0)
     .setPosition(10,40)
     .setSize(40,20)
     .setBroadcast(true)
     ;
  // and add another 2 buttons
  cp5.addButton("ButtonB")
     .setBroadcast(false)
     .setValue(100)
     .setPosition(10,65)
     .setSize(40,20)
     .setBroadcast(true)
     ;
  
  cp5.addColorWheel("c" , 150 , 50 , 150 ).setRGB(color(128,0,255));
  //usage:
  //int c = color(100); // as global variable
  //println(cp5.get(ColorWheel.class,"c").getRGB());
  
  
   slider2D = cp5.addSlider2D("wave")
         .setPosition(10,280)
         .setSize(100,100)
         .setMinMax(20,10,100,100)
         .setValue(50,50)
         //.disableCrosshair()
         ;
   //usage:
   //slider2D.getArrayValue()[0]
   //slider2D.getArrayValue()[1]
   
     cp5.addToggle("realTime")
     .setPosition(70,40)
     .setSize(40,10)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
      cp5.addToggle("usePhoto")
     .setPosition(70,70)
     .setSize(40,10)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
     cp5.addToggle("showContourDebug")
     .setPosition(70,100)
     .setSize(40,10)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
     //usage:define a global variable named 'toggle' and that's it
     //or use a callback named 'toggle'and do sth in there
     //but remember they cannnot exist together
  
    myTextlabelA = cp5.addTextlabel("label")
                    .setText("Textlabel A:")
                    .setPosition(150,300)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Georgia",15))
                    ;
                    
  cp5.end();
}


void bar(int n) {
  println("bar clicked, item-value:", n);
}

public void slider(float theColor) {
  myColor = color(theColor);
  println("slider callback");
}

// function colorA will receive changes from 
// controller with name colorA
public void ButtonA(int theValue) {
  println("a button event from colorA: "+theValue);
  //do sth
}

// function colorB will receive changes from 
// controller with name colorB
public void ButtonB(int theValue) {
  println("a button event from colorB: "+theValue);
  //do sth
}

/*can't not exist with the global variable named toggle*/
//void toggle(boolean theFlag) {
//  if(theFlag==true) {
//    //st
//  } else {
//    //sth
//  }
//  println("a toggle event.");
//}
