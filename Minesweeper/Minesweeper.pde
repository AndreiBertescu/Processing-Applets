Box[][] grid=new Box[100][100];
PFont f;
int i, j, n;
boolean lost, won;

//settings
int w=25; //cell width
int chance=14;//difficulty(the probability that every cell contains a mine) 14=default 20=hard

void setup() {
  size(600, 600);
  lost=false;
  won=false;
  f = createFont("calibri", 16, true);
  background(255);
  generate();
}

void draw() {
  if (!lost && !won) {
    won=true;
    for (i=0; i<n; i++)
      for (j=0; j<n; j++) {
        if ((!grid[i][j].shown && grid[i][j].state!=9) && (!grid[i][j].flag && grid[i][j].state!=9))
          won=false;
        grid[i][j].show();
      }
  } else if (lost) {
    fill(255, 0, 0, 2);
    rect(0, 0, width, height);
    textAlign(CENTER);
    fill(255);
    textFont(f, 45);
    text("You Lost!", width/2-6, height/2);
  } else if (won) {
    fill(0, 255, 0, 6);
    rect(0, 0, width, height);
    textAlign(CENTER);
    fill(255);
    textFont(f, 45);
    text("You Won!!!", width/2-6, height/2);
  }
}

public void mouseReleased(MouseEvent e) {
  if (mouseButton == LEFT) {
    if (lost || won)
      setup();
    else {
      for (i=0; i<n; i++)
        for (j=0; j<n; j++)
          if (mouseX>=grid[i][j].x && mouseX<grid[i][j].x+grid[i][j].w && mouseY>=grid[i][j].y && mouseY<grid[i][j].y+grid[i][j].w && !grid[i][j].flag) {
            if (grid[i][j].state==9)
              lost=true;
            else if (grid[i][j].state==0)
              floodFill(i, j);
            else
              grid[i][j].shown=true;
          }
    }
  } else if (mouseButton == RIGHT) {
    for (i=0; i<n; i++)
      for (j=0; j<n; j++)
        if (mouseX>=grid[i][j].x && mouseX<grid[i][j].x+grid[i][j].w && mouseY>=grid[i][j].y && mouseY<grid[i][j].y+grid[i][j].w)
          if (grid[i][j].flag)
            grid[i][j].flag=false;
          else
            grid[i][j].flag=true;
  }
}

void generate() {
  n=(width-w*2)/w;
  int nr=0;

  for (i=0; i<n; i++)
    for (j=0; j<n; j++) {
      grid[i][j]=new Box(w+w*i, w+w*j, w);
      if (random(100)>100-chance)
        grid[i][j].state=9;
    }

  for (i=0; i<n; i++)
    for (j=0; j<n; j++) {
      for (int x=-1; x<=1; x++)
        for (int y=-1; y<=1; y++) {
          int X=i+x;
          int Y=j+y;
          if (X>=0 && X<n && Y>=0 && Y<n && grid[i][j].state!=9 && grid[X][Y].state==9)
            nr++;
        }
      if (nr!=0)
        grid[i][j].state=nr;
      nr=0;
    }
}

void floodFill(int i, int j) {
  for (int x=-1; x<=1; x++)
    for (int y=-1; y<=1; y++) {
      int X=i+x;
      int Y=j+y;
      if (X>=0 && X<n && Y>=0 && Y<n)
        if (grid[X][Y].state!=9 && !grid[X][Y].shown) {
          grid[X][Y].shown=true;
          if (grid[X][Y].state==0)
            floodFill(X, Y);
        }
    }
}
