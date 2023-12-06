ArrayList<Boid> boids;
ArrayList<ArrayList<Boid>> h;
UI ui;
int resx, resy;
int maxN = 10;

//SETTING
int n = 7000;              //nr of boids
float maxVel = 2;          //max velocity of boid
float r = 3;               //size of boid
boolean showGrid = false;  //show hashmap grid
boolean showUI = true;     //show UI

//ui presets
int off = 15;      //UI rects offset
float maxForce = 0.1;  //maximum turn force
float drawDist = 30;   //distance of boid detection
float sep = 1.5;  //separation
float alg = 1;    //aling
float chs = 1.2;  //cohesion

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
    ui = new UI(250, 230);
}

void draw() {
  background(230);
  fill(5);
  strokeWeight(0.7);
  stroke(0);

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
  showUI = false;
  noLoop();
  loop();
  
  saveFrame("data/Flocking.png");
  super.exit();
}
