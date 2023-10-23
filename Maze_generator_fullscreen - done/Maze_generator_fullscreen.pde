import java.util.Stack;

Cell[][] grid;
Cell current, prev;
Stack<Cell> stk = new Stack<>();
boolean done;
int m;
float w, h;

//settings
int n = 50; //size

void setup() {
  fullScreen();
  frameRate(10000);
  strokeWeight(1.5);

  m = floor(n*(16.0/9));

  grid = new Cell[n][m];
  for (int i=0; i<n; i++)
    for (int j=0; j<m; j++)
      grid[i][j] = new Cell(i, j);

  h = height / (n*1.0);
  w = width / (m*1.0);

  done = false;
  current = grid[0][0];
  prev = grid[0][0];
  grid[0][0].visited = true;
  stk.push(current);

  background(0);
}

void update() {
  if (findNeigh(current.i, current.j) == -1) {
    stk.pop();

    if (stk.empty()) {
      done = true;
      println("Done!");
      save("Maze.tiff");
      return;
    }

    current = stk.peek();
  }

  int x = findNeigh(current.i, current.j);
  if (x != -1) {
    prev = current;

    switch(x) {
    case 0:
      current.walls[0] = false;
      current = grid[current.i-1][current.j];
      current.walls[3] = false;
      break;
    case 1:
      current.walls[1] = false;
      current = grid[current.i][current.j-1];
      current.walls[2] = false;
      break;
    case 2:
      current.walls[2] = false;
      current = grid[current.i][current.j+1];
      current.walls[1] = false;
      break;
    case 3:
      current.walls[3] = false;
      current = grid[current.i+1][current.j];
      current.walls[0] = false;
      break;
    }

    current.visited = true;
    stk.push(current);
  }
}

void draw() {
  //println(frameRate);
  if (!done)
    update();

  prev.show();
  current.show();
}

int findNeigh(int i, int j) {
  ArrayList<Integer> neigh = new ArrayList<>();

  if (i>0 && !grid[i-1][j].visited)
    neigh.add(0);
  if (i<n-1 && !grid[i+1][j].visited)
    neigh.add(3);
  if (j>0 && !grid[i][j-1].visited)
    neigh.add(1);
  if (j<m-1 && !grid[i][j+1].visited)
    neigh.add(2);

  if (neigh.size() > 0)
    return neigh.get(floor(random(neigh.size())));

  return -1;
}
