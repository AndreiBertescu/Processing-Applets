import peasy.*;
PeasyCam cam;

float rho = 28.0;
float sigma = 10.0;
float beta = 8.0 / 3.0;
double dx, dy, dz;
float x=1.0, y=1.0, z=1.0, dt=0.007;
int nr;

ArrayList<PVector> points = new ArrayList<PVector>();

void setup() {
  size(1920, 1080, P3D);
  colorMode(HSB);
  strokeWeight(2);
  noFill();

  cam = new PeasyCam(this, 200);
  perspective(PI/3.0, float(width)/float(height), 1, 400);
}

void draw() {
  background(0);
  translate(0, 0, 0);
  rotateY(PI/2);

  dx = (sigma*(y-x))*dt;
  dy = (x*(rho-z)-y)*dt;
  dz = (x*y-beta*z)*dt;
  x += dx;
  y += dy;
  z += dz;
  points.add(new PVector(x, y, z));

  nr=0;
  beginShape();
  for (PVector v : points) {
    stroke(nr%255, 255, 255);
    vertex(v.x, v.y, v.z-5);
    nr++;
  }
  endShape();

  nr=0;
  beginShape();
  for (PVector v : points) {
    stroke(nr%255, 255, 255);
    vertex(v.x, v.y, -v.z+5);
    nr++;
  }
  endShape();

  if (frameCount%60==0)
    saveFrame("Lorentz.tiff");
}
