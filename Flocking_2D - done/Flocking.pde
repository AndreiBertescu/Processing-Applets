ArrayList<Boid> boids;
ArrayList<ArrayList<Boid>> h;
UI ui;
int resx, resy;
int maxN = 10;

//settings
int n = 1000;              //nr of boids
float maxVel = 2;          //max velocity of boid
float r = 4;               //size of boid
boolean showGrid = false;  //show hashmap grid
boolean showUI = true;     //show UI

//ui presets
int off = 15;      //UI rects offset
float maxForce = 0.1;
float drawDist = 10;
float sep = 1.5;
float alg = 1;
float chs = 1.2;

void setup() {
  size(1920, 1080);
  colorMode(HSB);
  textAlign(LEFT, TOP);
  textSize(20);

  boids = new ArrayList<Boid>();
  h = new ArrayList<ArrayList<Boid>>();

  resx = floor(width/40);
  resy = floor(height/40);

  for (int i=0; i<n; i++)
    boids.add(new Boid());

  if (showUI)
    ui = new UI(250, 220);
}

void draw() {
  background(70);
  fill(5);
  strokeWeight(1);
  stroke(255);

  hash();

  for (Boid b : boids) {
    b.update();
    b.show();
  }

  if (showUI)
    ui.show();
}

void hash() {
  h = new ArrayList<ArrayList<Boid>>();

  for (int y=0; y<=height; y+=height/resy) {
    for (int x=0; x<=width; x+=width/resx) {
      if (showGrid)
        rect(x, y, width/resx, height/resy);
      h.add(new ArrayList<Boid>());
    }
  }

  for (Boid b : boids) {
    b.id = floor(abs(b.pos.x)/(width/resx)) + floor(abs(b.pos.y)/(height/resy))*resx + 1;
    h.get(b.id).add(b);
  }
}

void exit() {
  save("Flocking.tiff");
}
