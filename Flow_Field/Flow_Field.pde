Point[] fieldPoints;
Particle[] particles;
boolean paused = false;
float t = 0;

//settings
float vel = 14;  //1:7, 2:5, 3:5
float resx = 0.006;
float resy = 0.006;
float dt = 0.001;
float limit = PI*4.5; //1:4.5, 2:2, 3:2
int n_fieldPoints = 50000;
int n_particles = 1000;
int type = 1; // noise: 1, tangent: 2, sin+cos: 3
boolean Particles = false; //animate particles in flow field or just see flow field

void setup() {
  fullScreen();
  colorMode(HSB);

  fieldPoints = new Point[n_fieldPoints];
  for (int i=0; i<n_fieldPoints; i++)
    fieldPoints[i] = new Point(random(width), random(height));

  if (Particles) {
    background(0);
    particles = new Particle[n_particles];
    for (int i=0; i<n_particles; i++)
      particles[i] = new Particle(random(width), random(height));
  } else {
    noLoop();
    background(0);
    for (int i=0; i<n_fieldPoints; i++)
      fieldPoints[i].show();
  }
}

void draw() {
  if (Particles) {
    for (int i=0; i<n_particles; i++) {
      if ((particles[i].pos.x>width || particles[i].pos.x<0 || particles[i].pos.y>height || particles[i].pos.y<0) && !paused)
        particles[i] = new Particle(random(width), random(height));

      particles[i].update();
      particles[i].show();
    }
  }

  t += dt;
}

void keyReleased() {
  paused = !paused;
}

void exit() {
  saveFrame("data/FlowFields.png");
  super.exit();
}
