class TextBox {
  private int x, y, boxWidth, boxHeight, textLimit = 20;
  private float currentValue, keyCounter, previousKeyCounter;
  private String textValue = "";
  private char keyInput, c;
  private boolean keyReleased;

  TextBox(int x, int y, int boxWidth, int boxHeight) {
    this.x = x;
    this.y = y;
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
  }


  void show() {
    stroke(205);
    fill(0);
    rect(x, y, boxWidth, boxHeight);


    fill(255);
    textSize(20);
    textAlign(CENTER);
    textValue = textValue.toUpperCase();
    text(textValue, x + boxWidth/2, y + boxHeight/2 + 8);

    getUserInput();
  }

  void getUserInput() {
    if (!keyPressed) {
      keyReleased = true;
      keyCounter = 0;
      previousKeyCounter = 0;
    }

    if (keyPressed && key == ENTER)
      return;

    if (keyPressed && keyCounter<frameRate/2) {
      if (textValue.matches("INVALID VALUE!"))
        textValue = "";

      keyCounter = millis();

      c = key;

      if (c == BACKSPACE) textValue = textValue.substring(0, textValue.length()-1);
      else if (c >= ' ') textValue += str(c);
      if (textValue.length() > textLimit) textValue = "";

      previousKeyCounter = keyCounter;
      keyReleased = false;
    }
  }

  String getCursor() {
    return hovering() && (frameCount>>4 & 1) == 0 ? "|" : "";
  }

  boolean hovering() {
    return mouseX >= x && mouseX <= x + boxWidth && mouseY >= y && mouseY <= y + boxHeight;
  }
}
