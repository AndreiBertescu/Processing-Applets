float step, ang;
ArrayList<Float> points = new ArrayList<Float>();
float point;

//settings
float r=100;  //radius of big circle
float n=20;  //no. of sinusoidal function

void setup() {
  size(800, 600);
  stroke(255);
  strokeWeight(1.5);
  noFill();
  ellipseMode(RADIUS);
  colorMode(HSB);
  strokeWeight(1.5);

  step = 1/30.0;
}

void draw() {
  background(0);
  translate(width/2+100, height/2);

  pushMatrix();
  translate(-300, 0);
  float prevr=0, prevx=0, prevy=0;
  float x=0, y=0, r_=0;
  for (int i=1; i<n*2; i+=2) {
    r_ = r*(4/(PI*i));
    x = prevx+prevr*cos(-ang*step*(i-2));
    y = prevy+prevr*sin(-ang*step*(i-2));

    circle(x, y, r_);
    line(prevx, prevy, x, y);

    prevr = r_;
    prevx = x;
    prevy = y;
  }
  x = prevx+prevr*cos(-ang*step*(n*2-1));
  y = prevy+prevr*sin(-ang*step*(n*2-1));
  line(prevx, prevy, x, y);
  points.add(y);
  line(x, y, 300, y);
  popMatrix();


  beginShape();
  for (int i=points.size()-1; i>=0; i--) {
    point = points.get(i);
    vertex((points.size()-i), point);
    if (points.size()>width/2)
      points.remove(0);
  }
  endShape();
  ang++;
}
