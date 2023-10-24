class Player {
  int x, y, r=res/2;
  boolean up, down, left, right;
  PVector vel = new PVector(0, 0);

  Player() {
    while (true) {
      loadPixels();
      x=(int)random(800);
      y=(int)random(800);

      if (pixels[y*width+x]==walkable && pixels[y*width+x+r]==walkable && pixels[y*width+x-r]==walkable &&
        pixels[(y+r)*width+x]==walkable && pixels[(y-r)*width+x]==walkable)
        break;
    }
  }

  void update() {
    if (left) vel.x= -1;
    if (right) vel.x= 1;
    if (up) vel.y= -1;
    if (down) vel.y= 1;

    if ((left && right) || (!left && !right))
      vel.x=0;
    if ((up && down) || (!up && !down))
      vel.y=0;

    x+=vel.x;
    y+=vel.y;
    if (!(pixels[y*width+x+r]==walkable && pixels[y*width+x-r]==walkable)) {
      x-=vel.x;
    }
    if (!(pixels[(y+r)*width+x]==walkable && pixels[(y-r)*width+x]==walkable)) {
      y-=vel.y;
    }
  }

  void show() {
    ellipseMode(RADIUS);

    //strokeWeight(r+3);
    stroke(255);
    circle(x, y, r);
  }
}
