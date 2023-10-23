Piece[][] pieces = new Piece[9][9];
Text text;

boolean action = false;
ArrayList<PVector> actions = new ArrayList<PVector>();
ArrayList<Piece> removedPieces = new ArrayList<Piece>();

boolean c = false;
boolean c2 = false;
boolean Checkmate = false;
PVector king;
boolean alert = false;
int r, t, textWidth;

//settings
String currentTurn = "W"; // W or B
int res = 100; // size of each cell
int resSide = res/5; // side margin
int seed = 0; // generation preset - 0 or 1
boolean Text = true; //draw text

void settings() {
  if (!Text)
    textWidth = 0;
  else
    textWidth = 400;
  size(res*8 + resSide*2 + textWidth, res*8 + resSide*2);

  r = floor(res * 0.6);
  t = res/5;

  if (Text)
    text = new Text();
}

void setup() {
  colorMode(HSB);
  strokeWeight(1);
  ellipseMode(CENTER);
  textAlign(CENTER);
  textSize(t);

  generate(seed);
}

void draw() {
  background(255);

  //edges
  pushMatrix();
  translate(resSide, 0);
  for (int i=0; i<8; i++) {
    fill((i+1)%2 *70 + 150);
    rect(res*i, 0, res, resSide);
    rect(res*i, res*8 + resSide, res, resSide);

    fill(0);
    text(char(97+i), res*i+res/2, resSide/2 + t/2.5);
    text(char(97+i), res*i+res/2, res*8 + resSide + resSide/2 + t/2.5);
  }
  popMatrix();
  pushMatrix();
  translate(0, resSide);
  for (int i=0; i<8; i++) {
    fill((i+1)%2 *70 + 150);
    rect(0, res*i, resSide, res);
    rect(res*8 + resSide, res*i, resSide, res);

    fill(0);
    text(i+1, resSide/2, res*i+res/2 + 5);
    text(i+1, res*8 + resSide + resSide/2, res*i+res/2 + 5);
  }
  popMatrix();

  fill(150);
  square(0, 0, resSide);
  square(0, res*8 + resSide, resSide);
  square(res*8 + resSide, 0, resSide);
  fill(220);
  square(res*8 + resSide, res*8 + resSide, resSide);

  //board
  pushMatrix();
  translate(resSide, resSide);
  stroke(0);
  for (int y=0; y<8; y++)
    for (int x=0; x<8; x++) {
      fill((x+y) % 2 * 70 + 50);
      square(x*res, y*res, res);
    }

  for (PVector action : actions) {
    if (action.z == 1)
      fill(70, 255, 255, 100);
    else if (action.z == 2 || action.z == 4 || action.z == 5)
      fill(0, 255, 255, 100);
    else if (action.z == 3 || action.z == 6 || action.z == 7)
      fill(200, 255, 255, 100);
    square((action.x-1)*res, (action.y-1)*res, res);
  }
  if (c) {
    fill(50, 255, 255, 100);
    square((king.x-1)*res, (king.y-1)*res, res);
  }

  for (int y=1; y<=8; y++)
    for (int x=1; x<=8; x++)
      if (pieces[x][y] != null)
        pieces[x][y].show();

  if (Checkmate) {
    fill(0, 255, 255, 200);
    square(0, 0, res*8);
    fill(255);
    textSize(60);
    text("You lost!", res*4, res*4);
    textSize(20);
  }
  popMatrix();

  if (Text)
    text.show();
}

void mouseReleased() {
  //menu
  if (mouseX >= width-textWidth) {
    float x = width - textWidth + 40;
    float y = 60;

    if (mouseX >= x && mouseX <= x+180 && mouseY >= y && mouseY <= y+50) {
      if (Checkmate)
        restart();
      else
        if (!alert) {
          alert = true;
        } else {
          alert = false;
          restart();
        }
    }
  } else if (mouseX < width-textWidth && mouseX > resSide && mouseY > resSide && mouseX < res*8+resSide && mouseY < res*8+resSide)
    if (!Checkmate) {
      float mousex = mouseX - resSide;
      float mousey = mouseY - resSide;

      int x = int (mousex / res) + 1;
      int y = int (mousey / res) + 1;

      if (action) {
        for (PVector a : actions)
          if (a.x*res > mousex && (a.x-1)*res < mousex && a.y*res > mousey && (a.y-1)*res < mousey)
            if (a != actions.get(0)) {
              //make copy
              Piece[][] pieces2 = new Piece[9][9];
              for (int i=1; i<=8; i++)
                for (int j=1; j<=8; j++)
                  if (pieces[i][j] != null)
                    pieces2[i][j] = pieces[i][j].get();

              //if not check
              if (!c) {
                performAction(a);

                //find king
                for (int yy=1; yy<=8; yy++)
                  for (int xx=1; xx<=8; xx++)
                    if (pieces[yy][xx] != null && pieces[yy][xx].c != currentTurn && pieces[yy][xx].type == Type.King)
                      if (check(xx, yy)) {
                        c = true;
                        king = new PVector(xx, yy);// for draw
                        checkMate(xx, yy); //king's coord
                      }

                c2 = false;
                for (int yy=1; yy<=8; yy++)
                  for (int xx=1; xx<=8; xx++)
                    if (pieces[yy][xx] != null && pieces[yy][xx].c == currentTurn && pieces[yy][xx].type == Type.King)
                      if (check(xx, yy))
                        c2 = true;

                if (!c2)
                  if (currentTurn == "W")
                    currentTurn = "B";
                  else
                    currentTurn = "W";
              } else { //check case

                performAction(a);

                //check if still in checkmate
                c = false;
                for (int yy=1; yy<=8; yy++)
                  for (int xx=1; xx<=8; xx++)
                    if (pieces[yy][xx] != null && pieces[yy][xx].type == Type.King)
                      if (check(xx, yy))
                        c = true;

                if (c) {
                  //retry
                  //paste copy
                  for (int i=1; i<=8; i++)
                    for (int j=1; j<=8; j++)
                      pieces[i][j] = pieces2[i][j];

                  println("Try again");
                } else {
                  //continue
                  if (currentTurn == "W")
                    currentTurn = "B";
                  else
                    currentTurn = "W";
                }
              }

              if (c2) {
                for (int i=1; i<=8; i++)
                  for (int j=1; j<=8; j++)
                    pieces[i][j] = pieces2[i][j];

                println("Invalid move - check");
              }
            }

        action = false;
        actions = new ArrayList<PVector>();
      } else if (pieces[y][x] != null && pieces[y][x].c == currentTurn) { // && pieces[y][x].c == currentTurn
        action = true;
        actions = moveSet(pieces[y][x].type, x, y);
      }
    }
}

void performAction(PVector a) {
  if (a.z == 9) {
  } else {
    if (a.z !=3 && a.z !=6 && a.z != 7 && a.z != 2) {
      pieces[(int)a.y][(int)a.x] = pieces[(int)actions.get(0).y][(int)actions.get(0).x];
      pieces[(int)actions.get(0).y][(int)actions.get(0).x] = null;

      pieces[(int)a.y][(int)a.x].x = (int)a.x;
      pieces[(int)a.y][(int)a.x].y = (int)a.y;
    }

    if (a.z == 1) {
      for (int y=1; y<=8; y++)
        for (int x=1; x<=8; x++)
          if (pieces[y][x] != null && pieces[y][x] != pieces[(int)a.y][(int)a.x])
            pieces[y][x].second = false;
      if (pieces[(int)a.y][(int)a.x].first) {
        if (pieces[(int)a.y][(int)a.x].first) {
          pieces[(int)a.y][(int)a.x].first = false;
        }
        if (a.y == actions.get(0).y+2 || a.y == actions.get(0).y-2)
          pieces[(int)a.y][(int)a.x].second = true;
      } else if (pieces[(int)a.y][(int)a.x].second)
        pieces[(int)a.y][(int)a.x].second = false;
    } else if (a.z == 2) {
      if (pieces[(int)a.y][(int)a.x].first) {
        pieces[(int)a.y][(int)a.x].first = false;
      }
      removedPieces.add(pieces[(int)a.y][(int)a.x].get());

      pieces[(int)a.y][(int)a.x] = pieces[(int)actions.get(0).y][(int)actions.get(0).x];
      pieces[(int)actions.get(0).y][(int)actions.get(0).x] = null;

      pieces[(int)a.y][(int)a.x].x = (int)a.x;
      pieces[(int)a.y][(int)a.x].y = (int)a.y;
    } else if (a.z ==3) {
      pieces[(int)a.y][(int)a.x].type = Type.Queen;
    } else if (a.z == 4) {
      removedPieces.add(pieces[(int)a.y][(int)a.x+1]);
      pieces[(int)actions.get(0).y][(int)actions.get(0).x+1] = null;
    } else if (a.z == 5) {
      removedPieces.add(pieces[(int)a.y][(int)a.x-1]);
      pieces[(int)actions.get(0).y][(int)actions.get(0).x-1] = null;
    } else if (a.z == 6) {
      pieces[(int)a.y][3] = pieces[(int)a.y][5];
      pieces[(int)a.y][5] = null;

      pieces[(int)a.y][4] = pieces[(int)a.y][1];
      pieces[(int)a.y][1] = null;

      pieces[(int)a.y][3].x = 3;
      pieces[(int)a.y][3].y = (int)a.y;

      pieces[(int)a.y][4].x = 4;
      pieces[(int)a.y][4].y = (int)a.y;

      pieces[(int)a.y][3].first = false;
    } else if (a.z == 7) {
      pieces[(int)a.y][7] = pieces[(int)a.y][5];
      pieces[(int)a.y][5] = null;

      pieces[(int)a.y][6] = pieces[(int)a.y][8];
      pieces[(int)a.y][8] = null;

      pieces[(int)a.y][7].x = 7;
      pieces[(int)a.y][7].y = (int)a.y;

      pieces[(int)a.y][6].x = 6;
      pieces[(int)a.y][6].y = (int)a.y;

      pieces[(int)a.y][3].first = false;
    }
  }
}

boolean check(int x, int y) {
  //for every enemy piece if a move is on the king's tile
  for (int i=1; i<=8; i++)
    for (int j=1; j<=8; j++)
      if (pieces[i][j] != null && pieces[i][j].c != pieces[y][x].c) {
        ArrayList<PVector> act = moveSet(pieces[i][j].type, j, i);
        for (PVector a : act)
          if (a.x == x && a.y == y)
            return true;
      }
  return false;
}

void checkMate(int x, int y) {
  Checkmate = true;

  for (int i=1; i<=8; i++)
    for (int j=1; j<=8; j++)
      if (pieces[i][j] != null && pieces[i][j].c == pieces[y][x].c) {
        //find all pieces of same color as the king
        //get actions
        actions = moveSet(pieces[i][j].type, j, i);
        //try every action
        for (PVector a : actions)if (actions.get(0) != a)
          if (x(a)) {
            //check if moving the piece stops the check
            Checkmate = false;
            return;
          }
      }
}

boolean x(PVector act) {
  //make copy
  Piece[][] pieces2 = new Piece[9][9];
  for (int i=1; i<=8; i++)
    for (int j=1; j<=8; j++)
      if (pieces[i][j] != null)
        pieces2[i][j] = pieces[i][j].get();

  //perform action
  performAction(act);
  if (act.z == 2)
    removedPieces.remove(removedPieces.size()-1);

  //check if still in checkmate
  boolean cc = false;
  for (int yy=1; yy<=8; yy++)
    for (int xx=1; xx<=8; xx++)
      if (pieces[yy][xx] != null && pieces[yy][xx].c == pieces[(int)act.y][(int)act.x].c && pieces[yy][xx].type == Type.King)
        if (check(xx, yy))
          cc = true;

  for (int i=1; i<=8; i++)
    for (int j=1; j<=8; j++)
      pieces[i][j] = pieces2[i][j];

  if (cc)
    return false;
  return true;
}

void generate(int n) {
  if (n==0) {
    Type[][] types = {
      {Type.Rook, Type.Knight, Type.Bishop, Type.Queen, Type.King, Type.Bishop, Type.Knight, Type.Rook},
      {Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn, Type.Pawn},
      {Type.Rook, Type.Knight, Type.Bishop, Type.Queen, Type.King, Type.Bishop, Type.Knight, Type.Rook}
    };

    String[][] colors = {
      {"B", "B", "B", "B", "B", "B", "B", "B"},
      {"B", "B", "B", "B", "B", "B", "B", "B"},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {"W", "W", "W", "W", "W", "W", "W", "W"},
      {"W", "W", "W", "W", "W", "W", "W", "W"}
    };

    for (int i=1; i<=8; i++)
      for (int j=1; j<=8; j++)
        if (types[i-1][j-1] != null && colors[i-1][j-1] != null)
          pieces[i][j] = new Piece(i, j, types[i-1][j-1], colors[i-1][j-1]);
  } else if (n==1) {
    Type[][] types = {
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, Type.Knight, null, Type.Pawn, Type.King},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, Type.Rook, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, Type.Queen, null}
    };

    String[][] colors = {
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, "W", null, "B", "B"},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, "W", null, null},
      {null, null, null, null, null, null, null, null},
      {null, null, null, null, null, null, "W", null}
    };

    for (int i=1; i<=8; i++)
      for (int j=1; j<=8; j++)
        if (types[i-1][j-1] != null && colors[i-1][j-1] != null)
          pieces[i][j] = new Piece(i, j, types[i-1][j-1], colors[i-1][j-1]);
  }
}

void restart() {
  pieces = new Piece[9][9];
  action = false;
  actions = new ArrayList<PVector>();
  removedPieces = new ArrayList<Piece>();

  currentTurn = "W";
  Checkmate = false;

  c = false;
  king = null;

  for (int i=1; i<=100; i++) println();
  generate(0);
}
