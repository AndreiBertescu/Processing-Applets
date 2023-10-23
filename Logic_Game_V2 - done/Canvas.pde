class Canvas {
  PVector offset, semiOffset;
  ArrayList<Piece> pieces;
  ArrayList<Connection> connections;
  ArrayList<BigConnection> bigConnections;

  //settings
  int backgroundDist = 70; //distance between background pluses

  Canvas() {
    pieces = new ArrayList<>();
    connections = new ArrayList<>();
    bigConnections = new ArrayList<>();

    offset = new PVector(0, 0);
    semiOffset = new PVector(0, 0);
  }

  void update() {
    if (isMovingPiece) {
      movedPiece.x = map(mouseX, 0, width, 0, width/scale) - movedPieceOffset.x;
      movedPiece.y = map(mouseY, 0, height, 0, height/scale) - movedPieceOffset.y;
    } else if (isMovingNode)
      movedConnection.con.get(movedNodeIndex).set(map(mouseX, 0, width, 0, width/scale) - offset.x, map(mouseY, 0, height, 0, height/scale) - offset.y);

    for (Piece pc : pieces)
      pc.update();

    for (Connection cn : connections)
      cn.update();

    hoveredBigConnection = -1;
    for (BigConnection cn : bigConnections)
      if (within(mouseX, mouseY, cn.x+cn.piece.x - bigPortWidth/2 + offset.x, cn.x+cn.piece.x + bigPortWidth/2 + offset.x, cn.y+cn.piece.y - bigPortWidth/2 + offset.y, cn.y+cn.piece.y + bigPortWidth/2 + offset.y))
        hoveredBigConnection = bigConnections.indexOf(cn);
  }

  void show() {
    //draw background
    stroke(255, 150);
    strokeWeight(0.7);
    for (float x=(offset.x + semiOffset.x)%backgroundDist; x<width/(scale<1?scale:1); x+=backgroundDist)
      for (float y=(offset.y + semiOffset.y)%backgroundDist; y<height/(scale<1?scale:1); y+=backgroundDist) 
        if(!within(x * scale, y * scale, 50 + offset.x + semiOffset.x, 500 + offset.x + semiOffset.x, 50 + offset.y + semiOffset.y, 250 + offset.y + semiOffset.y)){
          line(x-backgroundDist/8, y, x+backgroundDist/8, y);
          line(x, y-backgroundDist/8, x, y+backgroundDist/8);
        }
      
    //draw controlls
    textSize(18);
    textAlign(LEFT);
    noFill();
    rect(45 + offset.x + semiOffset.x, 35 + offset.y + semiOffset.y, 455, 213);
    
    fill(255, 150);
    text("-HOLD MIDDLE MOUSE BUTTON TO DRAG WORK AREA\n-HOLD RIGH MOUSE BUTTON TO DRAG PIECE\n-PRESS MIDDLE MOUSE BUTTON TO ENABLE PIN\n-PRESS LEFT MOUSE BUTTON TO MAKE CONNECTIONS\n-RIGH CLICK ON A MENU ITEM TO ENABLE EXTRA BUTTONS\n-RIGHT CLICK ON A PIN TO DELETE CONNECTION\n-PRESS DELETE WHILE HOVERING ON A PIECE TO DELETE", 50 + offset.x + semiOffset.x, 60 + offset.y + semiOffset.y);
    textAlign(CENTER);

    //draw rest
    translate(offset.x + semiOffset.x, offset.y + semiOffset.y);
    fill(255);

    for (Connection cn : connections)
      cn.show();

    for (Piece pc : pieces)
      pc.show();

    for (BigConnection cn : bigConnections)
      cn.show();
  }

  void clearCanvas() {
    pieces = new ArrayList<>();
    connections = new ArrayList<>();
    bigConnections = new ArrayList<>();
    offset.set(0, 0);
    semiOffset.set(0, 0);
    
    isMakingConnection = false;
    isMovingPiece = false;
    isNewPiece = false;
    nrOfInputs = 0;
    nrOfOutputs = 0;
    movedNodeIndex = -1;
    connectionOriginType = -1;
    hoveredBigConnection = -1;
    currentBigConnection = -1;
  }

  void saveCanvasValues() {
    //get all the inputs and outputs in order
    ArrayList<IO> ins = new ArrayList<>();
    ArrayList<IO> outs = new ArrayList<>();
    for (Piece pc : pieces)
      if (pc.TYPE.matches("IN"))
        ins.add((IO)pc);
      else if (pc.TYPE.matches("OUT"))
        outs.add((IO)pc);

    //order them
    for (int i=0; i<ins.size()-1; i++)
      for (int j=i+1; j<ins.size(); j++)
        if (ins.get(i).id > ins.get(j).id) {
          IO aux = ins.get(i);
          ins.set(i, ins.get(j));
          ins.set(j, aux);
        }
    for (int i=0; i<outs.size()-1; i++)
      for (int j=i+1; j<outs.size(); j++)
        if (outs.get(i).id > outs.get(j).id) {
          IO aux = ins.get(i);
          outs.set(i, outs.get(j));
          outs.set(j, aux);
        }

    //get no of inputs and outputs
    int nrIns = 0, nrOuts = 0;
    for (IO pc : ins)
      nrIns += pc.nrOutputs;
    for (IO pc : outs)
      nrOuts += pc.nrInputs;

    //write all IO data
    PrintWriter file = createWriter(dataPath(dir.getName()) + "/" + textMenu.textValue + ".txt");
    file.print(nrIns);
    for (IO pc : ins)
      file.print(" " + pc.nrOutputs);
    file.print('\n');
    file.print(nrOuts);
    for (IO pc : outs)
      file.print(" " + pc.nrInputs);
    file.print('\n');

    //save initial values
    String initialValues = "";
    for (IO pc : ins) 
      for (int i=0; i<pc.nrOutputs; i++)
          initialValues += pc.output[i] ? "1 ":"0 ";

    //write all the combination values
    for (int i=0; i<pow(2, nrIns); i++) {
      String s = String.format("%"+nrIns+"s", Integer.toBinaryString(i)).replaceAll(" ", "0");

      int nr = 0;
      for (IO pc : ins) {
        for (int j=0; j<pc.nrOutputs; j++)
          pc.output[j] = Character.getNumericValue(s.charAt(nr + j)) == 1 ? true:false;
        nr += pc.nrOutputs;
      }

      for (int j=0; j<=mainCanvas.pieces.size()*2; j++)
        this.update();

      for (IO pc : outs)
        for (int j=0; j<pc.nrInputs; j++)
          file.print(pc.input[j] ? "1 ":"0 ");
      file.println();
    }

    //write color
    file.print((int)random(255) + " " + (int)random(255) + " " + (int)random(255));
    file.flush();
    file.close();
    
    //load initial values
    int nr = 0;
    for (IO pc : ins) {
      for (int i=0; i<pc.nrOutputs; i++)
        pc.output[i] = Character.getNumericValue(initialValues.charAt((nr++) * 2)) == 1 ? true:false;
    }
  }

  void saveCanvasComponents() {
    PrintWriter file = createWriter(dataPath(canv.getName()) + "/" + textMenu.textValue + ".txt");

    //write nr of pieces
    file.println(pieces.size());

    //write pieces type and position
    for (Piece pc : pieces) {
      file.print(pc.TYPE + " " + pc.x + " " + pc.y);
      if (pc.TYPE.matches("IN"))
        file.println(" " + pc.nrOutputs);
      else if (pc.TYPE.matches("OUT"))
        file.println(" " + pc.nrInputs);
      else
        file.println();
    }

    //write nr of connections
    file.println(connections.size());

    //write connection init var
    for (Connection cn : connections)
      file.println(pieces.indexOf(cn.firstPiece) + " " + cn.piecePortId1 + " " + pieces.indexOf(cn.secondPiece) + " " + cn.piecePortId2);

    //write connections con positions
    for (Connection cn : connections)
      if (cn.con.size() == 0)
        file.println("null");
      else{
        for (PVector pv : cn.con)
          file.print(pv.x + " " + pv.y + " ");
          file.print("\n");
      }
          
    //write bigConnections
    for (int i=0; i<bigConnections.size(); i++)
      if(bigConnections.get(i).connections.size() > 0)
        for (BigConnection bcn : bigConnections.get(i).connections)
          file.println(i + " " + bigConnections.indexOf(bcn) + " ");

    file.flush();
    file.close();
  }
}
