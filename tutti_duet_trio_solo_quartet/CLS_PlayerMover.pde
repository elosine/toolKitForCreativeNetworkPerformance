class PlayerMover {
  int goTime;

  PlayerMover(int PMgoTime){

    goTime = PMgoTime;

  }

  void movePlayers(){

    String[] ensemblesSetPieces = split(ensemblesSet[playersMoveCurrentEvent], "\t");
    int duration = int(ensemblesSetPieces[1]);

    for (int i=0; i<numOfPlayers; i++){

      int playerCondition = int (ensemblesSetPieces [i+2]);

      if (playerCondition != 0){

        switch (playerCondition){

        case 1:
          if (masterTime >= goTime && masterTime <= goTime + playerTransitionDuration){

            plrLocation[i] = map(masterTime, goTime, goTime + playerTransitionDuration, outRadius, playerInRadius);
          }
          break;

        case 2:
          if (masterTime >= goTime && masterTime <= goTime + playerTransitionDuration){

            plrLocation[i] = map(masterTime, goTime, goTime + playerTransitionDuration, playerInRadius , outRadius);
          }
          break;
        }


      }
    }

    kuchenSet[playersMoveCurrentEvent].windKuchen();
    
    
    if (goTime + duration <= pieceDuration){
      if (masterTime >= goTime + duration){
        playersMoveCurrentEvent++;
      }
    }
    else{
      for (int i=0; i<numOfPlayers; i++){
        plrLocation [i] = outRadius;
      }
    }





  }//end method

}//end class