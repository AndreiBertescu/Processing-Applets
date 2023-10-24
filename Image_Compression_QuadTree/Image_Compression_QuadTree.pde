QuadTree root;
PImage img, resultImg;
PGraphics pg;
int thresholdLvl = 14;

//settings
//right/left click to increase/decrease threshold
int threshold = 14;  //increase -> decreased detail

void setup() {
  size(1000, 1000);

  img = loadImage(dataPath("img.jpg"));
  root = new QuadTree(new PVector(0, 0), img.width, img.height, 0);
  root.split();
  
  show();
}

void show() {
  pg = createGraphics(img.width, img.height);
  pg.beginDraw();
  for (int i=0; i<= thresholdLvl; i++)
    root.show();
  pg.endDraw();
  println("Done! threshold - " + threshold);
}

void draw() {
  background(0);

  image(pg, 0, 0, width, width * ((float)img.height/img.width));
}

void mouseReleased() {
  if (mouseButton == LEFT)
    threshold--;
  else if (mouseButton == RIGHT)
    thresholdLvl++;

  root = new QuadTree(new PVector(0, 0), img.width, img.height, 0);
  root.split();
  show();
}

void exit() {
  pg.save("data/Compressed.jpg");
  super.exit();
}
