import peasy.*;
PeasyCam cam;

QuadTree root;
ArrayList<Rect> rects;
int[][] grid;
PShape roads;

//settings
float a = 0.4; //for default set both to 0.5
float b = 0.6;
int res = 5000; // no. of points to generate quad tree
int Width = 2000; //width of plane
int Height = 2000; //height of plane
float scale = 1; //Perlin noise scale

void setup() {
  size(1000, 1000, P3D);
  noStroke();
  noiseSeed((long)random(100000));

  cam = new PeasyCam(this, max(Width, Height)*1.5);
  perspective(PI/4.0, float(width)/float(height), 0.1, 100000);

  //quad tree
  rects = new ArrayList<>();
  root = new QuadTree(new PVector(0, 0), Width, Height, 0);
  for (int i=0; i<res*scale; i++)
    root.insert(new PVector(random(Width), random(Height)));
  root.Save(rects);
  for (Rect r : rects)
    r.generate();

  roads = createShape(GROUP);

  grid = new int[Height][Width];
  for (Rect r : rects) {
    PShape x = createShape();
    x.beginShape();
    x.noFill();
    x.strokeWeight(2);
    x.stroke(30);
    x.vertex(r.x, r.y, 0);
    x.vertex(r.x+r.w, r.y, 0);
    x.vertex(r.x+r.w, r.y+r.h, 0);
    x.vertex(r.x, r.y+r.h, 0);
    x.endShape(CLOSE);
    roads.addChild(x);

    for (int i=r.y; i<=r.y+r.h; i++) {
      grid[i][r.x] = 1;
      grid[i][r.x+r.w] = 1;
    }
    for (int i=r.x; i<=r.x+r.w; i++) {
      grid[r.y][i] = 1;
      grid[r.y+r.h][i] = 1;
    }
  }
}

void draw() {
  background(200);
  lights();

  //base plate
  translate(-Width/2, -Height/2, 15/2+1);

  //roads
  shape(roads);

  //rects
  noStroke();
  strokeWeight(1);

  for (Rect q : rects)
    for (Rect r : q.blocks)
      if (r.show) {
        pushMatrix();
        translate(r.x + r.w/2, r.y + r.h/2, r.z/2);
        //if (r.stroke)
        //  stroke(r.str2);
        //else
        //  noStroke();
        fill(r.str);
        box(r.w, r.h, r.z);
        popMatrix();
      }
}

void keyPressed() {
  setup();
}
