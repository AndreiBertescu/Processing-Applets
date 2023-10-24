float[][][] grid;
int time=0, res=10;
int x = res/2, layers = 2;
Player player;

//settings
//press wasd to move around
//left/right click to  increase/decrease time
color walkable = color(18, 161, 67); //grass color

void setup() {
  size(800, 800);
  noiseSeed((int)random(1000));

  grid = new float[layers][width/res+1][height/res+1];

  background(18, 125, 161);
  noFill();
  noStroke();
  for (int k=0; k<layers; k++)
    for (int i=0; i<=width/res; i++)
      for (int j=0; j<=height/res; j++) {
        grid[k][i][j]=round(noise(i*res*0.005, j*res*0.005, time*0.0004) - 0.15*k + 0.05);
        render(grid[k], i, j, k);
      }

  player = new Player();
}

void draw() {
  background(18, 125, 161);
  noFill();
  noStroke();

  for (int k=0; k<layers; k++)
    for (int i=0; i<=width/res; i++)
      for (int j=0; j<=height/res; j++) {
        grid[k][i][j]=round(noise(i*res*0.005, j*res*0.005, time*0.0004) - 0.15*k + 0.05);
        render(grid[k], i, j, k);
      }

  loadPixels();
  player.update();
  player.show();

  //time++;
}

void render(float[][] grid, int i, int j, int k) {
  float coffset1 = map(10*k, 0, 10*layers, 0, 100-18);
  float coffset2 = map(10*k, 0, 10*layers, 0, 100-161);
  float coffset3 = map(10*k, 0, 10*layers, 0, 100-67);

  pushMatrix();
  translate(i*res, j*res);
  if (i<width/res && j<height/res) {
    fill(18+coffset1, 161+coffset2, 67+coffset3);

    if (grid[j][i]==0 && grid[j][i+1]==0 && grid[j+1][i]==1 && grid[j+1][i+1]==0) {//1
      triangle(0, x, x, res, 0, res);
      sand(0, x, x, res);
    }
    if (grid[j][i]==0 && grid[j][i+1]==0 && grid[j+1][i]==0 && grid[j+1][i+1]==1) {//2
      triangle(res, x, x, res, res, res);
      sand(res, x, x, res);
    }
    if (grid[j][i]==0 && grid[j][i+1]==0 && grid[j+1][i]==1 && grid[j+1][i+1]==1) {//3
      beginShape();
      vertex(0, x);
      vertex(res, x);
      vertex(res, res);
      vertex(0, res);
      endShape();
      sand(0, x, res, x);
    }
    if (grid[j][i]==0 && grid[j][i+1]==1 && grid[j+1][i]==0 && grid[j+1][i+1]==0) {//4
      triangle(x, 0, res, x, res, 0);
      sand(x, 0, res, x);
    }
    if (grid[j][i]==0 && grid[j][i+1]==1 && grid[j+1][i]==1 && grid[j+1][i+1]==0) {//5
      beginShape();
      vertex(x, 0);
      vertex(res, 0);
      vertex(res, x);
      vertex(x, res);
      vertex(0, res);
      vertex(0, x);
      endShape();
      sand(x, 0, 0, x);
      sand(res, x, x, res);
    }
    if (grid[j][i]==0 && grid[j][i+1]==1 && grid[j+1][i]==0 && grid[j+1][i+1]==1) {//6
      beginShape();
      vertex(x, 0);
      vertex(x, res);
      vertex(res, res);
      vertex(res, 0);
      endShape();
      sand(x, 0, x, res);
    }
    if (grid[j][i]==0 && grid[j][i+1]==1 && grid[j+1][i]==1 && grid[j+1][i+1]==1) {//7
      beginShape();
      vertex(0, x);
      vertex(x, 0);
      vertex(res, 0);
      vertex(res, res);
      vertex(0, res);
      endShape();
      sand(0, x, x, 0);
    }
    if (grid[j][i]==1 && grid[j][i+1]==0 && grid[j+1][i]==0 && grid[j+1][i+1]==0) {//8
      triangle(x, 0, 0, x, 0, 0);
      sand(x, 0, 0, x);
    }
    if (grid[j][i]==1 && grid[j][i+1]==0 && grid[j+1][i]==1 && grid[j+1][i+1]==0) {//9
      beginShape();
      vertex(x, 0);
      vertex(x, res);
      vertex(0, res);
      vertex(0, 0);
      endShape();
      sand(x, 0, x, res);
    }
    if (grid[j][i]==1 && grid[j][i+1]==0 && grid[j+1][i]==0 && grid[j+1][i+1]==1) {//10
      beginShape();
      vertex(0, 0);
      vertex(x, 0);
      vertex(res, x);
      vertex(res, res);
      vertex(x, res);
      vertex(0, x);
      endShape();
      sand(x, 0, res, x);
      sand(x, res, 0, x);
    }
    if (grid[j][i]==1 && grid[j][i+1]==0 && grid[j+1][i]==1 && grid[j+1][i+1]==1) {//11
      beginShape();
      vertex(x, 0);
      vertex(res, x);
      vertex(res, res);
      vertex(0, res);
      vertex(0, 0);
      endShape();
      sand(x, 0, res, x);
    }
    if (grid[j][i]==1 && grid[j][i+1]==1 && grid[j+1][i]==0 && grid[j+1][i+1]==0) {//12
      beginShape();
      vertex(0, x);
      vertex(res, x);
      vertex(res, 0);
      vertex(0, 0);
      endShape();
      sand(0, x, res, x);
    }
    if (grid[j][i]==1 && grid[j][i+1]==1 && grid[j+1][i]==1 && grid[j+1][i+1]==0) {//13
      beginShape();
      vertex(res, x);
      vertex(x, res);
      vertex(0, res);
      vertex(0, 0);
      vertex(res, 0);
      endShape();
      sand(res, x, x, res);
    }
    if (grid[j][i]==1 && grid[j][i+1]==1 && grid[j+1][i]==0 && grid[j+1][i+1]==1) {//14
      beginShape();
      vertex(0, x);
      vertex(x, res);
      vertex(res, res);
      vertex(res, 0);
      vertex(0, 0);
      endShape();
      sand(0, x, x, res);
    }
    if (grid[j][i]==1 && grid[j][i+1]==1 && grid[j+1][i]==1 && grid[j+1][i+1]==1) //15
      square(0, 0, res);
  }
  popMatrix();
}

void sand(int x1, int y1, int x2, int y2) {
  stroke(198, 204, 112);
  strokeWeight(2);
  line(x1, y1, x2, y2);
  noStroke();
}

void mousePressed() {
  if (mouseButton == LEFT)
    time+=60;
  else if (mouseButton == RIGHT)
    time-=60;
    
  if (!(pixels[player.y*width+player.x]==walkable && pixels[player.y*width+player.x+player.r]==walkable && pixels[player.y*width+player.x-player.r]==walkable &&
    pixels[(player.y+player.r)*width+player.x]==walkable && pixels[(player.y-player.r)*width+player.x]==walkable)) {
    player = new Player();
    fill(0);
    rect(0, 0, width, height);
  }
}

void keyPressed() {
  if (keyCode == 87) {
    player.up=true;
  }
  if (keyCode == 83) {
    player.down=true;
  }
  if (keyCode == 65) {
    player.left=true;
  }
  if (keyCode == 68) {
    player.right=true;
  }
}

void keyReleased() {
  if (keyCode == 87) {
    player.up=false;
  }
  if (keyCode == 83) {
    player.down=false;
  }
  if (keyCode == 65) {
    player.left=false;
  }
  if (keyCode == 68) {
    player.right=false;
  }
}
