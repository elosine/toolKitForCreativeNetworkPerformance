import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress oscdest;
NetAddress broadcastServerAddr;

String connectAddr = "/broadcaster/connect";
String disconnectAddr = "/broadcaster/disconnect";

String oscheaderloc = "/gui";

int editct = 1;

void setup() {
  size(300, 300);
  osc = new OscP5(this, 55552);
  osc.plug(setOTextBox, "write", "/gui/tbwrite");

  setOTextBox.mkgui(0, 15, 15, 269, 69, "", 1, 2, "/tbwrite");
  setOTextBox.mkgui(1, 16, 111, 267, 166, "", 0, 2, "/textbox");

  broadcastServerAddr = new NetAddress("127.0.0.1", 55551);
}

void draw() {
  background(0);

  setOTextBox.drwset();
}

void keyPressed() {
  //connect to broadcaster with c
  OscMessage msg;
  if (key == 'c' ) {
    msg = new OscMessage("/broadcaster/connect", new Object[0]);
       // osc.send("/broadcaster/connect", new Object[0] , broadcastServerAddr);

    osc.flush(msg, broadcastServerAddr);
  }
}

void mousePressed() {
  setOTextBox.msclk();
}

void mouseDragged() {
  setOTextBox.msdrg();
}

void mouseReleased() {
}

void keyReleased() { 
  setOTextBox.keyrel();
}