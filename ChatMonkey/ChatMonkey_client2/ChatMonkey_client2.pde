/*
Chatter and multi tempo controls
 Make a text file control to load multiple destinations
 Clear
 Disable controls from txt file
 Make tempo setter and chatter
 Trigger buton - args what kind of gui object, ix - like dial with text boxes - send osc and graphic feedback
 */



import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress oscdest;

int editct = 1;
File file, ipfile;
String path, savepath, ippath;
String[] savedguis = new String[0];
int textboxix = 0;
String oscheaderloc = "/gui";
int flashtimer = 0;

String destaddr = "127.0.0.1";
int destport = 55552;
Object[] emptyobj = new Object[] {
};

int guilock = 0;


void setup() {
  size(300, 300);
  //Set up file paths
  path = dataPath("savedguis/");
  savepath = sketchPath("data/savedguis/");
  ippath = sketchPath("ip.txt");
  file = new File(path);
  ipfile = new File(ippath);
  //Load destination ip and port from text file ip.txt
  if (ipfile.exists()) {
    String[] iptemp = loadStrings("ip.txt");
    String[] splittemp = split(iptemp[0], "\t");
    destaddr = splittemp[0];
    destport = int(splittemp[1]);
    //Load GUI Lock
    guilock = int(iptemp[1]);
    println(guilock);
  }
  osc = new OscP5(this, 55553);
  oscdest = new NetAddress(destaddr, destport);
  osc.plug(dialset, "setdval", "/setdval");
  osc.plug(dialset, "setdset", "/setdset");
  osc.plug(xyset, "setxyval", "/setxyval");
  osc.plug(xyset, "setxyset", "/setxyset");
  osc.plug(setOTextBox, "write", "/gui/tbwrite");
  getguis();


  setOTextBox.mkgui(0, 15, 15, 269, 69, "", 1, 2, "/tbwrite");
  setOTextBox.mkgui(1, 16, 111, 267, 166, "", 0, 2, "/textbox");
}

void draw() {
  if (flashtimer>millis()) {
    background(clr.get("dodgerblue"));
  } else background(0);
  setOTextBox.drwset();
  buttonset.drw();
  dialset.drw();
  xyset.drw();
}

void keyPressed() {
  //connect to broadcaster with alt+c
  if (key == 'c' ) {
    osc.send("/broadcaster/connect", emptyobj, oscdest);
    println("sending:  " + oscdest.address() + "  port  " + oscdest.port());
  }
  //connect to broadcaster with alt+c
  if (keyz.name(keyCode).equals("alt+C") && keyz.rpt ) {
    keyz.rpt = false;
    osc.send("/broadcaster/connect", emptyobj, oscdest);
  }

  if (guilock == 0) {
    //make dial with alt+d
    if (keyz.name(keyCode).equals("alt+D") && keyz.rpt ) {
      keyz.rpt = false;
      dialset.mk(dialix, 200, 200);
      dialix++;
    }
    //make xy with alt+x
    if (keyz.name(keyCode).equals("alt+X") && keyz.rpt ) {
      keyz.rpt = false;
      xyset.mk(dialix, 100, 300, 100, 100);
      xyix++;
    }
    //make integer dial with alt+i
    if (keyz.name(keyCode).equals("alt+I") && keyz.rpt ) {
      keyz.rpt = false;
      dialset.mkint(dialix, 200, 200);
      dialix++;
    }
    //make button with alt+b
    if (keyz.name(keyCode).equals("alt+B") && keyz.rpt ) {
      keyz.rpt = false;
      buttonset.mk(buttonix, 100, 100);
      buttonix++;
    }
    //make toggle button with alt+t
    if (keyz.name(keyCode).equals("alt+T") && keyz.rpt ) {
      keyz.rpt = false;
      buttonset.mktog(buttonix, 100, 100);
      buttonix++;
    }
    //make textbox with alt+w
    if (keyz.name(keyCode).equals("alt+W") && keyz.rpt ) {
      keyz.rpt = false;
      setOTextBox.mk(textboxix, 200, 100, 100, 50);
      textboxix++;
    }
    //make return clearing textbox with alt+q
    if (keyz.name(keyCode).equals("alt+Q") && keyz.rpt ) {
      keyz.rpt = false;
      setOTextBox.mkrc(textboxix, 200, 100, 100, 50);
      textboxix++;
    }
    //Edit GUI objects with alt+e
    if (keyz.name(keyCode).equals("alt+E") && keyz.rpt ) {
      keyz.rpt = false;
      dialset.keyprs();
      xyset.keyprs();
      buttonset.keyprs();
      setOTextBox.edit();
      editct++;
    }
    //Remove GUI objects with alt+r
    if (keyz.name(keyCode).equals("alt+R") && keyz.rpt ) {
      keyz.rpt = false;
      //REMOVE DIAL
      for (int i=0; i<dialset.cset.size (); i++) {
        Dial inst = dialset.cset.get(i);
        if (mouseX>inst.l && mouseX<inst.r && mouseY>inst.t && mouseY<inst.b) {
          setOTextBox.rmv(inst.tbix[0]);
          setOTextBox.rmv(inst.tbix[1]);
          setOTextBox.rmv(inst.tbix[2]);
          dialset.cset.remove(i);
        }
      } 
      //REMOVE XY
      for (int i=0; i<xyset.cset.size (); i++) {
        XY inst = xyset.cset.get(i);
        if (mouseX>inst.l && mouseX<inst.r && mouseY>inst.t && mouseY<inst.b) {
          setOTextBox.rmv(inst.tbix[0]);
          setOTextBox.rmv(inst.tbix[1]);
          setOTextBox.rmv(inst.tbix[2]);
          setOTextBox.rmv(inst.tbix[3]);
          setOTextBox.rmv(inst.tbix[4]);
          setOTextBox.rmv(inst.tbix[5]);
          xyset.cset.remove(i);
        }
      } 
      //REMOVE BUTTON
      for (int i=0; i<buttonset.cset.size (); i++) {
        Button inst = buttonset.cset.get(i);
        if (mouseX>inst.l && mouseX<inst.r && mouseY>inst.t && mouseY<inst.b) {
          buttonset.cset.remove(i);
        }
      }
      //REMOVE TEXT BOX
      for (int i=0; i<setOTextBox.cset.size (); i++) {
        TextBox inst = setOTextBox.cset.get(i);
        if (mouseX>inst.l && mouseX<inst.r && mouseY>inst.t && mouseY<inst.b) {
          setOTextBox.cset.remove(i);
        }
      }
    }
    //Save GUI with alt+s
    if (keyz.name(keyCode).equals("alt+S") && keyz.rpt ) {
      keyz.rpt = false;
      savegui();
      getguis();
    }

    //Load Saved Guis
    if (keyz.name(keyCode).equals("alt+1") && keyz.rpt ) {
      println(keyz.name(keyCode));
      keyz.rpt = false; 
      loadgui(0);
    }
    if (keyz.name(keyCode).equals("alt+2") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(1);
    }
    if (keyz.name(keyCode).equals("alt+3") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(2);
    }
    if (keyz.name(keyCode).equals("alt+4") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(3);
    }
    if (keyz.name(keyCode).equals("alt+5") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(4);
    }
    if (keyz.name(keyCode).equals("alt+6") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(5);
    }
    if (keyz.name(keyCode).equals("alt+7") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(6);
    }
    if (keyz.name(keyCode).equals("alt+8") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(7);
    }
    if (keyz.name(keyCode).equals("alt+9") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(8);
    }
    if (keyz.name(keyCode).equals("alt+0") && keyz.rpt ) {
      keyz.rpt = false; 
      loadgui(9);
    }
  }
}

void mousePressed() {
  setOTextBox.msclk();
  dialset.msprs();
  xyset.msprs();
  buttonset.msprs();
}

void mouseDragged() {
  setOTextBox.msdrg();
  dialset.msdrg();
  xyset.msdrg();
  buttonset.msdrg();
}

void mouseReleased() {
  dialset.msrel();
  xyset.msrel();
  buttonset.msrel();
}

void keyReleased() { 
  setOTextBox.keyrel();
  dialset.keyrel();
  xyset.keyrel();
  if (keyz.keyrel(keyCode).equals("alt+C") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+D") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+I") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+B") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+T") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+W") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+X") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+Q") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+E") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+R") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+1") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+2") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+3") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+4") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+5") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+6") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+7") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+8") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+9") && !keyz.rpt )keyz.rpt = true;
  if (keyz.keyrel(keyCode).equals("alt+0") && !keyz.rpt )keyz.rpt = true;
}