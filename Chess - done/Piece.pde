enum Type {
  King,
    Queen,
    Bishop,
    Rook,
    Knight,
    Pawn
}

class Piece {
  Type type;
  int x, y;
  String c;
  Boolean first = true;
  Boolean second = false;

  Piece(int y, int x, Type type, String c) {
    this.type = type;
    this.x = x;
    this.y = y;
    this.c = c;
  }

  Piece(int y, int x, Type type, String c, boolean first, boolean second) {
    this.first = first;
    this.second = second;
    this.type = type;
    this.x = x;
    this.y = y;
    this.c = c;
  }

  void show() {
    if (c == "W") {
      stroke(0);
      fill(255);
    } else {
      stroke(255);
      fill(0);
    }

    circle((x-1)*res+res/2, (y-1)*res+res/2, r);


    if (c == "W")
      fill(0);
    else
      fill(255);

    textSize(t);
    text(String.valueOf(type), (x-1)*res+res/2, (y-1)*res+res/2 + t/2.5);
  }

  Piece get() {
    return new Piece(y, x, type, c, first, second);
  }
}
