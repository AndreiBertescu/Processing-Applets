import peasy.*;
PeasyCam cam;
int[][][] grid, oldGrid;
int h = 200;
int res = 10;
int nx=1;

void setup() {
  size(800, 800, P3D);
  cam = new PeasyCam(this, h*2);
  colorMode(HSB);

  grid = new int[h/res][h/res][h/res];

  for (int i=0; i<h/res; i++)
    for (int j=0; j<h/res; j++)
      for (int k=0; k<h/res; k++)
        grid[i][j][k] = floor(random(nx+1));
}

void draw() {
  background(0);

  stroke(100, 255, 255);
  noFill();
  box(h+25, h+25, h+25);
  stroke(0);
  strokeWeight(1);
  //noStroke();
  fill(255);
  translate(int((-h+res)/2), int((-h+res)/2), int((-h+res)/2));

  for (int i=0; i<h/res; i++)
    for (int j=0; j<h/res; j++)
      for (int k=0; k<h/res; k++)
        if (grid[i][j][k]>0) {
          pushMatrix();
          translate(i*res, j*res, k*res);
          fill(map(grid[i][j][k], 0, nx, 50, 250));
          box(res, res, res);
          popMatrix();
        }

  update();
}

void update() {
  oldGrid = grid;
  grid = new int[h/res][h/res][h/res];

  for (int i=1; i<h/res-1; i++)
    for (int j=1; j<h/res-1; j++)
      for (int k=1; k<h/res-1; k++) {

        int nr=0;

        for (int ii=i-1; ii<=i+1; ii++)
          for (int jj=j-1; jj<=j+1; jj++)
            for (int kk=k-1; kk<=k+1; kk++)
              if (ii!=i || jj!=j || kk!=k)
                if (oldGrid[ii][jj][kk]!=0)
                  nr++;

        //if (oldGrid[i][j][k]>0)
        //  grid[i][j][k] = oldGrid[i][j][k]-1;

        if (oldGrid[i][j][k]==1) {
          boolean alive=false;
          for (int h=13; h<=26; h++)
            if (nr==h) {
              alive=true;
              break;
            }
          if (alive)
            grid[i][j][k]=1;
          else
            grid[i][j][k]=0;
        }

        if (oldGrid[i][j][k]==0) {
          boolean dead=false;
          for (int h=13; h<=14; h++)
            if (nr==h) {
              dead=true;
              break;
            }
          for (int h=17; h<=19; h++)
            if (nr==h) {
              dead=true;
              break;
            }

          if (dead)
            grid[i][j][k]=1;
          else
            grid[i][j][k]=0;
        }
        //noLoop();
      }
}

void mousePressed() {
  //loop();
}
