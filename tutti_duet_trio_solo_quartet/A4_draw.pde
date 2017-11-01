


void draw(){
  background (255);

  ScoreField();


  masterTime = millis() - calibrateMasterTime - startDelay;
 // masterTime = ( frameCount * ((1.0/frmRate)*1000.0) ) - calibrateMasterTime; //for rendering

  //CLASS DECLARIATIONS



  //INSTRUCTIONS ----------------------------------------------------------------------------
  if(instructionsExsist){

    if(instructionSet[currInst].endTime <= pieceDuration){
      
        if(instructionSet[currInst].instructionType == 2){
        instructionSet[currInst].movie.loop();
      }

      instructionSet[currInst].displayInstruction();

      if( instructionSet[currInst+1] != null){
      nextInstruction = currInst+1;
        instructionSet[nextInstruction].displayInstruction();
      }

      if (masterTime >= instructionSet[currInst].endTime){
        if(instructionSet[currInst].instructionType == 2){
        instructionSet[currInst].movie.stop();
      }
        //ASSIGN A TRANSITION TIME
        if(instructionSet[currInst].calcTrans){
          transitionTime = round(random(maxTransitionTime));
          if(transitionTime > instructionSet[currInst].dur){
            transitionTime = round(instructionSet[currInst].dur) - 100;
          }
        //  println(transitionTime);
          instructionSet[currInst].calcTrans = false;
        }

        //fade out current instruction fade in next instruction
        if(masterTime < instructionSet[currInst].endTime + transitionTime){
          float transition = map(masterTime, instructionSet[currInst].endTime, instructionSet[currInst].endTime + transitionTime, 255, 0);
          instructionSet[currInst].opacity = round(transition);
          instructionSet[nextInstruction].opacity = 255 - round(transition);
        }
        //advance to next instruction
        if(masterTime >= instructionSet[currInst].endTime + transitionTime){
          currInst++;
        }

      }

    }
  }
  //END: instructions ----------------------------------------------------------------------------
  
  DrawPlayers();

  playersMove[playersMoveCurrentEvent].movePlayers();
  
  
  /*
  //RENDERING ---------------------------------------
  if(masterTime < 20000){
   saveFrame("tutti-#####.tif");
   delay(600);
  }
   //-------------------------------------------------
   */

}