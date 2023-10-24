import peasy.*;
PeasyCam cam;

HashMap<String, Integer> ff = new HashMap<>();
Cube cube;
int stage = 0;

//settings
//press space to solve a stage
//press ` to generate a new cube
//press 1 to fully solve the cube
//press wasc to change cube faces
//to make other moves consult movement conventions of rubik cubes
int w = 8; //width of each cubelet

void setup() {
  size(800, 800, P3D);
  cam = new PeasyCam(this, 100);
  perspective(PI/4.0, float(width)/float(height), 0.1, 100000);

  ff.put("top", 0);
  ff.put("front", 1);
  ff.put("bottom", 2);
  ff.put("back", 3);
  ff.put("right", 4);
  ff.put("left", 5);

  cube = new Cube();
}

void draw() {
  background(50);
  cube.show();

  //cube.generate(0);
  //solvef(cube, 1);
}

void solve(Cube cc) {
  switch(stage) {
    case(1):
    yellowCross(cc);
    break;
    case(2):
    firstLayer(cc);
    break;
    case(3):
    secondLayer(cc);
    break;
    case(4):
    whiteCross(cc);
    break;
    case(5):
    whiteCorners(cc);
    break;
  }
}

void solvef(Cube cc, int x) {
  yellowCross(cc);
  firstLayer(cc);
  secondLayer(cc);
  whiteCross(cc);
  whiteCorners(cc);

  if (x == 1)
    println(cube.moves.size());
  else if (x == 2) {
    ArrayList<String> aux = new ArrayList<>();
    int i = -1;
    while (i++ < cube.moves.size()-2) {
      if ((cube.moves.get(i)+"_").compareTo(cube.moves.get(i+1)) == 0 || cube.moves.get(i).compareTo(cube.moves.get(i+1)+"_") == 0) {
        i++;
        continue;
      }

      aux.add(cube.moves.get(i));
    }
    aux.add(cube.moves.get(cube.moves.size()-1));

    printArray(cube.moves);
    print(cube.moves.size());
    println();
    printArray(aux);
    print(aux.size());
  }
}

char[] toArray(ArrayList<Character> n) {
  char[] aux = new char[n.size()];
  for (int i=0; i<n.size(); i++)
    aux[i] = n.get(i);
  return aux;
}

boolean equals(char[] a, char[] b) {
  for (int i=0; i<a.length; i++)
    if (a[i] != b[i])
      return false;
  return true;
}

void keyPressed() {
  switch(key) {
    case('w'):
    cube.changeFace("bottom");
    break;
    case('a'):
    cube.changeFace("right");
    break;
    case('s'):
    cube.changeFace("top");
    break;
    case('c'):
    cube.changeFace("left");
    break;
    case('f'):
    cube.F();
    break;
    case('F'):
    cube.F_();
    break;
    case('r'):
    cube.R();
    break;
    case('R'):
    cube.R_();
    break;
    case('l'):
    cube.L();
    break;
    case('L'):
    cube.L_();
    break;
    case('u'):
    cube.U();
    break;
    case('U'):
    cube.U_();
    break;
    case('d'):
    cube.D();
    break;
    case('D'):
    cube.D_();
    break;
    case('b'):
    cube.B();
    break;
    case('B'):
    cube.B_();
    break;
    case(' '):
    stage++;
    solve(cube);
    printArray(cube.moves);
    break;
    case('`'):
    cube.generate(1);
    stage = 0;
    break;
    case('1'):
    solvef(cube, 2);
    break;
  }
}
