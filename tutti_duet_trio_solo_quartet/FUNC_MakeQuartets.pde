String [] MakeQuartets(int qSeed){

  int[] quartetsFund = ShuffleSeeded (numOfPlayers, qSeed);
  String [] quartetsA = new String [(numOfPlayers/3) + 1];
  String [] quartets = new String [1];

 int i = 0;
 int j = 0;
while(j<numOfPlayers){
  int k = j+1;
  int l = j+2;
  int m = j+3;
  quartetsA [i] = str(quartetsFund[j]) + "\t" +
  str (quartetsFund[k%quartetsFund.length]) + "\t" +
  str (quartetsFund[l%quartetsFund.length]) + "\t" +
  str (quartetsFund[m%quartetsFund.length]);
  quartets = subset(quartetsA, 0, i+1);
  j=j+4;
  i++;
}
return quartets;
}
  