String [] MakeEnsembleSet (){

  //GENERATE BASE ENSEMBLE SETS
  String [] tuttis = MakeTuttis();

  String [] duets = MakeDuets(duetsSeed);
  
  String [] trios = MakeTrios(triosSeed);

  String [] solos = MakeSolos();
  
  String [] quartets = MakeQuartets(quartetsSeed);

//CONCATENATE ALL THE SETS INTO ONE
String [] baseEnsembleSet = new String [1];

baseEnsembleSet = concat (tuttis, duets);
baseEnsembleSet = concat (baseEnsembleSet, trios);
baseEnsembleSet = concat (baseEnsembleSet, solos);
baseEnsembleSet = concat (baseEnsembleSet, quartets);

//MAKE ONE BIG SET CONSISTING OF SEVERAL BASE SETS SHUFFLED DIFFERENTLY
String [] ensembleSetA = new String [baseEnsembleSet.length];
String [] ensembleSet = new String [1];

for (int i=0; i<numOfEnsembleSets; i++){
  
  ensembleSetA = ShuffleSet(baseEnsembleSet);
  
  if (i==0){
  ensembleSet = ensembleSetA;
  }
  else{
  ensembleSet = concat (ensembleSet, ensembleSetA);
  }
  
}
//println(ensembleSet);

//variables

String [] timedEnsembleSetA = new String [2000];
String [] timedEnsembleSetB = new String [2000];
String [] timedEnsembleSet = new String [1];
String [] timedEnsembleSet0 = new String [1];
String [] timedEnsembleSet1 = new String [1];
String [] timedEnsembleSetPieces = new String [numOfPlayers+2];

int goTime = 0;
int duration;

int a = 0;//ensembleSet iterater
int b = 0;//timedEnsembleSet iterater


while (goTime < pieceDuration){
  
  //array member 0 = go time
  timedEnsembleSetPieces [0] = str(goTime);
  duration = ensemblesDuration[floor(random(ensemblesDuration.length))];
  timedEnsembleSetPieces [1] = str(duration);
  goTime = goTime + duration;//iterate goTime
  
  //make all player positions 0
  for (int i=0; i<numOfPlayers; i++){   
     timedEnsembleSetPieces [i+2] = "0";
   }
  
  //turn on players that are on according to the ensembleSet
  //look at ensembleSet line and split into pieces to find which players are on
    String [] ensembleSetPieces = split(ensembleSet[a], "\t");
    //if player numbers are present make those players 1 in the timedEnsembleSetPieces
    for(int i=0; i<ensembleSetPieces.length; i++){   
      timedEnsembleSetPieces[int(ensembleSetPieces[i])+2] = "1";
    }
    
    a++;//iterate ensembleSet
    
    //join timedEnsembleSetPieces and add to timedEnsembleSet
    
    timedEnsembleSetA [b] = join(timedEnsembleSetPieces, "\t");
    
    if (b==0){
      
    b++;//iterate timedEnsembleSetA
    timedEnsembleSet0[0] = timedEnsembleSetA[0];
    }
    
    else{    
    //tag the array 0 for don't move, 1 for move out to in, 2 for move in to out
    
    String [] timedEnsembleSetCurrentPieces = split(timedEnsembleSetA[b], "\t");
    String [] timedEnsembleSetLastPieces = split(timedEnsembleSetA[b-1], "\t");
    
    for (int j=2; j<timedEnsembleSetCurrentPieces.length; j++){
      
      if (int(timedEnsembleSetCurrentPieces[j]) == int(timedEnsembleSetLastPieces[j])){
        timedEnsembleSetPieces[j] = "0";
      }
      
      else if (int(timedEnsembleSetCurrentPieces[j]) > int(timedEnsembleSetLastPieces[j])){
        timedEnsembleSetPieces[j] = "1";
      }
      
      else if (int(timedEnsembleSetCurrentPieces[j]) < int(timedEnsembleSetLastPieces[j])){
        timedEnsembleSetPieces[j] = "2";
      }
    }
    
    timedEnsembleSetB [b] = join(timedEnsembleSetPieces, "\t");
   
    b++;//iterate timedEnsembleSetA
    timedEnsembleSet1 = subset(timedEnsembleSetB, 1, b-1);
    
    }
    
}//end while loop
timedEnsembleSet = concat(timedEnsembleSet0, timedEnsembleSet1);

return timedEnsembleSet;
}