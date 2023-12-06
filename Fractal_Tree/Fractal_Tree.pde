float len, ratio, ang;

//SETTING
//scroll to increase/decrease tree angle;

void setup() {
  size(1920, 1080);
  strokeWeight(2);
  colorMode(HSB);
  ellipseMode(CORNER);

  len = 300;
  ratio = 0.71;
  ang = 45;
}

void draw() {
  background(220);

  translate(800, height);
  rotate(PI+PI/6);
  stroke(#7E370C);
  strokeWeight(4);
  line(0, 0, 0, len);

  recursive(len*ratio);
  noLoop();
}

void recursive(float len) {
  if (len < 1.75) {
    pushMatrix();
    translate(0, len/ratio);

    strokeWeight(0.5);
    stroke(0, 100);
    fill(#ffb7c5, 200);

    circle(0, 0, 5);
    popMatrix();
  } else {
    stroke(#7E370C);
    if (len <= 15)
      strokeWeight(2);
    else
      strokeWeight(4);

    pushMatrix();
    translate(0, len/ratio);
    rotate(radians(-ang));
    line(0, 0, 0, len);

    recursive(len*ratio);
    popMatrix();

    if (len <= 15)
      strokeWeight(2);
    else
      strokeWeight(4);
    stroke(#7E370C);

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
  saveFrame("data/FractalTree.png");
  super.exit();
}
