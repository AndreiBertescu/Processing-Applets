void firstLayer(Cube cube) {
  for (int i=0; i<4; i++) {
    if (cube.findCorner("front", 2, 2).contains('Y')) {
      while (cube.findCorner("front", 0, 2).contains('Y'))
        cube.U();

      cube.R();
      cube.U();
      cube.R_();
    }
    cube.D();
  }

  for (int i=0; i<4; i++) {
    char aux[] = {cube.c[1].charAt(4), 'Y', cube.c[4].charAt(4)};
    while (!equals(sort(aux), sort(toArray(cube.findCorner("front", 0, 2)))))
      cube.U();

    if (cube.findCorner("front", 0, 2).indexOf('Y') == 0) {
      cube.F_();
      cube.U_();
      cube.F();
    } else if (cube.findCorner("front", 0, 2).indexOf('Y') == 2) {
      cube.R();
      cube.U();
      cube.R_();
    } else if (cube.findCorner("front", 0, 2).indexOf('Y') == 1) {
      cube.R();
      cube.U();
      cube.U();
      cube.R_();
      cube.U_();

      cube.R();
      cube.U();
      cube.R_();
    }

    cube.changeFace("right");
  }
}

void secondLayer(Cube cube) {
  for (int i=0; i<4; i++) {
    if (!cube.findEdge("front", 1, 0).contains('W')) {
      while (!cube.findEdge("front", 0, 1).contains('W'))
        cube.U();

      cube.U_();
      cube.L_();
      cube.U();
      cube.L();

      cube.U();
      cube.F();
      cube.U_();
      cube.F_();
    }

    cube.changeFace("right");
  }

  for (int i=0; i<4; i++) {
    char aux[] = {cube.c[1].charAt(4), cube.c[5].charAt(4)};
    while (!equals(sort(aux), sort(toArray(cube.findEdge("front", 0, 1)))))
      cube.U();

    cube.U_();
    cube.L_();
    cube.U();
    cube.L();

    cube.U();
    cube.F();
    cube.U_();
    cube.F_();

    if (cube.c[1].charAt(3) != cube.c[1].charAt(4)) {
      cube.U_();
      cube.L_();
      cube.U();
      cube.L();

      cube.U();
      cube.F();
      cube.U_();
      cube.F_();

      cube.U_();
      cube.U_();

      cube.U_();
      cube.L_();
      cube.U();
      cube.L();

      cube.U();
      cube.F();
      cube.U_();
      cube.F_();
    }

    cube.changeFace("right");
  }
}
