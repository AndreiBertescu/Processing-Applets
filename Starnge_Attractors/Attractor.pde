class Particle {
  ArrayList<PVector> points = new ArrayList<PVector>();
  double dx, dy, dz, x, y, z;
  float a, b, c, d, e, f;
  int nr;

  Particle(double x, double y, double z, int type) {
    this.x = x;
    this.y = y;
    this.z = z;

    switch(type) {
      case(1):
      a = 28.0;
      b = 10.0;
      c = 8.0 / 3.0;
      break;
      case(2):
      b = 0.19;
      break;
      case(3):
      a = 32.48;
      b = 45.84;
      c = 1.18;
      d = 0.13;
      e = 0.57;
      f = 14.7;
      break;
    }
  }

  void update() {
    switch(type) {
      case(1):
      dx = (b * (y-x)) * dt;
      dy = (x * (a-z) - y) * dt;
      dz = (x*y - c*z) * dt;
      break;
      case(2):
      dx = (sin((float)y) - b*x) * dt;
      dy = (sin((float)z) - b*y) * dt;
      dz = (sin((float)x) - b*z) * dt;
      break;
      case(3):
      dx = (a*(y-x) + d*x*z) * dt;
      dy = (b*x - x*z + f*y) * dt;
      dz = (c*z + x*y - e*x*x) * dt;
      break;
    }

    x += dx;
    y += dy;
    z += dz;

    points.add(new PVector((float)x, (float)y, (float)z));
  }

  void show() {
    nr=0;
    beginShape();
    for (PVector v : points) {
      stroke((nr++)%255, 255, 255);

      vertex(v.x, v.y, v.z-5);
    }
    endShape();

    if (type != 1)
      return;

    nr=0;
    beginShape();
    for (PVector v : points) {
      stroke((nr++)%255, 255, 255);

      vertex(v.x, v.y, -v.z+5);
    }
    endShape();
  }
}
