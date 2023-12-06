class Circle {
  int x, y, r = 1;
  boolean possible = true;
  color c;

  Circle(int x, int y) {
    this.x = x;
    this.y = y;

    if (image) {
      c = img.pixels[y*width+x];
  colorMode(HSB);
      noStroke();
    } else {
      //c = color(noise(x*ress, y*ress) * 255, 255, 255, 100);
      c = pallete[floor(noise(x*ress, y*ress) * pallete.length)];
      
  colorMode(RGB);
      strokeWeight(1.5);
      stroke(0);
    }
  }

  void update() {
    r++;

    if (!(x+r<width && x-r>=1 && y+r<height && y-r>=1))
      possible = false;
    for (Circle c : grid)
      if (this != c && r+c.r >= dist(x, y, c.x, c.y)-1) {
        possible=false;
        return;
      }
  }

  void show() {
    fill(c, 100);

    circle(x, y, r);
  }
}
