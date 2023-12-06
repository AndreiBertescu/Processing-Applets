import peasy.*;
PeasyCam cam;

ArrayList<Particle> particles;
boolean paused = false;

//SETTINGS
//press space to save image
//press r to reset simulation
//press p to toggle pause
int type = 2;             //1-Lorentz  2-Thomas   3-Three_Scroll
float dt = 0.07;         //time constant 1-0.007   2-0.07   3-0.0007
float strokeWeight = 2;   //width of line
int particleAmmount = 5;  //ammount of particles to be created

void setup() {
  fullScreen(P3D);

  frameRate(600);
  colorMode(HSB);
  strokeWeight(strokeWeight);
  stroke(235);
  noFill();

  cam = new PeasyCam(this, 20);
  perspective(PI/3.0, float(width)/float(height), 1, 1000000);

  init();
}

void init() {
  particles = new ArrayList<>();
  for (int i=0; i<particleAmmount; i++)
    particles.add(new Particle(random(1), random(1), random(1), type));
}

void draw() {
  background(30);

  for (Particle p : particles) {
    if (!paused)
      p.update();
    p.show();
  }
}

void keyReleased() {
  if (key == ' ')
    saveFrame("data/Strange.png");
  if (key == 'r')
    init();
  if (key == 'p')
    paused = !paused;
}
