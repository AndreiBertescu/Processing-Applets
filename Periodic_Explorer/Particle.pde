class Particle {

  float r;
  PVector pos, vel;
  boolean isFixed = false;
  int nr = 0;

  Particle(float r, PVector pos) {
    this.r = r;
    this.pos = pos;
    this.vel = new PVector();
  }

  void update() {
    if (centerP == this)
      return;

    if (nr < 200)
      pos.add(PVector.sub(centerP.pos, this.pos).mult(dtNucleus));

    for (Particle p : nucleus)
      if (p != this && PVector.dist(p.pos, this.pos)+r/8 < 2*r && nr++ >= 0)
        if (p != centerP) {
          pos.sub(PVector.sub(p.pos, this.pos).mult(dtNucleus/2));
          p.pos.add(PVector.sub(p.pos, this.pos).mult(dtNucleus/2));
        } else
          pos.sub(PVector.sub(p.pos, this.pos).mult(dtNucleus/2));
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(r);
    popMatrix();
  }
}
