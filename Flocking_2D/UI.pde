class UI {
  int w, h;
  float sepp, chss, algg, dist;
  float W, H;

  UI(int w, int h) {
    this.w = w;
    this.h = h;

    W = w-off*2;
    H = 25;
  }

  void show() {
    fill(0);
    noStroke();

    translate(width-w, 0);
    rect(0, 0, w, h);

    //sliders
    fill(255);
    rect(off, off, W, H); //dist
    fill(0);
    rect(off + 1, off + 1, map(drawDist, 1, 100, 0, W-2), H-2);
    fill(100, 255, 255);
    text("dist: "+drawDist, off + 5, off - 1);

    fill(255);
    rect(off, off*2 + H, W, H); //sep
    fill(0);
    rect(off + 1, off*2+H + 1, map(sep, 1, 2, 0, W-2), H-2);
    fill(100, 255, 255);
    text("sep: "+sep, off + 5, off*2+H - 1);

    fill(255);
    rect(off, off*3 + H*2, W, H); //alg
    fill(0);
    rect(off + 1, off*3 + H*2 + 1, map(alg, 1, 2, 0, W-2), H-2);
    fill(100, 255, 255);
    text("alg: "+alg, off + 5, off*3 + H*2 - 1);

    fill(255);
    rect(off, off*4 + H*3, W, H); //chs
    fill(0);
    rect(off + 1, off*4 + H*3 + 1, map(chs, 1, 2, 0, W-2), H-2);
    fill(100, 255, 255);
    text("chs: "+chs, off + 5, off*4 + H*3 - 1);

    fill(255);
    rect(off, off*5 + H*4, W, H); //reset
    fill(0);
    text("RESET", off + 5, off*5 + H*4 - 1);
  }
}

void mouseReleased() {
  if (showUI) {
    float mousex = mouseX - (width-ui.w);
    float mousey = mouseY;

    if (mousex>off && mousex<off+ui.W && mousey>off && mousey<off+ui.H)
      drawDist = map(mousex-off, 0, ui.W, 1, 100);

    if (mousex>off && mousex<off+ui.W && mousey>off*2+ui.H && mousey<off*2+ui.H*2)
      sep = map(mousex-off, 0, ui.W, 1, 2);

    if (mousex>off && mousex<off+ui.W && mousey>off*3+ui.H*2 && mousey<off*3+ui.H*3)
      alg = map(mousex-off, 0, ui.W, 1, 2);

    if (mousex>off && mousex<off+ui.W && mousey>off*4+ui.H*3 && mousey<off*4+ui.H*4)
      chs = map(mousex-off, 0, ui.W, 1, 2);

    if (mousex>off && mousex<off+ui.W && mousey>off*5+ui.H*4 && mousey<off*5+ui.H*5)
      setup();
  }
}
