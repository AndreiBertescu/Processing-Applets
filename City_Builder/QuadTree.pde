class QuadTree {
  ArrayList<PVector> points = new ArrayList<PVector>();
  QuadTree[] children = new QuadTree[4];
  PVector origin;
  float w, h;
  float woff = random(a, b), hoff = random(a, b);
  boolean isSplit = false;
  int level, cap = 4;

  QuadTree(PVector origin, float w, float h, int level) {
    this.origin = origin;
    this.w = w;
    this.h = h;
    this.level = level;

    cap += floor(log(level));
  }

  void insert(PVector p) {
    if (!isSplit) {
      points.add(p);
      if (points.size()>=cap) {
        isSplit = true;
        split();
      }
    } else {
      if (p.x < origin.x+w*woff) {
        if (p.y < origin.y+h*hoff)
          children[1].insert(p);
        else
          children[2].insert(p);
      } else {
        if (p.y < origin.y+h*hoff)
          children[0].insert(p);
        else
          children[3].insert(p);
      }
    }
  }

  void split() {
    children[0] = new QuadTree(new PVector(origin.x+w*woff, origin.y), w*(1-woff), h*hoff, level+1);
    children[1] = new QuadTree(origin, w*woff, h*hoff, level+1);
    children[2] = new QuadTree(new PVector(origin.x, origin.y+h*hoff), w*woff, h*(1-hoff), level+1);
    children[3] = new QuadTree(new PVector(origin.x+w*woff, origin.y+h*hoff), w*(1-woff), h*(1-hoff), level+1);

    for (PVector p : points) {
      if (p.x < origin.x+w*woff) {
        if (p.y < origin.y+h*hoff)
          children[1].insert(p);
        else
          children[2].insert(p);
      } else {
        if (p.y < origin.y+h*hoff)
          children[0].insert(p);
        else
          children[3].insert(p);
      }
    }
  }

  void show() {
    if (!isSplit) {
      strokeWeight(1);
      rect(floor(origin.x), floor(origin.y), floor(w), floor(h));

      strokeWeight(2);
      for (PVector p : points)
        point(p.x, p.y);
    } else for (int i=0; i<4; i++)
      children[i].show();
  }

  void Save(ArrayList<Rect> a) {
    if (!isSplit)
      a.add(new Rect(floor(origin.x), floor(origin.y), floor(w), floor(h)));
    else for (int i=0; i<4; i++)
      children[i].Save(a);
  }
}
