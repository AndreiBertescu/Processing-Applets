class Canvas {
  int IN, OUT;
  int inR, outR;
  int[] input, output;

  ArrayList<Connection> connections;
  ArrayList<Piece> pieces;

  int ww = 30;
  int woff = 10;

  PVector pp1, pp2, p1, p2, prevpos, pos, nextpos;

  Canvas(int IN, int OUT) {
    this.IN = IN;
    this.OUT = OUT;

    inR = (int)map(IN, 0, 10, 40, 20);
    outR = (int)map(OUT, 0, 10, 40, 20);

    input = new int[IN];
    output = new int[OUT];

    connections = new ArrayList<Connection>();
    pieces = new ArrayList<Piece>();
  }

  void update() {
    for (Connection c : canvas.connections)
      c.update();
    for (Piece p : pieces)
      p.update();
  }

  void show() {
    pushMatrix();
    translate(25, 25);

    strokeWeight(4);
    stroke(255, 25);
    rect(0, 0, CX, CY);

    strokeWeight(2);
    //draw connections
    pushMatrix();
    translate(-25, -25);
    for (Connection c : connections) {
      if (c.p1 == null) {
        if (input[c.id1]==0)
          stroke(10);
        else
          stroke(196, 3, 0);
      } else if (c.p1 != null) {
        if (c.p1.output[c.id1]==0)
          stroke(10);
        else
          stroke(196, 3, 0);
      }

      if (c.con.size()>2) {

        prevpos = c.con.get(0);
        pos = c.con.get(1);
        p1 = new PVector(pos.x - off*(pos.x - prevpos.x), pos.y - off*(pos.y - prevpos.y));
        line(c.con.get(0).x, c.con.get(0).y, p1.x, p1.y);

        for (int i=2; i<c.con.size(); i++) {
          prevpos = c.con.get(i-2);
          pos = c.con.get(i-1);
          nextpos = c.con.get(i);

          p1 = new PVector(pos.x - off*(pos.x - prevpos.x), pos.y - off*(pos.y - prevpos.y));
          p2 = new PVector(pos.x - off*(pos.x - nextpos.x), pos.y - off*(pos.y - nextpos.y));

          curve(prevpos.x, prevpos.y, p1.x, p1.y, p2.x, p2.y, nextpos.x, nextpos.y);

          if (i>2)
            line(pp2.x, pp2.y, p1.x, p1.y);

          pp1 = p1;
          pp2 = p2;
        }

        line(pp2.x, pp2.y, c.con.get(c.con.size()-1).x, c.con.get(c.con.size()-1).y);
      } else try {
        line(c.con.get(0).x, c.con.get(0).y, c.con.get(1).x, c.con.get(1).y);
      }
      catch(Exception e) {
        connections.remove(c);
        break;
      }
    }
    popMatrix();

    //draw IN ports
    strokeWeight(3);
    for (int i=0; i<IN; i++) {
      if (input[i] == 0) {
        noStroke();
        fill(0);
      } else if (input[i] == 1) {
        stroke(181, 3, 0);
        fill(196, 3, 0);
      }
      circle(0, CY/(IN+1) * (i+1), inR);

      //if hover
      if (dist(mouseX-25, mouseY-25, 0, CY/(IN+1) * (i+1)) < inR/2 && type == -1) {
        if (input[i] == 1)
          fill(0, 50);
        else
          fill(255, 100);
        circle(0, CY/(IN+1) * (i+1), inR);
      }
    }

    //draw OUT ports
    for (int i=0; i<OUT; i++) {
      if (output[i] == 0) {
        noStroke();
        fill(0);
      } else if (output[i] == 1) {
        stroke(181, 3, 0);
        fill(196, 3, 0);
      }
      circle(CX, CY/(OUT+1) * (i+1), outR);

      //if hover
      if (dist(mouseX-25, mouseY-25, CX, CY/(OUT+1) * (i+1)) < outR/2) {
        if (output[i] == 1)
          fill(0, 50);
        else
          fill(255, 100);
        circle(CX, CY/(OUT+1) * (i+1), outR);
      }
    }

    for (Piece p : pieces)
      p.show();

    //draw I/O buttons
    strokeWeight(3);
    fill(150);

    //top-left
    stroke(150);
    square(0, 0, ww);

    stroke(255);
    line(ww/2, woff, ww/2, ww-woff);
    line(woff, ww/2, ww-woff, ww/2);

    //top-right
    pushMatrix();
    translate(CX-ww, 0);
    stroke(150);
    square(0, 0, ww);

    stroke(255);
    line(ww/2, woff, ww/2, ww-woff);
    line(woff, ww/2, ww-woff, ww/2);
    popMatrix();

    //bottom-left
    pushMatrix();
    translate(0, CY-ww);
    stroke(150);
    square(0, 0, ww);

    stroke(255);
    line(woff, ww/2, ww-woff, ww/2);
    popMatrix();

    //bottom-right
    pushMatrix();
    translate(CX-ww, CY-ww);
    stroke(150);
    square(0, 0, ww);

    stroke(255);
    line(woff, ww/2, ww-woff, ww/2);
    popMatrix();

    popMatrix();
  }

  void saveCanvas() {
    //save piece
    //make copy of IN values
    int[] cinput = new int[IN];
    for (int i=0; i<IN; i++)
      cinput[i] = input[i];

    String[] lines = new String[1];
    boolean bec = false;
    for (int i=0; i<files.length; i++)
      if (files[i].compareTo(tb.textValue + ".txt") == 0 && tb.textValue.compareTo("AND") != 0 && tb.textValue.compareTo("NOT") != 0) {
        lines = loadStrings("types/" + tb.textValue + ".txt");
        bec = true;

        File F = new File(dir + "/" + files[i]);
        F.delete();

        try {
          F = new File(canv + "/" + files[i]);
          F.delete();
        }
        catch(Exception e) {
          println(e);
        }

        break;
      }

    PrintWriter file = createWriter(dir.getName() + "/" + tb.textValue + ".txt");

    file.println(IN);
    file.println(OUT);

    for (int i=0; i<pow(2, IN); i++) {
      String s = String.format("%"+IN+"s", Integer.toBinaryString(i)).replaceAll(" ", "0");

      for (int j=0; j<IN; j++)
        input[j] = Character.getNumericValue(s.charAt(j));

      for (int j=0; j<=canvas.pieces.size()*2; j++)
        this.update();
        
      for (int j=0; j<OUT; j++)
        file.print(output[j] + " ");
      file.println();
    }

    if (bec)
      file.println(Integer.valueOf(lines[lines.length-1].split(" ")[0]) + " " + Integer.valueOf(lines[lines.length-1].split(" ")[1]) + " " + Integer.valueOf(lines[lines.length-1].split(" ")[2]));
    else
      file.println((int)random(255) + " " + (int)random(255) + " " + (int)random(255));
    file.flush();
    file.close();

    //paste copy of IN values
    for (int i=0; i<IN; i++)
      input[i] = cinput[i];

    //save canvas
    file = createWriter(canv.getName() + "/" + tb.textValue + ".txt");
    file.println(IN);
    file.println(OUT);

    //pieces
    file.println(pieces.size());
    for (Piece p : pieces)
      file.println(p.TYPE+" "+p.x+" "+p.y);

    //connections
    file.println(connections.size());
    for (Connection c : connections) {
      if (c.p1 == null)
        file.print(pieces.size() + " " + c.id1 + " ");
      else for (int i=0; i<pieces.size(); i++)
        if (c.p1 == pieces.get(i))
          file.print(i + " " + c.id1 + " ");

      if (c.p2 == null)
        file.print(pieces.size() + " " + c.id2);
      else for (int i=0; i<pieces.size(); i++)
        if (c.p2 == pieces.get(i))
          file.print(i + " " + c.id2);

      file.println();
    }
    for (Connection c : connections) {
      file.print(c.con.size() + " ");
      for (PVector p : c.con)
        file.print(p.x + " " + p.y + " ");
      file.println();
    }

    file.flush();
    file.close();
  }
}
