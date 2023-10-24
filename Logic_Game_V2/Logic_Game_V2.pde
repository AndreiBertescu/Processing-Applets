Menu menu;
TextBox textMenu;
Canvas mainCanvas;

File dir, canv;
String[] files, cfiles;

float scale = 1;
String selectedType;
Piece newPiece, movedPiece;
PVector lastPressPos, movedPieceOffset;
int movedNodeIndex, connectionOriginType, nrOfInputs, nrOfOutputs, hoveredBigConnection, currentBigConnection;
Connection movedConnection, currentConnection;
boolean isMakingConnection, isMovingPiece, isMovingNode, isNewPiece, paused, saving;

//settings
int minWindowWidth = 800; //min width of window
int minWindowHeight = 600; //min height of window
float r = 15; //radius of ports
int minh = 50; //min width of piece
int minw = 50; //min height of piece
color cTrue = color(255, 0, 0); //color if port is on
color cFalse = color(0); //color if port is off
int menuWidth = 200; //width of the menu
int paddingNS = 5; //padding left-right
int paddingEW = 10; //padding top-bot
int btnHeight = 40; //height for the menu buttons
int menuSize = 18; //text size for the menu text
int bigPortWidth = 13; //width of the big ports square

void setup() {
  //size(800, 500);
  fullScreen();
  surface.setResizable(true);
  ellipseMode(CENTER);

  isMakingConnection = false;
  isMovingPiece = false;
  isNewPiece = false;
  selectedType = "";
  paused = false;
  saving = false;
  textMenu = null;
  newPiece = null;
  movedPiece = null;
  movedConnection = null;
  currentConnection = null;
  lastPressPos = new PVector(0, 0);
  movedPieceOffset = new PVector(0, 0);
  nrOfInputs = 0;
  nrOfOutputs = 0;
  movedNodeIndex = -1;
  connectionOriginType = -1;
  hoveredBigConnection = -1;
  currentBigConnection = -1;

  dir = new File(dataPath("types"));
  files = dir.list();
  canv = new File(dataPath("canv"));
  cfiles = dir.list();

  //create canvas
  mainCanvas = new Canvas();
  //create menu
  menu = new Menu(menuWidth, height, menuSize);

  //initialize work area
  mainCanvas = loadCanvas("4-BIT-ADDER");
}

void draw() {
  //set minimum window size
  if (width < minWindowWidth)
    surface.setSize(minWindowWidth, height);
  if (height < minWindowHeight)
    surface.setSize(width, minWindowHeight);

  pushMatrix();
  scale(scale);

  background(51);
  textAlign(CENTER);

  checkControlls();

  if (currentConnection != null)
    currentConnection.preshow();

  if (!paused)
    mainCanvas.update();
  mainCanvas.show();
  popMatrix();

  if (!paused)
    menu.update();
  menu.show();

  //draw new piece
  if (isNewPiece) {
    if (!paused) {
      newPiece.update();
      newPiece.show();
    } else { //draw pause menu for loading IN/OUT
      //insert no. of ports menu
      noStroke();
      fill(0, 200);
      rect(0, 0, width, height);

      fill(255);
      textSize(25);
      textAlign(CENTER);
      text("INSERT NUMBER OF PORTS:\n\n\nPRESS ENTER TO CONFIRM", width/2, height/2);
      textMenu.show();
    }
  }

  //draw menu for saving
  if (paused && saving) {
    noStroke();
    fill(0, 200);
    rect(0, 0, width, height);

    fill(255);
    textSize(25);
    textAlign(CENTER);
    text("NAME THE PIECE:\n\n\nPRESS ENTER TO CONFIRM", width/2, height/2);
    textMenu.show();
  }
}

boolean within(float px, float py, float x1, float x2, float y1, float y2) {
  px = map(px, 0, width, 0, width/scale);
  py = map(py, 0, height, 0, height/scale);
  return (px > x1 && px < x2 && py > y1 && py < y2);
}

boolean menuWithin(float px, float py, float x1, float x2, float y1, float y2) {
  return (px > x1 && px < x2 && py > y1 && py < y2);
}

void deleteType(String selectedType) {
  //delete pieces with same name from canvas
  for (int i=0; i<mainCanvas.pieces.size(); i++) {
    Piece pc = mainCanvas.pieces.get(i);
    if (pc.TYPE.equals(selectedType)) {
      i--;

      ArrayList<Connection> connections = new ArrayList<>();
      ArrayList<BigConnection> bigConnections = new ArrayList<>();

      for (Connection cn : mainCanvas.connections)
        if (cn.firstPiece != pc && cn.secondPiece != pc)
          connections.add(cn);

      for (BigConnection cn : mainCanvas.bigConnections)
        if (cn.piece != pc) {
          ArrayList<BigConnection> bigInterConnections = new ArrayList<>();
          for (BigConnection cnn : cn.connections) {
            if (cnn.piece != pc)
              bigInterConnections.add(cnn);
          }
          cn.connections = (ArrayList<BigConnection>)bigInterConnections.clone();
          bigConnections.add(cn);
        }

      mainCanvas.connections = (ArrayList<Connection>)connections.clone();
      mainCanvas.bigConnections = (ArrayList<BigConnection>)bigConnections.clone();
      mainCanvas.pieces.remove(pc);
    }
  }

  //delete file
  for (int i=0; i<files.length; i++)
    if (files[i].matches(selectedType + ".txt")) {
      File F = new File(dir + "/" + files[i]);
      F.delete();

      try {
        F = new File(canv + "/" + files[i]);
        F.delete();
      }
      catch(Exception e) {
        println(e);
      }
    }
}

Canvas loadCanvas(String selectedType) {
  //initialization
  isMakingConnection = false;
  isMovingPiece = false;
  isNewPiece = false;
  nrOfInputs = 0;
  nrOfOutputs = 0;
  movedNodeIndex = -1;
  connectionOriginType = -1;
  hoveredBigConnection = -1;
  currentBigConnection = -1;
  
  Canvas canvas = new Canvas();
  String[] lines = loadStrings(canv + "/" + selectedType + ".txt");

  //read pieces data
  int nrPieces = Integer.parseInt(lines[0]);
  for (int i=0; i<nrPieces; i++) {
    String[] lineComp = lines[i+1].split(" ");

    if (lineComp.length == 3)
      canvas.pieces.add(new LogicGate(lineComp[0], Float.valueOf(lineComp[1]), Float.valueOf(lineComp[2]), canvas));
    else if (lineComp.length == 4)
      canvas.pieces.add(new IO(lineComp[0], Float.valueOf(lineComp[1]), Float.valueOf(lineComp[2]), Integer.valueOf(lineComp[3]), canvas));
  }

  //read connections data
  if (lines.length <= nrPieces+1)
    return canvas;

  int nrConnections = Integer.parseInt(lines[nrPieces+1]);
  for (int i=0; i<nrConnections; i++) {
    String[] lineComp = lines[i+nrPieces+2].split(" ");

    canvas.connections.add(new Connection(canvas.pieces.get(Integer.valueOf(lineComp[0])), Integer.valueOf(lineComp[1]), canvas.pieces.get(Integer.valueOf(lineComp[2])), Integer.valueOf(lineComp[3])));

    String[] lineCon = lines[i+nrPieces+2+nrConnections].split(" ");
    if (lineCon.length < 2)
      continue;
    for (int j=0; j<lineCon.length; j+=2)
      canvas.connections.get(canvas.connections.size()-1).con.add(new PVector(Float.valueOf(lineCon[j]), Float.valueOf(lineCon[j+1])));
  }

  //read big connections data
  for (int i=nrConnections*2 + nrPieces + 2; i<lines.length; i++) {
    String[] lineComp = lines[i].split(" ");
    
    canvas.bigConnections.get(Integer.valueOf(lineComp[0])).addConnection(canvas.bigConnections.get(Integer.valueOf(lineComp[1])));
  }

  canvas.update();
  return canvas;
}
