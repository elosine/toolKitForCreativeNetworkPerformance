import java.awt.event.KeyEvent;

MoreKeys keyz = new MoreKeys();
/*
void setup() {
 size(500, 400);
 }
 void draw() {
 }
 
 void keyPressed() {
 // println(keyz.name(keyCode));
 
 if(keyz.name(keyCode).equals("alt+S") && keyz.rpt ){
 println(keyz.name(keyCode));
 //must use this gate else will repeat
 keyz.rpt = false;
 }
 }
 void keyReleased() { 
 keyz.keyrel();
 //must use this gate else will repeat
 if(keyz.name(keyCode).equals("alt+S") && !keyz.rpt )keyz.rpt = true;
 }
 */
class MoreKeys {
  boolean[] keys = new boolean[526];
  boolean rpt = true;

  String keyrel(int keycode) { 
    String keystr = "";
    String prefix;
    boolean prefixPresent;
    keys[keyCode] = false;
    prefix = "";
    prefixPresent = false;

    if (isKeyPressed(KeyEvent.VK_SHIFT)) {
      prefix += "shift";
      prefixPresent = true;
    }
    if (isKeyPressed(KeyEvent.VK_CONTROL)) {
      prefix += (prefixPresent == true ? "-" : "") +"ctl";
      prefixPresent = true;
    }
    if (isKeyPressed(KeyEvent.VK_ALT)) {
      prefix += (prefixPresent == true ? "-" : "") +"alt";
      prefixPresent = true;
    }
    prefix += (prefixPresent == true ? "+" : "");
    keystr = prefix + KeyEvent.getKeyText(keyCode);
    return keystr;
  }

  boolean isKeyPressed(int k) {
    if (keys.length >= k) {
      return keys[k];
    }
    return false;
  }

  //
  String name(int keycode) {
    String keystr = "";
    String prefix;
    boolean prefixPresent;
    keys[keyCode] = true;
    prefix = "";
    prefixPresent = false;

    if (isKeyPressed(KeyEvent.VK_SHIFT)) {
      prefix += "shift";
      prefixPresent = true;
    }
    if (isKeyPressed(KeyEvent.VK_CONTROL)) {
      prefix += (prefixPresent == true ? "-" : "") +"ctl";
      prefixPresent = true;
    }
    if (isKeyPressed(KeyEvent.VK_ALT)) {
      prefix += (prefixPresent == true ? "-" : "") +"alt";
      prefixPresent = true;
    }
    prefix += (prefixPresent == true ? "+" : "");
    keystr = prefix + KeyEvent.getKeyText(keyCode);
    return keystr;
  }
}