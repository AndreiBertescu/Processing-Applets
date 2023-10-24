class Planet {
  PGraphics canvas;
  color c;
  float m, r;
  float pvx, pvy;
  PVector pos, v;
  boolean isSun;
  int nr=0;

  Planet(float mass, PVector pos, PVector v, boolean isSun) {
    this.m=mass;
    this.pos=pos;
    this.v=v;
    this.isSun = isSun;

    pvx = pos.x;
    pvy = pos.y;
    r = map(m, 0, 5000, 5, 250);

    canvas = createGraphics(width, height);
    colorMode(HSB);
    if (!isSun)
      c = color(map(PVector.dist(sun.pos, pos)-r-sun.r, sun.r, width/2-r, 0, 255), 255, 255);
    else
      c=color(255);
  }

  void update() {
    PVector a = sun.pos.copy().sub(pos);
    a.setMag((G*sun.m)/pow(PVector.dist(sun.pos, pos), 2));

    v.add(a);

    for (int i=0; i<n; i++)
      if (PVector.dist(planets[i].pos, pos)!=0) {
        a = planets[i].pos.copy().sub(pos);
        a.setMag((G*planets[i].m/100)/pow(PVector.dist(planets[i].pos, pos), 2));

        v.add(a);
      }

    pos.add(v);
    pvx=pos.x;
    pvy=pos.y;
  }

  void show() {
    if (nr>10000) {
      canvas =createGraphics(width, height);
      nr=0;
    }

    image(canvas, -width/2, -height/2);
    canvas.beginDraw();
    canvas.translate(width/2, height/2);
    canvas.strokeWeight(2);
    canvas.stroke(c);
    canvas.line(pvx, pvy, pos.x, pos.y);
    canvas.endDraw();

    ellipseMode(CENTER);
    fill(c);
    noStroke();
    circle(pos.x, pos.y, r);
    nr++;
  }
}
