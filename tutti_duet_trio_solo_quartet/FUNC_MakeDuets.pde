String [] MakeDuets (int dSeed){
  
  int[] duetsFund = ShuffleSeeded (numOfPlayers, dSeed);
  String [] duetsA = new String [(numOfPlayers/2) + 1];
  String [] duets = new String [1];

int i = 0;
int j = 0;
while(j<numOfPlayers){
  int k = j+1;
  duetsA [i] = str(duetsFund[j]) + "\t" + str (duetsFund[k%duetsFund.length]);
  duets = subset(duetsA, 0, i+1);
  j=j+2;
  i++;
}

return duets;
}