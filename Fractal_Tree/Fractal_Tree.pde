float len, ratio, ang;

//settings
//scroll to increase/decrease tree angle;
void setup() {
  size(1920, 1080);
  strokeWeight(2);
  colorMode(HSB);

  len = 300;
  ratio = 0.71;
  ang = 45;
}

void draw() {
  background(20);

  translate(800, height);
  rotate(PI+PI/6);
  stroke(#7E370C);
  strokeWeight(2);
  line(0, 0, 0, len);

  recursive(len*ratio);
  noLoop();
}

void recursive(float len) {
  stroke(#7E370C);
  strokeWeight(2);
  if (len<=15){
    stroke(map(len, 15, 100, 0, 100), 255, 255);
    strokeWeight(0.8);
  }

  if (len>1) {
    pushMatrix();
    translate(0, len/ratio);
    rotate(radians(-ang));
    line(0, 0, 0, len);
    recursive(len*ratio);
    popMatrix();

    stroke(#7E370C);
    strokeWeight(2);
    if (len<=15){
      stroke(map(len, 15, 0, 0, 100), 255, 255);
      strokeWeight(0.8);
    }

    pushMatrix();
    translate(0, len/ratio);
    rotate(radians(ang*0.5));
    line(0, 0, 0, len);
    recursive(len*ratio);
    popMatrix();
  }
}

void mouseWheel(MouseEvent event) {
  ang += event.getCount()*2;
  loop();
}

void exit() {
  saveFrame("data/FractalTree.jpg");
  super.exit();
}
