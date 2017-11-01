//network sender with broadcaster from server
//messaging system

import oscP5.*;
import netP5.*;

OscP5 meosc;

NetAddress broadcastServerAddr, sclang; 


color red = color(255, 0, 0);
color black = color(0);
color bg = color(0);

boolean samp1snd = true;
boolean makebeats = true;

int beatmargin = 4;
float beatlen;
float barline;
int numtracks = 8;
float trackht;
int numplayers = 14;
int sampsperplr = 3;

float[] csrXs;
float sixteenthlen = 12.5;
float margins = 30;

float[] wholebeatsX, eighths, sixteenths;

int[] players = new int [numplayers*sampsperplr];

float[] times, bpms, phases, currphases, pxperms;
int[] csrdirs;

float[] seqdurs;

int[][] tracks;

float msfudge = 4;

int[] playerstemp;
String[] ip;
String myaddr;

void setup() {
  size(1000, 600);
  ip =  loadStrings("ip.txt");
  myaddr = ip[0];
  meosc = new OscP5(this, 12000);
  broadcastServerAddr = new NetAddress(myaddr, 32000);
  sclang = new NetAddress("127.0.0.1", 57120);

  meosc.plug(this, "newbt", "/newbt");
  meosc.plug(this, "clrbt", "/clrbt");

  beatlen = sixteenthlen*4.0;
  times = new float[numtracks];
  for (int i=0; i<times.length; i++) times[i] = 0.0;
  bpms = new float[numtracks];
  for (int i=0; i<bpms.length; i++) bpms[i] = 120.0;
  phases = new float[numtracks];
  for (int i=0; i<phases.length; i++) phases[i] = 0.0;
  currphases = new float[numtracks];
  for (int i=0; i<currphases.length; i++) currphases[i] = 0.0;
  seqdurs = new float[numtracks];
  pxperms = new float[numtracks];
  for (int i=0; i<seqdurs.length; i++) {
    seqdurs[i] = round( 16000.0*(60.0/bpms[i]) );
    pxperms[i] = (width - (margins*2) )/seqdurs[i];
  }
  csrdirs = new int[numtracks];
  for (int i=0; i<csrdirs.length; i++) csrdirs[i] = 1;
  csrXs = new float[numtracks];
  for (int i=0; i<csrXs.length; i++) csrXs[i] = margins;

  sixteenthlen = ( width-(margins*2.0) )/64.0;
  barline = sixteenthlen*16.0;
  trackht = ( height-(margins*2) )/numtracks;

  for (int i=0; i<players.length; i++) {
    players[i] = i;
  }

  playerstemp = players;

  wholebeatsX = new float[16];
  for (int i=0; i<wholebeatsX.length; i++) {
    wholebeatsX[i] = (i * (sixteenthlen*4) ) + margins;
  }
  eighths = new float[32];
  for (int i=0; i<eighths.length; i++) {
    eighths[i] = (i * (sixteenthlen*2) ) + margins;
  }
  sixteenths = new float[64];
  for (int i=0; i<sixteenths.length; i++) {
    sixteenths[i] = (i * sixteenthlen) + margins;
  }

  tracks = new int[numtracks][sixteenths.length];
  for (int i=0; i<tracks.length; i++) {
    for (int j=0; j<sixteenths.length; j++) {
      tracks[i][j] = -1;
    }
  }
}

void draw() {
  background(bg);

  //Sequencer Area
  noFill();
  stroke(252, 84, 0);
  strokeWeight(1);
  rect(margins, margins, width - (margins*2), height - (margins*2));

  //barlines
  stroke(0, 255, 0);
  strokeWeight(1);
  line(barline+margins, margins, barline+margins, height-margins);
  line((barline*2)+margins, margins, (barline*2)+margins, height-margins);
  line((barline*3)+margins, margins, (barline*3)+margins, height-margins);

  //wholebeat markers
  stroke(50, 75, 100);
  strokeWeight(1);
  for (int j=0; j<numtracks; j++) {
    for (int i=0; i<wholebeatsX.length; i++) {
      float y1temp = (trackht*j)+margins+(trackht*0.125);
      float y2temp = trackht + (trackht*j) + margins - (trackht*0.125);
      line(wholebeatsX[i], y1temp, wholebeatsX[i], y2temp);
    }
  }

  //eighth markers
  stroke(128, 128, 0);
  strokeWeight(1);
  for (int j=0; j<numtracks; j++) {
    for (int i=0; i<eighths.length; i++) {
      float y1temp = (trackht*j)+margins+(trackht*0.25);
      float y2temp = trackht + (trackht*j) + margins - (trackht*0.25);
      line(eighths[i], y1temp, eighths[i], y2temp);
    }
  }

  //sixteenths markers
  stroke(0, 255, 255);
  strokeWeight(1);
  for (int j=0; j<numtracks; j++) {
    for (int i=0; i<sixteenths.length; i++) {
      float y1temp = (trackht*j)+margins+(trackht*0.375);
      float y2temp = trackht + (trackht*j) + margins - (trackht*0.375);
      line(sixteenths[i], y1temp, sixteenths[i], y2temp);
    }
  }

  //sample marker
  noStroke();
  ellipseMode(CENTER);
  for (int j=0; j<numtracks; j++) {
    for (int i=0; i<sixteenths.length; i++) {
      if (tracks[j][i] > -1) { 
        fill(clr.getByIx(tracks[j][i]%numplayers)); 
        ellipse(sixteenths[i], margins+(trackht*j)+(trackht/2), 15, 15);
      }
    }
  }
}

void mousePressed() {
  //Make Beats w/Mouse Click
  for (int j=0; j<numtracks; j++) {
    for (int i=0; i<sixteenths.length; i++) {
      if (mouseY>margins+(trackht*j) && mouseY < margins + trackht + (trackht*j) ) {
        if (mouseX < sixteenths[i]+msfudge && mouseX>sixteenths[i]-msfudge) {

          if (makebeats) {
            makebeats = false;
            if (tracks[j][i] < 0) {
              OscMessage newbeatmsg = new OscMessage("/newbeat");
              newbeatmsg.add(j);
              newbeatmsg.add(i);
              meosc.send(newbeatmsg, broadcastServerAddr);
            }
          }
        }
      }
    }
  }

  //to delete single beats
  if (keyPressed) {
    if (key == 'q') {
      makebeats = false;
      for (int i = 0; i<sixteenths.length; i++) {
        if (mouseX < sixteenths[i]+msfudge && mouseX>sixteenths[i]-msfudge) {
          for (int j=0; j<numtracks; j++) {
            if (mouseY>margins+(trackht*j) && mouseY<margins+trackht+(trackht*j)) {
              if (tracks[j][i] > -1) {
                OscMessage clrbeatmsg = new OscMessage("/clrbeat");
                clrbeatmsg.add(j);
                clrbeatmsg.add(i);
                meosc.send(clrbeatmsg, broadcastServerAddr);                
                break;
              }
            }
          }
        }
      }
    }
  }
}

void mouseReleased() {
  makebeats = true;
}

void keyPressed() {
  OscMessage msg;
  switch(key) {
    case('c'):
    /* connect to the broadcaster */
    msg = new OscMessage("/server/connect", new Object[0]);
    meosc.flush(msg, broadcastServerAddr);  
    break;
    case('d'):
    /* disconnect from the broadcaster */
    msg = new OscMessage("/server/disconnect", new Object[0]);
    meosc.flush(msg, broadcastServerAddr);  
    break;
    case('1'):
    OscMessage chg1 = new OscMessage("/chgsamp1");
    meosc.send(chg1, sclang);  
    break;
    case('2'):
    OscMessage chg2 = new OscMessage("/chgsamp2");
    meosc.send(chg2, sclang);  
    break;
    case('3'):
    OscMessage chg3 = new OscMessage("/chgsamp3");
    meosc.send(chg3, sclang);  
    break;
  }
}

void newbt(int tr, int beat) {
  if (tracks[tr][beat] < 0) {
    if (playerstemp.length==0) playerstemp = players;
    int newpltmp = floor(random(playerstemp.length));
    tracks[tr][beat] = playerstemp[newpltmp];
    for (int k=newpltmp; k<playerstemp.length-1; k++) {
      playerstemp[k] = playerstemp[k+1];
    }
    playerstemp = shorten(playerstemp);
  }
}

void clrbt(int tr, int beat) {
  tracks[tr][beat] = -1;
}

void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
}