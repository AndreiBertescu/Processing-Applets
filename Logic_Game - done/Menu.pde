class Menu {
  boolean saveHover = false;
  boolean clearHover = false;

  int fw = MX-8;
  int fh = 40;
  int hover = 3;
  int off = 4;

  Menu() {
  }

  void update() {
    files = dir.list();

    if (mouseX-(CX+50+off) >= 0 && mouseX-(CX+50+off) <= MX-off*2 && mouseY-(25+off) >= 0 && mouseY-(25+off) <= 40)
      saveHover = true;
    else
      saveHover = false;

    if (mouseX-(CX+50+off) >= 0 && mouseX-(CX+50+off) <= MX-off*2 && mouseY-(25+off)-(40+off) >= 0 && mouseY-(25+off)-(40+off) <= 40)
      clearHover = true;
    else
      clearHover = false;

    if (mouseX-(CX+50+off) >= 0 && mouseX-(CX+50+off) <= MX-off*2 && mouseY-(25+off)-(40+off)-40 > 0)
      hover = (mouseY-(25+off)-(40+off)-40 - off*2)/fh;
    else
      hover = -1;
  }

  void show() {
    pushMatrix();
    translate(CX+50 + off, 25 + off);

    //save button
    strokeWeight(0.5);
    stroke(255);
    rect(0, 0, MX-off*2, 40);
    fill(255);
    text("SAVE CANVAS", fw/2, 30 - off);

    if (saveHover) {
      fill(255, 50);
      noStroke();
      rect(0, 0, MX-off*2, 40);
    }

    //save button
    stroke(255);
    noFill();
    rect(0, 40 + off, MX-off*2, 40);
    fill(255);
    text("CLEAR CANVAS", MX/2, 40 + 30);

    if (clearHover) {
      noStroke();
      fill(255, 50);
      rect(0, 40 + off, MX-off*2, 40);
    }

    //menu items
    translate(0, (40 + off) * 2);

    for (int i=0; i<files.length; i++) {
      pushMatrix();
      translate(0, i*fh);

      strokeWeight(0.5);
      stroke(255);
      noFill();
      rect(off, off, fw-off*2, fh-off*2);

      fill(255);
      text(files[i].substring(0, files[i].indexOf(".")), (fw-fh*1.5)/2, fh/2 + off*1.5);

      //del button
      fill(50);
      rect(fw-fh+off, off, fh-off*2, fh-off*2);
      pushMatrix();
      translate(fw-fh, 0);
      strokeWeight(2);
      stroke(255);
      line(fh/4, fh/4, fh*0.75, fh*0.75);
      line(fh/4, fh*0.75, fh*0.75, fh/4);
      popMatrix();

      //explore button
      strokeWeight(0.5);
      stroke(255);
      rect(fw-fh*2+off*3, off, fh-off*2, fh-off*2);
      pushMatrix();
      translate(fw-fh*2+off*2, off);
      strokeWeight(2);
      stroke(255);

      fill(255);
      textSize(30);
      text("E", fh/2, fh/2 + off*1.5);
      textSize(18);
      popMatrix();

      popMatrix();
    }

    //if hover
    fill(255, 40);
    noStroke();
    if (hover != -1 && hover<files.length) {
      rect(off, hover*fh + off, fw-off*2, fh-off*2);
      if (mouseX-50-CX-off*2 >= fw-fh) {
        fill(255, 50);
        rect(fw-fh+off, off + hover*fh, fh-off*2, fh-off*2);
      } else if (mouseX-50-CX-off*2 < fw-fh && mouseX-50-CX-off*2 > fw-fh*2+off*2) {
        fill(255, 50);
        rect(fw-fh*2+off*3, off + hover*fh, fh-off*2, fh-off*2);
      } else noFill();
    }
    popMatrix();
  }
}
