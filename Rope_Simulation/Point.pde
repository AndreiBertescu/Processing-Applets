class Point {
  int r = 15;
  PVector pos, prevpos, aux;
  boolean locked = false;

  Point(PVector pos) {
    this.pos = pos.copy();
    this.prevpos = pos.copy();
  }
  
  Point(PVector pos, boolean locked) {
    this.pos = pos.copy();
    this.prevpos = pos.copy();
    this.locked = locked;
  }

  void update() {
    aux = pos.copy();
    pos.add(pos.copy().sub(prevpos.copy()));
    pos.add(g);
    prevpos = aux.copy();
  }

  void show() {
    strokeWeight(1);
    stroke(0);

    if (locked)
      fill(255, 0, 0);
    else
      fill(255);

    ellipseMode(CENTER);
    circle(pos.x, pos.y, r);
  }
}
