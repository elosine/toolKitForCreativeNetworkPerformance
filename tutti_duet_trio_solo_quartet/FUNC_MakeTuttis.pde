String [] MakeTuttis (){

  String [] tuttisA = new String [1];
  String [] tuttis = new String [numOfTuttisPerSet];

  for (int i=0; i<numOfPlayers; i++){

    if (i == 0){
      tuttisA [0] = str (0);
    }
    else{
      tuttisA [0] = tuttisA [0] + "\t" + str(i);
    }
  }
  
  for (int i=0; i<numOfTuttisPerSet; i++){
    
    tuttis[i] = tuttisA[0];
  }
  
  return tuttis;
}//end function