void yellowCross(Cube cube) {

  for (int i=0; i<=5; i++) {
    if (cube.findEdge("front", 1, 0).contains('Y')) {
      while (cube.findEdge("top", 1, 0).contains('Y'))
        cube.U();
      cube.L_();
    }

    if (cube.findEdge("front", 1, 2).contains('Y')) {
      while (cube.findEdge("top", 1, 2).contains('Y'))
        cube.U();
      cube.R();
    }

    if (cube.findEdge("front", 2, 1).contains('Y')) {
      while (cube.findEdge("top", 2, 1).contains('Y'))
        cube.U();
      cube.F();
      cube.F();
    }

    cube.changeFace("right");
  }
  
  for (int i=0; i<4; i++) {
    char aux[] = {cube.c[1].charAt(4), 'Y'};
    while (!equals(sort(aux), sort(toArray(cube.findEdge("front", 0, 1)))))
      cube.U();

    if (cube.c[1].charAt(1) == cube.c[1].charAt(4)) {
      cube.F();
      cube.F();
    } else {
      cube.U();
      cube.L();
      cube.F_();
      cube.L_();
    }

    cube.changeFace("right");
  }
}
