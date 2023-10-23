ArrayList<PVector> moveSet(Type t, int x, int y) {
  ArrayList<PVector> actions = new ArrayList<PVector>();
  actions.add(new PVector(x, y, 1));

  switch(t) {
  case King:
    if (pieces[y][x].first && x==5) {
      try {
        if (pieces[y][1].first && pieces[y][2] == null && pieces[y][3] == null && pieces[y][4] == null)
          actions.add(new PVector(1, y, 6));
      }
      catch(Exception e) {
      }
      try {
        if (pieces[y][8].first && pieces[y][7] == null && pieces[y][6] == null)
          actions.add(new PVector(8, y, 7));
      }
      catch(Exception e) {
      }
    }


    if (x-1 >= 1) {
      if (pieces[y][x-1] == null)
        actions.add(new PVector(x-1, y, 1));
      else if (pieces[y][x-1].c != pieces[y][x].c)
        actions.add(new PVector(x-1, y, 2));
    }
    if (x+1 <= 8) {
      if (pieces[y][x+1] == null)
        actions.add(new PVector(x+1, y, 1));
      else if (pieces[y][x+1].c != pieces[y][x].c)
        actions.add(new PVector(x+1, y, 2));
    }
    if (y-1 >= 1) {
      if (pieces[y-1][x] == null)
        actions.add(new PVector(x, y-1, 1));
      else if (pieces[y-1][x].c != pieces[y][x].c)
        actions.add(new PVector(x, y-1, 2));
    }
    if (y+1 <= 8) {
      if (pieces[y+1][x] == null)
        actions.add(new PVector(x, y+1, 1));
      else if (pieces[y+1][x].c != pieces[y][x].c)
        actions.add(new PVector(x, y+1, 2));
    }
    if (x-1 >= 1 && y-1 >= 1) {
      if (pieces[y-1][x-1] == null)
        actions.add(new PVector(x-1, y-1, 1));
      else if (pieces[y-1][x-1].c != pieces[y][x].c)
        actions.add(new PVector(x-1, y-1, 2));
    }
    if (x+1 <= 8 && y+1 <= 8) {
      if (pieces[y+1][x+1] == null)
        actions.add(new PVector(x+1, y+1, 1));
      else if (pieces[y+1][x+1].c != pieces[y][x].c)
        actions.add(new PVector(x+1, y+1, 2));
    }
    if (x-1 >= 1 && y+1 <= 8) {
      if (pieces[y+1][x-1] == null)
        actions.add(new PVector(x-1, y+1, 1));
      else if (pieces[y+1][x-1].c != pieces[y][x].c)
        actions.add(new PVector(x-1, y+1, 2));
    }
    if (x+1 <= 8 && y-1 >= 1) {
      if (pieces[y-1][x+1] == null)
        actions.add(new PVector(x+1, y-1, 1));
      else if (pieces[y-1][x+1].c != pieces[y][x].c)
        actions.add(new PVector(x+1, y-1, 2));
    }
    return actions;
  case Queen:
    for (int i=1; i<=8; i++) try {
      if (pieces[y+i][x+i] != null) {
        if (pieces[y+i][x+i].c != pieces[y][x].c)
          actions.add(new PVector(x+i, y+i, 2));
        break;
      }
      if (pieces[y+i][x+i] == null)
        actions.add(new PVector(x+i, y+i, 1));
    }
    catch(Exception e) {
    }
    for (int i=1; i<=8; i++) try {
      if (pieces[y-i][x-i] != null) {
        if (pieces[y-i][x-i].c != pieces[y][x].c)
          actions.add(new PVector(x-i, y-i, 2));
        break;
      }
      if (pieces[y-i][x-i] == null  && y-i>0 && x-i>0)
        actions.add(new PVector(x-i, y-i, 1));
    }
    catch(Exception e) {
    }
    for (int i=1; i<=8; i++) try {
      if (pieces[y-i][x+i] != null) {
        if (pieces[y-i][x+i].c != pieces[y][x].c)
          actions.add(new PVector(x+i, y-i, 2));
        break;
      }
      if (pieces[y-i][x+i] == null && y-i>0)
        actions.add(new PVector(x+i, y-i, 1));
    }
    catch(Exception e) {
    }
    for (int i=1; i<=8; i++) try {
      if (pieces[y+i][x-i] != null) {
        if (pieces[y+i][x-i].c != pieces[y][x].c)
          actions.add(new PVector(x-i, y+i, 2));
        break;
      }
      if (pieces[y+i][x-i] == null && x-i>0)
        actions.add(new PVector(x-i, y+i, 1));
    }
    catch(Exception e) {
    }
    if (x+1<=8) for (int i=x+1; i<=8; i++) {
      if (pieces[y][i] != null) {
        if (pieces[y][i].c != pieces[y][x].c)
          actions.add(new PVector(i, y, 2));
        break;
      }
      if (pieces[y][i] == null)
        actions.add(new PVector(i, y, 1));
    }
    if (x-1>=1) for (int i=x-1; i>=1; i--) {
      if (pieces[y][i] != null) {
        if (pieces[y][i].c != pieces[y][x].c)
          actions.add(new PVector(i, y, 2));
        break;
      }
      if (pieces[y][i] == null)
        actions.add(new PVector(i, y, 1));
    }
    if (y+1<=8) for (int i=y+1; i<=8; i++) {
      if (pieces[i][x] != null) {
        if (pieces[i][x].c != pieces[y][x].c)
          actions.add(new PVector(x, i, 2));
        break;
      }
      if (pieces[i][x] == null)
        actions.add(new PVector(x, i, 1));
    }
    if (y-1>=1) for (int i=y-1; i>=1; i--) {
      if (pieces[i][x] != null) {
        if (pieces[i][x].c != pieces[y][x].c)
          actions.add(new PVector(x, i, 2));
        break;
      }
      if (pieces[i][x] == null)
        actions.add(new PVector(x, i, 1));
    }
    return actions;
  case Bishop:
    for (int i=1; i<=8; i++) try {
      if (pieces[y+i][x+i] != null) {
        if (pieces[y+i][x+i].c != pieces[y][x].c)
          actions.add(new PVector(x+i, y+i, 2));
        break;
      }
      if (pieces[y+i][x+i] == null)
        actions.add(new PVector(x+i, y+i, 1));
    }
    catch(Exception e) {
    }
    for (int i=1; i<=8; i++) try {
      if (pieces[y-i][x-i] != null) {
        if (pieces[y-i][x-i].c != pieces[y][x].c)
          actions.add(new PVector(x-i, y-i, 2));
        break;
      }
      if (pieces[y-i][x-i] == null && y-i>0 && x-i>0)
        actions.add(new PVector(x-i, y-i, 1));
    }
    catch(Exception e) {
    }
    for (int i=1; i<=8; i++) try {
      if (pieces[y-i][x+i] != null) {
        if (pieces[y-i][x+i].c != pieces[y][x].c)
          actions.add(new PVector(x+i, y-i, 2));
        break;
      }
      if (pieces[y-i][x+i] == null && y-i>0)
        actions.add(new PVector(x+i, y-i, 1));
    }
    catch(Exception e) {
    }
    for (int i=1; i<=8; i++) try {
      if (pieces[y+i][x-i] != null) {
        if (pieces[y+i][x-i].c != pieces[y][x].c)
          actions.add(new PVector(x-i, y+i, 2));
        break;
      }
      if (pieces[y+i][x-i] == null)
        actions.add(new PVector(x-i, y+i, 1));
    }
    catch(Exception e) {
    }
    return actions;
  case Rook:
    if (x+1<=8) for (int i=x+1; i<=8; i++) {
      if (pieces[y][i] != null) {
        if (pieces[y][i].c != pieces[y][x].c)
          actions.add(new PVector(i, y, 2));
        break;
      }
      if (pieces[y][i] == null)
        actions.add(new PVector(i, y, 1));
    }
    if (x-1>=1) for (int i=x-1; i>=1; i--) {
      if (pieces[y][i] != null) {
        if (pieces[y][i].c != pieces[y][x].c)
          actions.add(new PVector(i, y, 2));
        break;
      }
      if (pieces[y][i] == null)
        actions.add(new PVector(i, y, 1));
    }
    if (y+1<=8) for (int i=y+1; i<=8; i++) {
      if (pieces[i][x] != null) {
        if (pieces[i][x].c != pieces[y][x].c)
          actions.add(new PVector(x, i, 2));
        break;
      }
      if (pieces[i][x] == null)
        actions.add(new PVector(x, i, 1));
    }
    if (y-1>=1) for (int i=y-1; i>=1; i--) {
      if (pieces[i][x] != null) {
        if (pieces[i][x].c != pieces[y][x].c)
          actions.add(new PVector(x, i, 2));
        break;
      }
      if (pieces[i][x] == null)
        actions.add(new PVector(x, i, 1));
    }
    return actions;
  case Knight:
    try {
      if (pieces[y+2][x+1] == null)
        actions.add(new PVector(x+1, y+2, 1));
      if (pieces[y+2][x+1].c != pieces[y][x].c)
        actions.add(new PVector(x+1, y+2, 2));
    }
    catch(Exception e) {
    }
    try {
      if (pieces[y+2][x-1] == null && x-1>0)
        actions.add(new PVector(x-1, y+2, 1));
      if (pieces[y+2][x-1].c != pieces[y][x].c)
        actions.add(new PVector(x-1, y+2, 2));
    }
    catch(Exception e) {
    }
    try {
      if (pieces[y-2][x+1] == null && y-2>0)
        actions.add(new PVector(x+1, y-2, 1));
      if (pieces[y-2][x+1].c != pieces[y][x].c)
        actions.add(new PVector(x+1, y-2, 2));
    }
    catch(Exception e) {
    }
    try {
      if (pieces[y-2][x-1] == null && y-2>0 && x-1>0)
        actions.add(new PVector(x-1, y-2, 1));
      if (pieces[y-2][x-1].c != pieces[y][x].c)
        actions.add(new PVector(x-1, y-2, 2));
    }
    catch(Exception e) {
    }
    try {
      if (pieces[y+1][x+2] == null)
        actions.add(new PVector(x+2, y+1, 1));
      if (pieces[y+1][x+2].c != pieces[y][x].c)
        actions.add(new PVector(x+2, y+1, 2));
    }
    catch(Exception e) {
    }
    try {
      if (pieces[y-1][x+2] == null && y-1>0)
        actions.add(new PVector(x+2, y-1, 1));
      if (pieces[y-1][x+2].c != pieces[y][x].c)
        actions.add(new PVector(x+2, y-1, 2));
    }
    catch(Exception e) {
    }
    try {
      if (pieces[y+1][x-2] == null && x-2>0)
        actions.add(new PVector(x-2, y+1, 1));
      if (pieces[y+1][x-2].c != pieces[y][x].c)
        actions.add(new PVector(x-2, y+1, 2));
    }
    catch(Exception e) {
    }
    try {
      if (pieces[y-1][x-2] == null && y-1>0 && x-2>0)
        actions.add(new PVector(x-2, y-1, 1));
      if (pieces[y-1][x-2].c != pieces[y][x].c)
        actions.add(new PVector(x-2, y-1, 2));
    }
    catch(Exception e) {
    }
    return actions;
  case Pawn:
    if (pieces[y][x].c == "W") {
      if (y-1 >= 1 && pieces[y-1][x] == null) {
        actions.add(new PVector(x, y-1, 1));
        if (pieces[y][x].first && pieces[y-2][x] == null)
          actions.add(new PVector(x, y-2, 1));

        if (x+1 <= 8 && pieces[y-1][x+1] != null && pieces[y-1][x+1].c != pieces[y][x].c)
          actions.add(new PVector(x+1, y-1, 2));
        if (x-1 >= 1 && pieces[y-1][x-1] != null && pieces[y-1][x-1].c != pieces[y][x].c)
          actions.add(new PVector(x-1, y-1, 2));
      } else if (y-1 >= 1 && pieces[y-1][x] != null) {
        if (x+1 <= 8 && pieces[y-1][x+1] != null && pieces[y-1][x+1].c != pieces[y][x].c)
          actions.add(new PVector(x+1, y-1, 2));
        if (x-1 >= 1 && pieces[y-1][x-1] != null && pieces[y-1][x-1].c != pieces[y][x].c)
          actions.add(new PVector(x-1, y-1, 2));
      } else if (y == 1) {
        actions.add(new PVector(x, y, 3));
      }

      if (y-1 >= 1 && x+1 <= 8 && pieces[y][x+1] != null && pieces[y][x+1].type == Type.Pawn && pieces[y][x+1].second)
        actions.add(new PVector(x+1, y-1, 4));
      if (y-1 >= 1 && x-1 >= 1 && pieces[y][x-1] != null && pieces[y][x-1].type == Type.Pawn && pieces[y][x-1].second)
        actions.add(new PVector(x-1, y-1, 5));
    }

    if (pieces[y][x].c == "B") {
      if (y+1 <= 8 && pieces[y+1][x] == null) {
        actions.add(new PVector(x, y+1, 1));
        if (pieces[y][x].first && pieces[y+2][x] == null)
          actions.add(new PVector(x, y+2, 1));

        if (x+1 <= 8 && pieces[y+1][x+1] != null && pieces[y+1][x+1].c != pieces[y][x].c)
          actions.add(new PVector(x+1, y+1, 2));
        if (x-1 >= 1 && pieces[y+1][x-1] != null && pieces[y+1][x-1].c != pieces[y][x].c)
          actions.add(new PVector(x-1, y+1, 2));
      } else if (y+1 <= 8 && pieces[y+1][x] != null) {
        if (x+1 <= 8 && pieces[y+1][x+1] != null && pieces[y+1][x+1].c != pieces[y][x].c)
          actions.add(new PVector(x+1, y+1, 2));
        if (x-1 >= 1 && pieces[y+1][x-1] != null && pieces[y+1][x-1].c != pieces[y][x].c)
          actions.add(new PVector(x-1, y+1, 2));
      } else if (y == 8) {
        actions.add(new PVector(x, y, 3));
      }

      if (y+1 >= 1 && x+1 <= 8 && pieces[y][x+1] != null && pieces[y][x+1].type == Type.Pawn && pieces[y][x+1].second)
        actions.add(new PVector(x+1, y+1, 4));
      if (y+1 >= 1 && x-1 >= 1 && pieces[y][x-1] != null && pieces[y][x-1].type == Type.Pawn && pieces[y][x-1].second)
        actions.add(new PVector(x-1, y+1, 5));
    }
    return actions;
  }
  return actions;
}
