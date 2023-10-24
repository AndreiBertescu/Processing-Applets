boolean redraw = true;
color c1, c2;
float[][][] colors;
boolean[] done, redraww;
float cenx = 0, ceny = 0, scale = 1;

//settings
//use wasd keys to move arond
int maxIterr = 1500;  // quality/depth of sim
int type = 1; // 0 - Mandelbrot Set / 1- Julia Set

void setup() {
  size(1920, 1080);
  colorMode(HSB);

  cenx = 0;
  ceny = 0;
  scale = 1;
  if (type == 0) {
    cenx = 278.31122;
    ceny = 532.23596;
    scale = 25.628906;
  } else if (type == 1) {
    cenx = 843.61533;
    ceny = 454.44;
    scale = 13.3237;
  }

  c1 = color(174, 200, 135);
  c2 = color(40, 144, 235);
}

void draw() {
  if (redraw) {
    colors = new float[8][width + 1][height + 1];
    done = new boolean[8];

    for (int i=0; i<8; i++)
      done[i] = false;

    thread("th1");
    thread("th2");
    thread("th3");
    thread("th4");
    thread("th5");
    thread("th6");
    thread("th7");
    thread("th8");

    redraw=false;
    println(cenx, ceny, scale);
  } else {
    for (int i=0; i<8; i++)
      if (done[i])
        screenSet(i);
  }
}

void redraw(int id, int starty, int endy, int startx, int endx) {
  if (type == 1) { // Julia Set
    Complex z = new Complex(0, 0);
    Complex c = new Complex(-0.8, 0.156);
    float x0, y0;
    int nr = 0;

    for (int y=starty; y<=endy; y++)
      for (int x=startx; x<=endx; x++) {
        nr=0;
        x0 = map(x*(width/(height*scale))+cenx, 0, width, -2, 2);
        y0 = map(y/scale+ceny, 0, height, -2, 2);

        z.re = x0;
        z.im = y0;

        while (nr++<maxIterr && z.re*z.re + z.im*z.im <= 4) {
          z.poww(2);
          z.add(c);
        }

        if (nr==maxIterr+1)
          set(x, y, color(0));
        else if (nr==1 || nr==2)
          set(x, y, c1);
        else
          set(x, y, lerpColor(c1, c2, map(nr, 1, maxIterr-100, 0.0, 1.0)));

        colors[id][x][y] = map((nr*5), 1, maxIterr, 50, 255);
      }
  } else if (type == 0) { // Mandelbrot Set
    Complex c, z = new Complex(0, 0);
    float x0, y0;
    int nr = 0;

    for (int y=starty; y<=endy; y++)
      for (int x=startx; x<=endx; x++) {
        nr=0;
        x0 = map(x*(width/(height*scale))+cenx, 0, width, -2, 2);
        y0 = map(y/scale+ceny, 0, height, -2, 2);

        z.re = 0;
        z.im = 0;
        c = new Complex(x0, y0);

        while (nr++<maxIterr && z.re*z.re + z.im*z.im <= 4) {
          z.binom();
          z.add(c);
        }

        if (nr==maxIterr+1)
          colors[id][x][y] = -1;
        else
          colors[id][x][y] = map(nr*5, 0, maxIterr, 0, 230);
      }
  }
}

void th1() {
  redraw(0, 0, height/2, 0, int(width * 0.25));
  done[0] = true;
}

void th2() {
  redraw(1, 0, height/2, int(width * 0.25), int(width * 0.5));
  done[1] = true;
}

void th3() {
  redraw(2, 0, height/2, int(width * 0.5), int(width * 0.75));
  done[2] = true;
}

void th4() {
  redraw(3, 0, height/2, int(width * 0.75), width);
  done[3] = true;
}

void th5() {
  redraw(4, height/2, height, 0, int(width * 0.25));
  done[4] = true;
}

void th6() {
  redraw(5, height/2, height, int(width * 0.25), int(width * 0.5));
  done[5] = true;
}

void th7() {
  redraw(6, height/2, height, int(width * 0.5), int(width * 0.75));
  done[6] = true;
}

void th8() {
  redraw(7, height/2, height, int(width * 0.75), width);
  done[7] = true;
}

void screenSet(int id) {
  if (id < 4) {
    for (int y = 0; y < height/2; y++) {
      if (id == 0) {
        for (int x = 0; x < int(width * 0.25); x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      } else if (id == 1) {
        for (int x = int(width * 0.25); x < int(width * 0.5); x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      } else if (id == 2) {
        for (int x = int(width * 0.5); x < int(width * 0.75); x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      } else if (id == 3) {
        for (int x = int(width * 0.75); x < width; x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      }
    }
  } else {
    for (int y = height/2; y < height; y++) {
      if (id == 4) {
        for (int x = 0; x < int(width * 0.25); x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      } else if (id == 5) {
        for (int x = int(width * 0.25); x < int(width * 0.5); x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      } else if (id == 6) {
        for (int x = int(width * 0.5); x < int(width * 0.75); x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      } else if (id == 7) {
        for (int x = int(width * 0.75); x < width; x++)
          if (type == 0) {
            if (colors[id][x][y] == -1)
              set(x, y, color(0));
            else
              set(x, y, color(colors[id][x][y], 255, 255));
          } else if (type == 1)
            set(x, y, color(colors[id][x][y]));
      }
    }
  }
}

void mouseClicked() {
  scale*=1.5;
  redraw=true;
}

void keyPressed() {
  if (keyCode == 87) {//up
    ceny-=1000/scale;
  }
  if (keyCode == 83) {//down
    ceny+=1000/scale;
  }
  if (keyCode == 65) {//left
    cenx-=1000/scale;
  }
  if (keyCode == 68) {//right
    cenx+=1000/scale;
  }
  redraw=true;
}

void exit() {
  if(type == 1)
    saveFrame("data/MandelbrotSet.jpg");
  else if(type == 1)
    saveFrame("data/JuliaSet.jpg");
  else 
    saveFrame("data/Fractal.jpg");
  println(cenx, ceny, scale);
  super.exit();
}
