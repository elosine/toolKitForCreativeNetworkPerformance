String savestring = "gui1";
int saveidx = 1;

void savegui() {
  // if (file.exists()) println("exsists");
  String item;
  String[] items = new String[0];
  //SAVE DIALS
  for (int i=0; i<dialset.cset.size (); i++) {
    Dial inst = dialset.cset.get(i);
    item = "dial" + "#" + str(inst.ix) + "#" + str(inst.x) + "#" + 
      str(inst.y) + "#" + str(inst.drotate) + "#" + str(inst.dscale) + "#" + 
      str(inst.vlo) + "#" + str(inst.vhi) + "#" + str(inst.crv) + "#" + str(inst.isint) + "#" + inst.oscaddr;
    items = append(items, item);
  }
  //SAVE BUTTONS
  for (int i=0; i<buttonset.cset.size (); i++) {
    Button inst = buttonset.cset.get(i);
    item = "button" + "#" + str(inst.ix) + "#" + str(inst.x) + "#" + 
      str(inst.y) + "#" + str(inst.dscale) + "#" + str(inst.tog) + "#" + inst.oscaddr;
    items = append(items, item);
  }
  //SAVE TEXTBOXES
  for (int i=0; i<setOTextBox.cset.size (); i++) {
    TextBox inst = setOTextBox.cset.get(i);
    item = "textbox" + "#" + str(inst.ix) + "#" + str(inst.x) + "#" + 
      str(inst.y) + "#" + str(inst.w) + "#" + str(inst.h) + "#" + 
      inst.txt + "#" + int(inst.returnclears) + "#" + int(inst.edittog) + "#" + inst.oscaddr;
    items = append(items, item);
  }
  //SAVE XYs
  for (int i=0; i<xyset.cset.size (); i++) {
    XY inst = xyset.cset.get(i);
    item = "xy" + "#" + str(inst.ix) + "#" + str(inst.x) + "#" + str(inst.y) + "#" + 
      str(inst.w) + "#" + str(inst.h) + "#" + str(inst.valx) + "#" + 
      str(inst.vxlo) + "#" + str(inst.vxhi) + "#" + str(inst.xcrv) + "#" + 
      str(inst.valy) + "#" + str(inst.vylo) + "#" + str(inst.vyhi) + "#" + 
      str(inst.ycrv) + "#" + inst.oscaddr;
    items = append(items, item);
  }

  //CHECK EXISTING SAVES AND GIVE SAVE FILE A NEW NAME SO AS NOT TO OVERWRITE
  if ( file.exists() && file.isDirectory() ) {
    String[] filelist = file.list();
    for (int i=0; i<filelist.length; i++) {
      if (savestring.equals(filelist[i])) {
        saveidx++;
        savestring = "gui" + str(saveidx);
      }
    }
    saveStrings(savepath+savestring, items);
    flashtimer = millis()+500;
  }
}

void getguis() {
  if ( file.exists() && file.isDirectory() ) {
    String[] filelist = file.list();
    savedguis = new String[0];
    // for (int i=filelist.length-1; i>=0; i--) {
    for (int i=0; i<filelist.length; i++) {
      savedguis = append(savedguis, filelist[i]);
    }
  }
}

void loadgui(int ix) {
  if (ix < savedguis.length) {
    String[] items = loadStrings(savepath+savedguis[ix]);
    //clear current gui
    dialset.cset.clear();
    buttonset.cset.clear();
    setOTextBox.cset.clear();
    xyset.cset.clear();
    //LOAD DIALS
    for (int i=0; i<items.length; i++) {
      String[] item = split(items[i], '#');
      if (item[0].equals("dial")) {
        editct = 2;
        dialset.mkgui(int(item[1]), float(item[2]), float(item[3]), float(item[4]), 
        float(item[5]), float(item[6]), float(item[7]), float(item[8]), int(item[9]), item[10]);
      }
    }
    //LOAD BUTTONS
    for (int i=0; i<items.length; i++) {
      String[] item = split(items[i], '#');
      if (item[0].equals("button")) {
        editct = 2;
        buttonset.mkgui(int(item[1]), float(item[2]), float(item[3]), float(item[4]), 
        int(item[5]), item[6]);
      }
    }
    //LOAD TEXT BOXES
    for (int i=0; i<items.length; i++) {
      String[] item = split(items[i], '#');
      if (item[0].equals("textbox")) {
        if (int(item[8]) != -1) {
          editct = 2;
          setOTextBox.mkgui(int(item[1]), int(item[2]), int(item[3]), int(item[4]), 
          int(item[5]), item[6], int(item[7]), int(item[8]), item[9]);
        }
      }
    }
    //LOAD XY
    for (int i=0; i<items.length; i++) {
      String[] item = split(items[i], '#');
      if (item[0].equals("xy")) {
        editct = 2;
        xyset.mkgui(int(item[1]), float(item[2]), float(item[3]), float(item[4]), 
        float(item[5]), float(item[6]), float(item[7]), float(item[8]), float(item[9]), 
        float(item[10]), float(item[11]), float(item[12]), float(item[13]), item[14]);
      }
    }
  }
}