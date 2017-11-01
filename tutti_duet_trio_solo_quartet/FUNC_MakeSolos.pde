String [] MakeSolos(){
  
  String [] solos = new String [numOfPlayers];
  
  for (int i=0; i<numOfPlayers; i++){
    
    solos [i] = str(i);
  }
  return solos;
}