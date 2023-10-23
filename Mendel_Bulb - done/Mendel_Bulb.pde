import peasy.*;
PeasyCam cam;
PShader pointShader;
PShape shape;
float x, y, z, x1, y1, z1;
float minDist = 0.390625, maxDist = 1.3112904;
float r = 0;
float theta = 0;
float phi = 0;
int nr, i, j, k;
boolean show = true, edge;

//settings
int res = 600; // higher - lower performance
int n = 6; // bulb type 6 - default
int iter = 10; // bulf acuracy 20 - default
float weight = 0.0025; //size of points

void setup() {
  size(1000, 1000, P3D);
  cam = new PeasyCam(this, 3);
  perspective(PI/4.0, float(width)/float(height), 0.1, 100000);
  colorMode(HSB);

  double d = cam.getDistance() * 6;
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");
  pointShader.set("maxDepth", (float) d);
  shader(pointShader, POINTS);
  long time = System.currentTimeMillis();

  shape = createShape();
  shape.beginShape(POINTS);
  shape.strokeWeight(weight);
  shape.stroke(50, 255, 255);

  for (i=0; i<res; i++) {
    for (j=0; j<res; j++) {
      edge=false;
      for (k=0; k<res; k++) {

        x = (2f/res) * i - 1;
        y = (2f/res) * j - 1;
        z = (2f/res) * k - 1;
        x1 = y1 = z1 = r = nr = 0;

        while (++nr < iter && r < 2) {
          r = sqrtt(x1*x1 + y1*y1 + z1*z1);
          theta = atan2(sqrtt(x1*x1 + y1*y1), z1);
          phi = atan2(y1, x1);

          x1 = pow(r, n) * sinn(theta*n) * coss(phi*n) + x;
          y1 = pow(r, n) * sinn(theta*n) * sinn(phi*n) + y;
          z1 = pow(r, n) * coss(theta*n) + z;
        }

        if (nr == iter && !edge) {
          //minDist = min(minDist, dist(x, y, z, 0, 0, 0));
          //maxDist = max(maxDist, dist(x, y, z, 0, 0, 0));

          //shape.stroke(map(dist(x, y, z, 0, 0, 0), minDist, maxDist, 0, 255)+20, 255, 255);
          shape.stroke(dist(x, y, z, 0, 0, 0) * 255 +20, 255, 255);
          shape.vertex(x, y, z);
          edge=true;
        } else if (r >= 2 && edge)
          edge=false;
      }
    }
    if (i%50 == 0)
      println(i);
  }
  shape.endShape();

  time = System.currentTimeMillis() - time;
  println("\n"+shape.getVertexCount(), minDist, maxDist, time/1000+"s");
}

void draw() {
  background(50);
  if (show)
    shape(shape);
}

void keyPressed() {
  if (keyCode == UP)
    save("mendelBulb.tiff");
  else
    show = !show;
}
