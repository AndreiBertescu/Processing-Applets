class Boid {
  PVector pos, vel, acc;
  ArrayList<Boid> targets;
  int id = 0;

  Boid() {
    acc = new PVector();
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D().setMag(random(1.5, maxVel));
  }

  void update() {
    targets = new ArrayList<Boid>();

    for (int i=-1; i<=1; i++)
      for (Boid b : h.get(id+i))
        if (PVector.dist(pos, b.pos)<drawDist && b!=this)
          targets.add(b);

    if (id > resx+1)
      for (int i=-1; i<=1; i++)
        for (Boid b : h.get(id-resx-1+i))
          if (PVector.dist(pos, b.pos)<drawDist && b!=this)
            targets.add(b);

    if (id < (resx+1)*(resy+1) - (resx+1))
      for (int i=-1; i<=0; i++)
        for (Boid b : h.get(id+resx+1+i))
          if (PVector.dist(pos, b.pos)<drawDist && b!=this)
            targets.add(b);

    maxN = max(targets.size(), maxN);

    acc.add(separate());
    acc.add(align());
    acc.add(cohesion());

    if (pos.x<-r) pos.x = width+r;
    if (pos.y<-r) pos.y = height+r;
    if (pos.x>width+r) pos.x = -r;
    if (pos.y>height+r) pos.y = -r;
  }

  void show() {
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc.mult(0);

    noStroke();
    fill(144-map(targets.size()*1.3, 0, maxN, 0, 255), 255, 255);

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading()+PI/2);
    triangle(0, -r*1.5, -r, r*2, r, r*2);
    popMatrix();
  }

  PVector separate() {
    PVector force = new PVector();
    PVector diff = new PVector();

    if (targets.size()>0) {
      for (Boid b : targets) {
        diff = PVector.sub(pos, b.pos);
        diff.normalize();
        diff.div(PVector.dist(pos, b.pos));

        force.add(diff);
      }

      force.div(float(targets.size()));
      force.setMag(maxVel);
      force.sub(vel);
      force.limit(maxForce);
    }

    return force.mult(sep);
  }

  PVector align() {
    PVector force = new PVector();

    if (targets.size()>0) {
      for (Boid b : targets)
        force.add(b.vel);

      force.div(float(targets.size()));
      force.setMag(maxVel);
      force.sub(vel);
      force.limit(maxForce);
    }

    return force.mult(alg);
  }

  PVector cohesion() {
    PVector force = new PVector();
    PVector avPos = new PVector();
    PVector diff = new PVector();

    if (targets.size()>0) {
      for (Boid b : targets)
        avPos.add(b.pos);

      avPos.div(targets.size());

      diff = PVector.sub(avPos, pos);
      diff.setMag(maxVel);

      force = PVector.sub(diff, vel);
      force.limit(maxForce);
    }

    return force.mult(chs);
  }
}
