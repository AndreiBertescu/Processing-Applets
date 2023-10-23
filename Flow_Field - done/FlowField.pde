class Point {
  PVector pos;
  PVector p1, p2;
  float ang;

  float len = random(7, 10);

  Point(float x, float y) {
    pos = new PVector(x, y);

    if (type ==1)
      ang = map(noise(pos.x*resx, pos.y*resy), 0, 1, 0, limit);
    else if (type == 2)
      ang = (tan(pos.x*resx)+cos(pos.y*resy))*limit; // resx: 0.01, resy: 0.01, limit: 15, vel: 7
    else if (type == 3)
      ang = (sin(pos.x*resx)+cos(pos.y*resy))*limit; // resx: 0.01, resy: 0.01, limit: 15, vel: 7
    p1 = new PVector(-len*sin(ang), -len*cos(ang));
    p2 = new PVector(len*sin(ang), len*cos(ang));
  }

  void show() {
    stroke(50, 100);
    strokeWeight(0.7);

    pushMatrix();
    translate(pos.x, pos.y);
    line(p1.x, p1.y, p2.x, p2.y);
    popMatrix();
  }
}
