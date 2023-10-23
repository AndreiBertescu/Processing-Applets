class Triangle {
  float x1, x2, x3, y1, y2, y3, i;

  Triangle(float x1, float y1, float x2, float y2, float x3, float y3, float i) {
    this.x1 = x1;
    this.x2 = x2;
    this.x3 = x3;
    this.y1 = y1;
    this.y2 = y2;
    this.y3 = y3;
    this.i = i;
  }

  void update() {
    IntList c = new IntList();
    c.append(0);
    c.append(1);
    c.append(2);
    c.append(-1);
    c.shuffle();
    
    temp.add(new Triangle(x1, y1, (x1+x2)/2, (y1+y2)/2, (x1+x3)/2, (y1+y3)/2, i+c.get(0)));
    temp.add(new Triangle((x1+x2)/2, (y1+y2)/2, x2, y2, (x3+x2)/2, (y3+y2)/2, i+c.get(1)));
    temp.add(new Triangle((x3+x2)/2, (y3+y2)/2, x3, y3, (x3+x1)/2, (y3+y1)/2, i+c.get(2)));
    temp.add(new Triangle((x3+x2)/2, (y3+y2)/2, (x1+x2)/2, (y1+y2)/2, (x3+x1)/2, (y3+y1)/2, i+c.get(3)));
  }

  void show() {
    fill(255 - 20*i % 255, 255, 255);
    triangle(x1, y1, x2, y2, x3, y3);
  }
}
