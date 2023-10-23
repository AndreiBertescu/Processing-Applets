Point[] fieldPoints;
final float k = 0.9E10;

//settings
int nrPoints = 50000;
ArrayList<Source> sources;

void setup() {
  size(1000, 1000);
  colorMode(HSB);

  sources = new ArrayList();
  sources.add(new Source(300, 500, 2E-4));
  sources.add(new Source(700, 500, -2E-4));
  //sources.add(new Source(500, 300, 3E-4));
  //sources.add(new Source(500, 700, -1E-4));

  fieldPoints = new Point[nrPoints];
  for (int i=0; i<nrPoints; i++)
    fieldPoints[i] = new Point(random(width), random(height));

  noLoop();
  background(255);
  strokeWeight(0.5);
  stroke(0, 150);
  
  for (int i=0; i<nrPoints; i++)
    fieldPoints[i].show();
}

void draw() {
}

void keyReleased() {
  //paused = !paused;
}

void exit() {
  //save("FlowFields.tiff");
}
