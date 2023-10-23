class Piece {
  int IN, OUT;
  int[] input, output;
  boolean first;
  String[] lines;

  float x, y;
  float h;

  String TYPE;
  color c;

  boolean dragged = false;
  float xoff, yoff;

  int mh = 50;
  float w = 75;
  int r;

  Piece(String type, float x, float y, boolean first) {
    lines = loadStrings("types/" + type + ".txt");
    TYPE = type;
    this.first = first;

    IN = Integer.valueOf(lines[0]);
    OUT = Integer.valueOf(lines[1]);
    r = (int)map(max(IN, OUT), 1, 20, 15, 10);

    input = new int[IN];
    output = new int[OUT];

    this.x = x;
    this.y = y;

    h = max(max(IN, OUT) * r * 1.5, mh);
    w = max(w, textWidth(TYPE)+30);

    c = color(Integer.valueOf(lines[lines.length-1].split(" ")[0]), Integer.valueOf(lines[lines.length-1].split(" ")[1]), Integer.valueOf(lines[lines.length-1].split(" ")[2]));
  }

  void update() {
    if (first) {
      x = mouseX;
      y = mouseY;
    } else if (dragged) {
      //limit in canvas space
      if (mouseX-25 + xoff - 3 < r/2)
        x = r/2 + 3;
      else if (mouseX-25 + (w+xoff) + 3 > CX - r/2)
        x = CX - w - r/2 - 3;
      else
        x = mouseX-25 + xoff;

      if (mouseY-25 + yoff - 3 < 0)
        y = 3;
      else if (mouseY-25 + (h+yoff) + 3 > CY)
        y = CY - h - 3;
      else
        y = mouseY-25 + yoff;
    }

    checkTable();
  }

  void show() {
    pushMatrix();
    translate(x, y);

    fill(c);
    noStroke();
    rect(0, 0, w, h, 2);

    //draw IN ports
    for (int i=0; i<IN; i++) {
      if (dist(mouseX-25, mouseY-25, x, y + h/IN * (i+0.5)) < r/2)
        fill(100);
      else
        fill(0);
      circle(0, h/IN * (i+0.5), r);
    }

    //draw OUT ports
    for (int i=0; i<OUT; i++) {
      if (output[i] == 1) {
        fill(196, 3, 0);
        circle(w, h/OUT * (i+0.5), r);

        if (dist(mouseX-25, mouseY-25, x + w, y + h/OUT * (i+0.5)) < r/2 && type == -1)
          fill(0, 50);
        circle(w, h/OUT * (i+0.5), r);
      } else {
        fill(0);
        if (dist(mouseX-25, mouseY-25, x + w, y + h/OUT * (i+0.5)) < r/2 && type == -1)
          fill(100);

        circle(w, h/OUT * (i+0.5), r);
      }
    }

    textSize(18);
    fill(255);
    text(TYPE, w/2, h/2+5);
    popMatrix();
  }

  void checkTable() {
    String s = "";
    for (int i=0; i<IN; i++)
      s += String.valueOf(input[i]);

    String[] values = lines[2 + Integer.parseInt(s, 2)].split(" ");
    for (int j=0; j<OUT; j++)
      output[j] = Integer.valueOf(values[j]);
  }
}
