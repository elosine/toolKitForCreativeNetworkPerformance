void DrawPlayers(){
  
  for (int i=0; i<numOfPlayers; i++){
    
    
    fill(255, 0, 0);
    noStroke();
    ellipseMode(CENTER);

    ellipse ( (width/2) + (cos(i*playerSpacing)*plrLocation[i]),
    (height/2) + (sin(i*playerSpacing)*plrLocation[i]),
    playerDiameter, playerDiameter);

    textFont (monaco21);
    textAlign(CENTER, CENTER);
    fill(255);
    text(i, (width/2) + (cos(i*playerSpacing)*plrLocation[i]),
    (height/2) + (sin(i*playerSpacing)*plrLocation[i]) );
    
    

  }

}