import peasy.*;
PeasyCam cam;
float t=0;

//settings
int len = 16;
int w = 20;
float alpha = 0.5;
float dt = -0.05;

void setup() {
  size(900, 900, P3D);
  noStroke();
  fill(145, 255, 255);

  cam = new PeasyCam(this, len*w*3);
  perspective(PI/4.0, float(width)/float(height), 0.1, 100000);
}

void draw() {
  background(240);
  lights();
  rotateX(radians(50));
  rotateZ(PI/4);
  translate(-len*w/2, -len*w/2, 0);

  for (int y=0; y<=len; y++)
    for (int x=0; x<=len; x++) {
      pushMatrix();
      translate(x*w, y*w, 0);

      float off = dist(x, y, len/2, len/2) * alpha;
      box( w, w, 100 + (sin(t+off)*0.5 + 0.5) * len/2*w);

      popMatrix();
    }

  t += dt;
}
