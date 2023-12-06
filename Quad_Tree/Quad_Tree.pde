QuadTree root;

color[] pallete;

//settings
//right click to query the rootTree
//left click to place new point
int noPoints = 1000;
float res = 0.0025; //noise resolution

void setup() {
  size(1920, 1920);

  pallete = new color[5];
  pallete[0] = color(#33658A);
  pallete[1] = color(#86BBD8);
  pallete[2] = color(#758E4F);
  pallete[3] = color(#F6AE2D);
  pallete[4] = color(#F26419);

  root = new QuadTree(new PVector(0, 0), width-1, height-1, 0);
  while (noPoints > 0) {
    PVector pos = new PVector(random(0, width), random(0, height));

    if (noise(pos.x * res, pos.y * res) > 0.4) {
      root.insert(pos);
      noPoints--;
    }
  }
}

void draw() {
  background(0);
  root.show();

  //rect(mouseX-50, mouseY-50, 100, 100);
}

void mouseReleased() {
  if (mouseButton == LEFT)
    for (int i=0; i<1; i++)
      root.insert(new PVector(mouseX, mouseY));
  else if (mouseButton == RIGHT) {
    root.query(new PVector(mouseX, mouseY), 100);
    println(targets);
  }
}

void keyPressed() {
}

void exit() {
  saveFrame("data/QuadTree.png");
  super.exit();
}
