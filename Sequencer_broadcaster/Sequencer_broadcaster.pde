//network sender with broadcaster from server
//messaging system

//way to deal with colors

import oscP5.*;
import netP5.*;

OscP5 meosc;
NetAddressList broadcastList = new NetAddressList();
NetAddressList broadcastListSC = new NetAddressList();
int oscRecvPort = 32000;
int oscBroadcastPort = 12000;
int scport = 57120;
String connectAddr = "/server/connect";
String disconnectAddr = "/server/disconnect";

boolean samp1snd = true;
boolean makebeats = true;

int beatmargin = 4;
float beatlen;
float barline;
int numtracks = 8;
float trackht;
int numplayers;
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

int sampnum = 0;


void setup() {
  //size(1000, 600);
  size(1920, 1080);
  meosc = new OscP5(this, oscRecvPort);
  meosc.plug(this, "newbeat", "/newbeat");
  meosc.plug(this, "clrbeat", "/clrbeat");

  players = new int[broadcastList.size()];
  playerstemp = new int[broadcastList.size()];
  for (int i=0; i<players.length; i++) players[i] = i;
  playerstemp = players;

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
  background(0);

  for (int i=0; i<times.length; i++) {
    if (csrdirs[i]==1) times[i] = ( millis()+(seqdurs[i]*phases[i]) )%seqdurs[i];
    else times[i] = seqdurs[i]-(( millis()+(seqdurs[i]*phases[i]) )%seqdurs[i]);
  }
  for (int i=0; i<phases.length; i++) currphases[i] = norm(times[i], 0.0, seqdurs[i]);
  for (int i=0; i<csrXs.length; i++) csrXs[i]=map(times[i], 0.0, seqdurs[i], margins, width-margins);

  //Sequencer Area
  noFill();
  stroke(252, 84, 0);
  strokeWeight(1);
  rect(margins, margins, width - (margins*2), height - (margins*2));

  //cursor
  strokeWeight(3);
  for (int i=0; i<numtracks; i++) {
    stroke(clr.getByIx(i));
    line(csrXs[i], margins+(trackht*i), csrXs[i], margins+(trackht*i)+trackht);
  }

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
        //fill( clr.getByIx( tracks[j][i]%broadcastList.size() ) ); 
        fill( clr.getByIx( j%10) ); 
        ellipse(sixteenths[i], margins+(trackht*j)+(trackht/2), 15, 15);
      }
    }
  }

  //Detection of when cursor hits beatmarker
  for (int j = 0; j<numtracks; j++) {
    for (int i = 0; i<sixteenths.length; i++) {
      if (csrXs[j] > sixteenths[i]-beatmargin && csrXs[j] < sixteenths[i]+beatmargin && tracks[j][i] > -1) {

        if (samp1snd) {
          samp1snd = false;

          // println(tracks[j][i]);
          sampnum = (sampnum +1)%3;
          //  println(sampnum);
          String adrtmp = "/samp1";
          switch(sampnum) {
          case 0:
            adrtmp = "/samp1";
            break;
          case 1:
            adrtmp = "/samp2";
            break;
          case 2:
            adrtmp = "/samp3";
            break;
          }
          // println(adrtmp);
          //  println("false");

          OscMessage msg1 = new OscMessage(adrtmp);
          meosc.send(msg1, broadcastListSC.get(tracks[j][i]) );
          // println("Player Num: " + tracks[j][i]);
        }
      } //
      else if ( csrXs[j] > sixteenths[i]+beatmargin && csrXs[j] < sixteenths[i]+sixteenthlen-beatmargin && tracks[j][i] > -1) {
        if (!samp1snd) {
          samp1snd = true;
          // println("true");
        }
      }

      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////

      // sync();
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
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
              if (playerstemp.length==0) playerstemp = players;
              int newpltmp = floor(random(playerstemp.length));
              tracks[j][i] = playerstemp[newpltmp];
              for (int k=newpltmp; k<playerstemp.length-1; k++) {
                playerstemp[k] = playerstemp[k+1];
              }
              playerstemp = shorten(playerstemp);
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
                tracks[j][i] = -1;
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
  if (key=='c') {
    for (int j=0; j<numtracks; j++) {
      for (int i=0; i<sixteenths.length; i++) {
        tracks[j][i] = -1;
      }
    }
  }
  if (key=='r') {
    newtempo(0, 300.0 );
    //  t = (t+1)%numtracks;
  }
  if (key=='t') {
    newtempo(1, 300.0 );
    //  t = (t+1)%numtracks;
  }
  if (key=='w') {
    newtempo(0, random(30, 300) );
    //  t = (t+1)%numtracks;
  }
  if (key=='e') {
    newtempo(1, random(30, 300) );
    //  t = (t+1)%numtracks;
  }
  if (key=='1') {
    csrdir(0, d);
    t = (t+1)%numtracks;
    d = (csrdirs[0]+1)%2;
  }
  if (key=='3') {
    //  syncdr(0, 1, 7.0);
  }
}
int t = 0;
int d = 0;

void csrdir(int tn, int dir) {
  float phtemp1 = currphases[tn];
  csrdirs[tn] = dir;
  if (dir ==0) phases[tn] =  phases[tn]+1-phtemp1-phtemp1;
  else phases[tn] = phases[tn]-1+phtemp1+phtemp1;
}

void newtempo(int tracknum, float bpm) {
  float phtemp1 = currphases[tracknum];
  bpms[tracknum] = bpm;
  seqdurs[tracknum] = round( 16000.0*(60.0/bpms[tracknum]) );
  pxperms[tracknum] = (width - (margins*2) )/seqdurs[tracknum];
  times[tracknum] = ( millis()+(seqdurs[tracknum]*phases[tracknum]) )%seqdurs[tracknum];
  currphases[tracknum] = norm(times[tracknum], 0.0, seqdurs[tracknum]);
  float phtemp2 = currphases[tracknum];
  if (csrdirs[tracknum] == 1) phases[tracknum] = (phases[tracknum] + phtemp1-phtemp2)%1;
  else phases[tracknum] = (phases[tracknum] - phtemp2 + 1 - phtemp1)%1;
  if (phases[tracknum] < 0.0) phases[tracknum] = 1.0 + phases[tracknum]; //adjustment to keep phase positive
}
/*
void syncdr(int ac1, int ac2, float adur) {
 dur = adur;
 starttime = millis();
 c1 = ac1;
 c2 = ac2;
 inittempo = bpms[c1];
 if (bpms[c2]>bpms[c1]) {
 slowdown = true;
 if (csrXs[c2]<csrXs[c1]) initdist = width-(margins*2)-(csrXs[c1]-csrXs[c2]);
 else initdist = csrXs[c2]-csrXs[c1];
 } //
 else {
 slowdown = false;
 if (csrXs[c2]>csrXs[c1]) initdist = width-(margins*2)-(csrXs[c2]-csrXs[c1]);
 else initdist = csrXs[c1]-csrXs[c2];
 }
 
 if bpmc2>bpmc1 
 slowdown only
 if csrXs[c2]<csrXs[c1] initdist =width-(margins*2)-(csrXs[c1]-csrXs[c2])
 else initdist = csrXs[c2]-csrXs[c1]
 
 else
 speed up only
 if csrXs[c2]>csrXs[c1] initdist =width-(margins*2)-(csrXs[c2]-csrXs[c1])
 else initdist = csrXs[c1]-csrXs[c2]
 
 
 }
 
 float starttime = 0.0;
 float dur = 0.0;
 int c1, c2;
 float initdist = 0.0;
 boolean slowdown = false;
 float inittempo = 0.0;
 float ppxdif;
 
 
 
 
 void sync() {
 float numpxc1, tempotomatch, pxdif, durremain, ratioadj, tempoadj;
 if (millis()>= starttime && millis()< starttime+(dur*1000.0)) {
 durremain = ( (dur*1000.0)+starttime)  - millis();
 numpxc1 = ((bpms[c1]/60.0)*beatlen)*(durremain/1000.0);
 pxdif = csrXs[2] - csrXs[1];
 pixdif = constrain(pixdif, 0.0, initdist);
 //  ratioadj = norm(durremain, 0.0, dur*1000);   
 //ratioadj = pow(ratioadj, 1.0/50.0);
 tempotomatch = (   (  ( (numpxc1+pxdif)/(durremain/1000.0) )/beatlen  )*60.0    );
 
 if (slowdown) {
 tempotomatch = constrain(tempotomatch, 0.0, inittempo);
 } else tempotomatch = constrain(tempotomatch, inittempo, bpms[c1]*4);
 //  tempoadj = tempotomatch-bpms[c2];
 if (frameCount%1 == 0)newtempo(c2, constrain(bpms[c2]+(tempoadj*ratioadj), bpms[c1]/3, bpms[c1]*3));
 if (frameCount%10 == 0)  //println(ratioadj);
 
 tempotomatch = ptempotomatch;
 } //
 else if (millis()> starttime+(dur*1000.0) && millis()<starttime+(dur*1000.0)+40) {
 newtempo(1, bpms[0]);
 phases[1] = phases[0];
 }
 }
 */

void newbeat(int tr, int beat) {

  if (tracks[tr][beat] < 0) {
    if (playerstemp.length==0) {
      playerstemp = new int[broadcastList.size()];
      for (int i=0; i<players.length; i++)  playerstemp[i] = players[i];
      for (int i=0; i<players.length; i++) println("players: " + players[i] + "  playerstemp: " + playerstemp[i]);
    }
    int newpltmp = floor(random(playerstemp.length));
    tracks[tr][beat] = playerstemp[newpltmp];
    println(playerstemp[newpltmp]);

    OscMessage bct = new OscMessage("/newbt");
    bct.add(tr);
    bct.add(beat);
    meosc.send(bct, broadcastList);

    //
    for (int k=newpltmp; k<playerstemp.length-1; k++) playerstemp[k] = playerstemp[k+1];
    playerstemp = shorten(playerstemp);
    println(playerstemp);
  }
}

void clrbeat(int tr, int beat) {
  if (tracks[tr][beat] > -1) {
    tracks[tr][beat] = -1;
    OscMessage bct2 = new OscMessage("/clrbt");
    bct2.add(tr);
    bct2.add(beat);
    meosc.send(bct2, broadcastList);
  }
}

//LOOK AT SPEEDING UP CURSOR

void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(connectAddr)) {
    connect(theOscMessage.netAddress().address());
  } else if (theOscMessage.addrPattern().equals(disconnectAddr)) {
    disconnect(theOscMessage.netAddress().address());
  }
  /*
  else {
   meosc.send(theOscMessage, broadcastList);
   }
   */
}

private void connect(String theIPaddress) {
  if (!broadcastList.contains(theIPaddress, oscBroadcastPort)) {
    broadcastList.add(new NetAddress(theIPaddress, oscBroadcastPort));
    broadcastListSC.add(new NetAddress(theIPaddress, scport));
    println("### adding "+theIPaddress+" to the list.");
    players = append(players, broadcastList.size()-1);
    playerstemp = append(playerstemp, broadcastList.size()-1);
    println("numplayers:  " + (broadcastList.size()));
    for (int i=0; i<playerstemp.length; i++) println("players: " + playerstemp[i]);
  } //
  else {
    println("### "+theIPaddress+" is already connected.");
  }
  println("### currently there are "+broadcastList.list().size()+" remote locations connected.");
}

private void disconnect(String theIPaddress) {
  if (broadcastList.contains(theIPaddress, oscBroadcastPort)) {
    broadcastList.remove(theIPaddress, oscBroadcastPort);
    broadcastListSC.remove(theIPaddress, scport);
    players = shorten(players);
    println("### removing "+theIPaddress+" from the list.");
  } else {
    println("### "+theIPaddress+" is not connected.");
  }
  println("### currently there are "+broadcastList.list().size());
}

//ADD CHANGE TEMPO, SYNC, REVERSE, CHANGE UNISON TEMPO