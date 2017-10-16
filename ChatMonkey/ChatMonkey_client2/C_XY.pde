SetOXY xyset = new SetOXY();
int xyix = 0;

class XY {
  int ix;
  float x, y, w, h;

  PFont monaco12;

  float lx, ly;
  float l, r, t, b;
  float valx = 0.0;
  float vxlo = 0.0;
  float vxhi = 1.0;
  float xcrv = 3.0;
  float valy = 0.0;
  float vylo = 0.0;
  float vyhi = 1.0;
  float ycrv = 3.0;
  int edittog;
  String oscaddr = "/xy";
  boolean drag = false;
  int [] tbix = new int[6];

  // CONSTRUCTORS //
  XY(int aix, float ax, float ay, float aw, float ah) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;

    monaco12 = loadFont("Monaco-12.vlw");
    lx = x;
    ly = y;

    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;

    setOTextBox.mkne(textboxix, int(l-30), int(t-63), 50, 25, -1);
    tbix[0] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-63), 50, 25, -1);
    tbix[1] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-63), 50, 25, -1);
    tbix[2] = textboxix;
    textboxix++;

    setOTextBox.mkne(textboxix, int(l-30), int(t-29), 50, 25, -1);
    tbix[3] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-29), 50, 25, -1);
    tbix[4] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-29), 50, 25, -1);
    tbix[5] = textboxix;
    textboxix++;

    oscaddr = oscaddr + str(ix);
  }

  // CONSTRUCTORS 2 - Make From Save//
  XY(int aix, float ax, float ay, float aw, float ah, float avalx, float avxlo, 
  float avxhi, float axcrv, float avaly, float avylo, float avyhi, float aycrv, String aoscaddr) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    valx = avalx;
    vxlo = avxlo;
    vxhi = avxhi;
    xcrv = axcrv;
    valy = avaly;
    vylo = avylo;
    vyhi = avyhi;
    ycrv = aycrv;
    oscaddr = aoscaddr;

    monaco12 = loadFont("Monaco-12.vlw");
    lx = x;
    ly = y;

    l = x-(w/2.0);
    r = x+(w/2.0);
    t = y-(h/2.0);
    b = y+(h/2.0);
    edittog = editct;

    setOTextBox.mkne(textboxix, int(l-30), int(t-63), 50, 25, -1);
    tbix[0] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-63), 50, 25, -1);
    tbix[1] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-63), 50, 25, -1);
    tbix[2] = textboxix;
    textboxix++;

    setOTextBox.mkne(textboxix, int(l-30), int(t-29), 50, 25, -1);
    tbix[3] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+55), int(t-29), 50, 25, -1);
    tbix[4] = textboxix;
    textboxix++;
    setOTextBox.mkne(textboxix, int(l-30+110), int(t-29), 50, 25, -1);
    tbix[5] = textboxix;
    textboxix++;

    oscaddr = oscaddr + str(ix);
  }
 
  void drw() {
    fill(clr.get("mint"));
    stroke(clr.get("violetred"));
    strokeWeight(6);
    rectMode(CENTER);
    rect(x, y, w, h);
    strokeWeight(2);
    stroke(0);
    line(lx, t, lx, b);
    line(l, ly, r, ly);
    noStroke();
    fill(clr.getAlpha("orange", 180));
    ellipseMode(CENTER);
    ellipse(lx, ly, 20, 20);

    valx = norm(lx, l, r);
    if (xcrv<0) valx = pow(valx, 1.0/abs(xcrv));
    else valx = pow(valx, xcrv);
    valx = map(valx, 0.0, 1.0, vxlo, vxhi);
    valy = norm(ly, t, b);
    if (ycrv<0) valy = pow(valy, 1.0/abs(ycrv));
    else valy = pow(valy, ycrv);
    valy = map(valy, 0.0, 1.0, vylo, vyhi);
    textAlign(CENTER, CENTER);
    fill(clr.get("green"));
    textFont(monaco12);     
    if ((edittog%2)==0) { 
      text(nfc(valx, 2), x-30, t-15);  
      text(nfc(valy, 2), x+30, t-15);
    }

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
    if ((edittog%2)==1) {
      for (int i=0; i<setOTextBox.cset.size (); i++) {
        TextBox inst = setOTextBox.cset.get(i);
        if (inst.ix == tbix[0] ||inst.ix == tbix[1] ||inst.ix == tbix[2] ||
          inst.ix == tbix[3] ||inst.ix == tbix[4] ||inst.ix == tbix[5]) {
          inst.visible = true;
        }
      }
    } 
    //
    else {
      for (int i=0; i<setOTextBox.cset.size (); i++) {
        TextBox inst = setOTextBox.cset.get(i);
        if (inst.ix == tbix[0] ||inst.ix == tbix[1] ||inst.ix == tbix[2] ||
          inst.ix == tbix[3] ||inst.ix == tbix[4] ||inst.ix == tbix[5]) {
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
      lx = lx + (mouseX-pmouseX);
      ly = ly + (mouseY-pmouseY);
      l = x-(w/2.0);
      r = x+(w/2.0);
      t = y-(h/2.0);
      b = y+(h/2.0);
      setOTextBox.mv(tbix[0], int(l-30), int(t-63));
      setOTextBox.mv(tbix[1], int(l-30+55), int(t-63));
      setOTextBox.mv(tbix[2], int(l-30+110), int(t-63));
      setOTextBox.mv(tbix[3], int(l-30), int(t-29));
      setOTextBox.mv(tbix[4], int(l-30+55), int(t-29));
      setOTextBox.mv(tbix[5], int(l-30+110), int(t-29));
    } //
    if ((edittog%2)==1 && mouseX > r && mouseX <= r+30 && mouseY > b && mouseY <= b+30) {
      float mdxtp = mouseX-pmouseX;
      float mdytp = mouseY-pmouseY;

      x = x + (mdxtp/2.0);
      y = y + (mdytp/2.0);
      w = w + mdxtp;
      h = h + mdytp;

      l = x-(w/2.0);
      r = x+(w/2.0);
      t = y-(h/2.0);
      b = y+(h/2.0);
    } //
    if ((edittog%2)==0 && drag) {
      lx = constrain(mouseX, l, r);
      valx = norm(lx, l, r);
      if (xcrv<0) valx = pow(valx, 1.0/abs(xcrv));
      else valx = pow(valx, xcrv);
      valx = map(valx, 0.0, 1.0, vxlo, vxhi);

      ly = constrain(mouseY, t, b);
      valy = norm(ly, t, b);
      if (ycrv<0) valy = pow(valy, 1.0/abs(ycrv));
      else valy = pow(valy, ycrv);
      valy = map(valy, 0.0, 1.0, vylo, vyhi);
      //SEND OSC
      osc.send(oscheaderloc + oscaddr + str(ix), new Object[] {
        valx, valy
      }
      , oscdest);
    }
  }


  void msprs() {
    if ((edittog%2)==0 && mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) {
      drag = true;
      lx = constrain(mouseX, l, r);
      valx = norm(lx, l, r);
      if (xcrv<0) valx = pow(valx, 1.0/abs(xcrv));
      else valx = pow(valx, xcrv);
      valx = map(valx, 0.0, 1.0, vxlo, vxhi);

      ly = constrain(mouseY, t, b);
      valy = norm(ly, t, b);
      if (ycrv<0) valy = pow(valy, 1.0/abs(ycrv));
      else valy = pow(valy, ycrv);
      valy = map(valy, 0.0, 1.0, vylo, vyhi);
      //SEND OSC
      osc.send(oscheaderloc + oscaddr + str(ix), new Object[] {
        valx, valy
      }
      , oscdest);
    }
  }

  void msrel() {
    drag = false;
  }

  void keyrel() {
    if (keyCode==ENTER) {
      vxlo = setOTextBox.tbtofloat(tbix[0]);
      vxhi = setOTextBox.tbtofloat(tbix[1]);
      xcrv = setOTextBox.tbtofloat(tbix[2]);
      vylo = setOTextBox.tbtofloat(tbix[3]);
      vyhi = setOTextBox.tbtofloat(tbix[4]);
      ycrv = setOTextBox.tbtofloat(tbix[5]);
    }
  }

  void setdval(float invalx, float invaly) {
    invalx = constrain(invalx, 0.0, 1.0);
    lx = map(invalx, 0.0, 1.0, l, r);
    if (xcrv<0) valx = pow(invalx, 1.0/abs(xcrv));
    else valx = pow(invalx, xcrv);
    valx = map(valx, 0.0, 1.0, vxlo, vxhi);

    invaly = constrain(invaly, 0.0, 1.0);
    ly = map(invaly, 0.0, 1.0, t, b);
    if (ycrv<0) valy = pow(invaly, 1.0/abs(ycrv));
    else valy = pow(invaly, ycrv);
    valy = map(valy, 0.0, 1.0, vylo, vyhi);
    //SEND OSC
    osc.send(oscheaderloc + oscaddr + str(ix), new Object[] {
      valx, valy
    }
    , oscdest);
  }

  void setdset(float alox, float ahix, float acrvx, float aloy, float ahiy, float acrvy) {
    vxlo = alox;
    vxhi = ahix;
    xcrv = acrvx;
    vylo = aloy;
    vyhi = ahiy;
    ycrv = acrvy;
  }
  //
  //
}  //End class

//// CLASS SET CLASS ////
class SetOXY {
  ArrayList<XY> cset = new ArrayList<XY>();

  // Make Instance Method //
  void mk(int ix, float x, float y, float w, float h) {
    cset.add( new XY(ix, x, y, w, h) );
  } //end mk method
  
  // Make Instance From Load Gui Method //
   void mkgui(int aix, float ax, float ay, float aw, float ah, float avalx, float avxlo, 
  float avxhi, float axcrv, float avaly, float avylo, float avyhi, float aycrv, String aoscaddr) { 
   cset.add( new XY(aix, ax, ay, aw, ah, avalx, avxlo, avxhi, axcrv, avaly, avylo, avyhi, aycrv, aoscaddr) );
   } //end mkgui method
   
  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      inst.drw();
    }
  } //end dr method

  // Key Pressed Set Method //
  void keyprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      inst.edittog = editct;
    }
  } //end keyprs method

  // Mouse Pressed Set Method //
  void msprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      inst.msprs();
    }
  } //end msprs method

  // Mouse Dragged Set Method //
  void msdrg() {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      inst.msdrg();
    }
  } //end msdrg method

  // Mouse Released Set Method //
  void msrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      inst.msrel();
    }
  } //end msrel method

  // Key Released Set Method //
  void keyrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      inst.keyrel();
    }
  } //end keyrel method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Set XY Value Set Method //
  void setdval(int ix, float valx, float valy) {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      if (inst.ix==ix) inst.setdval(valx, valy);
    }
  } //end setdval method

  // Set XY Settings Set Method //
  void setdset(int ix, float alox, float ahix, float acrvx, float aloy, float ahiy, float acrvy) {
    for (int i=cset.size ()-1; i>=0; i--) {
      XY inst = cset.get(i);
      if (inst.ix==ix) inst.setdset(alox, ahix, acrvx, aloy, ahiy, acrvy);
    }
  } //end setdset method

  ////
} //end class set class