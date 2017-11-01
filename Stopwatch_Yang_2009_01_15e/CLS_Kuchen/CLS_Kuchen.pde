class Kuchen{
  float startTime, endTime;
  float arcTan2 = -HALF_PI;
  color kColor;

  Kuchen(float CstartTime, float CendTime, color CkColor){
    startTime = CstartTime;
    endTime = CendTime;
    kColor = CkColor;
  }


  void windKuchen(){
    if(masterTime >= startTime && masterTime <= endTime){
      arcTan2 = map(masterTime, startTime, endTime, -HALF_PI, PI + HALF_PI);
      ellipseMode(CENTER);
      noStroke();
      fill(kColor);
      arc(kuchenCenterX, kuchenCenterY, kuchenWidth-1, kuchenHeight-1, -HALF_PI, arcTan2);
    }



  }

}