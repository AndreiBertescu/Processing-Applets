import java.util.HashSet;

class Element {
  int A, Z;
  String name, symbol, chemicalGroup;
  int ionization = 0;
  int currentZ = 0;
  HashSet<Integer> stableNucleides;

  Element() {
    this.A = 1;
    this.Z = 1;
    currentZ = 1;
    this.name = "Unknown";
    this.symbol = "N/A";
    this.chemicalGroup = "Unknown";
    stableNucleides = new HashSet<>();
  }

  Element(int A, int Z, String name, String symbol, String chemicalGroup, HashSet<Integer> stableNucleides) {
    this.A = A;
    this.Z = Z;
    currentZ = Z;
    this.name = name;
    this.symbol = symbol;
    this.chemicalGroup = chemicalGroup;
    this.stableNucleides = stableNucleides;
  }

  @Override
    String toString() {
    return "A=" + A +
      ", Z=" + Z +
      ", name=" + name +
      ", symbol=" + symbol +
      ", chemicalGroup=" + chemicalGroup + "\n";
  }
}

void getElement() {
  currentElement = null;

  for (Element el : elements)
    if (el.A == protons) {
      currentElement = el;
      break;
    }

  if (currentElement == null) {
    currentElement = new Element();
    currentElement.A = protons;
    currentElement.Z = -1;
  }

  currentElement.currentZ = neutrons + protons;
  currentElement.ionization = currentElement.A - electrons;
}
