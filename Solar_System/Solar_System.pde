ArrayList<Planet> planets;
PVector mainBodyOffset;

Planet selectedPlanet;
boolean paused, movingPlanet;

/////////////SETTINGS
//use wasd to raise/lower y/x initial velocity of the selected planet
//press x to remove the selected planet
//press z to clear all traces
//press space to pause/unpause
//left click on a planet to select it
//left click drag to move a planet
final float G = 0.1;         //gravitational constant
final int steps = 1000;      //simulate trajectories steps

void setup() {
  fullScreen();
  //size(1000, 1000);
  colorMode(HSB);

  mainBodyOffset = new PVector();
  planets = new ArrayList<>();
  selectedPlanet = null;
  paused = true;
  movingPlanet = false;

  planets.add(new Planet(987.01373, 547.5412, 0.300416, 0.11209645, 75, 20.0, true));
  planets.add(new Planet(840.0772, 556.87933, 1.217366, 3.148103, 20, 3.0));
  planets.add(new Planet(1068.411, 648.3956, -3.4387205, 0.01027929, 15, 2));
  planets.add(new Planet(704.71545, 485.4346, 0.96105576, 2.5579395, 25, 10));
  planets.add(new Planet(489.77505, 820.33405, 0.70176274, 0.756915, 50, 15));
  simulateTrajectories();
}

void update() {
  for (Planet p : planets)
    p.updateVel();

  for (Planet p : planets)
    p.updatePos();
}

void draw() {
  if (movingPlanet)
    selectedPlanet.pos = new PVector(mouseX - mainBodyOffset.x, mouseY - mainBodyOffset.y);
  if (!paused)
    update();
  background(0);

  if (paused)
    for (Planet p : planets)
      p.showTrajectory();
  else
    for (Planet p : planets)
      p.showTrace();

  for (Planet p : planets)
    p.show();
}

void simulateTrajectories() {
  ArrayList<Planet> planetCopies = new ArrayList<>();

  //make cope of the planets array
  for (Planet p : planets) {
    planetCopies.add(new Planet(p));
    p.trajectory = createGraphics(width, height);

    if (p == selectedPlanet)
      selectedPlanet = planetCopies.get(planetCopies.size()-1);
  }

  //simulate trajectories
  for (int i=0; i<steps; i++) {
    for (Planet p : planets)
      if (p.pos.mag() < width * 2)
        p.updateVel();

    for (Planet p : planets)
      if (p.pos.mag() < width * 2)
        p.updatePos();

    for (Planet p : planets)
      if (p.pos.mag() < width * 2)
        p.updateTrajectory();
  }

  int nr = 0;
  for (Planet p : planetCopies)
    p.trajectory = planets.get(nr++).trajectory;
  planets = planetCopies;

  update();
}

void mousePressed() {
  if (mouseButton == LEFT && selectedPlanet != null)
    if (dist(selectedPlanet.pos.x + mainBodyOffset.x, selectedPlanet.pos.y + mainBodyOffset.y, mouseX, mouseY) <= selectedPlanet.radius/2) {
      movingPlanet = true;
      return;
    }
}

void mouseReleased() {
  if (movingPlanet) {
    println("Updating trajectories.");
    simulateTrajectories();
    println("Updated trajectories.");
  }
  movingPlanet = false;

  if (mouseButton == RIGHT) {
    selectedPlanet = null;
    paused = false;
    return;
  }

  for (Planet p : planets)
    if (dist(p.pos.x + mainBodyOffset.x, p.pos.y + mainBodyOffset.y, mouseX, mouseY) <= p.radius/2)
      if (mouseButton == LEFT) {
        selectedPlanet = p;
        paused = true;
        return;
      }

  paused = false;
  selectedPlanet = null;
}

void keyReleased() {
  if (key == ' ')
    paused = !paused;
  else if (key == 'z')
    for (Planet p : planets)
      p.trace = createGraphics(width, height);

  if (!paused)
    selectedPlanet = null;

  if (!paused || selectedPlanet == null)
    return;

  switch(key) {
  case 'w':
    selectedPlanet.vel.y /= 1.1;
    break;
  case 'a':
    selectedPlanet.vel.x /= 1.1;
    break;
  case 's':
    selectedPlanet.vel.y *= 1.1;
    break;
  case 'd':
    selectedPlanet.vel.x *= 1.1;
    break;
  case 'x':
    planets.remove(selectedPlanet);
    selectedPlanet = null;
    break;
  default:
    return;
  }

  println("Updating trajectories.");
  simulateTrajectories();
  println("Updated trajectories.");
}

void exit() {
  for (Planet p : planets)
    println("planets.add(new Planet(" + p.pos.x + ", " + p.pos.y + ", " + p.vel.x + ", " + p.vel.y + ", " + p.radius + ", " + p.g + ", " + p.mainBody + ");");
  super.exit();
}
