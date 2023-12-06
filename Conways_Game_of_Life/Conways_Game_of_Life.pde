short[][] grid, oldGrid;
boolean paused = false;

//SETTINGS
//press space to pause
//press w to update grid once
//left click to resurect cell
//right click to kill cell
int res=6; //screen pixel resolution - each cell is res pixels long

void setup() {
  size(1920, 1080);
  noStroke();

  grid = new short[height/res][width/res];
  for (int y=0; y<height/res; y++)
    for (int x=0; x<width/res; x++)
      grid[y][x] = (short)(random(2)); // 0 or 1
}

void draw() {
  background(30);
  if (!paused)
    update();
  if (mousePressed)
    if (mouseButton == RIGHT)
      grid[mouseY/res][mouseX/res] = 0;
    else if (mouseButton == LEFT)
      grid[mouseY/res][mouseX/res] = 1;

  for (int y=0; y<height/res; y++)
    for (int x=0; x<width/res; x++) {
      if (grid[y][x] == 1)
        fill(255);
      else
        noFill();
      square(x*res, y*res, res);
    }
}

void keyPressed() {
  if (key == 'w')
    update();
  else
    paused = !paused;
}

void update() {
  oldGrid = grid;
  grid = new short[height/res][width/res];

  for (int y=1; y<height/res-1; y++)
    for (int x=1; x<width/res-1; x++) {
      int nr=0;

      nr+=oldGrid[y-1][x-1];
      nr+=oldGrid[y-1][x];
      nr+=oldGrid[y-1][x+1];
      nr+=oldGrid[y][x-1];
      nr+=oldGrid[y][x+1];
      nr+=oldGrid[y+1][x-1];
      nr+=oldGrid[y+1][x];
      nr+=oldGrid[y+1][x+1];

      if ((oldGrid[y][x]==0 && nr==3) || (oldGrid[y][x]==1 && (nr==3 || nr==2)))
        grid[y][x] = 1;
      else
        grid[y][x] = 0;
    }
}

void exit() {
  saveFrame("data/Conways_Game_of_Life.png");
  super.exit();
}
