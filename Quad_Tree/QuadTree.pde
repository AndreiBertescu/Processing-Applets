ArrayList<PVector> targets;

class QuadTree {
  ArrayList<PVector> points = new ArrayList<PVector>();
  QuadTree[] children = new QuadTree[4];
  PVector origin;
  float w, h, strokeWeight;
  boolean isSplit = false;
  int level, cap = 4, colorr;

  QuadTree(PVector origin, float w, float h, int level) {
    this.origin = origin;
    this.w = w;
    this.h = h;
    this.level = level;

    cap += floor(log(level));
    
    strokeWeight = random(10, 15);
    colorr = floor(random(0, pallete.length));
  }

  void insert(PVector p) {
    if (!isSplit) {
      points.add(p);
      if (points.size()>=cap) {
        isSplit = true;
        split();
      }
    } else {
      if (p.x < origin.x+w/2) {
        if (p.y < origin.y+h/2)
          children[1].insert(p);
        else
          children[2].insert(p);
      } else {
        if (p.y < origin.y+h/2)
          children[0].insert(p);
        else
          children[3].insert(p);
      }
    }
  }

  void split() {
    children[0] = new QuadTree(new PVector(origin.x+w/2, origin.y), w/2, h/2, level+1);
    children[1] = new QuadTree(origin, w/2, h/2, level+1);
    children[2] = new QuadTree(new PVector(origin.x, origin.y+h/2), w/2, h/2, level+1);
    children[3] = new QuadTree(new PVector(origin.x+w/2, origin.y+h/2), w/2, h/2, level+1);

    for (PVector p : points) {
      if (p.x < origin.x+w/2) {
        if (p.y < origin.y+h/2)
          children[1].insert(p);
        else
          children[2].insert(p);
      } else {
        if (p.y < origin.y+h/2)
          children[0].insert(p);
        else
          children[3].insert(p);
      }
    }
  }

  void query(PVector point, int range) {
    if (level==0)
      targets = new ArrayList<PVector>();

    if (!isSplit) {
      for (PVector p : points)
        if (p.x>=point.x-range/1 && p.x<=point.x+range/2 && p.y>=point.y-range/2 && p.y<=point.y+range/2)
          targets.add(p);
    } else {
      if (contains(point, range, children[0]))
        children[0].query(point, range);
      if (contains(point, range, children[1]))
        children[1].query(point, range);
      if (contains(point, range, children[2]))
        children[2].query(point, range);
      if (contains(point, range, children[3]))
        children[3].query(point, range);
    }
  }

  boolean contains(PVector p, int range, QuadTree target) {
    if (target.origin.x>p.x+range/2 || target.origin.x+w<p.x-range/2 || target.origin.y>p.y+range/2 || target.origin.y+h<p.y-range/2)
      return false;
    else
      return true;
  }

  void show() {
    if (!isSplit) {
      //strokeWeight(1);
      //rect(origin.x, origin.y, w, h);

      //strokeWeight(2);
      //for (PVector p : points)
      //  point(p.x, p.y);

      fill(pallete[colorr]);
      strokeWeight(strokeWeight);
      stroke(0);
      
      rect(origin.x, origin.y, w, h);
    } else for (int i=0; i<4; i++)
      children[i].show();
  }
}
