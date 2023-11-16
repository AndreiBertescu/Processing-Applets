class Chunk extends Thread {
  Complex c, z;
  int iter, startx, endx, starty, endy;
  float x0, y0;

  Chunk(int startx, int endx, int starty, int endy) {
    this.startx =startx;
    this.endx = endx;
    this.starty = starty;
    this.endy = endy;

    c = new Complex ();
    z = new Complex ();

    start();
  }

  @Override
    public void run() {
    if (type == 0)
      mandelbrot();
    else
      julia();
  }

  public void mandelbrot() {
    for (int px=startx; px<endx; px++)
      for (int py=starty; py<endy; py++) {
        iter = 0;
        z.re = c.re = map((px + axisOffsetx) / scale, 0, minAxis, -2, 0.47);
        z.im = c.im = map((py + axisOffsety) / scale, 0, minAxis, -1.12, 1.12);

        while (iter++ < maxIter && z.len() <= 4) {
          z.square();
          z.add(c);
        }

        if (blackAndWhite)
          set(px, py, color(map(iter*imageDefinition, 0, maxIter, 255, 0)));
        else
          if (iter < maxIter)
            set(px, py, lerpColor(c1, c2, map(iter*imageDefinition, 0, maxIter, 0.0, 1.0)));
          else
            set(px, py, color(0, 0, 0));
      }
  }

  public void julia() {
    c = new Complex(-0.8, 0.156);

    for (int px=startx; px<endx; px++)
      for (int py=starty; py<endy; py++) {
        iter=0;
        z.re = map((px + axisOffsetx) / scale, 0, minAxis, -1, 1);
        z.im = map((py + axisOffsety) / scale, 0, minAxis, -1, 1);

        while (iter++ < maxIter && z.len() <= 4) {
          z.square();
          z.add(c);
        }

        if (blackAndWhite)
          set(px, py, color(map(iter*imageDefinition, 0, maxIter, 255, 0)));
        else
          if (iter < maxIter)
            set(px, py, lerpColor(c1, c2, map(iter*imageDefinition, 0, maxIter, 0.0, 1.0)));
          else
            set(px, py, color(0, 0, 0));
      }
  }
}
