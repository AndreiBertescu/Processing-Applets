class Cube {
  String[] c;
  ArrayList<String> moves;

  Cube() {
    c = new String[6];
    moves = new ArrayList<>();

    //init
    c[0] = "WWWWWWWWW"; //top
    c[1] = "RRRRRRRRR"; //front
    c[2] = "YYYYYYYYY"; //bottom
    c[3] = "OOOOOOOOO"; //back
    c[4] = "BBBBBBBBB"; //right
    c[5] = "GGGGGGGGG"; //left

    c[0] = "ORBOWRYBR"; //top
    c[1] = "ROGWRYRWO"; //front
    c[2] = "GBWBYGWYW"; //bottom
    c[3] = "OBYROYRGG"; //back
    c[4] = "YGYOBWBOB"; //right
    c[5] = "GWBRGGOYW"; //left
  }

  //change current face
  void changeFace(String newFront) {
    switch(newFront) {
      case("top"):
      top();
      break;
      case("left"):
      left();
      break;
      case("right"):
      right();
      break;
      case("bottom"):
      bottom();
      break;
    }

    moves.add(newFront);
  }

  void changeFaceInt(String newFront) {
    switch(newFront) {
      case("top"):
      top();
      break;
      case("left"):
      left();
      break;
      case("right"):
      right();
      break;
      case("bottom"):
      bottom();
      break;
    }
  }

  void top() {
    String aux = c[ff.get("top")];
    c[ff.get("top")] = new StringBuilder(c[ff.get("back")]).reverse().toString();
    c[ff.get("back")] = new StringBuilder(c[ff.get("bottom")]).reverse().toString();
    c[ff.get("bottom")] = c[ff.get("front")];
    c[ff.get("front")] = aux;

    c[ff.get("right")] = ""
      + c[ff.get("right")].charAt(2)
      + c[ff.get("right")].charAt(5)
      + c[ff.get("right")].charAt(8)
      + c[ff.get("right")].charAt(1)
      + c[ff.get("right")].charAt(4)
      + c[ff.get("right")].charAt(7)
      + c[ff.get("right")].charAt(0)
      + c[ff.get("right")].charAt(3)
      + c[ff.get("right")].charAt(6);

    c[ff.get("left")] = ""
      + c[ff.get("left")].charAt(6)
      + c[ff.get("left")].charAt(3)
      + c[ff.get("left")].charAt(0)
      + c[ff.get("left")].charAt(7)
      + c[ff.get("left")].charAt(4)
      + c[ff.get("left")].charAt(1)
      + c[ff.get("left")].charAt(8)
      + c[ff.get("left")].charAt(5)
      + c[ff.get("left")].charAt(2);
  }

  void left() {
    String aux = c[ff.get("left")];
    c[ff.get("left")] = c[ff.get("back")];
    c[ff.get("back")] = c[ff.get("right")];
    c[ff.get("right")] = c[ff.get("front")];
    c[ff.get("front")] = aux;

    c[ff.get("top")] = ""
      + c[ff.get("top")].charAt(2)
      + c[ff.get("top")].charAt(5)
      + c[ff.get("top")].charAt(8)
      + c[ff.get("top")].charAt(1)
      + c[ff.get("top")].charAt(4)
      + c[ff.get("top")].charAt(7)
      + c[ff.get("top")].charAt(0)
      + c[ff.get("top")].charAt(3)
      + c[ff.get("top")].charAt(6);

    c[ff.get("bottom")] = ""
      + c[ff.get("bottom")].charAt(6)
      + c[ff.get("bottom")].charAt(3)
      + c[ff.get("bottom")].charAt(0)
      + c[ff.get("bottom")].charAt(7)
      + c[ff.get("bottom")].charAt(4)
      + c[ff.get("bottom")].charAt(1)
      + c[ff.get("bottom")].charAt(8)
      + c[ff.get("bottom")].charAt(5)
      + c[ff.get("bottom")].charAt(2);
  }

  void right() {
    String aux = c[ff.get("right")];
    c[ff.get("right")] = c[ff.get("back")];
    c[ff.get("back")] = c[ff.get("left")];
    c[ff.get("left")] = c[ff.get("front")];
    c[ff.get("front")] = aux;

    c[ff.get("top")] = ""
      + c[ff.get("top")].charAt(6)
      + c[ff.get("top")].charAt(3)
      + c[ff.get("top")].charAt(0)
      + c[ff.get("top")].charAt(7)
      + c[ff.get("top")].charAt(4)
      + c[ff.get("top")].charAt(1)
      + c[ff.get("top")].charAt(8)
      + c[ff.get("top")].charAt(5)
      + c[ff.get("top")].charAt(2);

    c[ff.get("bottom")] = ""
      + c[ff.get("bottom")].charAt(2)
      + c[ff.get("bottom")].charAt(5)
      + c[ff.get("bottom")].charAt(8)
      + c[ff.get("bottom")].charAt(1)
      + c[ff.get("bottom")].charAt(4)
      + c[ff.get("bottom")].charAt(7)
      + c[ff.get("bottom")].charAt(0)
      + c[ff.get("bottom")].charAt(3)
      + c[ff.get("bottom")].charAt(6);
  }

  void bottom() {
    String aux = c[ff.get("bottom")];
    c[ff.get("bottom")] = new StringBuilder(c[ff.get("back")]).reverse().toString();
    c[ff.get("back")] = new StringBuilder(c[ff.get("top")]).reverse().toString();
    c[ff.get("top")] = c[ff.get("front")];
    c[ff.get("front")] = aux;

    c[ff.get("left")] = ""
      + c[ff.get("left")].charAt(2)
      + c[ff.get("left")].charAt(5)
      + c[ff.get("left")].charAt(8)
      + c[ff.get("left")].charAt(1)
      + c[ff.get("left")].charAt(4)
      + c[ff.get("left")].charAt(7)
      + c[ff.get("left")].charAt(0)
      + c[ff.get("left")].charAt(3)
      + c[ff.get("left")].charAt(6);

    c[ff.get("right")] = ""
      + c[ff.get("right")].charAt(6)
      + c[ff.get("right")].charAt(3)
      + c[ff.get("right")].charAt(0)
      + c[ff.get("right")].charAt(7)
      + c[ff.get("right")].charAt(4)
      + c[ff.get("right")].charAt(1)
      + c[ff.get("right")].charAt(8)
      + c[ff.get("right")].charAt(5)
      + c[ff.get("right")].charAt(2);
  }

  //move req
  void f() {
    String aux = c[ff.get("top")].substring(6, 8+1);
    c[ff.get("top")] = c[ff.get("top")].substring(0, 6)
      + c[ff.get("left")].charAt(8)
      + c[ff.get("left")].charAt(5)
      + c[ff.get("left")].charAt(2);

    c[ff.get("left")] = c[ff.get("left")].substring(0, 2) + c[ff.get("bottom")].charAt(0)
      + c[ff.get("left")].substring(2 + 1);
    c[ff.get("left")] = c[ff.get("left")].substring(0, 5) + c[ff.get("bottom")].charAt(1)
      + c[ff.get("left")].substring(5 + 1);
    c[ff.get("left")] = c[ff.get("left")].substring(0, 8) + c[ff.get("bottom")].charAt(2)
      + c[ff.get("left")].substring(8 + 1);

    c[ff.get("bottom")] = "" + c[ff.get("right")].charAt(6) + c[ff.get("right")].charAt(3) + c[ff.get("right")].charAt(0)
      +c[ff.get("bottom")].substring(3, 8+1);

    c[ff.get("right")] = c[ff.get("right")].substring(0, 0) + aux.charAt(0)
      + c[ff.get("right")].substring(0 + 1);
    c[ff.get("right")] = c[ff.get("right")].substring(0, 3) + aux.charAt(1)
      + c[ff.get("right")].substring(3 + 1);
    c[ff.get("right")] = c[ff.get("right")].substring(0, 6) + aux.charAt(2)
      + c[ff.get("right")].substring(6 + 1);

    c[ff.get("front")] = ""
      + c[ff.get("front")].charAt(6)
      + c[ff.get("front")].charAt(3)
      + c[ff.get("front")].charAt(0)
      + c[ff.get("front")].charAt(7)
      + c[ff.get("front")].charAt(4)
      + c[ff.get("front")].charAt(1)
      + c[ff.get("front")].charAt(8)
      + c[ff.get("front")].charAt(5)
      + c[ff.get("front")].charAt(2);
  }

  void f_() {
    String aux = c[ff.get("top")].substring(6, 8+1);
    c[ff.get("top")] = c[ff.get("top")].substring(0, 6)
      + c[ff.get("right")].charAt(0)
      + c[ff.get("right")].charAt(3)
      + c[ff.get("right")].charAt(6);

    c[ff.get("right")] = c[ff.get("right")].substring(0, 0) + c[ff.get("bottom")].charAt(2)
      + c[ff.get("right")].substring(0 + 1);
    c[ff.get("right")] = c[ff.get("right")].substring(0, 3) + c[ff.get("bottom")].charAt(1)
      + c[ff.get("right")].substring(3 + 1);
    c[ff.get("right")] = c[ff.get("right")].substring(0, 6) + c[ff.get("bottom")].charAt(0)
      + c[ff.get("right")].substring(6 + 1);

    c[ff.get("bottom")] = "" + c[ff.get("left")].charAt(2) + c[ff.get("left")].charAt(5) + c[ff.get("left")].charAt(8)
      +c[ff.get("bottom")].substring(3, 8+1);

    c[ff.get("left")] = c[ff.get("left")].substring(0, 2) + aux.charAt(2)
      + c[ff.get("left")].substring(2 + 1);
    c[ff.get("left")] = c[ff.get("left")].substring(0, 5) + aux.charAt(1)
      + c[ff.get("left")].substring(5 + 1);
    c[ff.get("left")] = c[ff.get("left")].substring(0, 8) + aux.charAt(0)
      + c[ff.get("left")].substring(8 + 1);

    c[ff.get("front")] = ""
      + c[ff.get("front")].charAt(2)
      + c[ff.get("front")].charAt(5)
      + c[ff.get("front")].charAt(8)
      + c[ff.get("front")].charAt(1)
      + c[ff.get("front")].charAt(4)
      + c[ff.get("front")].charAt(7)
      + c[ff.get("front")].charAt(0)
      + c[ff.get("front")].charAt(3)
      + c[ff.get("front")].charAt(6);
  }

  //move methods
  void F() {
    f();
    moves.add("F");
  }


  void F_() {
    f_();
    moves.add("F_");
  }


  void R() {
    right();
    f();
    left();
    moves.add("R");
  }


  void R_() {
    right();
    f_();
    left();
    moves.add("R_");
  }


  void L() {
    left();
    f();
    right();
    moves.add("L");
  }


  void L_() {
    left();
    f_();
    right();
    moves.add("L_");
  }


  void U() {
    top();
    f();
    bottom();
    moves.add("U");
  }


  void U_() {
    top();
    f_();
    bottom();
    moves.add("U_");
  }


  void D() {
    bottom();
    f();
    top();
    moves.add("D");
  }


  void D_() {
    bottom();
    f_();
    top();
    moves.add("D_");
  }


  void B() {
    right();
    right();
    f();
    right();
    right();
    moves.add("B");
  }


  void B_() {
    right();
    right();
    f_();
    right();
    right();
    moves.add("B_");
  }

  //find faces
  ArrayList<Character> findEdge(String face, int y, int x) {
    ArrayList<Character> n = new ArrayList<>();
    n.add(c[ff.get(face)].charAt(y*3 + x));

    if (face == "back") {
      changeFaceInt("right");
      changeFaceInt("right");
    } else if (face != "front")
      changeFaceInt(face);

    if (y == 0)
      n.add(c[0].charAt(7));
    else if (y == 1 && x == 0)
      n.add(c[5].charAt(5));
    else if (y == 1 && x == 2)
      n.add(c[4].charAt(3));
    else if (y == 2)
      n.add(c[2].charAt(1));

    if (face == "back") {
      changeFaceInt("right");
      changeFaceInt("right");
    } else if (face != "front") {
      changeFaceInt(face);
      changeFaceInt(face);
      changeFaceInt(face);
    }

    return n;
  }

  ArrayList<Character> findCorner(String face, int y, int x) {
    ArrayList<Character> n = new ArrayList<>();
    n.add(c[ff.get(face)].charAt(y*3 + x));

    if (face == "back") {
      changeFaceInt("right");
      changeFaceInt("right");
    } else if (face != "front")
      changeFaceInt(face);

    if (y == 0 && x == 0) {
      n.add(c[0].charAt(6));
      n.add(c[5].charAt(2));
    } else if (y == 0 && x == 2) {
      n.add(c[0].charAt(8));
      n.add(c[4].charAt(0));
    } else if (y == 2 && x == 0) {
      n.add(c[2].charAt(0));
      n.add(c[5].charAt(8));
    } else if (y == 2 && x == 2) {
      n.add(c[2].charAt(2));
      n.add(c[4].charAt(6));
    }

    if (face == "back") {
      changeFaceInt("right");
      changeFaceInt("right");
    } else if (face != "front") {
      changeFaceInt(face);
      changeFaceInt(face);
      changeFaceInt(face);
    }

    return n;
  }

  //draw the cube
  void show() {
    //top
    rectt(-w, -w, -w, 0, -1, 0, c[0].charAt(0));
    rectt( 0, -w, -w, 0, -1, 0, c[0].charAt(1));
    rectt( w, -w, -w, 0, -1, 0, c[0].charAt(2));
    rectt(-w, -w, 0, 0, -1, 0, c[0].charAt(3));
    rectt( 0, -w, 0, 0, -1, 0, c[0].charAt(4));
    rectt( w, -w, 0, 0, -1, 0, c[0].charAt(5));
    rectt(-w, -w, w, 0, -1, 0, c[0].charAt(6));
    rectt( 0, -w, w, 0, -1, 0, c[0].charAt(7));
    rectt( w, -w, w, 0, -1, 0, c[0].charAt(8));

    //front
    rectt(-w, -w, w, 0, 0, 1, c[1].charAt(0));
    rectt( 0, -w, w, 0, 0, 1, c[1].charAt(1));
    rectt( w, -w, w, 0, 0, 1, c[1].charAt(2));
    rectt(-w, 0, w, 0, 0, 1, c[1].charAt(3));
    rectt( 0, 0, w, 0, 0, 1, c[1].charAt(4));
    rectt( w, 0, w, 0, 0, 1, c[1].charAt(5));
    rectt(-w, w, w, 0, 0, 1, c[1].charAt(6));
    rectt( 0, w, w, 0, 0, 1, c[1].charAt(7));
    rectt( w, w, w, 0, 0, 1, c[1].charAt(8));

    ////bottom
    rectt(-w, w, w, 0, 1, 0, c[2].charAt(0));
    rectt( 0, w, w, 0, 1, 0, c[2].charAt(1));
    rectt( w, w, w, 0, 1, 0, c[2].charAt(2));
    rectt(-w, w, 0, 0, 1, 0, c[2].charAt(3));
    rectt( 0, w, 0, 0, 1, 0, c[2].charAt(4));
    rectt( w, w, 0, 0, 1, 0, c[2].charAt(5));
    rectt(-w, w, -w, 0, 1, 0, c[2].charAt(6));
    rectt( 0, w, -w, 0, 1, 0, c[2].charAt(7));
    rectt( w, w, -w, 0, 1, 0, c[2].charAt(8));

    ////back
    rectt( w, -w, -w, 0, 0, -1, c[3].charAt(0));
    rectt( 0, -w, -w, 0, 0, -1, c[3].charAt(1));
    rectt( -w, -w, -w, 0, 0, -1, c[3].charAt(2));
    rectt( w, 0, -w, 0, 0, -1, c[3].charAt(3));
    rectt( 0, 0, -w, 0, 0, -1, c[3].charAt(4));
    rectt( -w, 0, -w, 0, 0, -1, c[3].charAt(5));
    rectt( w, w, -w, 0, 0, -1, c[3].charAt(6));
    rectt( 0, w, -w, 0, 0, -1, c[3].charAt(7));
    rectt( -w, w, -w, 0, 0, -1, c[3].charAt(8));

    ////right
    rectt(w, -w, w, 1, 0, 0, c[4].charAt(0));
    rectt(w, -w, 0, 1, 0, 0, c[4].charAt(1));
    rectt(w, -w, -w, 1, 0, 0, c[4].charAt(2));
    rectt(w, 0, w, 1, 0, 0, c[4].charAt(3));
    rectt(w, 0, 0, 1, 0, 0, c[4].charAt(4));
    rectt(w, 0, -w, 1, 0, 0, c[4].charAt(5));
    rectt(w, w, w, 1, 0, 0, c[4].charAt(6));
    rectt(w, w, 0, 1, 0, 0, c[4].charAt(7));
    rectt(w, w, -w, 1, 0, 0, c[4].charAt(8));

    ////left
    rectt(-w, -w, -w, -1, 0, 0, c[5].charAt(0));
    rectt(-w, -w, 0, -1, 0, 0, c[5].charAt(1));
    rectt(-w, -w, w, -1, 0, 0, c[5].charAt(2));
    rectt(-w, 0, -w, -1, 0, 0, c[5].charAt(3));
    rectt(-w, 0, 0, -1, 0, 0, c[5].charAt(4));
    rectt(-w, 0, w, -1, 0, 0, c[5].charAt(5));
    rectt(-w, w, -w, -1, 0, 0, c[5].charAt(6));
    rectt(-w, w, 0, -1, 0, 0, c[5].charAt(7));
    rectt(-w, w, w, -1, 0, 0, c[5].charAt(8));
  }

  void rectt(float x, float y, float z, int xx, int yy, int zz, char ch) {
    pushMatrix();
    translate(x, y, z);
    beginShape();

    switch(ch) {
      case('W'):
      fill(255, 255, 255);
      break;
      case('R'):
      fill(255, 0, 0);
      break;
      case('Y'):
      fill(255, 255, 0);
      break;
      case('O'):
      fill(255, 150, 0);
      break;
      case('B'):
      fill(0, 0, 255);
      break;
      case('G'):
      fill(0, 200, 0);
      break;
    }

    if (xx == 1) { //right
      vertex(w/2, w/2, w/2);
      vertex(w/2, w/2, -w/2);
      vertex(w/2, -w/2, -w/2);
      vertex(w/2, -w/2, w/2);
    } else if (xx == -1) { //left
      vertex(-w/2, w/2, w/2);
      vertex(-w/2, w/2, -w/2);
      vertex(-w/2, -w/2, -w/2);
      vertex(-w/2, -w/2, w/2);
    } else if (yy == 1) { //bottom
      vertex(w/2, w/2, w/2);
      vertex(w/2, w/2, -w/2);
      vertex(-w/2, w/2, -w/2);
      vertex(-w/2, w/2, w/2);
    } else if (yy == -1) { //top
      vertex(w/2, -w/2, w/2);
      vertex(w/2, -w/2, -w/2);
      vertex(-w/2, -w/2, -w/2);
      vertex(-w/2, -w/2, w/2);
    } else if (zz == 1) { //front
      vertex(-w/2, -w/2, w/2);
      vertex(-w/2, w/2, w/2);
      vertex(w/2, w/2, w/2);
      vertex(w/2, -w/2, w/2);
    } else if (zz == -1) { //back
      vertex(-w/2, -w/2, -w/2);
      vertex(-w/2, w/2, -w/2);
      vertex(w/2, w/2, -w/2);
      vertex(w/2, -w/2, -w/2);
    }

    endShape();
    popMatrix();
  }

  void print() {
    println();
    printArray(c);
    println();
  }

  void generate(int x) {
    moves = new ArrayList<>();

    for (int i=0; i<50; i++) {
      int j = floor(random(6));

      switch(j) {
        case(0):
        F();
        break;
        case(1):
        B();
        break;
        case(2):
        U();
        break;
        case(3):
        D();
        break;
        case(4):
        L();
        break;
        case(5):
        R();
        break;
      }
    }

    if (x == 1)
      this.print();
  }
}
