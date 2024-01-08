import java.io.File;
import java.io.FileReader;


public ArrayList<Element> getCsvContents(String csvPath) {
  ArrayList<Element> csvObjects = new ArrayList<>();
  String tokens[];

  try {
    String[] lines = loadStrings(dataPath(csvPath));

    for (int i=1; i<lines.length; i++) {
      tokens = lines[i].split(",");
      if (tokens.length < 5)
        continue;

      // read logic
      int A = Integer.parseInt(tokens[0].trim());
      int Z = Integer.parseInt(tokens[1].trim());
      String name = tokens[2].trim();
      String symbol = tokens[3].trim();
      String chemicalGroup = tokens[4].trim();

      HashSet<Integer> stableNucleides = new HashSet<>();
      for (int j=5; j<tokens.length; j++)
        stableNucleides.add(Integer.parseInt(tokens[j].trim()));

      csvObjects.add(new Element(A, Z, name, symbol, chemicalGroup, stableNucleides));
      // read logic
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  return csvObjects;
}
