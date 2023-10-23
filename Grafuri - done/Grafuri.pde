ArrayList<Node> nodes;
ArrayList<Line> lines;
Text text;

Node prevN;
boolean line=false, move=false;
int prev;

//settings
int r = 30;
int w = 300;

void setup() {
  size(800, 800);
  ellipseMode(CENTER);

  nodes = new ArrayList<Node>();
  lines = new ArrayList<Line>();
  text = new Text();
}

void draw() {
  background(255);
  for (Line l : lines)
    l.show();

  if (line) {
    stroke(0);
    strokeWeight(1.5);
    line(prevN.pos.x, prevN.pos.y, mouseX, mouseY);
  }

  for (Node n : nodes)
    n.show();

  text.show();
}

public void mouseReleased(MouseEvent e) {
  if (mouseX > text.X + 10 && mouseX < width-10 && mouseY > 10 && mouseY < 40)
    setup();

  move = false;
  if (mouseButton == LEFT && node() == null && mouseX+r<text.X) {
    nodes.add(new Node(mouseX, mouseY));
    return;
  }

  if (mouseButton == RIGHT && line) {
    //add line
    line = false;
    Node n = node();

    if (n != null && n != prevN) {
      //if line doesnt exist
      for (Line l : lines)
        if ((l.n1==n && l.n2==prevN) || (l.n2==n && l.n1==prevN))
          return;

      lines.add(new Line(n, prevN));
      return;
    } else if (n == prevN) {
      //remove pressed node
      nodes.remove(n);
      int x = 1;
      for (Node nn : nodes)
        nn.i = x++;

      ArrayList<Line> tempLines = new ArrayList<Line>();
      for (Line l : lines)
        if (l.n1!=n && l.n2!=n)
          tempLines.add(l);
      lines = tempLines;
    }
  }
}

public void mousePressed(MouseEvent e) {
  if (mouseX >= text.X)
    return;

  Node n = node();
  if (n == null)
    return;

  //if pressed on node
  prevN = n;
  if (mouseButton == RIGHT) {
    line=true;
  } else if (mouseButton == LEFT)
    move=true;
}

Node node() {
  for (Node n : nodes)
    if (mouseX>(n.pos.x-r/2) && mouseX<(n.pos.x+r/2) &&
      mouseY>(n.pos.y-r/2) && mouseY<(n.pos.y+r/2))
      return n;

  return null;
}

void mouseDragged() {
  if (move && mouseButton == LEFT) {
    prevN.pos = new PVector(mouseX, mouseY);

    if (mouseX+r/2 > text.X)
      prevN.pos.x = text.X-r/2-1;
    if (mouseX < r/2)
      prevN.pos.x = r/2;

    if (mouseY+r/2 > height)
      prevN.pos.y = height-r/2-1;
    if (mouseY < r/2)
      prevN.pos.y = r/2;
  }
}
