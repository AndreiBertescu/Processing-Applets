QuadTree root;

void setup() {
  size(800, 800);
  stroke(255);
  noFill();

  root = new QuadTree(new PVector(0, 0), width-1, height-1, 0);
  for (int i=0; i<1000; i++)
    root.insert(new PVector(random(width), random(height)));
}

void draw() {
  background(0);
  root.show();

  rect(mouseX-50, mouseY-50, 100, 100);
}

void mouseReleased() {
  if (mouseButton == LEFT)
    for (int i=0; i<1; i++)
      root.insert(new PVector(mouseX, mouseY));
  else if (mouseButton == RIGHT) {
    root.query(new PVector(mouseX, mouseY), 100);
    println(targets);
  }
}
