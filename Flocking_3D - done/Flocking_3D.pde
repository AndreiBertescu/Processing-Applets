import peasy.*;
PeasyCam cam;
ArrayList<Boid> boids;
ArrayList<ArrayList<Boid>> h;
PShape[] boidShapes;
int maxN = 10;
int aux;
Boid b;

//settings
int size = 1000;             //size of box
int n = 10000;               //no. of boids
float r = 0.7;               //size of boid
boolean showGrid = false;    //show hashmap grid
boolean showBorder = false;  //show border
int res = size/40;           //size of hash cells
float maxVel = 6;            //max velocity
float drawDist = 50;         //radius of vision
float maxForce = 0.4;        //max force
float sep = 1.0;             //separation
float alg = 1.4;             //align
float chs = 1.0;             //cohesion
int minN = 5;                //no. of neighbours to get drawn

void setup() {
  fullScreen(P3D);
  colorMode(HSB);

  cam = new PeasyCam(this, 1.5*size);
  perspective(PI/3.0, float(width)/float(height), 0.01, 400000);

  boids = new ArrayList<Boid>();
  h = new ArrayList<ArrayList<Boid>>();
  boidShapes = new PShape[256];
  for (int i=0; i<256; i++)
    boidShapes[i] = makeShape(r, i);
  aux = size / res;

  for (int i=0; i<n; i++)
    boids.add(new Boid());
}

void draw() {
  background(30);

  if (showBorder) {
    noFill();
    stroke(155, 255, 205);
    strokeWeight(2);
    box(size, size, size);
  }

  pushMatrix();
  translate(-size/2, -size/2, -size/2);
  hash();

  for (Boid b : boids) {
    b.update();
    if (b.targets.size() > minN)
      b.show();
  }
  popMatrix();
}

void hash() {
  h = new ArrayList<ArrayList<Boid>>();
  noFill();
  stroke(255);
  strokeWeight(0.8);

  for (int z=0; z<=size; z+=res)
    for (int y=0; y<=size; y+=res) {
      for (int x=0; x<=size; x+=res) {
        if (showGrid && z<size && y<1 && x<1) {
          pushMatrix();
          translate(x + res/2, y + res/2, z + res/2);
          box(res, res, res);
          popMatrix();
        }
        h.add(new ArrayList<Boid>());
      }
    }

  for (Boid b : boids) {
    b.id = 1 + IX(floor(abs(min(b.pos.x, size-1))/res), floor(abs(min(b.pos.y, size-1))/res), floor(abs(min(b.pos.z, size-1))/res));
    h.get(b.id).add(b);
  }
}

int IX(int x, int y, int z) {
  return y*aux*aux + z*aux + x;
}

PShape makeShape(float r, int c) {
  PShape boid = createShape(GROUP);

  PShape face = createShape();
  face.beginShape();
  face.noStroke();
  face.fill(color(128 - c, 255, 255));
  face.vertex(0, 0, r*2);
  face.vertex(-r, -r, -r);
  face.vertex(r, -r, -r);
  face.endShape();
  boid.addChild(face);

  face = createShape();
  face.beginShape();
  face.noStroke();
  face.fill(color(128 - c, 255, 255));
  face.vertex(0, 0, r*2);
  face.vertex(r, -r, -r);
  face.vertex(r, r, -r);
  face.endShape();
  boid.addChild(face);

  face = createShape();
  face.beginShape();
  face.noStroke();
  face.fill(color(128 - c, 255, 255));
  face.vertex(0, 0, r*2);
  face.vertex(r, r, -r);
  face.vertex(-r, r, -r);
  face.endShape();
  boid.addChild(face);

  face = createShape();
  face.beginShape();
  face.noStroke();
  face.fill(color(128 - c, 255, 255));
  face.vertex(0, 0, r*2);
  face.vertex(-r, r, -r);
  face.vertex(-r, -r, -r);
  face.endShape();
  boid.addChild(face);

  face = createShape();
  face.beginShape();
  face.noStroke();
  face.fill(color(128 - c, 255, 255));
  face.vertex(r, -r, -r);
  face.vertex(r, r, -r);
  face.vertex(-r, r, -r);
  face.vertex(-r, -r, -r);
  face.endShape();
  boid.addChild(face);

  return boid;
}

void mouseReleased() {
  saveFrame("Flocking.png");
}
