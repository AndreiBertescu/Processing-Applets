//settings
int res = 3;

void setup() {
  size(1920, 1080);
  textAlign(CENTER);
  background(0);
  noStroke();

  int nr=1;
  int downY=(height/res)/2;
  int leftX=(width/res)/2;
  int upY=downY-1;
  int rightX=leftX+1;

  int a = 0;
  while (a++ < max(width/res, height/res)) {
    for (int x=leftX; x<rightX; x++) {
      if (!isPrime(nr++))
        fill(0);
      else
        fill(205);
      square(x*res, downY*res, res);
    }
    leftX--;

    for (int y=downY; y>upY; y--) {
      if (!isPrime(nr++))
        fill(0);
      else
        fill(205);
      square(rightX*res, y*res, res);
    }
    downY++;

    for (int x=rightX; x>leftX; x--) {
      if (!isPrime(nr++))
        fill(0);
      else
        fill(205);
      square(x*res, upY*res, res);
    }
    rightX++;

    for (int y=upY; y<downY; y++) {
      if (!isPrime(nr++))
        fill(0);
      else
        fill(205);
      square(leftX*res, y*res, res);
    }
    upY--;
  }

  fill(255, 0, 0);
  rect((width/res)/2*res, (height/res)/2*res, res, res);
  println("Done!");
}

boolean isPrime(int x) {
  for (int i=2; i<x/2; i++)
    if (x%i == 0)
      return false;
  return true;
}

void exit() {
  save("Ulam.tiff");
}
