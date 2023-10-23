Canvas canvas;
Menu menu;
TextBox tb;

File dir, canv;
String[] files, cfiles;

int MX = 200;
int CX = 1920 - 75 - MX;
int CY = 1080 - 50;
int MY = CY;

float off = 0.1839261;

int currentID = -1;
Piece currentP;
int type = -1;
int ctype = -1;
float mousex, mousey;

boolean newPiece = false;
Piece newpiece;

boolean conn = false;
ArrayList<PVector> con = new ArrayList<PVector>();

//settings
//right click a node to delete a connection
//right click a piece to delete it
//right click an input port to toggle it on-off
//left click to an output node to start a connection
//left click drag to move a piece
void setup() {
  fullScreen();
  ellipseMode(CENTER);
  
  dir = new File(sketchPath() + "/data/types");
  files = dir.list();
  canv = new File(sketchPath() + "/data/canv");
  cfiles = dir.list();

  canvas = new Canvas(4, 2);
  menu = new Menu();
  tb = new TextBox(CX+50, height-25-50, MX, 50);

  canvas.pieces.add(new Piece("AND", CX/2, CY/2, false));
  canvas.pieces.add(new Piece("NOT", CX/2, CY-200, false));
}

void draw() {
  background(51);
  textAlign(CENTER);

  noFill();
  noStroke();
  canvas.update();
  canvas.show();

  noFill();
  noStroke();
  menu.update();
  menu.show();

  noFill();
  noStroke();
  tb.draw();

  stroke(0);
  strokeWeight(2);
  if (con.size() > 0) {
    if (conn)
      line(con.get(con.size()-1).x, con.get(con.size()-1).y, mouseX, mouseY);

    for (int i=1; i<con.size(); i++) {
      PVector ppos = con.get(i-1);
      PVector pos = con.get(i);
      line(ppos.x, ppos.y, pos.x, pos.y);
    }
  }

  noStroke();
  textAlign(CENTER);
  if (newPiece) {
    newpiece.update();
    newpiece.show();
  }
}

void mousePressed() {
  mousex = mouseX - 25;
  mousey = mouseY - 25;

  if (mouseButton == RIGHT) {
    //cancel connection
    conn = false;
    con = new ArrayList<PVector>();

    //switch IN port
    for (int i=0; i<canvas.IN; i++)
      if (dist(0, CY/(canvas.IN+1) * (i+1), mousex, mousey) < canvas.inR/2) {
        currentID = i;
        type = 2;
        return;
      }

    //remove piece
    for (Piece p : canvas.pieces)
      // if is the piece
      if (mousex>=p.x+p.r/2 && mousex<=p.x+p.w-p.r/2 && mousey>=p.y && mousey<=p.y+p.h) {
        //make copy of con  excluding removed piece's conn
        ArrayList<Connection> connections = new ArrayList<Connection>();
        for (Connection c : canvas.connections)
          if (c.p1 != p && c.p2 != p)
            connections.add(c);
        canvas.connections = connections;
        for (int i=0; i<canvas.OUT; i++)
          canvas.output[i] = 0;

        canvas.pieces.remove(p);
        return;
      }
  }

  if (!newPiece) {
    if (mouseButton == LEFT) {
      //drag piece
      if (!conn)
        for (Piece p : canvas.pieces)
          if (mousex>=p.x+p.r/2 && mousex<=p.x+p.w-p.r/2 && mousey>=p.y && mousey<=p.y+p.h) {
            p.dragged = true;
            p.xoff = p.x - mousex;
            p.yoff = p.y - mousey;
            return;
          }

      //if pressed a valid port
      for (int i=0; i<canvas.IN; i++)
        if (dist(0, CY/(canvas.IN+1) * (i+1), mousex, mousey) < canvas.inR/2) {
          currentID = i;
          type = 0;
          ctype = 0;
          return;
        }
      for (Piece p : canvas.pieces)
        for (int i=0; i<p.OUT; i++)
          if (dist(p.x+p.w, p.y+p.h/p.OUT * (i+0.5), mousex, mousey) < p.r/2) {
            currentP = p;
            currentID = i;
            type = 4;
            ctype = 4;
            return;
          }
    }
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    //delete connections from pieces or OUT ports
    for (int i=0; i<canvas.OUT; i++)
      if (dist(mousex, mousey, CX, CY/(canvas.OUT+1) * (i+1)) < canvas.outR/2) {
        del(null, i, "");
        return;
      }

    for (Piece p : canvas.pieces) {
      for (int i=0; i<p.IN; i++)
        if (dist(p.x, p.y+p.h/p.IN * (i+0.5), mousex, mousey) < p.r/2) {
          del(p, i, "IN");
          return;
        }
      for (int i=0; i<p.OUT; i++)
        if (dist(p.x+p.w, p.y+p.h/p.OUT * (i+0.5), mousex, mousey) < p.r/2) {
          del(p, i, "OUT");
          return;
        }
    }
  }

  if (mouseX >= 50 + CX)
    menu();
  else {
    IObtn();

    if (newPiece && mouseX > 25+newpiece.r/2 && mouseX < 25+CX-newpiece.w-newpiece.r/2 && mouseY > 25 && mouseY < 25+CY-newpiece.h) {
      //if in canvas limits
      newPiece = false;
      newpiece.first = false;
      newpiece.x -= 25;
      newpiece.y -= 25;
      canvas.pieces.add(newpiece);
    }

    for (Piece p : canvas.pieces)
      p.dragged = false;

    //if mouse is in same place
    if (mouseX-25==mousex && mouseY-25==mousey) {
      if (type == 2) {
        //switch IN values
        if (canvas.input[currentID] == 0)
          canvas.input[currentID] = 1;
        else
          canvas.input[currentID] = 0;

        type = -1;
        return;
      } else if (type == 0) {
        con = new ArrayList<PVector>();
        conn = true;
        con.add(new PVector(25, 25 + CY/(canvas.IN+1) * (currentID+1)));

        type = -1;
        return;
      } else if (type == 4) {
        con = new ArrayList<PVector>();
        conn = true;
        con.add(new PVector(25 + currentP.x+currentP.w, 25 + currentP.y+currentP.h/currentP.OUT * (currentID+0.5)));

        type = -1;
        return;
      }
    }

    mousex = mouseX - 25;
    mousey = mouseY - 25;

    //if finished connection
    for (int i=0; i<canvas.OUT; i++)
      if (dist(CX, CY/(canvas.OUT+1) * (i+1), mousex, mousey) < canvas.outR/2) {
        con.add(new PVector(25 + CX, 25 + CY/(canvas.OUT+1) * (i+1)));

        if (ctype == 0) {
          check(null, i);
          canvas.connections.add(new Connection(null, currentID, null, i, con));
        } else if (ctype == 4) {
          check(null, i);
          canvas.connections.add(new Connection(currentP, currentID, null, i, con));
        }

        con = new ArrayList<PVector>();
        conn = false;
        ctype = -1;
        currentP = null;
        currentID = -1;
        type = -1;
        return;
      }
    for (Piece p : canvas.pieces)
      if (p != currentP)
        for (int i=0; i<p.IN; i++)
          if (dist(p.x, p.y+p.h/p.IN * (i+0.5), mousex, mousey) < p.r/2) {
            con.add(new PVector(25 + p.x, 25 + p.y+p.h/p.IN * (i+0.5)));

            if (ctype == 0) {
              check(p, i);
              canvas.connections.add(new Connection(null, currentID, p, i, con));
            } else if (ctype == 4) {
              check(p, i);
              canvas.connections.add(new Connection(currentP, currentID, p, i, con));
            }

            con = new ArrayList<PVector>();
            conn = false;
            ctype = -1;
            currentP = null;
            currentID = -1;
            type = -1;
            return;
          }

    if (conn)
      con.add(new PVector(mouseX, mouseY));
  }

  type = -1;
}

void del(Piece p, int id, String s) {
  ArrayList<Connection> connections = new ArrayList<Connection>();

  if (p == null)
    for (Connection c : canvas.connections)
      if (c.p2 == null && c.id2 == id);
      else
        connections.add(c);
  else if (s.compareTo("OUT") == 0) {
    for (Connection c : canvas.connections)
      if (c.p1 == p && c.id1 == id);
      else
        connections.add(c);
  } else if (s.compareTo("IN") == 0) {
    for (Connection c : canvas.connections)
      if (c.p2 == p && c.id2 == id);
      else
        connections.add(c);
  }

  canvas.connections = connections;
}

void check(Piece p, int id) {
  //remove duplicate connections
  if (p != null) {
    for (Connection c : canvas.connections)
      if (c.p2 == p && c.id2 == id) {
        canvas.connections.remove(c);
        break;
      }
  } else
    for (Connection c : canvas.connections)
      if (c.id2 == id && c.p2 == null) {
        canvas.connections.remove(c);
        break;
      }
}

void updateConn(String s) {
  //update connections after change of I/O ports
  if (s.compareTo("IN") == 0)
    for (Connection c : canvas.connections)
      if (c.p1 == null)
        c.con.get(0).y = 25 + CY/(canvas.IN+1) * (c.id1+1);

  if (s.compareTo("OUT") == 0)
    for (Connection c : canvas.connections)
      if (c.p2 == null)
        c.con.get(c.con.size()-1).y = 25 + CY/(canvas.OUT+1) * (c.id2+1);
}

void IObtn() {
  // I/O buttons
  if (mouseX >= 25 && mouseX < 25+canvas.ww && mouseY >= 25 && mouseY < 25+canvas.ww  && canvas.IN < 19) {
    //resize array
    canvas.IN++;
    int[] input = new int[canvas.IN];
    for (int i=0; i<canvas.IN-1; i++)
      input[i] = canvas.input[i];
    canvas.input = input;
    canvas.inR = (int)map(canvas.IN, 1, 21, 40, 20);
    return;
  } else if (mouseX >= 25+CX-canvas.ww && mouseX < 25+CX && mouseY >= 25 && mouseY < 25+canvas.ww  && canvas.OUT < 19) {
    //resize array
    canvas.OUT++;
    int[] output = new int[canvas.OUT];
    for (int i=0; i<canvas.OUT-1; i++)
      output[i] = canvas.output[i];
    canvas.output = output;
    canvas.outR = (int)map(canvas.OUT, 1, 21, 40, 20);
    return;
  } else if (mouseX >= 25 && mouseX < 25+canvas.ww && mouseY >= 25+CY-canvas.ww && mouseY < 25+CY && canvas.IN > 1) {
    //resize array
    canvas.IN--;
    int[] input = new int[canvas.IN];
    for (int i=0; i<canvas.IN; i++)
      input[i] = canvas.input[i];
    canvas.input = input;
    canvas.inR = (int)map(canvas.IN, 1, 21, 40, 20);

    //delete removed connections
    ArrayList<Connection> connections = new ArrayList<Connection>();
    for (Connection c : canvas.connections)
      if (c.p1 == null && c.id1 >= canvas.IN);
      else
        connections.add(c);
    canvas.connections = connections;
    for (int i=0; i<canvas.OUT; i++)
      canvas.output[i] = 0;
    return;
  } else if (mouseX >= 25+CX-canvas.ww && mouseX < 25+CX && mouseY >= 25+CY-canvas.ww && mouseY < 25+CY && canvas.OUT > 1) {
    //resize array
    canvas.OUT--;
    int[] output = new int[canvas.OUT];
    for (int i=0; i<canvas.OUT; i++)
      output[i] = canvas.output[i];
    canvas.output = output;
    canvas.outR = (int)map(canvas.OUT, 1, 21, 40, 20);

    //delete removed connections
    ArrayList<Connection> connections = new ArrayList<Connection>();
    for (Connection c : canvas.connections)
      if (c.p2 == null && c.id2 >= canvas.OUT);
      else
        connections.add(c);
    canvas.connections = connections;
    for (int i=0; i<canvas.OUT; i++)
      canvas.output[i] = 0;
    return;
  }
}

void menu() {
  //save canvas
  if (menu.saveHover) {
    if (tb.textValue != "") {
      pushMatrix();
      translate(CX+50, 25);
      fill(255, 50);
      rect(menu.off, menu.off, MX-menu.off*2, 40);
      popMatrix();

      canvas.saveCanvas();
      tb.textValue = "";
    } else
      println("Invalid name.");
    return;
  }

  //clear canvas
  if (menu.clearHover) {
    canvas.pieces = new ArrayList<Piece>();
    canvas.connections = new ArrayList<Connection>();
    canvas.output = new int[canvas.OUT];

    pushMatrix();
    translate(CX+50, 25 + menu.off + 40);
    fill(255, 50);
    rect(menu.off, menu.off, MX-menu.off*2, 40);
    popMatrix();
    return;
  }

  //piece buttons
  if (menu.hover != -1 && menu.hover <= files.length) {
    if (mouseX<width-25-menu.fh*2+menu.off*2) {
      pushMatrix();
      translate(CX+50 + menu.off, 25 + menu.off + (40 + menu.off) * 2 + menu.fh*menu.hover);
      fill(255, 50);
      rect(menu.off, menu.off, menu.fw-menu.off*2, menu.fh-menu.off*2);
      popMatrix();

      newPiece = true;
      newpiece = new Piece(files[menu.hover].substring(0, files[menu.hover].indexOf(".")), mouseX, mouseY, true);
      return;
    } else if (mouseX>width-25-menu.fh) {
      //delete piece entry
      if (files[menu.hover].compareTo("AND.txt") !=0 && files[menu.hover].compareTo("NOT.txt") != 0) {
        for (String f : files)
          if (f == files[menu.hover]) {
            File F = new File(dir + "/" + f);
            F.delete();

            F = new File(canv + "/" + f);
            F.delete();
          }
      } else println("Can't delete fundamental operation.");
    } else if (mouseX>width-25-menu.fh*2) {
      //explore piece entry
      if (files[menu.hover].compareTo("AND.txt") !=0 && files[menu.hover].compareTo("NOT.txt") != 0)
        for (String f : files)
          if (f == files[menu.hover])
          try {
            loadCanvas(f);
          }
      catch(Exception e) {
        println(e);
        //println("Can't explore this operation.");
      }
    }

    return;
  }
}

void keyReleased() {
  if (keyCode == UP) {
    off *= 1.1;
    println(off);
  } else if (keyCode == DOWN) {
    off *= 0.9;
    println(off);
  } else if (keyCode == 32)
    save("Logic.tiff");
}

void loadCanvas(String type) {
  for (String l : cfiles) {
    if (l.compareTo(type) == 0) {
      String[] lines = loadStrings(canv + "/" + type);

      canvas = new Canvas(Integer.valueOf(lines[0]), Integer.valueOf(lines[1]));

      for (int i=0; i<Integer.valueOf(lines[2]); i++) {
        String[] s = lines[3+i].split(" ");
        canvas.pieces.add(new Piece(s[0], Float.valueOf(s[1]), Float.valueOf(s[2]), false));
      }

      for (int i=0; i<Integer.valueOf(lines[3 + canvas.pieces.size()]); i++) {
        String[] s = lines[4 + i + canvas.pieces.size()].split(" ");
        int[] f = new int[s.length];
        for (int j=0; j<s.length; j++)
          f[j] = Integer.valueOf(s[j]);

        s = lines[4 + i + canvas.pieces.size() + Integer.valueOf(lines[3 + canvas.pieces.size()])].split(" ");
        ArrayList<PVector> temp = new ArrayList<PVector>();
        for (int j=0; j<Integer.valueOf(s[0])*2; j+=2)
          temp.add(new PVector(Float.valueOf(s[j+1]), Float.valueOf(s[j+2])));

        if (f[0] == canvas.pieces.size()) {
          if (f[2] == canvas.pieces.size())
            canvas.connections.add(new Connection(null, f[1], null, f[3], temp));
          else
            canvas.connections.add(new Connection(null, f[1], canvas.pieces.get(f[2]), f[3], temp));
        } else {
          if (f[2] == canvas.pieces.size())
            canvas.connections.add(new Connection(canvas.pieces.get(f[0]), f[1], null, f[3], temp));
          else
            canvas.connections.add(new Connection(canvas.pieces.get(f[0]), f[1], canvas.pieces.get(f[2]), f[3], temp));
        }
      }

      return;
    }
  }
}
