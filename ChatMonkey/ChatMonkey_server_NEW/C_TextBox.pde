// DECLARE/INITIALIZE CLASS SET
TextBoxSet setOTextBox = new TextBoxSet();


class TextBox {
  // CONSTRUCTOR VARIALBES //
  int ix, x, y, w, h;

  // CLASS VARIABLES //
  String txt = "";
  int borderweight = 1;
  int textinset = 2;
  int bbinset;
  String just = "l";
  String align = "t";

  int l, r, t, b, m, c;
  int rx, ry, rw, rh;
  int tx, ty, tw, th;

  String bdrclr = "orange";
  String fillclr = "white";
  String txtclr = "black";
  String highlightclr = "mint";

  boolean active = false;
  int edittog = 0; 
  boolean visible = true;
  String oscaddr = "/textbox";
  int returnclears = 0;

  // CONSTRUCTORS //
  TextBox(int aix, int ax, int ay, int aw, int ah) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;

    //BOUNDING BOX COORDINATES
    l = x;
    t = y;
    r = l+w;
    b = t+h;
    m = l + round(w/2.0);
    c = t + round(h/2.0);

    //RECT COORDINATES
    bbinset = ceil(borderweight/2.0);
    rx = x+bbinset;
    ry = y+bbinset;
    rw = w - (bbinset*2);
    rh = h - (bbinset*2);

    //TEXT COORDINATES
    textinset = textinset + ceil(borderweight/2.0);

    tx = rx + textinset;
    ty = ry + textinset;
    tw = rw - (textinset*2);
    th = rh - (textinset*2);
    edittog = editct;
  } //end constructor 1
  

  // CONSTRUCTORS - Can't edit //
  TextBox(int aix, int ax, int ay, int aw, int ah, float aedittog) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    edittog = int(aedittog);

    //BOUNDING BOX COORDINATES
    l = x;
    t = y;
    r = l+w;
    b = t+h;
    m = l + round(w/2.0);
    c = t + round(h/2.0);

    //RECT COORDINATES
    bbinset = ceil(borderweight/2.0);
    rx = x+bbinset;
    ry = y+bbinset;
    rw = w - (bbinset*2);
    rh = h - (bbinset*2);

    //TEXT COORDINATES
    textinset = textinset + ceil(borderweight/2.0);

    tx = rx + textinset;
    ty = ry + textinset;
    tw = rw - (textinset*2);
    th = rh - (textinset*2);
  } //end constructor 1

  // CONSTRUCTORS 2 - Return Clears//
  TextBox(int aix, int ax, int ay, int aw, int ah, int areturnclears) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    returnclears = areturnclears;

    //BOUNDING BOX COORDINATES
    l = x;
    t = y;
    r = l+w;
    b = t+h;
    m = l + round(w/2.0);
    c = t + round(h/2.0);

    //RECT COORDINATES
    bbinset = ceil(borderweight/2.0);
    rx = x+bbinset;
    ry = y+bbinset;
    rw = w - (bbinset*2);
    rh = h - (bbinset*2);

    //TEXT COORDINATES
    textinset = textinset + ceil(borderweight/2.0);

    tx = rx + textinset;
    ty = ry + textinset;
    tw = rw - (textinset*2);
    th = rh - (textinset*2);
    edittog = editct;
  } //end constructor 2
  

  // CONSTRUCTORS 3 - From Save//
  TextBox(int aix, int ax, int ay, int aw, int ah, String atxt, int areturnclears, int aedittog, String aoscaddr) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    txt = atxt;
    returnclears = areturnclears;
    edittog = aedittog;
    oscaddr = aoscaddr;
    
    //BOUNDING BOX COORDINATES
    l = x;
    t = y;
    r = l+w;
    b = t+h;
    m = l + round(w/2.0);
    c = t + round(h/2.0);

    //RECT COORDINATES
    bbinset = ceil(borderweight/2.0);
    rx = x+bbinset;
    ry = y+bbinset;
    rw = w - (bbinset*2);
    rh = h - (bbinset*2);

    //TEXT COORDINATES
    textinset = textinset + ceil(borderweight/2.0);

    tx = rx + textinset;
    ty = ry + textinset;
    tw = rw - (textinset*2);
    th = rh - (textinset*2);
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    if (visible) {
      rectMode(CORNER);

      //WHITE BACKGROUND RECT
      noStroke();
      fill(255);
      rect(rx, ry, rw, rh);

      //BOX FILL RECT
      if (borderweight == 0) noStroke();
      else stroke(clr.get(bdrclr));
      strokeWeight(borderweight);
      if (active) fill(clr.get(highlightclr));
      else fill(clr.get(fillclr));
      rect(rx, ry, rw, rh);

      if ( edittog>0 && (edittog%2)==1 ) {
        //RESIZE SQUARE
        noStroke();
        fill(128);
        rect(r, b, 30, 30);
        //BOUNDING BOX
        noFill();
        strokeWeight(4);
        stroke(clr.get("orange"));
        rect(rx, ry, rw, rh);
      }


      //SET TEXT ALIGNMENT
      if (just.equals("l")&&align.equals("t")) textAlign(LEFT, TOP);
      if (just.equals("l")&&align.equals("c")) textAlign(LEFT, CENTER);
      if (just.equals("l")&&align.equals("b")) textAlign(LEFT, BOTTOM);
      if (just.equals("c")&&align.equals("t")) textAlign(CENTER, TOP);
      if (just.equals("c")&&align.equals("c")) textAlign(CENTER, CENTER);
      if (just.equals("c")&&align.equals("b")) textAlign(CENTER, BOTTOM);
      if (just.equals("r")&&align.equals("t")) textAlign(RIGHT, TOP);
      if (just.equals("r")&&align.equals("c")) textAlign(RIGHT, CENTER);
      if (just.equals("r")&&align.equals("b")) textAlign(RIGHT, BOTTOM);
      fill(clr.get(txtclr));
      text(txt, tx, ty, tw, th);
    }
    //
  } //End drw


  //  KEY PRESSED //
  void keyrel() {
    if (active) {
      if (keyCode == BACKSPACE) {
        if (txt.length() > 0) {
          txt = txt.substring(0, txt.length()-1);
        }
      } 
      //
     
      //
      else if (keyCode == ENTER) {
        txtentered();
        if(returnclears==1) txt = "";
      } 
      //
       else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
        txt = txt + key;
      }
    }
  } //End keyprs

  //  Mouse Pressed //
  void msclk() {
    if ( mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) active = true;
    else active = false;
  } //End msclk

  void msdrg() {
    //MOVE BOX
    if ( edittog>0 && (edittog%2)==1 && mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) {
      //BOUNDING BOX COORDINATES
      x = x + (mouseX - pmouseX);
      y = y + (mouseY - pmouseY);
      l = x;
      t = y;
      r = l+w;
      b = t+h;
      m = l + round(w/2.0);
      c = t + round(h/2.0);
      //RECT COORDINATES
      rx = x+bbinset;
      ry = y+bbinset;
      //TEXT COORDINATES
      tx = rx + textinset;
      ty = ry + textinset;
    }

    //RESIZE
    if ( edittog>0 && (edittog%2)==1 && mouseX >= r && mouseX <= r+30 && mouseY >= b && mouseY <= b+30) {
      //BOUNDING BOX COORDINATES
      w = w + (mouseX - pmouseX);
      h = h + (mouseY - pmouseY);

      r = l+w;
      b = t+h;
      m = l + round(w/2.0);
      c = t + round(h/2.0);

      //RECT COORDINATES
      rw = w - (bbinset*2);
      rh = h - (bbinset*2);

      //TEXT COORDINATES
      tw = rw - (textinset*2);
      th = rh - (textinset*2);
    } 
    //
  } //end msdrg


  //  TEXT ENTERED //
  String txtentered() {
    println("fdsafdsafdsa");
    active = false;
    osc.send(oscheaderloc + oscaddr, new Object[] {1, txt}, broadcastList);

    return txt;
  } //End txtentered


  //
}  //End class

//// CLASS SET CLASS ////
class TextBoxSet {
  ArrayList<TextBox> cset = new ArrayList<TextBox>();

  // Make Instance Method //
  void mk(int ix, int x, int y, int w, int h) {
    cset.add( new TextBox(ix, x, y, w, h) );
  } //end mk method

  // Make Instance Method //
  void mkne(int ix, int x, int y, int w, int h, float et) {
    cset.add( new TextBox(ix, x, y, w, h, -1.1) );
  } //end mkne method


  // Make Return Clearing Instance Method //
  void mkrc(int ix, int x, int y, int w, int h) {
    cset.add( new TextBox(ix, x, y, w, h, 1) );
  } //end mk method

  // Make Instance From SaveMethod //
  void mkgui(int ix, int x, int y, int w, int h, String txt, int rc, int edittog, String oscadr) {
    cset.add( new TextBox(ix, x, y, w, h, txt, rc, edittog, oscadr) );
  } //end mk method

  // Draw Set Method //
  void drwset() {
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      inst.drw();
    }
  } //end dr method

  // Key Pressed Set Method //
  void keyrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      inst.keyrel();
    }
  } //end keyprs method

  // Mouse Pressed Set Method //
  void msclk() {
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      inst.msclk();
    }
  } //end msclk method

  // Mouse Dragged Set Method //
  void msdrg() {
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      inst.msdrg();
    }
  } //end msmvd method

  // Edit Method //
  void edit() {
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      if(inst.edittog>0) inst.edittog = editct;
    }
  } //end msmvd method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Move Instance Method //
  void mv(int ix, int x, int y) {
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      if (inst.ix == ix) {
        inst.x = x;
        inst.y = y; 
        inst.l = inst.x;
        inst.t = inst.y;
        inst.r = inst.l+inst.w;
        inst.b = inst.t+inst.h;
        inst.m = inst.l + round(inst.w/2.0);
        inst.c = inst.t + round(inst.h/2.0);
        inst.rx = inst.x+inst.bbinset;
        inst.ry = inst.y+inst.bbinset;
        inst.tx = inst.rx + inst.textinset;
        inst.ty = inst.ry + inst.textinset;
        break;
      }
    }
  } //End rmv method
  
   // Write to TextBox Method //
  void write(int ix, String val) {
    for (int i=cset.size ()-1; i>=0; i--) {
    //  TextBox inst = cset.get(i);
   // if(inst.ix==ix) inst.txt = val + "\n" + inst.txt;
     osc.send("/gui/tbwrite", new Object[] {1, val}, broadcastList);
    }
  } //end setdval method

  // Text Entered Method //
  float tbtofloat(int ix) {
    float ftemp = 0.0;
    for (int i=cset.size ()-1; i>=0; i--) {
      TextBox inst = cset.get(i);
      if (inst.ix == ix) {
        ftemp =  float(inst.txt);
        break;
      }
    }
    return ftemp;
  } //End tbtofloat method
} //end class set class