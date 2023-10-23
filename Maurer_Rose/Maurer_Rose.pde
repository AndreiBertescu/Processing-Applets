float x, y, pvx=0, pvy=0, d;
boolean pt = false;
float maxi, mini = 10000;

//settings
//right click to increase angle
//left click to decrease angle
//press w to increment no. of points
//press s to decrament no. of points
//press anything else to toggle between points and lines
int n = 6;
float  d_ = 71;
int  res = 350;

void setup() {
  size(1920, 1080);
  colorMode(HSB);
  stroke(255);
  strokeWeight(1.2);
}

void draw() {
  background(70);
  translate(width/2, height/2);

  if (pt)
    strokeWeight(3);
  else
    strokeWeight(1.5);
  d = radians(d_);

  for (int i=0; i<=360; i++) {
    x = sin(n*i*d)*cos(i*d) * res;
    y = sin(n*i*d)*sin(i*d) * res;

    if (dist(x, y, pvx, pvy) > maxi)
      maxi = dist(x, y, pvx, pvy);
    if (dist(x, y, pvx, pvy) < mini)
      mini = dist(x, y, pvx, pvy);

    stroke(map(dist(x, y, pvx, pvy), mini, maxi, 255, 0), 255, 255);

    if (!pt)
      line(x, y, pvx, pvy);
    else
      point(x, y);

    pvx = x;
    pvy = y;
  }
}

void mousePressed() {
  if (mouseButton == LEFT)
    d_++;
  else if (mouseButton == RIGHT)
    d_--;

  if (d_==361)
    d_=0;
  if (d_==-1)
    d_=360;
}

void keyPressed() {
  if (key == 'w')
    n++;
  else if (key == 's')
    n--;
  else
    pt = !pt;
}

void exit(){
  saveFrame("data/MaurerRose.jpg");
  super.exit();
}
