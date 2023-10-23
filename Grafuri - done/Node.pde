class Node {
  int i;
  PVector pos;

  Node(int x, int y) {
    pos = new PVector(x, y);
    i = nodes.size()+1;
  }

  void show() {
    textAlign(CENTER);
    fill(255);
    strokeWeight(1);
    stroke(0);
    ellipse(pos.x, pos.y, r, r);

    fill(0);
    text(i, pos.x, pos.y+6);
  }
}
