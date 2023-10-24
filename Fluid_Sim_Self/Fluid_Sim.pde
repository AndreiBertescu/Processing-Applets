Fluid fluid;
int varr = 4;
int iter = 4;
PVector z = PVector.fromAngle(random(360)).mult(10);

//settings
//drag mouse to play with fluid
int N = 270;//270 - higher -> slower
int len = 8; //8 - lower -> slower
boolean blackAndWhite= true; //black and white or color
float dt = 0.15; //time step
float diff = 0;
float visc = 0.5;
float fade = 0;


void settings() {
  fullScreen();
}

void setup() {
  colorMode(HSB);
  ellipseMode(CENTER);
  fluid = new Fluid();
}

void draw() {
  background(40);

  if (frameRate%10 <= 2)
    z = PVector.fromAngle(random(360)).mult(10);

  //fluid.addVelocity(width/len/2, height/len/4, z);
  //fluid.addDensity(width/len/2, height/len/4, 1000);

  fluid.update();
  fluid.showVec();
  //save("Fluid.tiff");
}

void mouseDragged() {
  fluid.addDensity(mouseX/len, mouseY/len, 1000);
  fluid.addVelocity(mouseX/len, mouseY/len, new PVector(mouseX-pmouseX, mouseY-pmouseY));
}

void exit() {
  saveFrame("data/Fluid.jpg");
  super.exit();
}
