float ang1=radians(270), ang2=radians(270);
float angv1, angv2, anga1, anga2;
PVector pos1, pos2, prevpos;
PGraphics canvas;

//SETTINGS
int l1=300;  //length of first pendulum
int l2=280;  //length of second pendulum
int m1=400;  //mass of first pendulum
int m2=400;  //mass of second pendulum
float g=0.7;  //gravitational constant

void setup() {
  size(1920, 1080);
  ellipseMode(CENTER);
  fill(255);
  stroke(255);
  strokeWeight(1.5);
  canvas=createGraphics(width, height);
  canvas.smooth(8);
  canvas.beginDraw();
  canvas.colorMode(HSB);
  canvas.noFill();
  canvas.strokeWeight(2);
  canvas.endDraw();

  prevpos=new PVector(0, l1).rotate(ang1).add(new PVector(0, l2).rotate(ang2));
}

void update() {
  anga1=(-g*(2*m1+m2)*sin(ang1)-m2*g*sin(ang1-2*ang2)-2*sin(ang1-ang2)*m2*(angv2*angv2*l2+angv1*angv1*l1*cos(ang1-ang2)))/(l1*(2*m1+m2-m2*cos(2*ang1-2*ang2)));
  anga2=(2*sin(ang1-ang2)*(angv1*angv1*l1*(m1+m2)+g*(m1+m2)*cos(ang1)+angv2*angv2*l2*m2*cos(ang1-ang2)))/(l2*(2*m1+m2-m2*cos(2*ang1-2*ang2)));

  angv1 += anga1;
  angv2 += anga2;

  ang1 += angv1;
  ang2 += angv2;

  pos1 = new PVector(0, l1).rotate(ang1);
  pos2 = pos1.copy().add(new PVector(0, l2).rotate(ang2));
}

void draw() {
  update();
  background(0);
  image(canvas, 0, 0);

  translate(width/2, height/2-200);
  line(0, 0, pos1.x, pos1.y);
  circle(pos1.x, pos1.y, 25);
  line(pos2.x, pos2.y, pos1.x, pos1.y);
  circle(pos2.x, pos2.y, 25);

  canvas.beginDraw();
  canvas.translate(width/2, height/2-200);
  
  //canvas.stroke(map(abs(ang1-ang2)%PI, 0, PI, 0, 255), 255, 230);  //angle
  canvas.stroke(map(m2 * (PVector.sub(prevpos,pos2).mag() * 1/60), 0, 250, 0, 255), 255, 230);  //cinetic energy
  
  canvas.line(pos2.x, pos2.y, prevpos.x, prevpos.y);
  canvas.endDraw();
  prevpos = pos2.copy();
}

void exit() {
  saveFrame("data/Pendulum.png");
  super.exit();
}
