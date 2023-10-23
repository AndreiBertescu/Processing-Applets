class Cell {
  int i, j;
  boolean[] walls;
  boolean visited;

  Cell(int i, int j) {
    this.i = i;
    this.j = j;

    visited = false;

    walls = new boolean[4];
    for (int k=0; k<4; k++)
      walls[k] = true;
  }

  void show() {
    pushMatrix();
    translate(j*w, i*w);

    if (visited) {
      noStroke();
      fill(100, 0, 100);
      rect(0, 0, w, w);
    }
    //if (this == current) {
    //  noStroke();
    //  fill(255, 0, 255);
    //  rect(0, 0, w, w);
    //}

    stroke(255);
    if (walls[0])
      line(0, 0, w, 0);
    if (walls[1])
      line(0, 0, 0, w);
    if (walls[2])
      line(w, 0, w, w);
    if (walls[3])
      line(0, w, w, w);

    popMatrix();
  }
}
