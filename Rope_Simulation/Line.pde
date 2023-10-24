class Line {
  Point p1, p2;
  PVector center, dir;
  float l;

  Line(Point p1, Point p2) {
    this.p1 = p1;
    this.p2 = p2;
    l = PVector.dist(p1.pos.copy(), p2.pos.copy())/2;
  }

  void update() {
    center = (p1.pos.copy().add(p2.pos.copy())).div(2);
    dir = (p1.pos.copy().sub(p2.pos.copy())).normalize();

    if (!p1.locked)
      p1.pos = center.copy().add(dir.copy().mult(l));
    if (!p2.locked)
      p2.pos = center.copy().sub(dir.copy().mult(l));
  }

  void show() {
    stroke(0);
    strokeWeight(1.5);
    line(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
  }
}
