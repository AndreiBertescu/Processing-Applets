import peasy.*;
PeasyCam cam;

PShape shape, sph;
PVector resolution;
PImage img, cimg;
PShader pointShader;
PVector[] stars;
ArrayList<City> cities;

float offs = 1;
float offx = 0;
float offy = 0;

//settings
//press space to save image
float offh = 0.04; // height offset - default: 0.04
int res = 2; // image resolution - multiples of 2 - more = less detail
int s = 1000; // star count
float offc = 30; // color offset - only on colorr 1 or 2
int colorr = 1; // color mode - black&white: 1, height map: 2, color map: 3 (only on earth)
String geomPath = "Topo Custom 16x8.png"; // height map path - Topo Custom 16x8.png - lroc_color_poles_16kv2.png - 5672_mars_6k_topo.png
String colorPath = "colorMap.png"; // color map path

boolean geom = true; // height map
boolean ocean = true; // unit sphere
boolean citiess = false; // city points
boolean light = true; // lights
boolean normals = true; // calculated normals
boolean star = false; // stars

void setup() {
  size(1920, 1080, P3D);
  colorMode(HSB);
  sphereDetail(180);

  cam = new PeasyCam(this, 3);
  perspective(PI/4.0, float(width)/float(height), 0.1, 100000);

  if (geom) {
    //load height map
    img = loadImage(dataPath(geomPath));
    img.loadPixels();
    resolution = new PVector(img.width, img.height);
    //load color map
    cimg = loadImage(dataPath(colorPath));
    cimg.loadPixels();

    generateSphere();
  }

  //cities
  if (citiess) {
    cities = new ArrayList<City>();
    loadCities();
  }

  //stars
  if (star) {
    stars = new PVector[s];

    double d = cam.getDistance()*30;
    pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");
    pointShader.set("maxDepth", (float) d);
    shader(pointShader, POINTS);

    for (int i=0; i<s; i++) {
      stars[i] = new PVector(random(-10, 10), random(-10, 10), random(-10, 10));
      while ((stars[i].x>=-1 && stars[i].x<=1) || (stars[i].y>=-1 && stars[i].y<=1) || (stars[i].z>=-1 && stars[i].z<=1))
        stars[i] = new PVector(random(-10, 10), random(-10, 10), random(-10, 10));
    }
  }

  //ocean
  if (ocean) {
    sph = createShape(SPHERE, 1.0005);
    sph.setFill(color(map(200, 0, 360, 0, 255), 255, 50));
    sph.setStroke(false);
  }
}

void draw() {
  background(0);
  translate(offx, 0, offy);

  //lights
  if (light) {
    lights();
    ambientLight(0, 0, 20);
  }

  //stars
  if (star) {
    stroke(255);
    strokeWeight(0.01);
    for (int i=0; i<s; i++)
      point(stars[i].x, stars[i].y, stars[i].z);
  }

  //ocean
  if (ocean) {
    pushMatrix();
    rotateX(PI/2);
    shape(sph);
    popMatrix();
  }

  //geography
  if (geom)
    shape(shape);

  //cities
  if (citiess)
    for (City c : cities) {
      if (c.pop < 100000)
        stroke(map(c.pop, 5000, 50000, 25, 45), 255, 255);
      else
        stroke(45, 255, 255);
      if (c.pop < 10000000)
        strokeWeight(map(c.pop, 5000, 10000000, 0.001, 0.005));
      else
        strokeWeight(0.005);
      point(c.pos.x, c.pos.y, c.pos.z);
    }

  //key controls
  if (keyPressed) {
    if (key == 'w')
      offy += 0.1/offs;
    if (key == 's')
      offy -= 0.1/offs;
    if (key == 'a')
      offx += 0.1/offs;
    if (key == 'd')
      offx -= 0.1/offs;
    if (key == 'r') {
      offx = 0;
      offy = 0;
    }
  }
}

void keyReleased() {
  if (key == ' ')
    saveFrame("data/HeightMapS.jpg");
}

//offs controll
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e > 0)
    offs *= 0.9;
  else
    offs *= 1.1;
}

void generateSphere() {
  PVector a, b, c, i = new PVector();

  shape = createShape();
  shape.beginShape(QUAD_STRIP);
  shape.noStroke();
  shape.fill(150);

  for (int y=0; y<resolution.y/res-1; y++) {
    boolean bec = false;

    for (int x=0; x<(resolution.x/res-1); x++) {
      if (!bec && br(x*res, y*res)==0 && br(x*res, (y+1)*res)==0 && br((x+1)*res, y*res)==0 && br((x+1)*res, (y+1)*res)==0) {
        a = spherical_to_cartesian(map(x, 0, resolution.x/res, 0, PI*2), map(y, 0, resolution.y/res-1, 0, PI));
        b = spherical_to_cartesian(map(x, 0, resolution.x/res, 0, PI*2), map(y+1, 0, resolution.y/res-1, 0, PI));
        shape.noFill();
        shape.vertex(a.x, a.y, a.z);
        shape.vertex(b.x, b.y, b.z);

        bec = true;
        continue;
      }
      if (bec)
        if (br(x*res, y*res)==0 && br(x*res, (y+1)*res)==0 && br((x+1)*res, y*res)==0 && br((x+1)*res, (y+1)*res)==0) continue;
        else {
          a = spherical_to_cartesian(map(x-1, 0, resolution.x/res, 0, PI*2), map(y, 0, resolution.y/res-1, 0, PI));
          b = spherical_to_cartesian(map(x-1, 0, resolution.x/res, 0, PI*2), map(y+1, 0, resolution.y/res-1, 0, PI));
          shape.noFill();
          shape.vertex(a.x, a.y, a.z);
          shape.vertex(b.x, b.y, b.z);

          bec = false;
        }

      a = spherical_to_cartesian(map(x, 0, resolution.x/res, 0, PI*2), map(y, 0, resolution.y/res-1, 0, PI));
      b = spherical_to_cartesian(map(x, 0, resolution.x/res, 0, PI*2), map(y+1, 0, resolution.y/res-1, 0, PI));

      if (normals) {
        c = spherical_to_cartesian(map(x+1, 0, resolution.x/res, 0, PI*2), map(y, 0, resolution.y/res-1, 0, PI));
        i = calcNormal(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z);
        normal(i.x, i.y, i.z);
      }

      if (colorr == 1)
        shape.fill(br(x*res, y*res) + offc); // black & white
      else if (colorr == 2)
        shape.fill(br(x*res, y*res), 255, 255); // height map
      else if (colorr == 3) {
        colorMode(RGB);
        shape.fill(cbr(x*res, y*res)); // color map
        colorMode(HSB);
      }
      shape.vertex(a.x, a.y, a.z);

      if (colorr == 1)
        shape.fill(br(x*res, (y+1)*res) + offc); // black & white
      else if (colorr == 2)
        shape.fill(br(x*res, (y+1)*res), 255, 255); // height map
      else if (colorr == 3) {
        colorMode(RGB);
        shape.fill(cbr(x*res, (y+1)*res)); // color map
        colorMode(HSB);
      }
      shape.vertex(b.x, b.y, b.z);
    }
  }
  shape.endShape();

  println(shape.getVertexCount());
}

PVector spherical_to_cartesian(float theta, float phi) {
  float r = br(floor(map(theta, 0, 2*PI, 0, resolution.x-1)), floor(map(phi, 0, PI, 0, resolution.y-1)));
  r = map(r, 0, 255, 1, 1 + 1*offh);

  float x = r * sin(phi) * cos(theta);
  float y = r * sin(phi) * sin(theta);
  float z = r * cos(phi);

  return new PVector(x, y, z);
}

PVector calcNormal(float x1, float y1, float z1, float x2, float y2, float z2, float x3, float y3, float z3) {
  PVector a = new PVector(x1, y1, z1);
  PVector b = new PVector(x2, y2, z2);
  PVector c = new PVector(x3, y3, z3);

  PVector n = b.sub(a);
  n = n.cross(c.sub(a));

  return n;
}

float br(int x, int y) {
  x = (int)resolution.x - x - 1;
  return brightness(img.pixels[int(y*resolution.x) + x]);
}

color cbr(int x, int y) {
  x = (int)resolution.x - x - 1;
  int xx = floor(map(x, 0, resolution.x, 0, cimg.width));
  int yy = floor(map(y, 0, resolution.y, 0, cimg.height));

  return color(red(cimg.pixels[yy * cimg.width + xx]),
    green(cimg.pixels[yy * cimg.width + xx]),
    blue(cimg.pixels[yy * cimg.width + xx]));
}

void loadCities() {
  JSONArray values = loadJSONArray(dataPath("data.json"));
  for (int i = 0; i < values.size(); i++) {
    JSONObject entry = values.getJSONObject(i);

    int pop = 0;
    try {
      pop = entry.getInt("population");
    }
    catch(Exception e) {
    }

    PVector pos = spherical_to_cartesian(radians(-1*entry.getFloat("lng")+180), radians(-1*entry.getFloat("lat")+90), 0.006);
    String city = entry.getString("city");
    String country = entry.getString("country");

    if (pop > 0)
      cities.add(new City(pos, city, country, pop));
  }
}

PVector spherical_to_cartesian(float theta, float phi, float rr) {
  float r = br(floor(map(theta, 0, 2*PI, 0, resolution.x-1)), floor(map(phi, 0, PI, 0, resolution.y-1)));
  r = map(r, 0, 255, 1, 1 + 1*offh);
  r += rr;

  float x = r * sin(phi) * cos(theta);
  float y = r * sin(phi) * sin(theta);
  float z = r * cos(phi);

  return new PVector(x, y, z);
}
