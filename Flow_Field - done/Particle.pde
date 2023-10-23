class Particle {
  PVector pos, prevPos;
  float ang;
  float c;

  Particle(float x, float y) {
    prevPos = new PVector(x, y);
    pos = new PVector(x, y);

    c = map(pos.x, 0, width, 0, 255);
  }

  void update() {
    if (type ==1)
      ang = map(noise(pos.x*resx, pos.y*resy), 0, 1, 0, limit);
    else if (type == 2)
      ang = (tan(pos.x*resx)+cos(pos.y*resy))*limit; // resx: 0.001, resy: 0.01, limit: 15, vel: 7
    else if (type == 3)
      ang = (sin(pos.x*resx)+cos(pos.y*resy))*limit; // resx: 0.01, resy: 0.01, limit: 15, vel: 7
    pos.add(new PVector(sin(ang)*vel, cos(ang)*vel));
  }

  void show() {
    stroke(c, 255, 255, 150);
    strokeWeight(0.2);

    line(pos.x, pos.y, prevPos.x, prevPos.y);

    prevPos = pos.copy();
  }
}
