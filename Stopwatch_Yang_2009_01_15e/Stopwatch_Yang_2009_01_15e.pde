
import oscP5.*;
import netP5.*;

//PIECE TIMING
float pieceDuration = 300000; //6 MINUTES
float markDur = pieceDuration/19.0;
float [] markers = {
  0.0, markDur, markDur*2.0, markDur*3.0, markDur*4.0, markDur*5.0, markDur*6.0
    , markDur*7.0, markDur*8.0, markDur*9.0, markDur*10.0, markDur*11.0, markDur*12.0, markDur*13.0
    , markDur*14.0, markDur*15.0, markDur*16.0, markDur*17.0, markDur*18.0, markDur*19.0};

//OSC
OscP5 meOSC;
NetAddress [] swClients = new NetAddress[100];

OscMessage swMark0 = new OscMessage("/swMark0");
OscMessage swMark1 = new OscMessage("/swMark1");
OscMessage swMark2 = new OscMessage("/swMark2");
OscMessage swMark3 = new OscMessage("/swMark3");
OscMessage swMark4 = new OscMessage("/swMark4");
OscMessage swMark5 = new OscMessage("/swMark5");
OscMessage swMark6 = new OscMessage("/swMark6");
OscMessage swMark7 = new OscMessage("/swMark7");
OscMessage swMark8 = new OscMessage("/swMark8");
OscMessage swMark9 = new OscMessage("/swMark9");
OscMessage swMark10 = new OscMessage("/swMark10");
OscMessage swMark11 = new OscMessage("/swMark11");
OscMessage swMark12 = new OscMessage("/swMark12");
OscMessage swMark13 = new OscMessage("/swMark13");
OscMessage swMark14 = new OscMessage("/swMark14");
OscMessage swMark15 = new OscMessage("/swMark15");
OscMessage swMark16 = new OscMessage("/swMark16");
OscMessage swMark17 = new OscMessage("/swMark17");
OscMessage swMark18 = new OscMessage("/swMark18");
OscMessage swMark19 = new OscMessage("/swMark19");

OscMessage pause = new OscMessage("/pause");
OscMessage unpause = new OscMessage("/unpause");
OscMessage millisTag = new OscMessage("/millisTag");

//FONTS
PFont fontMonaco99;

//STOPWATCH
int hundredeths, seconds, minutes, hours, days;
String secondsA = "00";

//UNIVERSAL
float calibrateMasterTime = 0;
float masterTime;

float pauseTimeCalibration;

float networkLatency = 1000.0;

//KUCHEN
int kuchenCenterX, kuchenCenterY, kuchenWidth, kuchenHeight;
Kuchen[] kuchenSet;
color[] kuchenColor = {
  color(255,0,0), color(0,255,0), color(0,0,255), color(255,255,0), color(255,128,0), 
  color(128,0,255), color(255, 0, 128), color(0)};
  boolean kuchenExsists = false;

void setup() {

  //size(screen.width, screen.height);
  size(1000, 1000);
  smooth();

  //KUCHEN
  kuchenCenterX = width/2;
  kuchenCenterY = height/2 + 50;
  kuchenWidth = 400;
  kuchenHeight = 400;

  ////LOAD KUCHEN TIMINGS
  String [] kuchenSetLoad = loadStrings ("kuchenTimingColor.txt");
  if (kuchenSetLoad != null){
   kuchenExsists = true; 
    kuchenSet = new Kuchen [kuchenSetLoad.length];
    for(int i=0; i<kuchenSetLoad.length; i++){
      if (kuchenSetLoad[i].equals("null")!=true){
        String [] kuchenSetLoadPieces = split(kuchenSetLoad[i], "\t");
        kuchenSet[i] = new Kuchen(float(kuchenSetLoadPieces[0]), float(kuchenSetLoadPieces[1]), kuchenColor[int(kuchenSetLoadPieces[2])]);
      }
    }
  }



  //OSC
  ////Receiving Port
  meOSC = new OscP5(this,7777);
  ////Sending Ports from file
  String [] swClientIPsLoad = loadStrings ("swClientIPs.txt");
  if (swClientIPsLoad != null){
    for(int i=0; i<swClientIPsLoad.length; i++){
      if (swClientIPsLoad[i].equals("null")!=true){
        String [] swClientIPsLoadPieces = split(swClientIPsLoad[i], "\t");
        swClients[i] = new NetAddress(swClientIPsLoadPieces[0], int(swClientIPsLoadPieces[1]) );
      }
    }
  }


  //LOAD FONTS
  fontMonaco99 = loadFont("Monaco-99.vlw");

  //LOAD NETWORK LATENCY
  String [] networkLatencyLoad = loadStrings ("networkLatency.txt");
  if (networkLatencyLoad != null){
    if (networkLatencyLoad[0].equals("null")!=true){
      networkLatency = float(networkLatencyLoad [0]);
    }
  }

  //LOAD PIECE TIME AND PUNCH IN TIMES FROM FILE
  String [] pieceDurationLoad = loadStrings ("pieceDuration.txt");
  if (pieceDurationLoad != null){
    if (pieceDurationLoad[0].equals("null")!=true){
      pieceDuration = int(pieceDurationLoad [0]);
    }
    markDur = pieceDuration/19.0;
  }

  for(int i=0; i<markers.length; i++){
    markers[i] = markDur*i;
  }

  //LOAD MARKERS FROM FILE
  String [] markersLoad = loadStrings ("markers.txt");
  if (markersLoad != null){

    for(int i=0; i<markersLoad.length; i++){

      if (markersLoad[i].equals("null")!=true){
        markers[i] = float(markersLoad [i]);
      }
      else{
        markers[i] = markDur*i;
      }

    }

  }

  calibrateMasterTime = millis();

}

void draw () {

  background(255, 255, 255, 0);
  masterTime = millis() - calibrateMasterTime;

  //STOPWATCH
  seconds = int(((masterTime)/1000)%60);
  minutes = int ((((masterTime)/1000)/60)%60); 
  // Clock display
  textFont(fontMonaco99, 200);
  fill (0);
  textAlign(CENTER, TOP);
  if(seconds<10){
    secondsA = "0"+str(seconds);
  }
  else{
    secondsA = str(seconds);
  }
  text(minutes + ":" + secondsA, width/2, 70);

  if(masterTime >= pieceDuration){
    noLoop();
  }

  //KÜCHEN
  noFill();
  stroke(0);
  strokeWeight(2);
  ellipseMode(CENTER);
  ellipse(kuchenCenterX, kuchenCenterY, kuchenWidth, kuchenHeight);

if(kuchenExsists == true){
  for(int i=0; i<kuchenSet.length; i++){
    kuchenSet[i].windKuchen();
  }
}


}

void keyPressed () {

  //PAUSE
  if(key == 'a') {

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(pause, swClients[i]); 
      }
    }
    pauseTimeCalibration = millis();
    noLoop();
  }
  //UNPAUSE
  if(key == 's') {

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(unpause, swClients[i]); 
      }
    }
    calibrateMasterTime = calibrateMasterTime + millis() - pauseTimeCalibration;
    loop();
  }


  //SPACE BAR TO START/RESTART PIECE
  if (key == 32) {
    calibrateMasterTime = millis();

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark0, swClients[i]); 
      }
    }
    loop();
  }

  //PUNCH IN 1-10
  if (key == '1') {
    calibrateMasterTime = millis();

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark0, swClients[i]); 
      }
    }

  }


  if (key == '2') {
    calibrateMasterTime = millis() - markers[0]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark1, swClients[i]); 
      }
    }

  }


  if (key == '3') {
    calibrateMasterTime = millis() - markers[1];

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark2, swClients[i]); 
      }
    }

  }


  if (key == '4') {
    calibrateMasterTime = millis() - markers[2];

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark3, swClients[i]); 
      }
    }

  }


  if (key == '5') {
    calibrateMasterTime = millis() - markers[3];

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark4, swClients[i]); 
      }
    }

  }


  if (key == '6') {
    calibrateMasterTime = millis() - markers[4];

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark5, swClients[i]); 
      }
    }

  }


  if (key == '7') {
    calibrateMasterTime = millis() - markers[5]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark6, swClients[i]); 
      }
    }

  }


  if (key == '8') {
    calibrateMasterTime = millis() - markers[6]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark7, swClients[i]); 
      }
    }

  }


  if (key == '9') {
    calibrateMasterTime = millis() - markers[7];  

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark8, swClients[i]); 
      }
    }

  }


  if (key == '0') {
    calibrateMasterTime = millis() - markers[8];  

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark9, swClients[i]); 
      }
    }

  }


  if (key == 'q') {
    calibrateMasterTime = millis() - markers[9]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark10, swClients[i]); 
      }
    }

  }


  if (key == 'w') {
    calibrateMasterTime = millis() - markers[10]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark11, swClients[i]); 
      }
    }

  }


  if (key == 'e') {
    calibrateMasterTime = millis() - markers[11];  

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark12, swClients[i]); 
      }
    }

  }


  if (key == 'r') {
    calibrateMasterTime = millis() - markers[12];  

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark13, swClients[i]); 
      }
    }

  }


  if (key == 't') {
    calibrateMasterTime = millis() - markers[13]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark14, swClients[i]); 
      }
    }

  }


  if (key == 'y') {
    calibrateMasterTime = millis() - markers[14];

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark15, swClients[i]); 
      }
    }

  }


  if (key == 'u') {
    calibrateMasterTime = millis() - markers[15]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark16, swClients[i]); 
      }
    }

  }
  if (key == 'i') {
    calibrateMasterTime = millis() - markers[16];  

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark17, swClients[i]); 
      }
    }

  }
  if (key == 'o') {
    calibrateMasterTime = millis() - markers[17]; 

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark18, swClients[i]); 
      }
    }

  }
  if (key == 'p') {
    calibrateMasterTime = millis() - markers[18];  

    for(int i=0; i<swClients.length; i++){
      if(swClients[i] != null){
        meOSC.send(swMark19, swClients[i]); 
      }
    }

  }

}

void oscEvent(OscMessage theOscMessage) {

 // if( theOscMessage.addrpattern().equals( "/pause" ) ){
    if( theOscMessage.checkAddrPattern("/pause")==true ){
    
    pauseTimeCalibration = millis();
    noLoop();
  }

 // if( theOscMessage.addrpattern().equals( "/unpause" ) ){
    if( theOscMessage.checkAddrPattern("/unpause")==true ){
    calibrateMasterTime = calibrateMasterTime + millis() - pauseTimeCalibration;
    loop();
  }
/*
  if( theOscMessage.addrpattern().equals( "/swMark0" ) ){
    calibrateMasterTime = millis() - networkLatency; 
    loop(); 
  }
  if( theOscMessage.addrpattern().equals( "/swMark1" ) ){
    calibrateMasterTime = millis() - markers[0] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark2" ) ){
    calibrateMasterTime = millis() - markers[1] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark3" ) ){
    calibrateMasterTime = millis() - markers[2] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark4" ) ){
    calibrateMasterTime = millis() - markers[3] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark5" ) ){
    calibrateMasterTime = millis() - markers[4] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark6" ) ){
    calibrateMasterTime = millis() - markers[5] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark7" ) ){
    calibrateMasterTime = millis() - markers[6] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark8" ) ){
    calibrateMasterTime = millis() - markers[7] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark9" ) ){
    calibrateMasterTime = millis() - markers[8] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark10" ) ){
    calibrateMasterTime = millis() - markers[9] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark11" ) ){
    calibrateMasterTime = millis() - markers[10] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark12" ) ){
    calibrateMasterTime = millis() - markers[11] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark13" ) ){
    calibrateMasterTime = millis() - markers[12] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark14" ) ){
    calibrateMasterTime = millis() - markers[13] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark15" ) ){
    calibrateMasterTime = millis() - markers[14] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark16" ) ){
    calibrateMasterTime = millis() - markers[15] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark17" ) ){
    calibrateMasterTime = millis() - markers[16] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark18" ) ){
    calibrateMasterTime = millis() - markers[17] - networkLatency;  
  }
  if( theOscMessage.addrpattern().equals( "/swMark19" ) ){
    calibrateMasterTime = millis() - markers[18] - networkLatency;  
  }
*/
}