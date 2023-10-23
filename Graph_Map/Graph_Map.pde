Node[] nodes;

//settings
int n = 300; //nr. of nodes
int r = 1;
int str = 2;
int nr = 6;  //max nr. of connections
boolean Color = true;  //make connections color/black and white

void setup() {
  size(1920, 1080);
  ellipseMode(CENTER);
  colorMode(HSB);
  strokeWeight(str);
  stroke(255, 150);
  fill(255, 250);

  nodes = new Node[n];
  for (int i=0; i<n; i++)
    nodes[i] = new Node(new PVector(random(width), random(height)), i);
}

void draw() {
  background(50);

  for (Node n : nodes) {
    n.update();
    n.showLines();
  }
  for (Node n : nodes)
    n.showCircles();
}

void exit() {
  save("data/GraphMap.jpg");
  super.exit();
}
