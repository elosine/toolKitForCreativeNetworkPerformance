class Instructions{
  float startTime, endTime;
  String instruction;
  int instructionType;
  PImage graphic;
  Movie movie;
  
  int opacity = 0;
  boolean calcTrans = true;
  float dur;

  Instructions(float CstartTime, float CendTime, String Cinstruction, int CinstructionType){
    startTime = CstartTime;
    endTime = CendTime;
    instruction = Cinstruction;
    instructionType = CinstructionType;
  }

  Instructions(float CstartTime, float CendTime, PImage Cgraphic, int CinstructionType){
    startTime = CstartTime;
    endTime = CendTime;
    graphic = Cgraphic;
    instructionType = CinstructionType;
  }

  Instructions(float CstartTime, float CendTime, Movie Cmovie, int CinstructionType){
    startTime = CstartTime;
    endTime = CendTime;
    movie = Cmovie;
    instructionType = CinstructionType;
  }


  void displayInstruction(){
    dur = endTime - startTime;

      switch(instructionType){

      case 0:
        textAlign(CENTER, CENTER);
        fill(0,opacity);
        rectMode(CENTER);
        textFont(monaco21);
        text(instruction, kuchenCenterX, kuchenCenterY, textW, textW);
        break;

      case 1:
        imageMode(CENTER);
        tint(255, opacity);
        image(graphic, kuchenCenterX, kuchenCenterY);
        break; 

      case 2:
        imageMode(CENTER);
        tint(255, opacity);
        image(movie, kuchenCenterX, kuchenCenterY);
        break; 
      }
    

  }

}