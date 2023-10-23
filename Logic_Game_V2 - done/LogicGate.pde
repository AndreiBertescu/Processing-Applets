class LogicGate extends Piece {
  String[] lines;

  LogicGate(String type, float x, float y, Canvas canvas) {
    super(type, x, y);

    //load piece from file
    lines = loadStrings("types/" + type + ".txt");

    nrInputs = Integer.valueOf(lines[0].split(" ")[0]);
    nrOutputs = Integer.valueOf(lines[1].split(" ")[0]);

    inputSets = new int[lines[0].split(" ").length-1];
    for (int i=0; i<inputSets.length; i++)
      inputSets[i] = Integer.valueOf(lines[0].split(" ")[i+1]);

    outputSets = new int[lines[1].split(" ").length-1];
    for (int i=0; i<outputSets.length; i++)
      outputSets[i] = Integer.valueOf(lines[1].split(" ")[i+1]);

    c = color(Integer.valueOf(lines[lines.length-1].split(" ")[0]), Integer.valueOf(lines[lines.length-1].split(" ")[1]), Integer.valueOf(lines[lines.length-1].split(" ")[2]));

    lines = null;
    //end

    input = new boolean[nrInputs];
    output = new boolean[nrOutputs];

    textSize(20);
    h = max(max(nrInputs, nrOutputs) * r * 2, minh);
    w = max(minw, textWidth(TYPE)+80);

    //init big ports
    int nr = 0;
    if (inputSets != null)
      for (int i : inputSets) {
        if (i > 1) {
          float hght1 = h/(nrInputs+0.3) * (nr + 0.65);
          float hght2 = h/(nrInputs+0.3) * (nr + i-1 + 0.65);

          canvas.bigConnections.add(new BigConnection(r+3, hght1 + (hght2-hght1)/2.0, nr, nr + i-1, this, -1));
        }
        nr += i;
      }
    nr = 0;
    if (outputSets != null)
      for (int i : outputSets) {
        if (i > 1) {
          float hght1 = h/(nrOutputs+0.3) * (nr + 0.65);
          float hght2 = h/(nrOutputs+0.3) * (nr + i-1 + 0.65);

          canvas.bigConnections.add(new BigConnection(w - r-3, hght1 + (hght2-hght1)/2, nr, nr + i-1, this, 1));
        }
        nr += i;
      }
  }

  void update() {
    super.update();

    if (changed)
      checkTable();
    changed = false;
  }

  void checkTable() {
    lines = loadStrings("types/" + TYPE + ".txt");
    String s = "";
    for (int i=0; i<nrInputs; i++)
      s += input[i] ? "1":"0";

    String[] values = lines[2 + Integer.parseInt(s, 2)].split(" ");
    for (int j=0; j<nrOutputs; j++)
      output[j] = Integer.valueOf(values[j]) == 1 ? true:false;
  }
}
