class Rect {
  ArrayList<Rect> blocks = new ArrayList<>();
  int x, y, w, h;
  float id, z;
  color str, str2;
  boolean show = true;
  boolean stroke = false;

  Rect(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    id = noise(x*0.003, y*0.003);
  }

  void generate() {
    if (id < 0.4) {
      int origin = floor(random(1, 3));
      blocks.add(new Rect(x+origin, y+origin, w-origin*2, h-origin*2));
      float x = random(1);
      blocks.get(0).str = lerpColor(color(191, 250, 102), color(252, 240, 3), x);
      blocks.get(0).z = x*5;
      return;
    }

    QuadTree qt = new QuadTree(new PVector(x, y), w, h, 0);
    for (int i=0; i<10; i++)
      qt.insert(new PVector(random(x, x+w), random(y, y+h)));
    qt.Save(blocks);

    update();
  }

  boolean update() {
    for (Rect r : blocks) {
      float margin = random(2/scale, 6/scale);
      r.x += margin;
      r.y += margin;
      r.w -= margin*2;
      r.h -= margin*2;

      if (r.w <= 3 || r.h <= 3) {
        r.show = false;
        continue;
      }

      //r.str = color(255 * noise(r.x*0.02, r.y*0.02));
      r.z = 50 * noise(r.x*0.002, r.y*0.002)/scale;

      if (r.id >= 0.65) {
        r.z += exp(5.7*id);
        if (scale >= 0.9)
          r.z /= scale;
      } else if (id <= 0.45)
        r.z -= exp(2*r.id);

      r.z -= r.w*r.h * 0.02;
      r.z = max(1, r.z);

      if (r.w*r.h >= 800/scale && r.z < 10 && random(1)>0.5)
        r.str = color(92, 224, 96);
      else {
        r.stroke = true;
        r.str2 = color(200);
        r.str = lerpColor(color(93, 240, 225), color(49, 86, 235), r.z/40);
      }
    }
    return false;
  }
}
