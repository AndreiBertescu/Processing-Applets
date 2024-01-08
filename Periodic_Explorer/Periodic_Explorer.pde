import peasy.*;
PeasyCam cam;

GUI gui;
ArrayList<Particle> nucleus;
ArrayList<Electron> orbitals;
ArrayList<Element> elements;
Particle centerP;
Element currentElement;
int sOrbitals, pOrbitals, dOrbitals, fOrbitals;
String csvPath = "elements.csv";

//SETTINGS
int protons = 2;    // no. of protons
int neutrons = 1;     // no. of neutrons
int electrons = 1;  // no. of electrons; max - 119

float dtNucleus = 0.05;  // time step for nucleus collision detection
float dtOrbitals = 2;    // time step for electron orbitals animation
float rNucleus = 0.25;   // radius of protons and neutrons
float rOrbitals = 0.15;  // radius of electrons

int hudWidth = 300;      // width of the gui; default - 300

void setup() {
  fullScreen(P3D);
  ellipseMode(CENTER);
  noStroke();
  frameRate(60);

  cam = new PeasyCam(this, 25);
  cam.rotateX(-PI/120);
  cam.rotateY(-PI/12);
  cam.rotateZ(-PI/12);
  perspective(PI/4.0, float(width)/float(height), 0.1, 100000);
  gui = new GUI();

  //elements
  elements = getCsvContents(csvPath);
  currentElement = new Element();
  getElement();

  //nucleus
  nucleus = new ArrayList<>(protons + neutrons);
  for (int i=0; i<protons+neutrons; i++) {
    PVector x = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    nucleus.add((i<protons) ? new Proton(rNucleus, x) : new Neutron(rNucleus, x));
  }
  centerP = nucleus.get(0);
  centerP.pos = new PVector();
  centerP.isFixed = true;

  //electron orbitals
  orbitals = new ArrayList<>(electrons);
  for (int i=0; i<electrons; i++)
    orbitals.add(new Electron(rOrbitals));
  arangeElectrons();
}

void draw() {
  background(230);
  lights();
  directionalLight(100, 100, 100, 0, 0, 1);

  //nucleus
  for (Particle p : nucleus) {
    p.update();
    p.show();
  }

  //electron orbitals
  for (Electron p : orbitals) {
    p.update();
    p.show();
  }

  //orbital orbits
  strokeWeight(1.5);
  stroke(0, 30);
  noFill();

  for (int i=0; i<sOrbitals; i++) {
    pushMatrix();
    rotateY(PI/2);
    rotateX(i * PI/sOrbitals);
    circle(0, 0, 4 * 2);
    popMatrix();
  }
  for (int i=0; i<pOrbitals; i++) {
    pushMatrix();
    rotateY(PI/2);
    rotateX(i * PI/pOrbitals);
    circle(0, 0, 6 * 2);
    popMatrix();
  }
  for (int i=0; i<dOrbitals; i++) {
    pushMatrix();
    rotateY(PI/2);
    rotateX(PI/2 + i * PI/dOrbitals);
    circle(0, 0, 8 * 2);
    popMatrix();
  }
  for (int i=0; i<fOrbitals; i++) {
    pushMatrix();
    rotateY(PI/2);
    rotateX(i * PI/fOrbitals);
    circle(0, 0, 10 * 2);
    popMatrix();
  }

  noStroke();

  //HUD
  gui.show();
}
