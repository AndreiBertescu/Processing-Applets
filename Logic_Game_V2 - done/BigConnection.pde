class BigConnection {
  ArrayList<BigConnection> connections;
  int startPort, endPort, TYPE;
  Piece piece;
  float x, y;

  BigConnection(float x, float y, int startPort, int endPort, Piece piece, int type) {
    this.piece = piece;
    this.startPort = startPort;
    this.endPort = endPort;
    this.TYPE = type;
    this.x = x;
    this.y = y;

    connections = new ArrayList<>();
  }

  void show() {
    if (mainCanvas.bigConnections.indexOf(this) == hoveredBigConnection) {
      rectMode(CENTER);
      noStroke();
      fill(0, 100);
      square(x + piece.x, y + piece.y, bigPortWidth);
      rectMode(CORNER);
    }

    strokeWeight(2);
    stroke(255);
    for (BigConnection cn : connections)
      line(x + piece.x, y + piece.y, cn.x + cn.piece.x, cn.y + cn.piece.y);

    if (currentBigConnection != -1 && mainCanvas.bigConnections.get(currentBigConnection) == this)
      line(x + piece.x, y + piece.y, map(mouseX, 0, width, 0, width/scale) - mainCanvas.offset.x - mainCanvas.semiOffset.x, map(mouseY, 0, height, 0, height/scale) - mainCanvas.offset.y - mainCanvas.semiOffset.y);
  }

  void addConnection(BigConnection cn) {
    if (cn.TYPE == TYPE || cn.piece == piece || cn.endPort - cn.startPort != endPort - startPort || cn.connections.indexOf(this) != -1)
      return;

    if (TYPE == -1) {
      connections = new ArrayList<>();
      for (BigConnection bcn : mainCanvas.bigConnections)
        if (bcn.connections.indexOf(this) != -1) {
          bcn.connections.remove(this);
          break;
        }
    } else if (TYPE == 1) {
      cn.connections = new ArrayList<>();
      for (BigConnection bcn : mainCanvas.bigConnections)
        if (bcn.connections.indexOf(cn) != -1) {
          bcn.connections.remove(cn);
          break;
        }
    }

    connections.add(cn);
    for (int i=0; i<=(endPort - startPort); i++) {
      if (TYPE == -1)
        new Connection(piece, startPort + i, cn.piece, cn.startPort + i + cn.piece.nrInputs).addConnection(true);
      else
        new Connection(piece, startPort + i + piece.nrInputs, cn.piece, cn.startPort + i).addConnection(true);
    }
  }
}

void invalidateBigConnection(Connection connection) {
  if (connection.piecePortId1 < connection.firstPiece.nrInputs) {
    //delete any invalidated big ports
    for (BigConnection cn : mainCanvas.bigConnections)
      if (cn.piece == connection.firstPiece && cn.TYPE == -1 && cn.startPort <= connection.piecePortId1 && cn.endPort >= connection.piecePortId1)
        cn.connections = new ArrayList<>();
      else if (cn.piece == connection.secondPiece && cn.TYPE == 1 && cn.startPort <= connection.piecePortId2 && cn.endPort >= connection.piecePortId2)
        for (BigConnection cnn : cn.connections)
          if (cnn.piece == connection.firstPiece && cnn.startPort <= connection.piecePortId1 && cnn.endPort >= connection.piecePortId1) {
            cn.connections.remove(cnn);
            break;
          }
  } else if (connection.piecePortId2 < connection.secondPiece.nrInputs) {
    //delete any invalidated big ports
    for (BigConnection cn : mainCanvas.bigConnections)
      if (cn.piece == connection.secondPiece && cn.TYPE == -1 && cn.startPort <= connection.piecePortId2 && cn.endPort >= connection.piecePortId2)
        cn.connections = new ArrayList<>();
      else if (cn.piece == connection.firstPiece && cn.TYPE == 1 && cn.startPort <= connection.piecePortId1 && cn.endPort >= connection.piecePortId1)
        for (BigConnection cnn : cn.connections)
          if (cnn.piece == connection.secondPiece && cnn.startPort <= connection.piecePortId2 && cnn.endPort >= connection.piecePortId2) {
            cn.connections.remove(cnn);
            break;
          }
  }
}
