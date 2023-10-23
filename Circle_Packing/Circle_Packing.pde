ArrayList<Circle> grid = new ArrayList<>();
PImage img;
int nr;
boolean done = false;

//settings
String imageName = "img.jpg";
int res = 1000; // no. of circles - 1-1000
int maxiter = 1000; // max no. of tries to place new circle

void setup() {
  size(1920, 1080);

  try {
    img = loadImage("data/" + imageName);
    img.resize(width, height);
    img.loadPixels();
  }
  catch(Exception e) {
    println("Image not found!");
    exit();
  }
  clear();
}

void draw() {
  background(0);
  for (Circle c : grid) {
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
  save("data/Circle.jpg");
  noLoop();
}
