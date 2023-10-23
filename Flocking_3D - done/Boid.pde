class Boid {
  PVector pos, vel, acc;
  ArrayList<Boid> targets;
  int nr = 0;
  int id = 0;

  Boid() {
    acc = new PVector();
    pos = new PVector(random(size), random(size), random(size));
    vel = PVector.random3D().setMag(random(1.5, maxVel));
  }

  void update() {
    targets = new ArrayList<Boid>();

    for (int i=-1; i<=1; i++)
      for (Boid b : h.get(id+i))
        if (PVector.dist(pos, b.pos)<drawDist && b!=this)
          targets.add(b);

    if ((id-1)%(aux*aux) >= aux)
      for (Boid b : h.get(id-aux))
        if (PVector.dist(pos, b.pos)<drawDist && b!=this)
          targets.add(b);

    if ((id-1)%(aux*aux) < aux*(aux-1))
      for (Boid b : h.get(id+aux))
        if (PVector.dist(pos, b.pos)<drawDist && b!=this)
          targets.add(b);

    if (id > aux*aux)
      for (Boid b : h.get(id-aux*aux))
        if (PVector.dist(pos, b.pos)<drawDist && b!=this)
          targets.add(b);

    if (id <= aux*aux*(aux-1))
      for (Boid b : h.get(id+aux*aux))
        if (PVector.dist(pos, b.pos)<drawDist && b!=this)
          targets.add(b);

    maxN = max(maxN, targets.size());

    acc.add(separate());
    acc.add(align());
    acc.add(cohesion());

    if (pos.x < -r) pos.x = size+r;
    if (pos.y < -r) pos.y = size+r;
    if (pos.z < -r) pos.z = size+r;
    if (pos.x > size+r) pos.x = -r;
    if (pos.y > size+r) pos.y = -r;
    if (pos.z > size+r) pos.z = -r;

    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc.mult(0);
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);

    //rotations
    rotateY(atan2(vel.x, vel.z) + PI);
    rotateX(new PVector((vel.x+vel.z)/2, vel.y).heading());
    rotateX(PI);

    shape(boidShapes[floor(map(targets.size(), minN, maxN, 0, 255))]);
    popMatrix();
  }

  PVector separate() {
    if (targets.size() == 0)
      return new PVector();

    PVector force = new PVector();
    PVector diff = new PVector();
    int nr = 0;

    for (Boid b : targets) {
      if (PVector.dist(pos, b.pos)<drawDist && b!=this) {
        diff = PVector.sub(pos, b.pos);
        diff.normalize();
        diff.div(PVector.dist(pos, b.pos));

        force.add(diff);
        nr++;
      }
    }
    if (nr>0) {
      force.div(float(nr));
      force.setMag(maxVel);
      force.sub(vel);
      force.limit(maxForce);
    }

    return force.mult(sep);
  }

  PVector align() {
    if (targets.size() == 0)
      return new PVector();
    PVector force = new PVector();
    int nr = 0;

    for (Boid b : targets) {
      if (PVector.dist(pos, b.pos)<drawDist && b!=this) {
        force.add(b.vel);
        nr++;
      }
    }
    if (nr>0) {
      force.div(float(nr));
      force.setMag(maxVel);
      force.sub(vel);
      force.limit(maxForce);
    }

    return force.mult(alg);
  }

  PVector cohesion() {
    if (targets.size() == 0)
      return new PVector();

    PVector force = new PVector();
    PVector avPos = new PVector();
    PVector diff = new PVector();
    int nr = 0;

    for (Boid b : targets) {
      if (PVector.dist(pos, b.pos)<drawDist && b!=this) {
        avPos.add(b.pos);
        nr++;
      }
    }
    if (nr>0) {
      avPos.div(nr);

      diff = PVector.sub(avPos, pos);
      diff.setMag(maxVel);

      force = PVector.sub(diff, vel);
      force.limit(maxForce);
    }

    return force.mult(chs);
  }
}
