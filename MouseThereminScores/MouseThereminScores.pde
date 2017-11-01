import oscP5.*;
import netP5.*;

OscP5 meosc;

NetAddress sclang; 


float tbmargins = 0;
int menubar = 45;
float highestmidinote = 80;
float lowestmidinote = 30;
float t, b, numnotes, pxpersemitone;
int[] blackeys = {
  30, 32, 34, 37, 39, 42, 44, 46, 49, 51, 54, 56, 58, 61, 63, 66, 68, 70, 
  73, 75, 78, 80
};
int[] cmaj = {
  36, 38, 40, 41, 43, 45, 47, 
  48, 50, 52, 53, 55, 57, 59, 
  60, 62, 64, 65, 67, 69, 71, 
  72, 74, 76, 77, 79
};
int[] amelodicminor = {
  33, 35, 36, 38, 40, 42, 44, 
  45, 47, 48, 50, 52, 54, 56, 
  57, 59, 60, 62, 64, 66, 68, 
  69, 71, 72, 74, 76, 78, 80
};
int[] ddorian = {
  38, 40, 41, 43, 45, 47, 48, 
  50, 52, 53, 55, 57, 59, 60, 
  62, 64, 65, 67, 69, 71, 72, 
  74, 76, 77, 79
};
int[] octatonic = {
  36, 38, 39, 41, 42, 44, 45, 47, 
  48, 50, 51, 53, 54, 56, 57, 59, 
  60, 62, 63, 65, 66, 68, 69, 71, 
  72, 74, 75, 77, 78, 80
};
int[] gangster = {
  36, 41, 43, 44, 67, 71, 72, 74, 75, 77
};
int[] turndown = {
  76, 72, 71, 62, 64, 65, 40
};

int[] currentscale;

void setup() {
 // size(displayWidth-400, displayHeight);
 size(1920,1050);

  meosc = new OscP5(this, 44443);
  sclang = new NetAddress("127.0.0.1", 57120);

  currentscale = ddorian;
  numnotes = highestmidinote - lowestmidinote;
  println(numnotes);
  pxpersemitone = ( height-(tbmargins*2.0) )/numnotes ;
  println(pxpersemitone);
  //Draw once
  strokeWeight( constrain(pxpersemitone/3.0, 1, 5) );
  // stroke(0, 255, 0);
}

void draw() {
      frame.setLocation(400, 0);

  background(0);
  stroke(0, 255, 0);

  for (int i=0; i<numnotes; i++) {
    for (int j=0; j<currentscale.length; j++) {
      if (i == currentscale[j]-lowestmidinote)
        line( 0, height-(i*pxpersemitone) , width, height-(i*pxpersemitone) );
    }
  }
}

void keyPressed() {
  if (key=='d') currentscale = ddorian;
  if (key=='c') currentscale = cmaj;
  if (key=='a') currentscale = amelodicminor;
  if (key=='o') currentscale = octatonic;
  if (key=='b') currentscale = blackeys;
  if (key=='g') currentscale = gangster;
  if (key=='t') currentscale = turndown;
 if (key=='s'){
    OscMessage msg1 = new OscMessage("/mtstart");
    meosc.send(msg1, sclang); 
 }
 if (key=='q'){
    OscMessage msg1 = new OscMessage("/mtstop");
    meosc.send(msg1, sclang); 
 }
 if (key=='1'){
    OscMessage msg3 = new OscMessage("/samp1");
    meosc.send(msg3, sclang); 
 }
 if (key=='2'){
    OscMessage msg4 = new OscMessage("/samp2");
    meosc.send(msg4, sclang); 
 }
 if (key=='3'){
    OscMessage msg5 = new OscMessage("/samp3");
    meosc.send(msg5, sclang); 
 }
 if (key=='l'){
    OscMessage msg6 = new OscMessage("/loadmtsamps");
    meosc.send(msg6, sclang); 
 }
}

 /// to make a frame not displayable, you can 
//public void init() {
// frame.removeNotify(); 
// frame.setUndecorated(true);  
// frame.addNotify(); 
// super.init();
//}