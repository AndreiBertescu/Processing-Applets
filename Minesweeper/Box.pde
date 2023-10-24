class Box {
  int x, y, w, state;// 9=mine 1-8=value
  boolean flag, shown;// 0=shown 1=hidden

  Box(int X, int Y, int W) {
    x=X;
    y=Y;
    w=W;
    flag=false;
    shown=false;
  }

  void update() {
  }

  void show() {
    stroke(0);
    if (flag) {
      ellipseMode(CENTER);
      fill(255, 0, 0);
      ellipse(x+w/2, y+w/2, w/2, w/2);
    } else {
      if (!shown) {
        fill(210);
        rect(x, y, w, w);
      } else {
        fill(225);
        rect(x, y, w, w);
        if (state==9) {
          ellipseMode(CENTER);
          fill(0);
          ellipse(x+w/2, y+w/2, w/2, w/2);
        } 
        if (state>0 && state<9) {
          textAlign(CENTER);
          textFont(f, 19);  
          switch(state) {
          case 1:
            fill(0, 0, 255);
            break;
          case 2:
            fill(0, 200, 0);
            break;
          case 3:
            fill(255, 0, 0);
            break;
          case 4:
            fill(1, 1, 127);
            break;
          case 5:
            fill(129, 2, 1);
            break;
          case 6:
            fill(0, 128, 128);
            break;
          case 7:
            fill(0);
            break;
          case 8:
            fill(128, 128, 128);
            break;
          }
          text(String.valueOf(state), x+w/2, y+w-w/4);
        }
      }
    }
  }
}
