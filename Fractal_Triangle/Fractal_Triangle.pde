Triangle t1, t2, t3;

//settings
int iter = 10000; //fractal detail
int w=150; //image offset
boolean single = true; //single triangle or 3 triangles

void setup() {
  size(1920, 1080);
  background(20);
  colorMode(HSB);
  strokeWeight(0.5);

  t1 = new Triangle(0, height-w, width/2, 0);
  t2 = new Triangle(width/2, height-w, width/2, 0);
  t3 = new Triangle((int)t1.points[2].x, (int)t1.points[2].y, width/2, 1);
}

void draw() {
  for (int i=0; i<iter; i++) {
    t3.update();
    if (!single) {
      t1.update();
      t2.update();
    }
  }
}

void exit() {
  saveFrame("data/Triangle.jpg");
  super.exit();
}
