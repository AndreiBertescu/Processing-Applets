class QuadTree {
  PVector origin;
  float w, h;
  QuadTree[] children = new QuadTree[4];
  boolean isSplit = false;
  int level;

  QuadTree(PVector origin, float w, float h, int level) {
    this.origin = origin;
    this.w = w;
    this.h = h;
    this.level = level;
  }

  void split() {
    if (!isSplit) {
      isSplit = true;
      children[0] = new QuadTree(new PVector(origin.x+w/2, origin.y), w/2, h/2, level+1);
      children[1] = new QuadTree(new PVector(origin.x, origin.y), w/2, h/2, level+1);
      children[2] = new QuadTree(new PVector(origin.x, origin.y+h/2), w/2, h/2, level+1);
      children[3] = new QuadTree(new PVector(origin.x+w/2, origin.y+h/2), w/2, h/2, level+1);
    } else {
      children[0].split();
      children[1].split();
      children[2].split();
      children[3].split();
    }
  }

  void show() {
    if (!isSplit) {
      img.loadPixels();

      int r = 0;
      int g = 0;
      int b = 0;
      for (int y=floor(origin.y); y<floor(origin.y)+h; y++)
        for (int x=floor(origin.x); x<floor(origin.x)+w; x++) {
          r += red(img.pixels[y*img.width + x]);
          g += green(img.pixels[y*img.width + x]);
          b += blue(img.pixels[y*img.width + x]);
        }
      r /= w*h;
      g /= w*h;
      b /= w*h;

      int colorSum = 0;
      for (int y=floor(origin.y); y<floor(origin.y)+h; y++)
        for (int x=floor(origin.x); x<floor(origin.x)+w; x++) {
          colorSum += abs(red(img.pixels[y*img.width + x])-r);
          colorSum += abs(green(img.pixels[y*img.width + x])-g);
          colorSum += abs(blue(img.pixels[y*img.width + x])-b);
        }
      colorSum /= 3*w*h;

      if (colorSum>threshold && level<thresholdLvl)
        split();

      pg.fill(r, g, b);
      pg.stroke(r, g, b);
      pg.strokeWeight(0.4);
      pg.rect(origin.x, origin.y, w, h);
    } else for (int i=0; i<4; i++)
      children[i].show();
  }
}
