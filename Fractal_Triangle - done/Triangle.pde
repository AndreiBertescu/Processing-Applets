class Triangle {
  PVector[] points = new PVector[3];
  PVector last;
  int x;

  Triangle(int x, int y, int w, int i) {
    points[0] = new PVector(x, y);
    points[1] = new PVector(x+w, y);
    if (i==0)
      points[2] = new PVector((points[0].x+points[1].x+sqrt(3)*(points[0].y-points[1].y))/2, (points[0].y+points[1].y+sqrt(3)*(points[0].x-points[1].x))/2);
    else {
      points[2] = new PVector((points[0].x+points[1].x+sqrt(3)*(points[0].y-points[1].y))/2, 2*y - (points[0].y+points[1].y+sqrt(3)*(points[0].x-points[1].x))/2);
    }
    last = points[floor(random(3))];
  }

  void update() {
    x = floor(random(3));
    stroke(PVector.dist(last, points[x])%255, 255, 255);
    point(last.x, last.y);
    last = new PVector((points[x].x+last.x)/2, (points[x].y+last.y)/2);
  }
}
