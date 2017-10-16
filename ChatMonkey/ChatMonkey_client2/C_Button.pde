SetOButton buttonset = new SetOButton();
int buttonix = 0;

class Button {

  int imagew = 569;
  int imageh = 571;
  int ix;
  float x, y;

  PImage buttonpic1, buttonpic2;

  float dscale = 0.1;
  float w, h, l, r, t, b;
  int val = 0;

  int edittog;
  String oscaddr = "/button";
  boolean pressed = false;
  int tog = -1;

  Button(int aix, float ax, float ay) {
    ix = aix;
    x = ax;
    y = ay;

    buttonpic1 = loadImage("button_norm.png");
    buttonpic2 = loadImage("button_pressed.png");
    w = imagew*dscale;
    h = imageh*dscale;
    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;
  }

  Button(int aix, float ax, float ay, int atog) {
    ix = aix;
    x = ax;
    y = ay;
    tog = atog;

    buttonpic1 = loadImage("button_norm.png");
    buttonpic2 = loadImage("button_pressed.png");
    w = imagew*dscale;
    h = imageh*dscale;
    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;
  }

  Button(int aix, float ax, float ay, float adscale, int atog, String aoscaddr) {
    ix = aix;
    x = ax;
    y = ay;
    dscale = adscale;
    tog = atog;
    oscaddr = aoscaddr;

    buttonpic1 = loadImage("button_norm.png");
    buttonpic2 = loadImage("button_pressed.png");
    w = imagew*dscale;
    h = imageh*dscale;
    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;
  }

  void drw() {

    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    scale(dscale);
    if (tog<0) {
      if (!pressed) image(buttonpic1, 0, 0); 
      else image(buttonpic2, 0, 0);
    } else {
      if (tog%2==0) image(buttonpic1, 0, 0); 
      else if (tog%2==1) image(buttonpic2, 0, 0);
    }
    popMatrix();

    //Bounding Box
    if ((edittog%2)==1) {
      noFill();
      rectMode(CORNER);
      strokeWeight(3);
      stroke(clr.get("orange"));
      rect(l, t, w, h);
      fill(clr.get("orange"));
      rect(r, b, 30, 30);
    } 
    //
  }

  void msdrg() {
    if ((edittog%2)==1 && mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) {
      x = x + (mouseX-pmouseX);
      y = y + (mouseY-pmouseY);
      l = x-(w/2.0);
      r = x+(w/2.0);
      t = y-(h/2.0);
      b = y+(h/2.0);
    } //
    if ((edittog%2)==1 && mouseX > r && mouseX <= r+30 && mouseY > b && mouseY <= b+30) {

      dscale = dscale + ((mouseY-pmouseY)/300.0 ) + ( (mouseX-pmouseX)/300.0 );
      w = imagew*dscale;
      h = imageh*dscale;
      l = x-(w/2.0);
      r = x+(w/2.0);
      t = y-(h/2.0);
      b = y+(h/2.0);
    } //
  }

  void msprs() {
    if ((edittog%2)==0 && mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) {
      if (tog<0) {
        pressed = true;
        val = 1;
        osc.send(oscheaderloc + oscaddr + str(ix), new Object[] {
          val
        }
        , oscdest);
      } //
      else {
        tog++;
        val = tog%2;
        osc.send(oscheaderloc + oscaddr+ str(ix), new Object[] {
          val
        }
        , oscdest);
      }
      //
    }
  }

  void msrel() {
    if ((edittog%2)==0 && mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) {
      if (tog<0) {
        pressed = false;
        val = 0;
        osc.send(oscheaderloc + oscaddr + str(ix), new Object[] {
          val
        }
        , oscdest);
      }
    }
  }

  //
  //
}  //End class

//// CLASS SET CLASS ////
class SetOButton {
  ArrayList<Button> cset = new ArrayList<Button>();

  // Make Instance Method //
  void mk(int ix, float x, float y) {
    cset.add( new Button(ix, x, y) );
  } //end mk method

  // Make Instance Method //
  void mkgui(int ix, float x, float y, float dscale, int tog, String oscaddr) {
    cset.add( new Button(ix, x, y, dscale, tog, oscaddr) );
  } //end mk method
  

  // Make Toggle Instance Method //
  void mktog(int ix, float x, float y) {
    cset.add( new Button(ix, x, y, 0) );
  } //end mktog method

  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Button inst = cset.get(i);
      inst.drw();
    }
  } //end dr method

  // Key Pressed Set Method //
  void keyprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Button inst = cset.get(i);
      inst.edittog = editct;
    }
  } //end keyprs method

  // Mouse Pressed Set Method //
  void msprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Button inst = cset.get(i);
      inst.msprs();
    }
  } //end msprs method

  // Mouse Dragged Set Method //
  void msdrg() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Button inst = cset.get(i);
      inst.msdrg();
    }
  } //end msdrg method

  // Mouse Released Set Method //
  void msrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Button inst = cset.get(i);
      inst.msrel();
    }
  } //end msrel method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Button inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  ////
} //end class set class