void whiteCorners(Cube cube) {
  int bec = 0;
  char aux1[] = {cube.c[0].charAt(4), cube.c[3].charAt(4), cube.c[5].charAt(4)};
  char aux2[] = {cube.c[0].charAt(4), cube.c[3].charAt(4), cube.c[4].charAt(4)};
  char aux3[] = {cube.c[0].charAt(4), cube.c[1].charAt(4), cube.c[5].charAt(4)};
  char aux4[] = {cube.c[0].charAt(4), cube.c[1].charAt(4), cube.c[4].charAt(4)};

  if (equals(sort(aux1), sort(toArray(cube.findCorner("top", 0, 0)))) ||
    equals(sort(aux2), sort(toArray(cube.findCorner("top", 0, 2)))) ||
    equals(sort(aux3), sort(toArray(cube.findCorner("top", 2, 0)))) ||
    equals(sort(aux4), sort(toArray(cube.findCorner("top", 2, 2)))) )
    bec = 1;
  if (equals(sort(aux1), sort(toArray(cube.findCorner("top", 0, 0)))) &&
    equals(sort(aux2), sort(toArray(cube.findCorner("top", 0, 2)))) &&
    equals(sort(aux3), sort(toArray(cube.findCorner("top", 2, 0)))) &&
    equals(sort(aux4), sort(toArray(cube.findCorner("top", 2, 2)))) )
    bec = 2;

  if (bec != 2) {
    if (bec == 0) {
      cube.U();
      cube.R();
      cube.U_();
      cube.L_();

      cube.U();
      cube.R_();
      cube.U_();
      cube.L();

      bec = 1;
    }

    aux4 = new char[] {cube.c[0].charAt(4), cube.c[1].charAt(4), cube.c[4].charAt(4)};
    while (!equals(sort(aux4), sort(toArray(cube.findCorner("front", 0, 2))))) {
      cube.changeFace("right");
      aux4 = new char[] {cube.c[0].charAt(4), cube.c[1].charAt(4), cube.c[4].charAt(4)};
    }

    cube.U();
    cube.R();
    cube.U_();
    cube.L_();

    cube.U();
    cube.R_();
    cube.U_();
    cube.L();


    aux1 = new char[] {cube.c[0].charAt(4), cube.c[3].charAt(4), cube.c[5].charAt(4)};
    aux2 = new char[] {cube.c[0].charAt(4), cube.c[3].charAt(4), cube.c[4].charAt(4)};
    aux3 = new char[] {cube.c[0].charAt(4), cube.c[1].charAt(4), cube.c[5].charAt(4)};
    aux4 = new char[] {cube.c[0].charAt(4), cube.c[1].charAt(4), cube.c[4].charAt(4)};

    if (!equals(sort(aux1), sort(toArray(cube.findCorner("top", 0, 0)))) ||
      !equals(sort(aux2), sort(toArray(cube.findCorner("top", 0, 2)))) ||
      !equals(sort(aux3), sort(toArray(cube.findCorner("top", 2, 0)))) ||
      !equals(sort(aux4), sort(toArray(cube.findCorner("top", 2, 2)))) ) {
      cube.U();
      cube.R();
      cube.U_();
      cube.L_();

      cube.U();
      cube.R_();
      cube.U_();
      cube.L();
    }
  }

  for (int i=0; i<4; i++) {
    char[] aux5 = {cube.c[1].charAt(1), 'W', cube.c[4].charAt(1)};
    while (!equals(aux5, toArray(cube.findCorner("front", 0, 2)))) {
      cube.R_();
      cube.D_();
      cube.R();
      cube.D();
    }

    cube.U();
  }
}
