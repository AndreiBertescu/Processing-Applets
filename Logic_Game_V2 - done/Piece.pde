class Piece {
  int nrInputs, nrOutputs, hoveredPort;
  int[] inputSets, outputSets;
  boolean[] input, output;
  boolean changed;

  float x, y, w, h;
  String TYPE;
  color c;

  Piece(String type, float x, float y) {
    hoveredPort = -1;
    TYPE = type;
    changed = true;

    inputSets = null;
    outputSets = null;

    this.x = x;
    this.y = y;
  }

  void update() {
    if (isNewPiece && newPiece == this) {
      x = mouseX - w/2;
      y = mouseY - h/2;
      return;
    }

    //check ports if hovered
    for (int i=0; i<nrInputs; i++)
      if (dist(map(mouseX, 0, width, 0, width/scale), map(mouseY, 0, height, 0, height/scale), x + mainCanvas.offset.x, y + (h/(nrInputs+0.3) * (i+0.65)) + mainCanvas.offset.y) < r/2) {
        hoveredPort = i;
        return;
      }
    for (int i=0; i<nrOutputs; i++)
      if (dist(map(mouseX, 0, width, 0, width/scale), map(mouseY, 0, height, 0, height/scale), x + w + mainCanvas.offset.x, y + (h/(nrOutputs+0.3) * (i+0.65)) + mainCanvas.offset.y) < r/2) {
        hoveredPort = nrInputs + i;
        return;
      }
    hoveredPort = -1;
  }

  void show() {
    pushMatrix();
    translate(x, y);

    fill(c);
    noStroke();
    rect(0, 0, w, h, 2);

    //draw input sets
    rectMode(CENTER);
    strokeWeight(2);
    fill(255);
    stroke(0);

    int nr = 0;
    if (inputSets != null)
      for (int i : inputSets) {
        if (i > 1) {
          float hght1 = h/(nrInputs+0.3) * (nr + 0.65);
          float hght2 = h/(nrInputs+0.3) * (nr + i-1 + 0.65);

          line(0, hght1, r+3, hght1);
          line(r+3, hght1, r+3, hght2);
          line(0, hght2, r+3, hght2);

          square(r+3, hght1 + (hght2-hght1)/2, bigPortWidth);
        }

        nr += i;
      }

    //draw output sets
    nr = 0;
    if (outputSets != null) {
      for (int i : outputSets) {
        if (i > 1) {
          float hght1 = h/(nrOutputs+0.3) * (nr + 0.65);
          float hght2 = h/(nrOutputs+0.3) * (nr + i-1 + 0.65);

          line(w, hght1, w - r-3, hght1);
          line(w - r-3, hght1, w - r-3, hght2);
          line(w, hght2, w - r-3, hght2);

          square(w - r-3, hght1 + (hght2-hght1)/2, bigPortWidth);
        }

        nr += i;
      }
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
    fill(255);
    text(TYPE, w/2, h/2+5);
    popMatrix();
  }
}
