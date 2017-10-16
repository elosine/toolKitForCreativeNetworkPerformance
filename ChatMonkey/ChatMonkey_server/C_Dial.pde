SetODial dialset = new SetODial();
int dialix = 0;

class Dial {

  int ix;
  float x, y;

  PImage dialpic1;
  PFont monaco12;

  float drotate=0.0;
  float dscale = 0.33;
  float w, h, l, r, t, b;
  float val = 0.0;
  float vlo = 20.0;
  float vhi = 20000.0;
  float crv = 3.0;
  int edittog;
  String oscaddr = "/dial";
  boolean drag = false;
  int [] tbix = new int[3];
  int isint = 0;
  int istrig = 0;

  Dial(int aix, float ax, float ay) {
    ix = aix;
    x = ax;
    y = ay;

    dialpic1 = loadImage("dialtrans.gif");
    monaco12 = loadFont("Monaco-12.vlw");
    w = 300*dscale;
    h = 300*dscale;
    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;

    setOTextBox.mkne(textboxix, int(l-30), int(t-29), 50, 25, -1);
    tbix[0] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-29), 50, 25, -1);
    tbix[1] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-29), 50, 25, -1);
    tbix[2] = textboxix;
    textboxix++;

    oscaddr = oscaddr + str(ix);
  }

  Dial(int aix, float ax, float ay, int aisint) {
    ix = aix;
    x = ax;
    y = ay;
    isint = aisint;

    dialpic1 = loadImage("dialtrans.gif");
    monaco12 = loadFont("Monaco-12.vlw");
    w = 300*dscale;
    h = 300*dscale;
    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;

    setOTextBox.mkne(textboxix, int(l-30), int(t-29), 50, 25, -1);
    tbix[0] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-29), 50, 25, -1);
    tbix[1] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-29), 50, 25, -1);
    tbix[2] = textboxix;
    textboxix++;

    oscaddr = oscaddr + str(ix);
  }

  Dial(int aix, float ax, float ay, float adrotate, float adscale, float avlo, float avhi, float acrv, int aisint) {
    ix = aix;
    x = ax;
    y = ay;
    drotate = adrotate;
    dscale = adscale;
    vlo = avlo;
    vhi = avhi;
    crv = acrv;
    isint = aisint;

    dialpic1 = loadImage("dialtrans.gif");
    monaco12 = loadFont("Monaco-12.vlw");
    w = 300*dscale;
    h = 300*dscale;
    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;

    setOTextBox.mkne(textboxix, int(l-30), int(t-29), 50, 25, -1);
    tbix[0] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-29), 50, 25, -1);
    tbix[1] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-29), 50, 25, -1);
    tbix[2] = textboxix;
    textboxix++;

    oscaddr = oscaddr + str(ix);
  }


  Dial(int aix, float ax, float ay, float adrotate, 
  float adscale, float avlo, float avhi, float acrv, int aisint, String aoscaddr) {
    ix = aix;
    x = ax;
    y = ay;
    drotate = adrotate;
    dscale = adscale;
    vlo = avlo;
    vhi = avhi;
    crv = acrv;
    isint = aisint;

    dialpic1 = loadImage("dialtrans.gif");
    monaco12 = loadFont("Monaco-12.vlw");
    w = 300*dscale;
    h = 300*dscale;
    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;

    setOTextBox.mkne(textboxix, int(l-30), int(t-29), 50, 25, -1);
    tbix[0] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-29), 50, 25, -1);
    tbix[1] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-29), 50, 25, -1);
    tbix[2] = textboxix;
    textboxix++;

    oscaddr = aoscaddr;
  }

  void drw() {

    noFill();
    stroke(clr.get("limegreen"));
    strokeWeight(10);
    arc(x, y, 300*dscale, 300*dscale, -HALF_PI, drotate-HALF_PI);
    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    scale(dscale);
    rotate(drotate);
    image(dialpic1, 0, 0); 
    popMatrix();

    val = norm(drotate, 0.0, TWO_PI);
    if (crv<0) val = pow(val, 1.0/abs(crv));
    else val = pow(val, crv);
    val = map(val, 0.0, 1.0, vlo, vhi);
    textAlign(CENTER, CENTER);
    fill(clr.get("green"));
    textFont(monaco12);     
    if (isint==1) val = round(val);
    if ((edittog%2)==0) text(nfc(val, 2), x, t-13);

    //Bounding Box
    if ((edittog%2)==1) {
      noFill();
      rectMode(CORNER);
      strokeWeight(3);
      stroke(clr.get("orange"));
      rect(l, t, w, h);
      fill(clr.get("orange"));
      rect(r, b, 30, 30);
      for (int i=0; i<setOTextBox.cset.size (); i++) {
        TextBox inst = setOTextBox.cset.get(i);
        if (inst.ix == tbix[0] ||inst.ix == tbix[1] ||inst.ix == tbix[2]) {
          inst.visible = true;
        }
      }
    } 
    //
    else {
      for (int i=0; i<setOTextBox.cset.size (); i++) {
        TextBox inst = setOTextBox.cset.get(i);
        if (inst.ix == tbix[0] ||inst.ix == tbix[1] ||inst.ix == tbix[2]) {
          inst.visible = false;
        }
      }
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
      setOTextBox.mv(tbix[0], int(l-30), int(t-29));
      setOTextBox.mv(tbix[1], int(l-30+55), int(t-29));
      setOTextBox.mv(tbix[2], int(l-30+110), int(t-29));
    } //
    if ((edittog%2)==1 && mouseX > r && mouseX <= r+30 && mouseY > b && mouseY <= b+30) {

      dscale = dscale + ((mouseY-pmouseY)/300.0 ) + ( (mouseX-pmouseX)/300.0 );
      w = 300*dscale;
      h = 300*dscale;

      l = x-(w/2.0);
      r = x+(w/2.0);
      t = y-(h/2.0);
      b = y+(h/2.0);
      setOTextBox.mv(tbix[0], int(l-30), int(t-29));
      setOTextBox.mv(tbix[1], int(l-30+55), int(t-29));
      setOTextBox.mv(tbix[2], int(l-30+110), int(t-29));
    } //
    if ((edittog%2)==0 && drag) {
      drotate = constrain(  (  drotate + ( (mouseY-pmouseY)/30.0 )  ), 0.0, TWO_PI);
      val = norm(drotate, 0.0, TWO_PI);
      if (crv<0) val = pow(val, 1.0/abs(crv));
      else val = pow(val, crv);
      val = map(val, 0.0, 1.0, vlo, vhi);
      if (isint==1) val = round(val);
      if (istrig==0) {
        osc.send(oscheaderloc + oscaddr + str(ix), new Object[] {
          val
        }
        , oscdest);
      }
    }
  }

  void keyprs() {
  }

  void msprs() {
    if ((edittog%2)==0 && mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) {
      drag = true;
    }
  }

  void msrel() {
    drag = false;
  }

  void keyrel() {
    if (keyCode==ENTER) {
      vlo = setOTextBox.tbtofloat(tbix[0]);
      vhi = setOTextBox.tbtofloat(tbix[1]);
      crv = setOTextBox.tbtofloat(tbix[2]);
    }
  }

  void setdval(float inval) {
    inval = constrain(inval, 0.0, 1.0);
    drotate = map(inval, 0.0, 1.0, 0.0, TWO_PI);
    if (crv<0) val = pow(inval, 1.0/abs(crv));
    else val = pow(inval, crv);
    val = map(val, 0.0, 1.0, vlo, vhi);
    if (isint==1) val = round(val);
    if (istrig==0) {
      osc.send(oscheaderloc + oscaddr + str(ix), new Object[] {
        val
      }
      , oscdest);
    }
  }

  void setdset(float alo, float ahi, float acrv) {
    vlo = alo;
    vhi = ahi;
    crv = acrv;
  }
  //
  //
}  //End class

//// CLASS SET CLASS ////
class SetODial {
  ArrayList<Dial> cset = new ArrayList<Dial>();

  // Make Instance Method //
  void mk(int ix, float x, float y) {
    cset.add( new Dial(ix, x, y) );
  } //end mk method

  // Make Int Instance Method //
  void mkint(int ix, float x, float y) {
    cset.add( new Dial(ix, x, y, 1) );
  } //end mkint method

  // Make Instance From Load Gui Method //
  void mkgui(int ix, float x, float y, float adrotate, float adscale, 
  float avlo, float avhi, float acrv, int aisint, String aoscaddr) { 
    cset.add( new Dial(ix, x, y, adrotate, adscale, avlo, avhi, acrv, aisint, aoscaddr) );
  } //end mkgui method

  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      inst.drw();
    }
  } //end dr method

  // Key Pressed Set Method //
  void keyprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      inst.edittog = editct;
    }
  } //end keyprs method

  // Mouse Pressed Set Method //
  void msprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      inst.msprs();
    }
  } //end msprs method

  // Mouse Dragged Set Method //
  void msdrg() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      inst.msdrg();
    }
  } //end msdrg method

  // Mouse Released Set Method //
  void msrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      inst.msrel();
    }
  } //end msrel method

  // Key Released Set Method //
  void keyrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      inst.keyrel();
    }
  } //end keyrel method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Set Dial Value Set Method //
  void setdval(int ix, float val) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      if (inst.ix==ix) inst.setdval(val);
    }
  } //end setdval method

  // Set Dial Settings Set Method //
  void setdset(int ix, float alo, float ahi, float acrv) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      if (inst.ix==ix) inst.setdset(alo, ahi, acrv);
    }
  } //end setdset method

  ////
} //end class set class