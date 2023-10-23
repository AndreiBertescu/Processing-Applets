class Menu {
  int w, h;
  int textSize, itemHover = -1, optHover = -1;
  float textOffset = 5, semiWidth;
  boolean saveHover = false, clearHover = false;

  Menu(int w, int h, int textSize) {
    this.w = w;
    this.h = h;
    this.textSize = textSize;

    semiWidth = w/2 - paddingEW*1.5;

    textSize(textSize);
    if (textWidth("SAVE CANVAS") > menuWidth-paddingEW*4)
      this.textSize *= ((menuWidth-paddingEW*4) / textWidth("SAVE CANVAS"));
  }

  void update() {
    h = height;

    saveHover = menuWithin(mouseX, mouseY, width-w+paddingEW, width-paddingEW, paddingNS, paddingNS + btnHeight);
    clearHover = menuWithin(mouseX, mouseY, width-w+paddingEW, width-paddingEW, paddingNS*2 + btnHeight, paddingNS*2 + btnHeight*2);

    if (menuWithin(mouseX, mouseY, width-w + paddingEW, width-w + paddingEW + semiWidth, h - paddingNS - btnHeight, h - paddingNS))
      optHover = 1;
    else if (menuWithin(mouseX, mouseY, width-w + paddingEW*2 + semiWidth, width-w + paddingEW*2 + semiWidth*2, h - paddingNS - btnHeight, h - paddingNS))
      optHover = 2;
    else
      optHover = -1;

    //check if on a button
    itemHover = -1;
    if (menuWithin(mouseX, mouseY, width-w+paddingEW, width-paddingEW, btnHeight*2 + paddingNS*3, h)) {
      float x = mouseX - (width-w+paddingEW);
      float y = mouseY - (btnHeight*2 + paddingNS*3);

      if (x > semiWidth + paddingEW)
        x = 1;
      else if (x <= semiWidth)
        x = 0;
      else
        return;

      if (y - ((btnHeight + paddingNS) * floor(y / (btnHeight+paddingNS))) > btnHeight)
        return;
      y = floor(y / (btnHeight+paddingNS));


      if (int(y*2 + x) < files.length+2)
        itemHover = int(y*2 + x);
    }
  }

  void show() {
    pushMatrix();
    textSize(textSize);
    translate(width - w, 0);

    //draw background
    fill(30);
    noStroke();
    rect(0, 0, w, h);

    //save button
    strokeWeight(0.5);
    stroke(255);

    rect(paddingEW, paddingNS, w - 2*paddingEW, btnHeight);
    fill(255);
    text("SAVE CANVAS", w/2, paddingNS + btnHeight/2 + textOffset);

    if (saveHover) {
      fill(255, mousePressed ? 70:35);
      noStroke();
      rect(paddingEW, paddingNS, w - 2*paddingEW, btnHeight);
    }

    //save button
    stroke(255);
    noFill();
    rect(paddingEW, 2*paddingNS + btnHeight, w - 2*paddingEW, btnHeight);
    fill(255);
    text("CLEAR CANVAS", w/2, 2*paddingNS + 1.5*btnHeight + textOffset);

    if (clearHover) {
      noStroke();
      fill(255, mousePressed ? 70:35);
      rect(paddingEW, 2*paddingNS + btnHeight, w - 2*paddingEW, btnHeight);
    }

    //draw in/out buttons
    translate(0, btnHeight*2 + paddingNS*3);
    strokeWeight(0.5);
    stroke(255);
    noFill();

    rect(paddingEW, 0, semiWidth, btnHeight);
    rect(paddingEW*2 + semiWidth, 0, semiWidth, btnHeight);

    if (itemHover == 0) {
      noStroke();
      fill(255, mousePressed ? 70:35);
      rect(paddingEW, 0, semiWidth, btnHeight);
    } else if (itemHover == 1) {
      noStroke();
      fill(255, mousePressed ? 70:35);
      rect(paddingEW*2 + semiWidth, 0, semiWidth, btnHeight);
    }

    fill(255);
    adjustTextSize("INPUT", semiWidth-paddingEW);
    text("INPUT", paddingEW + semiWidth/2, btnHeight/2 + textOffset);
    text("OUTPUT", paddingEW*2 + semiWidth + semiWidth/2, btnHeight/2 + textOffset);

    //menu items
    for (int i=0; i<files.length; i+=2) {
      pushMatrix();
      translate(0, (i/2 + 1)*(paddingNS + btnHeight));

      //draw rects
      strokeWeight(0.5);
      stroke(255);
      noFill();

      if (selectedType.matches(files[i].substring(0, files[i].indexOf("."))))
        fill(255);
      else
        noFill();

      rect(paddingEW, 0, semiWidth, btnHeight);
      if (i+1 < files.length) {
        if (selectedType.matches(files[i+1].substring(0, files[i+1].indexOf("."))))
          fill(255);
        else
          noFill();

        rect(paddingEW*2 + semiWidth, 0, semiWidth, btnHeight);
      }

      if (itemHover == i+2) {
        noStroke();
        fill(selectedType.matches(files[i].substring(0, files[i].indexOf("."))) ? 0:255, mousePressed ? 70:35);
        rect(paddingEW, 0, semiWidth, btnHeight);
      } else if (itemHover == i+3 && i+1 < files.length) {
        noStroke();
        fill(selectedType.matches(files[i+1].substring(0, files[i+1].indexOf("."))) ? 0:255, mousePressed ? 70:35);
        rect(paddingEW*2 + semiWidth, 0, semiWidth, btnHeight);
      }

      //draw texts if pieces
      fill(selectedType.matches(files[i].substring(0, files[i].indexOf("."))) ? 0:255);
      adjustTextSize(files[i].substring(0, files[i].indexOf(".")), semiWidth-paddingEW);
      text(files[i].substring(0, files[i].indexOf(".")), paddingEW + semiWidth/2, btnHeight/2 + textOffset);

      if (i+1 < files.length) {
        fill(selectedType.matches(files[i+1].substring(0, files[i+1].indexOf("."))) ? 0:255);
        adjustTextSize(files[i+1].substring(0, files[i+1].indexOf(".")), semiWidth-paddingEW);
        text(files[i+1].substring(0, files[i+1].indexOf(".")), paddingEW*2 + semiWidth + semiWidth/2, btnHeight/2 + textOffset);
      }
      popMatrix();
    }
    popMatrix();

    //del & explore buttons
    if (selectedType.matches("")) {
      strokeWeight(0.5);
      stroke(255);
      noFill();
    } else {
      noStroke();
      fill(255);
    }

    rect(width - w + paddingEW, h - paddingNS - btnHeight, semiWidth, btnHeight);
    rect(width - w + paddingEW*2 + semiWidth, h - paddingNS - btnHeight, semiWidth, btnHeight);

    //if hovered
    if (optHover == 1) {
      fill(0, mousePressed ? 70:35);
      rect(width - w + paddingEW, h - paddingNS - btnHeight, semiWidth, btnHeight);
    } else if (optHover == 2) {
      fill(0, mousePressed ? 70:35);
      rect(width - w + paddingEW*2 + semiWidth, h - paddingNS - btnHeight, semiWidth, btnHeight);
    }

    if (selectedType.matches(""))
      fill(255);
    else
      fill(0);
    adjustTextSize("EXPLORE", semiWidth-paddingEW);
    text("DELETE", width - w + paddingEW + semiWidth/2, h - paddingNS - btnHeight/2 + textOffset);
    text("EXPLORE", width - w + paddingEW*2 + semiWidth + semiWidth/2, h - paddingNS - btnHeight/2 + textOffset);
  }

  void adjustTextSize(String text, float preferedWidth) {
    textSize(textSize);
    if (textWidth(text) > preferedWidth)
      textSize(textSize * ((preferedWidth) / textWidth(text)));
  }
}
