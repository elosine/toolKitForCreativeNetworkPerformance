int [] ShuffleSeeded(int arrayLength, int seed){
  
  randomSeed(seed);
  
  int[] toShuffle = new int [arrayLength];
  for (int i = 0; i<arrayLength; i++){
    toShuffle[i] = i;
  }
  
  int[] shuffled = new int[toShuffle.length]; 
  int i=0; 
  while ( toShuffle.length > 0 )  { 
    int rnd = int(random(toShuffle.length));  // by default random() never returns the given max value 
    shuffled[i] = toShuffle[rnd]; 
    i++; 
    if ( rnd > 0 && rnd < toShuffle.length-1 ) 
      toShuffle = concat(subset(toShuffle,0,rnd), subset(toShuffle,rnd+1,toShuffle.length-rnd-1)); 
    else if ( rnd == 0 ) 
      toShuffle = subset(toShuffle,1,toShuffle.length-1); 
    else 
      toShuffle = shorten( toShuffle ); 
  }
  return shuffled;
}