int[][] grid;
int dir;
int len;
int posx, posy;
int state;

//settings
//use wasd keys to move
int n = 32; //cells no.
int dt = 5; //timestep(speed - framerate/dt)

void setup() {
  textAlign(CENTER);
  size(800, 800);

  dir = 2;
  len = 3;
  state = 0;

  grid = new int[n][n];
  grid[floor(random(n))][floor(random(n))] = -1;

  posx = n/2+1;
  posy = n/2;
  grid[n/2][n/2-1] = len-2;
  grid[n/2][n/2] = len-1;
  grid[n/2][n/2+1] = len;
}

void draw() {
  frameRate(60);
  stroke(40);

  if (state == 1) {
    fill(0, 160, 0);
    square(0, 0, width);
    fill(255);
    textSize(40);
    text("You won!\nPress any key to restart.", width/2, width/2);
    textSize(20);
  } else if (state == 2) {
    fill(160, 0, 0);
    square(0, 0, width);
    fill(255);
    textSize(40);
    text("You lost! - length: " + len + "\nPress any key to restart.", width/2, width/2);
    textSize(20);
  } else if (state == 0) {
    for (int y=0; y<n; y++)
      for (int x=0; x<n; x++) {
        if (grid[y][x] == 0)
          fill(0);
        else if (grid[y][x] > 0)
          fill(0, 200, 0);
        else
          fill(200, 0, 0);
        if (grid[y][x] == len)
          fill(0, 255, 0);

        square(x * width/n, y * width/n, width/n);
      }

    if (frameCount % dt == 0)
      update();
  }
}

void update() {
  //food
  boolean exis = false;
  for (int y=0; y<n; y++)
    for (int x=0; x<n; x++)
      if (grid[y][x] == -1)
        exis = true;

  if (!exis) {
    int x=0, y=0;
    while (true) {
      x = floor(random(n));
      y = floor(random(n));
      if (grid[y][x] == 0)
        break;
    }
    grid[y][x] = -1;
  }

  //snake
  int lastx=0, lasty=0;
  for (int y=0; y<n; y++)
    for (int x=0; x<n; x++)
      if (grid[y][x] > 0) {
        if (grid[y][x] == 1) {
          lastx = x;
          lasty = y;
        }
        grid[y][x]--;
      }

  if (dir == 1)
    posy--;
  else if (dir == 2)
    posx++;
  else if (dir == 3)
    posy++;
  else if (dir == 4)
    posx--;

  //check if lost
  if (posx == n || posx == -1 || posy == n || posy == -1 || grid[posy][posx] > 0) {
    state = 2;
    return;
  }

  //if eaten food
  if (grid[posy][posx] == -1) {
    len++;
    for (int y=0; y<n; y++)
      for (int x=0; x<n; x++)
        if (grid[y][x] > 0)
          grid[y][x]++;
    grid[lasty][lastx]++;
  }

  //if won
  if (len == n*n) {
    state = 1;
    return;
  }

  //move
  grid[posy][posx] = len;
}

void keyPressed() {
  if (key == 'w' && dir != 3)
    dir = 1;
  else if (key == 'd' && dir != 4)
    dir = 2;
  else if (key == 's' && dir != 1)
    dir = 3;
  else if (key == 'a' && dir != 2)
    dir = 4;
  else if (key == 'q')
    len = n*n-1;
  else
    setup();
}
