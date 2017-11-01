/*

 'tutti, duet, trio, solo, quartet' by Justin Yang
 http://www.somasa.qub.ac.uk/~jyang/portfolio/Justin_Yang/Welcome.html 
 tutti, duet, trio, solo, quartet by Justin Yang is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
 http://creativecommons.org/licenses/by-nc-sa/3.0/
 This code was created with Processing V. 1.5.1
 It may not run on other versions of the software
 
 */
 
 
void setup() {
  size(1920, 1080);// size(1024, 768);
 // size(1920, 1080);
  smooth();
  //frameRate(frmRate);


  //Kuchen
  kuchenCenterX = width/2;
  kuchenCenterY = height/2;
  kuchenWidth = innerInCircleDiameter - 10;
  kuchenHeight = innerInCircleDiameter - 10;

  //Text
  textW = int(sqrt((sq(innerInCircleDiameter)/2)));

  //load fonts
  //monaco21 = loadFont ("Monaco-21.vlw");
  monaco21 = loadFont ("Monaco-36.vlw");
  

  //LOAD DATA
  String [] dataLoad = loadStrings ("data.txt");
  if (dataLoad != null) {
    if (dataLoad[0].equals("null")!=true) {
      numOfPlayers = int(dataLoad [0]);
      // println("numofPlayers---" + numOfPlayers);
    }
    if (dataLoad[1].equals("null")!=true) {
      pieceDuration = int(dataLoad [1]);
      // println("duration-------" + pieceDuration);
    }
    if (dataLoad[2].equals("null")!=true) {
      seed = int(dataLoad [2]);
    }
    if (dataLoad[3].equals("null")!=true) {
      maxTransitionTime = int(dataLoad [3]);
    }
    if (dataLoad[4].equals("null")!=true) {
      ensemblesDuration = int(split(dataLoad[4], "\t"));
      // println("ensemblesDuration-------------");
      //  println(ensemblesDuration);
    }
    if (dataLoad[5].equals("null")!=true) {
      instructionDurations = int(split(dataLoad[5], "\t"));
      maxInstFade = min(instructionDurations);
      //println("maxInstFade" + maxInstFade);
    }
    if (dataLoad[6].equals("null")!=true) {
      String[] pieces = split(dataLoad[6], "\t");
      myListeningPort = int(pieces[1]);
      myBroadcastPort = int(pieces[2]);
    }
  }



  randomSeed(seed);

  duetsSeed = seed + 13;
  triosSeed = seed + 19;
  solosSeed = seed + 14;
  quartetsSeed = seed + 33;


  //SET CLOCK TO END OF PIECE TO PAUSE, USE SPACEBAR TO START
  calibrateMasterTime = millis() + pieceDuration + 10000;


  plrLocation = new float [numOfPlayers];
  playerSpacing = TWO_PI/numOfPlayers;

  ensemblesSet = MakeEnsembleSet();
  // println(ensemblesSet);

  //Get Text Instructions
  String [] instructionsLoad = loadStrings ("instructions.txt");
  if (instructionsLoad != null) {
    instructionsExsist = true;
    int j = 0;
    int m = 0;
    int o = 0;
    int p = 0;
    for (int n=0; n<instructionsLoad.length; n++) {
      String[] instructionPieces = split(instructionsLoad[n], "\t");
      if (int(instructionPieces[0]) == 1) {
        imgCt = o+1;
        o++;
      }
      if (int(instructionPieces[0]) == 2) {
        movCt = p+1;
        p++;
      }
    }
    images = new PImage[imgCt];
    movies = new Movie[movCt];
    for (int i=0; i<instructionsLoad.length; i++) {
      String[] instructionPieces = split(instructionsLoad[i], "\t");
      if (int(instructionPieces[0]) == 1) {
        images[j] = loadImage(instructionPieces[1]);
        j++;
      }
      if (int(instructionPieces[0]) == 2) {
        movies[m] = new Movie(this, instructionPieces[1]);
        movies[m].loop();
        m++;
      }
    }
  }

  else {
    instructionsExsist = false;
  }

  //populate PlayerMover, kuchen, and text classes
  for (int i=0; i<ensemblesSet.length; i++) {

    String [] ensemblesSetPieces = split(ensemblesSet[i], "\t");
    int movePlayerGoTime = int(ensemblesSetPieces [0]);
    int endTime = int(ensemblesSetPieces[1]) + movePlayerGoTime;

    playersMove [playersMoveIdxCurrent] = new PlayerMover (movePlayerGoTime);
    playersMoveEventsSave[playersMoveIdxCurrent] = movePlayerGoTime;

    //Kuchen
    kuchenSet[playersMoveIdxCurrent] = new Kuchen(movePlayerGoTime, endTime, kuchenColor[3]);

    playersMoveIdxCurrent++;
  }

  //Populate Instructions and Timings
  if (instructionsExsist) {
    while (totalInstTime < pieceDuration) {

      eventTp = floor(random(instructionsLoad.length));
      imgTp = floor(random(images.length));
      vidTp = floor(random(movies.length));
      String[] instructionPieces = split(instructionsLoad[eventTp], "\t");
      instTp =  floor(random(instructionDurations.length));
      int instEndTime = totalInstTime + instructionDurations[instTp];

      switch(int(instructionPieces[0])) {

      case 0:
        instructionSet[instIdx] = new Instructions(totalInstTime, instEndTime, instructionPieces[1], 0);
        instIdx++;
        break;

      case 1:
        instructionSet[instIdx] = new Instructions(totalInstTime, instEndTime, images[imgTp], 1);
        instIdx++;
        break;

      case 2:
        instructionSet[instIdx] = new Instructions(totalInstTime, instEndTime, movies[vidTp], 2);
        instIdx++;
        break;
      }

      totalInstTime = instEndTime;
    }


    instructionSet[currInst].opacity = 255;
  }

  //position all players on the outside circle

  for (int i=0; i<numOfPlayers; i++) {
    plrLocation [i] = outRadius;
  }


  meOSC = new OscP5(this, myListeningPort);  


}

void keyPressed() {
  if (key == 32) {
    calibrateMasterTime = millis() - 2000;
    currInst = 0;
    playersMoveCurrentEvent = 0;
    for (int i=0; i<numOfPlayers; i++) {
      plrLocation [i] = outRadius;
    }
    startPiece = new OscMessage("/startPiece");
    meOSC.send(startPiece, myNetAddressList);
  }


}


void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    connect(theOscMessage.netAddress().address());
    println("connected");
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    disconnect(theOscMessage.netAddress().address());
  }

  if (theOscMessage.addrPattern().equals("/startPiece")) {
    calibrateMasterTime = millis() - 2000;
    currInst = 0;
    playersMoveCurrentEvent = 0; 
    for (int i=0; i<numOfPlayers; i++) {
      plrLocation [i] = outRadius;
    }
  }
}


// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}