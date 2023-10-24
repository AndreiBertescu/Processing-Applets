ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Line> lines = new ArrayList<Line>();
boolean isOnPoint=false;
Point prevp;
boolean simulate=false;

//settings
//press space to start/stop simulation
//left click on node to lock position
//left click to place node
//left click drag from a node to another to create connection
//right click drag to move a node
PVector g = new PVector(0, 0.3); //gravity

void setup() {
  size(800, 800);

  Point p1;
  int step=25;
  for (int i=200; i<=600; i+=step)
    for (int j=200; j<=600; j+=step) {
      if (i==200)
        p1 = new Point(new PVector(j, i), true);
      else
        p1 = new Point(new PVector(j, i));
      points.add(p1);
    }

  for (int i=200; i<=600; i+=step)
    for (int j=200; j<=600; j+=step) {
      if (i==200 && j<600) {
        lines.add(new Line(points.get(j/step-(200/step) + (i/step-(200/step))*(400/step+1)), points.get(j/step-(200/step)+1 + (i/step-(200/step))*(400/step+1))));
      } else if (i!=200) {
        if (j<600)
          lines.add(new Line(points.get(j/step-(200/step) + (i/step-(200/step))*(400/step+1)), points.get(j/step-(200/step)+1 + (i/step-(200/step))*(400/step+1))));
        lines.add(new Line(points.get(j/step-(200/step) + (i/step-(200/step))*(400/step+1)), points.get(j/step-(200/step) + ((i-1)/step-(200/step))*(400/step+1) )));
      }
    }
}

void draw() {
  background(255);
  for (Point p : points) {
    if (!p.locked && simulate)
      p.update();
  }
  for (Line l : lines) {
    if (simulate)
      for (int k=0; k<10; k++)
        l.update();
    l.show();
  }
  for (Point p : points)
    p.show();

  if (mousePressed == true)
    if (mouseButton == RIGHT && prevp!=null) {
      prevp.pos = new PVector(mouseX, mouseY);
    }
}

public void mouseReleased() {
  if (isOnPoint && mouseButton == LEFT)
    for (Point p : points)
      if (mouseX>(p.pos.x-p.r/2) && mouseX<(p.pos.x+p.r/2) && mouseY>(p.pos.y-p.r/2) && mouseY<(p.pos.y+p.r/2)) {
        if (p!=prevp)
          lines.add(new Line(prevp, p));
        else
          p.locked=!p.locked;
        break;
      }
  if (!isOnPoint && mouseButton == LEFT)
    points.add(new Point(new PVector(mouseX, mouseY)));
  isOnPoint=false;
}

public void mousePressed() {
  for (Point p : points)
    if (mouseX>(p.pos.x-p.r/2) && mouseX<(p.pos.x+p.r/2) &&
      mouseY>(p.pos.y-p.r/2) && mouseY<(p.pos.y+p.r/2)) {
      isOnPoint=true;
      prevp = p;
      break;
    }
}

public void keyReleased() {
  if(key == ' ')
    simulate=!simulate;
}
