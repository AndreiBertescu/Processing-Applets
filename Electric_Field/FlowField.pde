class Point {
  PVector pos = new PVector(0, 0);
  PVector[] positions;
  float x, y, len, ang;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
    positions = new PVector[sources.size()];
  }

  void update() {
    for (int i=0; i<sources.size(); i++) {
      ang = atan2(y - sources.get(i).pos.y, x - sources.get(i).pos.x);
      len = (k*sources.get(i).q) / (PVector.dist(new PVector(x, y), sources.get(i).pos)*PVector.dist(new PVector(x, y), sources.get(i).pos));
      positions[i] = new PVector(len * cos(ang), len * sin(ang));
    }

    for (int i=0; i<sources.size(); i++) {
      pos.add(positions[i].copy());
    }

    pos.limit(25);
  }

  void show() {
    line(x, y, x + pos.x, y + pos.y);
  }
}
