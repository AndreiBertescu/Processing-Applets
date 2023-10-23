class Text {
  PFont mono;
  String x;
  int X, Y, nr;

  Text() {
    mono = createFont("Courier New", 18);
    X = width-w; //290
    Y = 0;
  }

  void show() {
    fill(0);
    noStroke();
    rect(width-w, 0, w, height);

    fill(255);
    rect(width-w + 10, 10, w-20, 30);
    fill(0);
    textAlign(CENTER);
    text("RESTART", X + w/2, 30);

    translate(width-w + 10, 40);
    fill(255);
    textFont(mono);
    textAlign(LEFT);

    x = "Nr. noduri: " + nodes.size();
    text(x, 0, 25);

    x = "Nr. muchii: " + lines.size();
    text(x, 0, 25*2);

    if (nodes.size() > 0) {
      x = "Grad: ";
      for (Node n : nodes) {
        nr=0;

        for (Line l : lines)
          if (l.n1 == n || l.n2 == n)
            nr++;

        x+=nr;
        x+=" ";
      }
      text(x, 0, 25*3);
    }

    if (lines.size() > 0) {
      nr = 1;
      text("Muchii: ", 0, 25*4);
      for (Line l : lines) {
        x = min(l.n1.i, l.n2.i) + " " + max(l.n1.i, l.n2.i);
        text(x, 10, 25*(nr+++4));
      }
    }
  }
}
