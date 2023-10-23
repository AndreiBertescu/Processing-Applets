Point[] fieldPoints;
final float k = 0.9E10;
ArrayList<Source> sources;
Source draggingSource = null;

//settings
int nrPoints = 10000;

void setup() {
  size(1000, 1000);

  sources = new ArrayList();
  sources.add(new Source(300, 500, 2E-3));
  sources.add(new Source(700, 500, -2E-3));
  sources.add(new Source(500, 300, 3E-4));
  sources.add(new Source(500, 700, -1E-4));

  fieldPoints = new Point[nrPoints];
  for (int i=0; i<nrPoints; i++)
    fieldPoints[i] = new Point(random(width), random(height));
}

void draw() {
  background(255);
  strokeWeight(0.5);
  stroke(50);
  noFill();
  
  if (draggingSource != null)
    draggingSource.pos = new PVector(mouseX, mouseY);

  for (int i=0; i<nrPoints; i++) {
    fieldPoints[i].update();
    fieldPoints[i].show();
  }
  for (Source s : sources) {
    strokeWeight(1);
    stroke(255, 0, 0);
    circle(s.pos.x, s.pos.y, 25);
  }
}

void mousePressed() {
  for (Source s : sources)
    if (dist(mouseX, mouseY, s.pos.x, s.pos.y) < 25)
      draggingSource = s;
}

void mouseReleased() {
  draggingSource = null;
}

void exit() {
  saveFrame("data/FlowFields.jpg");
  println("Saved!");
  super.exit();
}
