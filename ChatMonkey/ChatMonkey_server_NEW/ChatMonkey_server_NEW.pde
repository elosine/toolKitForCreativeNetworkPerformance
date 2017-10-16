import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress oscdest;
NetAddress broadcastServerAddr;

NetAddressList broadcastList;
int oscBroadcastPort = 55552;

String connectAddr = "/broadcaster/connect";
String disconnectAddr = "/broadcaster/disconnect";

String oscheaderloc = "/gui";

int editct = 1;

void setup() {
  size(300, 300);
  osc = new OscP5(this, 55551);
  broadcastList = new NetAddressList();
  osc.plug(setOTextBox, "write", "/gui/tbwrite");

  broadcastServerAddr = new NetAddress("127.0.0.1", 55551);

  setOTextBox.mkgui(0, 15, 15, 269, 69, "", 1, 2, "/tbwrite");
  setOTextBox.mkgui(1, 16, 111, 267, 166, "", 0, 2, "/textbox");
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

void oscEvent(OscMessage theOscMessage) {

  print("### received an osc message.");
  println(" addrpattern: "+theOscMessage.addrPattern());
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(connectAddr)) {
    connect(theOscMessage.netAddress());
  } //
  else if (theOscMessage.addrPattern().equals(disconnectAddr)) {
    disconnect(theOscMessage.netAddress().address());
  }
 
}

private void connect(NetAddress newAdr) {
  if (!broadcastList.contains(newAdr.address(), oscBroadcastPort)) {
    broadcastList.add(new NetAddress(newAdr.address(), oscBroadcastPort));
    println("### adding "+newAdr.address()+" to the list.");
    println("numplayers:  " + (broadcastList.size()));
  } //
  else {
    println("### "+newAdr.address()+" is already connected.");
  }
  println("### currently there are "+broadcastList.list().size()+" remote locations connected.");
}

private void disconnect(String theIPaddress) {
  if (broadcastList.contains(theIPaddress, oscBroadcastPort)) {
    broadcastList.remove(theIPaddress, oscBroadcastPort);

    println("### removing "+theIPaddress+" from the list.");
  } //
  else {
    println("### "+theIPaddress+" is not connected.");
  }
  println("### currently there are "+broadcastList.list().size());
}