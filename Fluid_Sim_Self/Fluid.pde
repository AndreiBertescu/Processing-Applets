class Fluid {
  float[] prevDens = new float[N * N];
  float[] dens = new float[N * N];
  PVector[] vel = new PVector[N * N];
  PVector[] prevVel = new PVector[N * N];

  int n = 40000;
  PVector[] p = new PVector[n];

  Fluid() {
    for (int i=0; i<N*N; i++) {
      vel[i] = new PVector();
      prevVel[i] = new PVector();
    }

    for (int i=0; i<n; i++)
      p[i] = new PVector(floor(random(N)), floor(random(N/2)));
  }

  void addDensity(int x, int y, float amount) {
    dens[IX(x, y)] += amount;

    dens[IX(x+1, y)] += amount;
    dens[IX(x-1, y)] += amount;
    dens[IX(x, y+1)] += amount;
    dens[IX(x, y-1)] += amount;
  }

  void addVelocity(int x, int y, PVector v) {
    vel[IX(x, y)].add(v);

    vel[IX(x+1, y)].add(v);
    vel[IX(x-1, y)].add(v);
    vel[IX(x, y+1)].add(v);
    vel[IX(x, y-1)].add(v);
  }

  void update() {
    //vel
    diffuseVel(prevVel, vel);
    project(prevVel, vel);
    advectVel(vel, prevVel);
    project(vel, prevVel);

    //density
    diffuseDensity(prevDens, dens);
    advectDensity(dens, prevDens, vel);
    fade(dens);
  }

  void showVec() {
    for (int i=0; i<n; i++) {
      float x = constrain(vel[IX((int)p[i].x, (int)p[i].y)].mag(), 0, 0.1);
      float y = map(x, 0, 0.1, 5, 10);

      if(blackAndWhite)
        stroke(150-map(vel[IX((int)p[i].x, (int)p[i].y)].mag(), 0, 0.1, 0, 150), 255, 255);
      else
        stroke(map(dens[IX((int)p[i].x, (int)p[i].y)], 0, 100, 100, 255));
      strokeWeight(map(y, 10, 20, 0.7, 1.5));

      pushMatrix();
      translate(p[i].x*len, p[i].y*len);
      rotate(vel[IX((int)p[i].x, (int)p[i].y)].heading());

      line(0, 0, y, y);
      popMatrix();
    }
  }

  void show() {
    noStroke();
    for (int y = 0; y<=N/2; y++)
      for (int x = 0; x<N; x++) {
        fill(255-map(vel[IX(x, y)].mag(), 0, 0.1, 0, 255), 255, map(dens[IX(x, y)], 0, 100, 10, 255));
        square(x*len, y*len, len);
      }
  }
}

void fade(float[] dens) {
  for (int y = 0; y<N; y++)
    for (int x = 0; x<N; x++) {
      dens[IX(x, y)] = constrain(dens[IX(x, y)]-fade, 0, 500);
    }
}

void diffuseDensity (float[] dens, float[] prevDens) {
  float a = dt * diff * N * N;

  for (int k = 0; k < iter; k++) {
    for (int j = 1; j < N-1; j++)
      for (int i = 1; i < N-1; i++)
        dens[IX(i, j)] = (prevDens[IX(i, j)] + a*(dens[IX(i+1, j)] + dens[IX(i-1, j)] + dens[IX(i, j+1)] + dens[IX(i, j-1)])) / (1 + varr*a);

    set_bndDens(dens);
  }
}

void advectDensity(float[] dens, float[] prevDens, PVector[] vel) {
  int i, j, i0, j0;
  float x, y, s1, t1;

  float dt0 = dt * (N-1);

  for ( i=1; i < N-1; i++ ) {
    for ( j=1; j < N-1; j++ ) {

      x = i-dt0 * vel[IX(i, j)].x;
      y = j-dt0 * vel[IX(i, j)].y;

      x = constrain(x, 0.5, N+0.5);
      y = constrain(y, 0.5, N+0.5);

      i0=(int)x;
      j0=(int)y;

      s1 = x-(int)x;
      t1 = y-(int)y;

      dens[IX(i, j)] =
        (1-s1) * ((1-t1)*prevDens[IX(i0, j0)] + t1*prevDens[IX(i0, j0+1)])+
        s1 * ((1-t1)*prevDens[IX(i0+1, j0)] + t1 *prevDens[IX(i0+1, j0+1)]);
    }
  }

  set_bndDens(dens);
}

void set_bndDens(float[] dens) {
  for (int i = 1; i < N-1; i++) {
    dens[IX(i, 0)] = dens[IX(i, 1)];
    dens[IX(i, N-1)] = dens[IX(i, N-2)];
    dens[IX(0, i)] = dens[IX(1, i)];
    dens[IX(N-1, i)] = dens[IX(N-2, i)];
  }

  dens[IX(0, 0)]       = (dens[IX(1, 0)]  + dens[IX(0, 1)]) / 2;
  dens[IX(0, N-1)]     = (dens[IX(1, N-1)] + dens[IX(0, N-2)]) / 2;
  dens[IX(N-1, 0)]     = (dens[IX(N-2, 0)] + dens[IX(N-1, 1)]) / 2;
  dens[IX(N-1, N-1)]   = (dens[IX(N-2, N-1)] + dens[IX(N-1, N-2)]) / 2;
}

void diffuseVel (PVector[] vel, PVector[] prevVel) {
  float a = dt * diff * N * N;

  for (int k = 0; k < iter; k++) {
    for (int j = 1; j < N-1; j++)
      for (int i = 1; i < N-1; i++) {
        vel[IX(i, j)].x = (prevVel[IX(i, j)].x + a*(vel[IX(i+1, j)].x + vel[IX(i-1, j)].x + vel[IX(i, j+1)].x + vel[IX(i, j-1)].x)) / (1 + varr*a);
        vel[IX(i, j)].y = (prevVel[IX(i, j)].y + a*(vel[IX(i+1, j)].y + vel[IX(i-1, j)].y + vel[IX(i, j+1)].y + vel[IX(i, j-1)].y)) / (1 + varr*a);
      }

    set_bnd(vel);
  }
}

void advectVel(PVector[] vel, PVector prevVel[]) {
  int i, j, i0, j0;
  float x, y, s1, t1;

  float dt0 = dt * (N-1);

  for ( i=1; i < N-1; i++ ) {
    for ( j=1; j < N-1; j++ ) {

      x = i-dt0 * prevVel[IX(i, j)].x;
      y = j-dt0 * prevVel[IX(i, j)].y;

      x = constrain(x, 0.5, N+0.5);
      y = constrain(y, 0.5, N+0.5);

      i0=(int)x;
      j0=(int)y;

      s1 = x-(int)x;
      t1 = y-(int)y;

      vel[IX(i, j)].x =
        (1-s1) * ((1-t1)*prevVel[IX(i0, j0)].x + t1*prevVel[IX(i0, j0+1)].x)+
        s1 * ((1-t1)*prevVel[IX(i0+1, j0)].x + t1 *prevVel[IX(i0+1, j0+1)].x);

      vel[IX(i, j)].y =
        (1-s1) * ((1-t1)*prevVel[IX(i0, j0)].y + t1*prevVel[IX(i0, j0+1)].y)+
        s1 * ((1-t1)*prevVel[IX(i0+1, j0)].y + t1 *prevVel[IX(i0+1, j0+1)].y);
    }
  }

  set_bnd(vel);
}

void project(PVector[] vel, PVector[] prevVel) {
  for (int j = 1; j < N-1; j++) {
    for (int i = 1; i < N-1; i++) {
      prevVel[IX(i, j)].y = -0.5 * (vel[IX(i+1, j)].x - vel[IX(i-1, j)].x + vel[IX(i, j+1)].y - vel[IX(i, j-1)].y) / N;
      prevVel[IX(i, j)].x = 0;
    }
  }
  set_bnd(prevVel);

  for (int k = 0; k < iter; k++) {
    for (int j = 1; j < N-1; j++)
      for (int i = 1; i < N-1; i++) {
        prevVel[IX(i, j)].x = (prevVel[IX(i, j)].y + (prevVel[IX(i+1, j)].x + prevVel[IX(i-1, j)].x + prevVel[IX(i, j+1)].x + prevVel[IX(i, j-1)].x)) / varr;
      }
    set_bnd(prevVel);
  }

  for (int j = 1; j < N-1; j++) {
    for (int i = 1; i < N-1; i++) {
      vel[IX(i, j)].x -= 0.5 * (prevVel[IX(i+1, j)].x - prevVel[IX(i-1, j)].x) * N;
      vel[IX(i, j)].y -= 0.5 * (prevVel[IX(i, j+1)].x - prevVel[IX(i, j-1)].x) * N;
    }
  }
  set_bnd(vel);
}

void set_bnd(PVector[] v) {

  for (int i = 1; i < N-1; i++) {
    v[IX(i, 0)].x = -v[IX(i, 1)].x;
    v[IX(i, 0)].y = -v[IX(i, 1)].y;

    v[IX(i, N-1)].x = -v[IX(i, N-2)].x;
    v[IX(i, N-1)].y = -v[IX(i, N-2)].y;

    v[IX(0, i)].x = -v[IX(1, i)].x;
    v[IX(0, i)].y = -v[IX(1, i)].y;

    v[IX(N-1, i)].x = -v[IX(N-2, i)].x;
    v[IX(N-1, i)].y = -v[IX(N-2, i)].y;
  }

  v[IX(0, 0)].x = (v[IX(1, 0)].x + v[IX(0, 1)].x) / 2;
  v[IX(0, 0)].y = (v[IX(1, 0)].y + v[IX(0, 1)].y) / 2;

  v[IX(0, N-1)].x = (v[IX(1, N-1)].x + v[IX(0, N-2)].x) / 2;
  v[IX(0, N-1)].y = (v[IX(1, N-1)].y + v[IX(0, N-2)].y) / 2;

  v[IX(N-1, 0)].x = (v[IX(N-2, 0)].x + v[IX(N-1, 1)].x) / 2;
  v[IX(N-1, 0)].y = (v[IX(N-2, 0)].y + v[IX(N-1, 1)].y) / 2;

  v[IX(N-1, N-1)].x = (v[IX(N-2, N-1)].x + v[IX(N-1, N-2)].x) / 2;
  v[IX(N-1, N-1)].y = (v[IX(N-2, N-1)].y + v[IX(N-1, N-2)].y) / 2;
}

int IX(int x, int y) {
  x = constrain(x, 0, N-1);
  y = constrain(y, 0, N-1);
  return x + y*N;
}
