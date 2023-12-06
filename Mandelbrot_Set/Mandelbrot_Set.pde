float minAxis, axisOffsetx, axisOffsety;
float offsetx = 0, offsety = 0, offx = 0, offy = 0, scale = 1;
boolean isLooping = true;
Chunk[][] chunks;
byte[][] pixls;
color c1, c2;

////////////////SETINGS
//use left/right click to increase/decrease zoom
//use wasd keys to move arond
//use shift + wasd keys to move around faster
int maxIter = 2500;             //max iterations to check if complex number escaped
int threads = 3;                //ammount of threads per horizontal line - total ammount id squared
float moveAmount = 10;          //ammount to move the offset
float zoomAmount = 0.3;         //values between 0-1 the percentage to increase/decrease the scale
boolean blackAndWhite = false;  //choose whether the fractal is black and white, or colored
int imageDefinition = 15;       //the detail rendered - lower value -> higher definiton
int type = 0;                   // 0 - Mandelbrot Set / 1- Julia Set

void setup() {
  //size(1000, 1000);
  fullScreen();
  colorMode(HSB);

  c2 = color(map(121, 0, 360, 0, 255), 255, 50*2.55);
  c1 = color(map(69, 0, 360, 0, 255), 255, 100*2.55);

  //Mandelbrot
  offx = 18373.197;
  offy = 4128.673;
  offsetx = -1020.0;
  offsety = -6780.0;
  scale = 21.201246;

  //Julia
  //offx = 22906.152;
  //offy = 11840.96;
  //offsetx = 1500;
  //offsety = -200;
  //scale = 23.298075;

  minAxis = min(width, height);
  pixls = new byte[width][height];

  chunks = new Chunk[threads][threads];
}

void draw() {
  if (!isLooping)
    return;

  if (minAxis == height) {
    axisOffsetx = -abs(width-height)/2 + offx;
    axisOffsety = offy;
  } else {
    axisOffsetx =  offx;
    axisOffsety = -abs(width-height)/2 + offy;
  }

  //draw function
  background(255);

  for (int i=0; i<threads; i++)
    for (int j=0; j<threads; j++) {
      if (chunks[i][j] != null)
        chunks[i][j].interrupt();
      chunks[i][j] = new Chunk(width/threads * i, width/threads * (i+1), height/threads * j, height/threads * (j+1));
    }

  println(offx, offy, offsetx, offsety, scale);

  isLooping = false;
}

public void mouseReleased() {
  if (mouseButton == RIGHT)
    scale *= 1 - zoomAmount;
  else if (mouseButton == LEFT)
    scale *= 1 + zoomAmount;

  offx = (width/2) * (scale-1) + offsetx;
  offy = (height/2) * (scale-1) + offsety;

  isLooping = true;
}

public void keyReleased() {
  switch(key) {
  case 'W':
    offsety -= moveAmount;
    offy -= moveAmount;
    break;
  case 'A':
    offsetx -= moveAmount;
    offx -= moveAmount;
    break;
  case 'S':
    offsety += moveAmount;
    offy += moveAmount;
    break;
  case 'D':
    offsetx += moveAmount;
    offx += moveAmount;
    break;
  case 'w':
    offsety -= moveAmount * 10;
    offy -= moveAmount * 10;
    break;
  case 'a':
    offsetx -= moveAmount * 10;
    offx -= moveAmount * 10;
    break;
  case 's':
    offsety += moveAmount * 10;
    offy += moveAmount * 10;
    break;
  case 'd':
    offsetx += moveAmount * 10;
    offx += moveAmount * 10;
    break;
  default:
    return;
  }

  isLooping = true;
}

void exit() {
  if (type == 0)
    saveFrame("data/MandelbrotSet.png");
  else if (type == 1)
    saveFrame("data/JuliaSet.png");
  else
    saveFrame("data/Fractal.png");
  super.exit();
}
