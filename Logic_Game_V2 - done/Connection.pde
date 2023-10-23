class Connection {
  int piecePortId1, piecePortId2;
  Piece firstPiece, secondPiece;
  ArrayList<PVector> con;
  int hoveredNode;
  PVector origin;
  color stroke;

  Connection(Piece firstPiece, int piecePortId, PVector origin) {
    if (origin != null)
      this.origin = origin;
    else
      this.origin = null;

    this.firstPiece = firstPiece;
    this.piecePortId1 = piecePortId;

    stroke = color(0);
    con = new ArrayList<>();

    this.secondPiece = null;
    this.piecePortId2 = -1;
  }

  Connection(Piece firstPiece, int piecePortId1, Piece secondPiece, int piecePortId2) {
    origin = null;

    this.firstPiece = firstPiece;
    this.secondPiece = secondPiece;
    this.piecePortId1 = piecePortId1;
    this.piecePortId2 = piecePortId2;

    stroke = color(0);
    con = new ArrayList<>();
  }

  void update() {
    if (piecePortId1 >= firstPiece.nrInputs) {
      if (secondPiece.input[piecePortId2] != firstPiece.output[piecePortId1 - firstPiece.nrInputs]) {
        secondPiece.changed = true;
        secondPiece.input[piecePortId2] = firstPiece.output[piecePortId1 - firstPiece.nrInputs];
      }
      stroke = secondPiece.input[piecePortId2] ? cTrue:cFalse;
    } else if (piecePortId2 >= secondPiece.nrInputs) {
      if (firstPiece.input[piecePortId1] != secondPiece.output[piecePortId2 - secondPiece.nrInputs]) {
        firstPiece.changed = true;
        firstPiece.input[piecePortId1] = secondPiece.output[piecePortId2 - secondPiece.nrInputs];
      }
      stroke = firstPiece.input[piecePortId1] ? cTrue:cFalse;
    }

    for (PVector c : con)
      if (dist(c.x + mainCanvas.offset.x, c.y + mainCanvas.offset.y, map(mouseX, 0, width, 0, width/scale), map(mouseY, 0, height, 0, height/scale)) < r/2) {
        hoveredNode = con.indexOf(c);
        return;
      }

    hoveredNode = -1;
  }

  void show() {
    PVector p1, p2;

    if (origin == null) {
      if (piecePortId1 < firstPiece.nrInputs)
        p1 = new PVector(firstPiece.x, firstPiece.y + firstPiece.h/(firstPiece.nrInputs+0.3) * (piecePortId1+0.65));
      else
        p1 = new PVector(firstPiece.x + firstPiece.w, firstPiece.y + firstPiece.h/(firstPiece.nrOutputs+0.3) * ((piecePortId1-firstPiece.nrInputs) + 0.65));
    } else p1 = origin;

    if (piecePortId2 < secondPiece.nrInputs)
      p2 = new PVector(secondPiece.x, secondPiece.y + secondPiece.h/(secondPiece.nrInputs+0.3) * (piecePortId2+0.65));
    else
      p2 = new PVector(secondPiece.x + secondPiece.w, secondPiece.y + secondPiece.h/(secondPiece.nrOutputs+0.3) * ((piecePortId2-secondPiece.nrInputs) + 0.65));



    fill(stroke);
    stroke(stroke);
    strokeWeight(1.5);

    //draw lines
    if (con.size() > 0) {
      line(p1.x, p1.y, con.get(0).x, con.get(0).y);
      for (int i=0; i<con.size(); i++) {
        if (i > 0)
          line(con.get(i-1).x, con.get(i-1).y, con.get(i).x, con.get(i).y);
        circle(con.get(i).x, con.get(i).y, 5);
      }
      line(con.get(con.size()-1).x, con.get(con.size()-1).y, p2.x, p2.y);
    } else line(p1.x, p1.y, p2.x, p2.y);

    //draw node if selected
    if (hoveredNode != -1 && con.size() > 0) {
      strokeWeight(2);
      stroke(255);
      noFill();

      circle(con.get(hoveredNode).x, con.get(hoveredNode).y, r/1.5);
    }
  }

  void preshow() {
    PVector p1;

    if (origin == null) {
      if (piecePortId1 < firstPiece.nrInputs) {
        p1 = new PVector(firstPiece.x, firstPiece.y + firstPiece.h/(firstPiece.nrInputs+0.3) * (piecePortId1+0.65));
        stroke = firstPiece.input[piecePortId1] ? cTrue:cFalse;
      } else {
        p1 = new PVector(firstPiece.x + firstPiece.w, firstPiece.y + firstPiece.h/(firstPiece.nrOutputs+0.3) * ((piecePortId1-firstPiece.nrInputs) + 0.65));
        stroke = firstPiece.output[piecePortId1 - firstPiece.nrInputs] ? cTrue:cFalse;
      }
    } else {
      p1 = origin;
      stroke = firstPiece.output[piecePortId1 - firstPiece.nrInputs] ? cTrue:cFalse;
    }

    fill(stroke);
    stroke(stroke);
    strokeWeight(1.5);

    if (con.size() > 0) {
      line(p1.x + mainCanvas.offset.x + mainCanvas.semiOffset.x, p1.y + mainCanvas.offset.y + mainCanvas.semiOffset.y, con.get(0).x  + mainCanvas.offset.x + mainCanvas.semiOffset.x, con.get(0).y + mainCanvas.offset.y + mainCanvas.semiOffset.y);
      for (int i=0; i<con.size(); i++) {
        if (i > 0)
          line(con.get(i-1).x + mainCanvas.offset.x + mainCanvas.semiOffset.x, con.get(i-1).y + mainCanvas.offset.y + mainCanvas.semiOffset.y, con.get(i).x + mainCanvas.offset.x + mainCanvas.semiOffset.x, con.get(i).y + mainCanvas.offset.y + mainCanvas.semiOffset.y);
        circle(con.get(i).x + mainCanvas.offset.x + mainCanvas.semiOffset.x, con.get(i).y + mainCanvas.offset.y + mainCanvas.semiOffset.y, 5);
      }
      line(con.get(con.size()-1).x + mainCanvas.offset.x + mainCanvas.semiOffset.x, con.get(con.size()-1).y + mainCanvas.offset.y + mainCanvas.semiOffset.y, map(mouseX, 0, width, 0, width/scale), map(mouseY, 0, height, 0, height/scale));
    } else
      line(p1.x + mainCanvas.offset.x + mainCanvas.semiOffset.x, p1.y + mainCanvas.offset.y + mainCanvas.semiOffset.y, map(mouseX, 0, width, 0, width/scale), map(mouseY, 0, height, 0, height/scale));
  }

  void addConnection(boolean isFromBigConnection) {
    if (!isFromBigConnection) {
      if (piecePortId1 < firstPiece.nrInputs) {
        //delete any invalidated big ports
        for (BigConnection cn : mainCanvas.bigConnections)
          if (cn.piece == firstPiece && cn.TYPE == -1 && cn.startPort <= piecePortId1 && cn.endPort >= piecePortId1)
            cn.connections = new ArrayList<>();
          else if (cn.piece == secondPiece && cn.TYPE == 1 && cn.startPort <= piecePortId2 && cn.endPort >= piecePortId2)
            for (BigConnection cnn : cn.connections)
              if (cnn.piece == firstPiece && cnn.startPort <= piecePortId1 && cnn.endPort >= piecePortId1) {
                cn.connections.remove(cnn);
                break;
              }
      } else if (piecePortId2 < secondPiece.nrInputs) {
        //delete any invalidated big ports
        for (BigConnection cn : mainCanvas.bigConnections)
          if (cn.piece == secondPiece && cn.TYPE == -1 && cn.startPort <= piecePortId2 && cn.endPort >= piecePortId2)
            cn.connections = new ArrayList<>();
          else if (cn.piece == firstPiece && cn.TYPE == 1 && cn.startPort <= piecePortId1 && cn.endPort >= piecePortId1)
            for (BigConnection cnn : cn.connections)
              if (cnn.piece == secondPiece && cnn.startPort <= piecePortId2 && cnn.endPort >= piecePortId2) {
                cn.connections.remove(cnn);
                break;
              }
      }
    }

    if (piecePortId1 < firstPiece.nrInputs) {
      //if first is input - replace any other where there is this output
      for (Connection cn : mainCanvas.connections)
        if ((cn.firstPiece == firstPiece && cn.piecePortId1 == piecePortId1) || (cn.secondPiece == firstPiece && cn.piecePortId2 == piecePortId1)) {
          cn.firstPiece = firstPiece;
          cn.piecePortId1 = piecePortId1;
          cn.secondPiece = secondPiece;
          cn.piecePortId2 = piecePortId2;
          cn.con = con;
          return;
        }
    } else if (piecePortId2 < secondPiece.nrInputs) {
      //if second is input - replace any other where there is this output
      for (Connection cn : mainCanvas.connections)
        if ((cn.firstPiece == secondPiece && cn.piecePortId1 == piecePortId2) || (cn.secondPiece == secondPiece && cn.piecePortId2 == piecePortId2)) {
          cn.firstPiece = firstPiece;
          cn.piecePortId1 = piecePortId1;
          cn.secondPiece = secondPiece;
          cn.piecePortId2 = piecePortId2;
          cn.con = con;
          return;
        }
    }

    mainCanvas.connections.add(this);
  }

  Piece getOutputPiece() {
    if (piecePortId1 >= firstPiece.nrInputs)
      return firstPiece;
    return secondPiece;
  }

  int getOutputPort() {
    if (piecePortId1 >= firstPiece.nrInputs)
      return piecePortId1;
    return piecePortId2;
  }
}
