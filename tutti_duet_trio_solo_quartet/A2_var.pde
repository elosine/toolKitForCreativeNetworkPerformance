//VARIABLES

int numOfPlayers = 19; //PLAYERS ARE NUMBERED beginning with 0
int seed = 50;
int duetsSeed = seed + 13;
int triosSeed = seed + 19;
int solosSeed = seed + 14;
int quartetsSeed = seed + 33;

int pieceDuration = 300000;
int totalInstTime = 0;

//how long an ensemble will play for
int [] ensemblesDuration = {
  9000, 13000, 15000, 3000, 20000, 4400, 7700, 6900, 11000, 2200, 17000, 23000, 27000, 3500, 5300, 8000};
int [] instructionDurations = {
  3333, 5555, 7600, 13000, 8000};

//fonts
PFont monaco21;

//MakeTuttis function variables
int numOfTuttisPerSet = 5;

//ensembles set
int numOfEnsembleSets = 9;
String [] ensemblesSet = new String [1];

//draw


//variables
int circleWeight = 8;
//int outCirDiameter = 600;
int outCirDiameter = 900;
int outCirRadius = outCirDiameter/2;
float playerSpacing;
int playerDiameter = 60;
float outRadius = outCirRadius + playerDiameter/2 + circleWeight;
int outerInCircleDiameter = 700;
int innerInCircleDiameter = 550;
float masterTime;
float calibrateMasterTime = 0;
float startDelay = 5000;
int goTime;
int duration;
int playerTransitionDuration = 1000;
float playerInRadius = (outerInCircleDiameter/2 - innerInCircleDiameter/2)/2 + innerInCircleDiameter/2;

float plrLocRadius = playerInRadius;

//KUCHEN
int kuchenCenterX, kuchenCenterY, kuchenWidth, kuchenHeight;
Kuchen[] kuchenSet = new Kuchen [500];
color[] kuchenColor = {
  color(255,0,0,70), color(0,255,0,70), color(0,0,255,70), color(255,255,0,70), color(255,128,0,70), 
  color(128,0,255,70), color(255, 0, 128,70)};

//TEXT
int textW;
Instructions[] instructionSet = new Instructions [500];
int eventTp, instTp, imgTp, vidTp;
boolean instructionsExsist = false;

//class arrays
PlayerMover[] playersMove = new PlayerMover [500];
int[] playersMoveEventsSave = new int [500];
int playersMoveIdxCurrent = 0;
int playersMoveCurrentEvent = 0;

float [] plrLocation;

int currInst = 0;
int instIdx = 0;
int transitionTime;

int nextInstruction;
int maxInstFade;
int maxTransitionTime;

int frmRate = 24;

PImage[] images;
int imgCt = 0;
int movCt = 0;
Movie[] movies;

OscP5 meOSC;

OscMessage startPiece; 
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 13231;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 13331;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";