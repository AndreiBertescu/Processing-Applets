class IO extends Piece {
  int id;

  IO(String type, float x, float y, int nrPorts, Canvas canvas) {
    super(type, x, y);
    TYPE = type;

    if (type.matches("OUT")) {
      id = nrOfOutputs++;
      nrInputs = nrPorts;
      input = new boolean[nrInputs];
      output = null;
    } else if (type.matches("IN")) {
      id = nrOfInputs++;
      nrOutputs = nrPorts;
      output = new boolean[nrOutputs];
      input = null;
    }

    textSize(20);
    h = max(max(nrInputs, nrOutputs) * r * 2, minh);
    w = max(minw, textWidth("no. "+id)+80);
    c = color(255, 150, 50);

    if (type.matches("OUT") && nrInputs > 1)
      canvas.bigConnections.add(new BigConnection(r+3, h/2, 0, nrInputs-1, this, -1));
    else if (type.matches("IN") && nrOutputs > 1)
      canvas.bigConnections.add(new BigConnection(w - r-3, h/2, 0, nrOutputs-1, this, 1));
  }

  void show() {
    pushMatrix();
    translate(x, y);

    fill(c);
    noStroke();
    rect(0, 0, w, h, 2);

    //draw sets
    rectMode(CENTER);
    strokeWeight(2);
    stroke(0);
    fill(255);

    if (TYPE.matches("IN") && nrOutputs > 1) {
      float hght1 = h/(nrOutputs+0.3) * (0.65);
      float hght2 = h/(nrOutputs+0.3) * (nrOutputs - 1 + 0.65);

      line(w, hght1, w - r-3, hght1);
      line(w - r-3, hght1, w - r-3, hght2);
      line(w, hght2, w - r-3, hght2);

      square(w - r-3, h/2, bigPortWidth);
    } else if (TYPE.matches("OUT") && nrInputs > 1) {
      float hght1 = h/(nrInputs+0.3) * (0.65);
      float hght2 = h/(nrInputs+0.3) * (nrInputs - 1 + 0.65);

      line(0, hght1, r+3, hght1);
      line(r+3, hght1, r+3, hght2);
      line(0, hght2, r+3, hght2);

      square(r+3, h/2, bigPortWidth);
    }
    rectMode(CORNER);

    //draw input ports
    for (int i=0; i<nrInputs; i++) {
      float hght = h/(nrInputs+0.3) * (i+0.65);

      stroke(0);
      strokeWeight(1.5);
      fill(input[i] ? cTrue:cFalse);
      circle(0, hght, r);


      if (hoveredPort == i) {
        noStroke();
        fill(input[i] ? color(0, 50):color(255, 100));
        circle(0, hght, r);
      }
    }

    //draw output ports
    for (int i=0; i<nrOutputs; i++) {
      float hght = h/(nrOutputs+0.3) * (i+0.65);

      stroke(0);
      strokeWeight(1.5);
      fill(output[i] ? cTrue:cFalse);
      circle(w, hght, r);


      if (hoveredPort == nrInputs + i) {
        noStroke();
        fill(output[i] ? color(0, 50):color(255, 100));
        circle(w, hght, r);
      }
    }

    //write text type
    textSize(20);
    textLeading(20);
    fill(255);
    if (TYPE.matches("IN"))
      text(TYPE + "\nno. " + id, w/2, h/2 - 3);
    else if (TYPE.matches("OUT"))
      text(TYPE + "\nno. " + id, w/2, h/2 - 3);
    popMatrix();
  }
}
