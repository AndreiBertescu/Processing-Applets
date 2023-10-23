class Circle {
  int x, y, r = 1;
  boolean possible = true;
  color c;

  Circle(int x, int y) {
    this.x = x;
    this.y = y;

    c = img.pixels[y*width+x];
    colorMode(HSB);
  }

  void update() {
    if (possible) {
      r++;

      if (!(x+r<width && x-r>=1 && y+r<height && y-r>=1))
        possible = false;
      for (Circle c : grid)
        if (this != c && r+c.r >= dist(x, y, c.x, c.y)-1) {
          possible=false;
          return;
        }
    }
  }

  void show() {
    ellipseMode(RADIUS);
    fill(c);
    noStroke();
    circle(x, y, r);
  }
}
