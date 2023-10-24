void whiteCross(Cube cube) {
  int bec = 1;

  if ((cube.c[0].charAt(1) == 'W' && cube.c[0].charAt(3) == 'W') ||
    (cube.c[0].charAt(1) == 'W' && cube.c[0].charAt(5) == 'W') ||
    (cube.c[0].charAt(7) == 'W' && cube.c[0].charAt(3) == 'W') ||
    (cube.c[0].charAt(7) == 'W' && cube.c[0].charAt(5) == 'W'))
    bec = 2;
  if ((cube.c[0].charAt(1) == 'W' && cube.c[0].charAt(7) == 'W') ||
    (cube.c[0].charAt(3) == 'W' && cube.c[0].charAt(5) == 'W'))
    bec = 3;
  if (cube.c[0].charAt(1) == 'W' && cube.c[0].charAt(3) == 'W' && cube.c[0].charAt(5) == 'W' && cube.c[0].charAt(7) == 'W')
    bec = 4;

  if (bec == 3) {
    while (cube.c[0].charAt(3) != 'W')
      cube.U();

    cube.F();
    cube.R();
    cube.U();
    cube.R_();
    cube.U_();
    cube.F_();
  } else if (bec == 2) {
    while (cube.c[0].charAt(3) != 'W' || cube.c[0].charAt(1) != 'W')
      cube.U();

    cube.F();
    cube.R();
    cube.U();
    cube.R_();
    cube.U_();

    cube.R();
    cube.U();
    cube.R_();
    cube.U_();
    cube.F_();
  } else if (bec == 1) {
    cube.F();
    cube.R();
    cube.U();
    cube.R_();
    cube.U_();
    cube.F_();

    cube.F();
    cube.R();
    cube.U();
    cube.R_();
    cube.U_();
    cube.F_();

    if (cube.c[0].charAt(3) != 'W')
      cube.changeFace("right");

    cube.F();
    cube.R();
    cube.U();
    cube.R_();
    cube.U_();
    cube.F_();
  }

  while (cube.c[1].charAt(1) != cube.c[1].charAt(4))
    cube.U();
  cube.changeFace("left");

  if (cube.c[1].charAt(1) == cube.c[1].charAt(4))
    cube.changeFace("left");
  else {
    cube.R();
    cube.U();
    cube.R_();
    cube.U();
    cube.R();

    cube.U();
    cube.U();
    cube.R_();
    cube.U();

    cube.changeFace("left");

    if (cube.c[4].charAt(1) != cube.c[4].charAt(4)) {
      cube.R();
      cube.U();
      cube.R_();
      cube.U();
      cube.R();

      cube.U();
      cube.U();
      cube.R_();
      cube.U();

      cube.changeFace("right");

      cube.R();
      cube.U();
      cube.R_();
      cube.U();
      cube.R();

      cube.U();
      cube.U();
      cube.R_();
      cube.U();

      cube.changeFace("left");
    }
  }

  if (cube.c[1].charAt(1) != cube.c[1].charAt(4)) {
    cube.R();
    cube.U();
    cube.R_();
    cube.U();
    cube.R();

    cube.U();
    cube.U();
    cube.R_();
    cube.U();
  }
}
