void ScoreField(){

 stroke (0);
 noFill();
 strokeWeight (circleWeight);
 ellipseMode(CENTER);
 
 //outside line
 ellipse(width/2, height/2, outCirDiameter, outCirDiameter);
 
 //inside lines
 stroke(0, 255, 0);
 ellipse(width/2, height/2, outerInCircleDiameter, outerInCircleDiameter);
 ellipse(width/2, height/2, innerInCircleDiameter, innerInCircleDiameter);
 
}