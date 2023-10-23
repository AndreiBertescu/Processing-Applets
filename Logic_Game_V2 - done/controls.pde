void mousePressed() {
  if (isNewPiece || mouseX > width-menu.w || paused)
    return;

  if (mouseButton != LEFT && mouseButton != CENTER) {
    //reset connection
    connectionOriginType = -1;
    isMakingConnection = false;
    currentConnection = null;
    currentBigConnection = -1;
  }

  if (mouseButton == RIGHT) {
    for (Piece pc : mainCanvas.pieces) //check if on piece port
      if (within(mouseX, mouseY, pc.x + mainCanvas.offset.x, pc.x + pc.w + mainCanvas.offset.x, pc.y + mainCanvas.offset.y, pc.y + pc.h + mainCanvas.offset.y)) {
        movedPiece = pc;
        isMovingPiece = true;
        movedPieceOffset.set(map(mouseX, 0, width, 0, width/scale) - pc.x, map(mouseY, 0, height, 0, height/scale) - pc.y);
        return;
      }
    for (Connection c : mainCanvas.connections) //check if on any node
      if (c.hoveredNode != -1) {
        movedNodeIndex = c.hoveredNode;
        movedConnection = c;
        isMovingNode = true;
        return;
      }
  }

  if (mouseButton == CENTER)
    lastPressPos.set(mouseX, mouseY);
}

void checkControlls() {
  if (isNewPiece || paused)
    return;

  if (mousePressed) {
    if (mouseButton == CENTER) {
      mainCanvas.semiOffset.set((mouseX - lastPressPos.x)/scale, (mouseY - lastPressPos.y)/scale);
    }
  }
}

void mouseReleased() {
  if (paused)
    return;

  mainCanvas.offset.add(mainCanvas.semiOffset);
  mainCanvas.semiOffset.set(0, 0);

  isMovingPiece = false;
  movedPiece = null;

  movedNodeIndex = -1;
  isMovingNode = false;
  movedConnection = null;

  if (mouseX > width-menuWidth) { //if in menu
    if (menu.saveHover) { //save
      paused = true;
      textMenu = new TextBox(width/2 - 100, height/2 + 30, 200, 50);
      saving = true;
      return;
    }

    if (menu.clearHover) { //clear
      mainCanvas.clearCanvas();
      return;
    }

    if (menu.optHover == 1 && !selectedType.matches("")) { //delete
      deleteType(selectedType);
      files = dir.list();
      selectedType = "";
      return;
    } else if (menu.optHover == 2 && !selectedType.matches("")) { //explore
      mainCanvas = loadCanvas(selectedType);
      selectedType = "";
      return;
    }

    if (menu.itemHover != -1) {
      //if IN or OUT make pause menu
      if (menu.itemHover >= 2 && mouseButton == LEFT) {
        isNewPiece = true;
        selectedType = "";
        newPiece = new LogicGate(files[menu.itemHover - 2].substring(0, files[menu.itemHover - 2].indexOf(".")), mouseX, mouseY, mainCanvas);
      } else if (menu.itemHover >= 2 && mouseButton == RIGHT && !files[menu.itemHover - 2].substring(0, files[menu.itemHover - 2].indexOf(".")).matches("AND") && !files[menu.itemHover - 2].substring(0, files[menu.itemHover - 2].indexOf(".")).matches("NOT"))
        selectedType = files[menu.itemHover - 2].substring(0, files[menu.itemHover - 2].indexOf("."));
      else if (menu.itemHover < 2) {
        isNewPiece = true;
        selectedType = "";
        textMenu = new TextBox(width/2 - 100, height/2 + 30, 200, 50);
        paused = true;
      }
    }

    return;
  }

  selectedType = "";

  if (isNewPiece && mouseX < width-menu.w) {
    newPiece.x = newPiece.x / scale - mainCanvas.offset.x;
    newPiece.y = newPiece.y / scale - mainCanvas.offset.y;
    mainCanvas.pieces.add(newPiece);
    isNewPiece = false;
    newPiece = null;
  } else if (isNewPiece)
    return;

  if (mouseButton == RIGHT) { //remove connections
    for (Piece pc : mainCanvas.pieces)
      if (pc.hoveredPort != -1)
        for (Connection cn : mainCanvas.connections)
          if ((cn.firstPiece == pc && cn.piecePortId1 == pc.hoveredPort) || (cn.secondPiece == pc && cn.piecePortId2 == pc.hoveredPort)) {
            if (cn.piecePortId1 < cn.firstPiece.nrInputs) {
              cn.firstPiece.input[cn.piecePortId1] = false;
              cn.firstPiece.changed = true;
            } else {
              cn.secondPiece.input[cn.piecePortId2] = false;
              cn.secondPiece.changed = true;
            }
            invalidateBigConnection(cn);
            mainCanvas.connections.remove(cn);
            return;
          }
    if (hoveredBigConnection != -1) {
      mainCanvas.bigConnections.get(hoveredBigConnection).connections = new ArrayList<>();
      for (BigConnection cn : mainCanvas.bigConnections)
        if (cn.connections.contains(mainCanvas.bigConnections.get(hoveredBigConnection)))
          cn.connections.remove(mainCanvas.bigConnections.get(hoveredBigConnection));
    }
  } else if (mouseButton == CENTER) {
    for (Piece pc : mainCanvas.pieces)
      if (pc.TYPE.matches("IN") && pc.hoveredPort != -1) //change input ports
        pc.output[pc.hoveredPort] = !pc.output[pc.hoveredPort];
  } else if (mouseButton == LEFT) {
    if (isMakingConnection) {
      for (Piece pc : mainCanvas.pieces) //check to end connection
        if ((pc.hoveredPort != -1) && ((pc.hoveredPort < pc.nrInputs && connectionOriginType == 2) || (pc.hoveredPort >= pc.nrInputs && connectionOriginType == 1))) {
          isMakingConnection = false;
          connectionOriginType = -1;
          currentConnection.secondPiece = pc;
          currentConnection.piecePortId2 = pc.hoveredPort;

          //add connection to the rest
          currentConnection.addConnection(false);
          //reset connection
          connectionOriginType = -1;
          isMakingConnection = false;
          currentConnection = null;
          return;
        }

      if (hoveredBigConnection != -1 && currentBigConnection != hoveredBigConnection) {
        mainCanvas.bigConnections.get(currentBigConnection).addConnection(mainCanvas.bigConnections.get(hoveredBigConnection));
        isMakingConnection = false;
        currentBigConnection = -1;
        return;
      }

      //if all invalid connections - reset
      if (currentConnection != null)
        currentConnection.con.add(new PVector(map(mouseX, 0, width, 0, width/scale) - mainCanvas.offset.x, map(mouseY, 0, height, 0, height/scale) - mainCanvas.offset.y));
    } else { //start connection if valid
      for (Piece pc : mainCanvas.pieces)
        if (pc.hoveredPort != -1) {//check to start connection
          if (pc.hoveredPort < pc.nrInputs)
            connectionOriginType = 1;
          else
            connectionOriginType = 2;
          isMakingConnection = true;

          currentConnection = new Connection(pc, pc.hoveredPort, null);
          return;
        }

      for (Connection c : mainCanvas.connections)
        if (c.hoveredNode != -1) {//check to start connection
          connectionOriginType = 2;

          isMakingConnection = true;
          currentConnection = new Connection(c.getOutputPiece(), c.getOutputPort(), c.con.get(c.hoveredNode));
          return;
        }

      if (hoveredBigConnection != -1) {
        isMakingConnection = true;
        currentBigConnection = hoveredBigConnection;
        return;
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  if (event.getCount() > 0)
    scale = max(scale-0.2, 0.2);
  else if (event.getCount() < 0)
    scale += 0.2;
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
    saving = false;
    newPiece = null;
    isNewPiece = false;
    return;
  }

  if (key == ENTER && paused && isNewPiece && textMenu.textValue != "") try {
    if (Integer. parseInt(textMenu.textValue) > 0 && Integer. parseInt(textMenu.textValue) <= 32) {
      newPiece = new IO(menu.itemHover == 0 ? "IN":"OUT", mouseX, mouseY, Integer. parseInt(textMenu.textValue), mainCanvas);
      paused = false;
    }
    return;
  }
  catch(Exception e) {
    textMenu.textValue = "Invalid value!";
    return;
  }

  if (key == ENTER && paused && saving) { //save
    if (textMenu.textValue.matches("")) {
      println("Invalid name.");
      return;
    }
    for (int i=0; i<files.length; i++)
      if (textMenu.textValue.matches(files[i].substring(0, files[i].indexOf(".")))) {
        textMenu.textValue = "Invalid value!";
        return;
      }

    paused = false;
    saving = false;
    mainCanvas.saveCanvasValues();
    mainCanvas.saveCanvasComponents();
    files = dir.list();
    return;
  }

  if (key == DELETE) //delete piece
    for (Piece pc : mainCanvas.pieces)
      if (within(mouseX, mouseY, pc.x + mainCanvas.offset.x, pc.x + pc.w + mainCanvas.offset.x, pc.y + mainCanvas.offset.y, pc.y + pc.h + mainCanvas.offset.y)) {
        ArrayList<Connection> connections = new ArrayList<>();
        ArrayList<BigConnection> bigConnections = new ArrayList<>();

        for (Connection cn : mainCanvas.connections)
          if (cn.firstPiece != pc && cn.secondPiece != pc)
            connections.add(cn);

        for (BigConnection cn : mainCanvas.bigConnections)
          if (cn.piece != pc) {
            ArrayList<BigConnection> bigInterConnections = new ArrayList<>();
            for (BigConnection cnn : cn.connections) {
              if (cnn.piece != pc)
                bigInterConnections.add(cnn);
            }
            cn.connections = (ArrayList<BigConnection>)bigInterConnections.clone();
            bigConnections.add(cn);
          }

        mainCanvas.connections = (ArrayList<Connection>)connections.clone();
        mainCanvas.bigConnections = (ArrayList<BigConnection>)bigConnections.clone();
        mainCanvas.pieces.remove(pc);
        return;
      }
}
