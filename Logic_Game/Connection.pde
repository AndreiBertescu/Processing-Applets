class Connection {
  int id1, id2;
  Piece p1, p2;
  ArrayList<PVector> con;

  Connection(Piece p1, int id1, Piece p2, int id2, ArrayList<PVector> con) {
    this.p1 = p1;
    this.id1 = id1;
    this.p2 = p2;
    this.id2 = id2;
    this.con = con;

    if (p2 == null)
      con.get(con.size()-1).x = 25+CX;
  }

  void update() {
    if (p1 != null) {
      con.get(0).x = 25 + p1.x + p1.w;
      con.get(0).y = 25 + p1.y + p1.h/p1.OUT * (id1 + 0.5);
    } else
      con.get(0).y = 25 + CY/(canvas.IN+1) * (id1+1);
    if (p2 != null) {
      con.get(con.size()-1).x = 25 + p2.x;
      con.get(con.size()-1).y = 25 + p2.y + p2.h/p2.IN * (id2 + 0.5);
    } else
      con.get(con.size()-1).y = 25 + CY/(canvas.OUT+1) * (id2+1);

    if (p1 == null && p2 == null)
      canvas.output[id2] = canvas.input[id1];
    else if (p1 != null && p2 == null)
      canvas.output[id2] = p1.output[id1];
    else if (p1 == null && p2 != null)
      p2.input[id2] = canvas.input[id1];
    else if (p1 != null && p2 != null)
      p2.input[id2] = p1.output[id1];
  }
}
