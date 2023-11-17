class Planet {
  PVector pos, vel, acc;
  final int radius;
  final float g, mass;
  boolean mainBody;

  final color c;
  PGraphics trajectory, trace;

  Planet(float x, float y, float velx, float vely, int radius, float g) {
    pos = new PVector(x, y);
    vel = new PVector(velx, vely);

    this.radius = radius;
    this.g = g;
    this.mainBody = false;
    mass = radius*radius * g * G;

    c = color(map(dist(pos.x, pos.y, width/2, height/2) % min(width, height), 0, min(width, height), 0, 255), 255, 255);
    trace = createGraphics(width, height);
  }

  Planet(float x, float y, float velx, float vely, int radius, float g, boolean mainBody) {
    pos = new PVector(x, y);
    vel = new PVector(velx, vely);

    this.radius = radius;
    this.g = g;
    this.mainBody = mainBody;
    mass = radius*radius * g * G;

    c = color(map(dist(pos.x, pos.y, width/2, height/2) % min(width, height), 0, min(width, height), 0, 255), 255, 255);
    trace = createGraphics(width, height);
  }

  Planet(Planet p) {
    this.pos = p.pos.copy();
    this.vel = p.vel.copy();

    this.radius = p.radius;
    this.g = p.g;
    this.mainBody = p.mainBody;
    this.mass = p.mass;

    this.c = p.c;
    this.trajectory = p.trajectory;
    trace = createGraphics(width, height);
  }

  void updateVel() {
    float dist = 0;
    PVector dir;

    acc = new PVector();

    for (Planet p : planets)
      if (p != this) {
        dist = PVector.dist(pos, p.pos);
        dir = PVector.sub(p.pos, pos).normalize();

        acc.add(dir.mult(G * p.mass / (dist*dist)));
      }

    vel.add(acc);
  }

  void updatePos() {
    if (mainBody)
      mainBodyOffset = PVector.sub(new PVector(width/2, height/2), pos);

    pos.add(vel);

    if (trace != null) {
      trace.beginDraw();
      trace.strokeWeight(2);
      trace.stroke(c);
      trace.line(pos.x - vel.x + mainBodyOffset.x, pos.y - vel.y + mainBodyOffset.y, pos.x + mainBodyOffset.x, pos.y + mainBodyOffset.y);
      trace.endDraw();
    }
  }

  void showTrajectory() {
    if (trajectory != null)
      image(trajectory, 0, 0);
  }

  void showTrace() {
    if (trace != null)
      image(trace, 0, 0);
  }

  void show() {
    fill(c);

    if (selectedPlanet == this) {
      strokeWeight(2);
      stroke(255);
    } else
      noStroke();

    if (mainBody)
      circle(width/2, height/2, radius);
    else
      circle(pos.x + mainBodyOffset.x, pos.y + mainBodyOffset.y, radius);
  }

  void updateTrajectory() {
    if (mainBody)
      return;

    trajectory.beginDraw();
    trajectory.strokeWeight(2);
    trajectory.stroke(c);
    trajectory.line(pos.x - vel.x + mainBodyOffset.x, pos.y - vel.y + mainBodyOffset.y, pos.x + mainBodyOffset.x, pos.y + mainBodyOffset.y);
    trajectory.endDraw();
  }
}
