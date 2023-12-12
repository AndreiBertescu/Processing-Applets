float len, phi, x, y;
PVector prevPoint;
boolean loop = true;
float t = 0;

//SETTINGS
//press w/s to increase/decrease lenStep
//press a/d to decrease/increase phiStep
float lenStep = 0.031285662;    //the length of the line
float phiStep = 0.019066144;    //the length increase from the center
float maxLen = 1920;            //the maximum radius of the spiral

void setup() {
  fullScreen();
  colorMode(HSB);
  stroke(0);

  prevPoint = new PVector();
}

void draw() {
  if (!loop)
    return;

  translate(width/2, height/2);
  background(230);

  len = phi = 0;
  prevPoint = new PVector();
  while (len <= maxLen) {
    float x = len * cos(phi);
    float y = len * sin(phi);

    stroke(noise(t) * 255, 255, 255);
    stroke(0);
    strokeWeight(noise(t) * 15);

    line(prevPoint.x, prevPoint.y, x, y);
    prevPoint.set(x, y);

    phi += phiStep;
    len += lenStep;
    t += 0.8;
  }

  loop = false;
}

void keyReleased() {
  switch(key) {
  case 'w':
    lenStep *= 1.1;
    break;
  case 's':
    lenStep *= 0.9;
    break;
  case 'a':
    phiStep *= 0.9;
    break;
  case 'd':
    phiStep *= 1.1;
    break;
  }

  loop = true;
}

void exit() {
  println(lenStep, phiStep);

  save("data/Disk.png");
  super.exit();
}
