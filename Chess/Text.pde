class Text {

  Text() {
  }

  void show() {
    pushMatrix();
    translate(width - textWidth, 0);
    fill(0);
    noStroke();
    rect(0, 0, textWidth, height);
    stroke(0);

    fill(255);
    rect(40, 60, 180, 50);
    fill(0);
    if (!alert)
      text("RESTART", 40 + 180/2, 60 + 50/2 + 8);
    else
      text("ARE YOU SURE?", 40 + 180/2, 60 + 50/2 + 8);

    textSize(16);
    if (currentTurn == "B") {
      fill(0);
      stroke(255);
      circle(310, 85, 110);
      fill(255);
      text("CURRENT\nTURN", 310, 80);
    } else {
      fill(255);
      circle(310, 85, 110);
      fill(0);
      text("CURRENT\nTURN", 310, 80);
    }
    textSize(20);
    stroke(0);

    if (removedPieces.size() > 0) {
      fill(255);
      text("Lost pieces:", 90, 170);
      for (int i=0; i<removedPieces.size(); i++) {
        text(removedPieces.get(i).type + " " + removedPieces.get(i).c, 80, 170 + 30*(i+1));
      }
    }

    popMatrix();
  }
}
