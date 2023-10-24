Planet sun;
Planet[] planets;

//settings
int n=10; //no. of planets
float G=1;
float destabilise = 0.1;  //grade of planet destabilization

void setup() {
  size(1080, 1080);

  planets = new Planet[n];
  sun = new Planet(1000, new PVector(0, 0), new PVector(0, 0), true);

  for (int i=0; i<n; i++)
    newPlanet(int(random(10, 500)), i);
}

void draw() {
  background(0);
  translate(width/2, width/2);

  for (int i=0; i<n; i++) {
    planets[i].update();
    planets[i].show();
  }
  sun.show();
}

void newPlanet(int m, int i) {
  float dist = random(sun.r+map(m, 0, 10000, 5, 250), width/2);

  float theta = random(2*PI);
  PVector pos = new PVector(dist*cos(theta), dist*sin(theta));
  PVector rot = pos.copy().rotate(PI/2);
  rot.setMag(sqrt(G*sun.m/pos.mag()));
  rot.mult(random(1-destabilise, 1+destabilise));

  planets[i]=new Planet(m, pos, rot, false);
}
