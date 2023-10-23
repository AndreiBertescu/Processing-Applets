ArrayList<Triangle> triangles = new ArrayList<>();
ArrayList<Triangle> temp = new ArrayList<>();

//settings
int len = 100;

void setup() {
  size(1920, 1080);
  noStroke();
  colorMode(HSB);

  load();
}

void draw() {
  background(255);

  for (Triangle t : triangles)
    t.show();
}

public void mousePressed(MouseEvent e) {
  len /= 2;

  for (Triangle t : triangles)
    t.update();

  triangles = temp;
  temp = new ArrayList<>();
}

void load() {
  int nr, h, x, y;
  h = floor(len*(sqrt(3)/2));
  nr = 0;
  y=0;

  while (y<height) {
    x=-len;

    while (x-len/2<width) {
      if (nr%2==0) {
        triangles.add(new Triangle(x, y, x+len, y, x+len/2, y+h, random(7)));
        x += len;
      } else if (nr%2!=0)
        triangles.add(new Triangle(x, y, x-len/2, y+h, x+len/2, y+h, random(7)));

      nr++;
    }
    y += h;
  }
}

void keyPressed(){
  save("Triangles.tiff");
}
