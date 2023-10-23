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
    translate(j*w, i*h);

    if (visited) {
      noStroke();
      fill(0);
      rect(0, 0, w, h);
    }

    stroke(255);
    if (walls[0])
      line(0, 0, w-1, 0);
    if (walls[1])
      line(0, 0, 0, h-1);
    if (walls[2])
      line(w-1, 0, w-1, h-1);
    if (walls[3])
      line(0, h-1, w-1, h-1);

    popMatrix();
  }
}
