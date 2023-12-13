float dt = 0.1;
color c;

//SETTINGS
//press w/s to increase/decrease res
//press z/x to decrease/increase time
//press a/d to decrease/increase maxStroke
float maxStroke = 0.012946145;
float res = 0.012674865;
float t = 1;
float falloff = 0.03;

void setup() {
  fullScreen();
  size(800, 800);
  colorMode(HSB);

  stroke(0);
  strokeWeight(3);

  noiseSeed((long)random(10000));
  noiseDetail(5, 0.25);
}

void draw() {
  background(0);

  for (int x=0; x<width; x++)
    for (int y=0; y<height; y++) {
      float noise = noise(x * res, y * res, t);

      for (float step=falloff; step<=1; step += falloff)
        if ((noise - step) < maxStroke && (noise - step) > 0) {
          set(x, y, color(255 - 255 * step, 200, 255));
          break;
        }
    }
}

void keyReleased() {
  switch(key) {
  case 'w':
    maxStroke *= 1.1;
    break;
  case 's':
    maxStroke *= 0.9;
    break;
  case 'x':
    res *= 1.1;
    break;
  case 'z':
    res *= 0.9;
    break;
  case 'a':
    t += dt;
    break;
  case 'd':
    t -= dt;
    break;
  }
}

void exit() {
  println(maxStroke, res);

  save("data/Perlin.png");
  super.exit();
}
