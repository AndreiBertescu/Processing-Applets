class Node {
  int[] mini = new int[nr];
  float[] dists = new float[n];
  PVector pos, dir;
  int id, minii;

  Node(PVector pos, int id) {
    this.id = id;
    this.pos = pos;
    dir = PVector.random2D().setMag(1);
  }

  void update() {
    pos.add(dir);
    if (pos.x+r/2+1 <= 0)
      pos.x = width+1;
    if (pos.x-r/2-1 >= width)
      pos.x = -r/2-1;
    if (pos.y+r/2+1 <= 0)
      pos.y = height+1;
    if (pos.y-r/2-1 >= height)
      pos.y = -r/2-1;

    for (int i=0; i<n; i++)
      dists[i] = PVector.dist(pos, nodes[i].pos);

    for (int i=0; i<nr; i++) {
      mini[i] = minii = id;

      for (int j=0; j<n; j++)
        if ((dists[j] < dists[minii] && possible(j)) || minii == id)
          minii = j;

      mini[i] = minii;
    }
  }

  void showLines() {
    if (Color) {
      stroke(map(id, 0, n-1, 0, 255), 255, 255, 175);
      fill(map(id, 0, n-1, 0, 255), 255, 255, 255);
    }
    for (int i=0; i<nr; i++)
      line(pos.x, pos.y, nodes[mini[i]].pos.x, nodes[mini[i]].pos.y);
      triangle(pos.x, pos.y, nodes[mini[0]].pos.x, nodes[mini[0]].pos.y, nodes[mini[1]].pos.x, nodes[mini[1]].pos.y);
  }

  void showCircles() {
    if (Color) {
      stroke(map(id, 0, n-1, 0, 255), 255, 255, 175);
      fill(map(id, 0, n-1, 0, 255), 255, 255, 255);
    }
    circle(pos.x, pos.y, r);
  }

  boolean possible(int minii) {
    for (int i=0; i<nr; i++)
      if (mini[i] == minii)
        return false;
    return true;
  }
}
