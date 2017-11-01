String [] MakeTrios (int tSeed){

  int[] triosFund = ShuffleSeeded (numOfPlayers, tSeed);
  String [] triosA = new String [(numOfPlayers/3) + 1];
  String [] trios = new String [1];

 int i = 0;
 int j = 0;
while(j<numOfPlayers){
  int k = j+1;
  int l = j+2;
  triosA [i] = str(triosFund[j]) + "\t" + str (triosFund[k%triosFund.length]) + "\t" + str (triosFund[l%triosFund.length]);
  trios = subset(triosA, 0, i+1);
  j=j+3;
  i++;
}
return trios;
}