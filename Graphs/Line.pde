class Line {
  Node n1, n2;

  Line(Node n1_, Node n2_) {
    n1=n1_;
    n2=n2_;
  }

  void show() {
    stroke(0);
    strokeWeight(1.5);
    line(n1.pos.x, n1.pos.y, n2.pos.x, n2.pos.y);
  }
}
