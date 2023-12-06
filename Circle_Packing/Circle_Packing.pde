ArrayList<Circle> grid = new ArrayList<>();
PImage img;
int nr;
boolean done = false;

color[] pallete;

//SETTINGS
String imageName = "img.jpg";
int res = 90; // no. of circles - 1-1000
int maxiter = 1000; // max no. of tries to place new circle
boolean image = false; //use an image or use Perlin noise
float ress = 0.008; //noise resolution

void setup() {
  fullScreen();
  ellipseMode(RADIUS);

  pallete = new color[5];
  //pallete[0] = color(#0C1618);
  //pallete[1] = color(#004643);
  //pallete[2] = color(#FAF4D3);
  //pallete[3] = color(#D1AC00);
  //pallete[4] = color(#F6BE9A);

  pallete[0] = color(#2E4057);
  pallete[1] = color(#E3D985);
  pallete[2] = color(#9A1436);
  pallete[3] = color(#2EC4B6);
  pallete[4] = color(#FF785A);

  if (image)
  try {
    img = loadImage("data/" + imageName);
    img.resize(width, height);
    img.loadPixels();
  }
  catch(Exception e) {
    println("Image not found!");
    exit();
  }

  background(255);
}

void draw() {
  for (Circle c : grid)
    if (c.possible) {
      c.update();
      c.show();
    }

  for (int i=0; i<res; i++) {
    newCircle();
    if (done)
      return;
  }
}

void newCircle() {
  int iter = 0;

  while (++iter < maxiter) {
    int x = (int)random(width);
    int y = (int)random(height);

    boolean poss=true;
    for (Circle c : grid)
      if (dist(x, y, c.x, c.y)<=c.r+2) {
        poss = false;
        break;
      }

    if (poss) {
      grid.add(new Circle(x, y));
      return;
    }
  }

  println("Done!");
  done = true;
  save("data/Circle.png");
  noLoop();
}

void exit() {
  save("data/Circle.png");

  super.exit();
}
