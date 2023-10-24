import peasy.*;
PeasyCam cam;

PVector resolution;
PImage img, cimg;
PShape shape, lights;
PVector n;

float offs = 1;
float offx = 0;
float offy = 0;
float s = 2.5;

ArrayList<City> cities;
City scity = null;
PVector pos;

//settings
//press space to save image
float hcoef = 0.3; // height offset - default: 0.3
int res = 4; // image resolution - multiples of 2
float offc = 30; // color offset - only on colorr 1/2
int colorr = 3; // color mode - black&white: 1, height map: 2, color map: 3 (only on earth)
String geomPath = "Topo Custom 16x8.png"; // height map path - Topo Custom 16x8.png - lroc_color_poles_16kv2.png - 5672_mars_6k_topo.jpg
String colorPath = "colorMap.png"; // color map path

boolean geom = true; // height map
boolean citiess = true; // city points
boolean light = true; // lights
boolean normals = true; // self calculated normals

void setup() {
  size(1920, 1080, P3D);
  textSize(20);
  colorMode(HSB);

  cam = new PeasyCam(this, 2000);
  perspective(PI/4.0, float(width)/float(height), 1, 100000);

  if (geom) {
    img = loadImage(dataPath(geomPath));
    img.loadPixels();
    resolution = new PVector(img.width, img.height);
    cimg = loadImage(dataPath(colorPath));
    cimg.loadPixels();
    make();
  }

  if (citiess) {
    cities = new ArrayList<City>();
    loadCities();
  }
}


void draw() {
  background(offc);
  translate(-resolution.x/2+offx, -resolution.y/2+offy, 0);

  if (light)
    lights();

  if (geom)
    shape(shape);

  if (citiess) {
    for (City c : cities) {
      if (c.pop < 100000)
        stroke(map(c.pop, 5000, 50000, 25, 45), 255, 255);
      else
        stroke(45, 255, 255);
      if (c.pop < 10000000)
        strokeWeight(map(c.pop, 5000, 10000000, 1, 6));
      else
        strokeWeight(7);
      point(c.x, c.y, c.z);
    }

    //HUD
    if (scity != null) {
      PVector ppos = new PVector(screenX(scity.x, scity.y, scity.z), screenY(scity.x, scity.y, scity.z));
      cam.beginHUD();
      float w = 200;
      float h = 83;
      float of = 50;

      w = max(w, (int)textWidth("Population: "+nfc(scity.pop))+15, (int)textWidth("Country: "+scity.country)+15);

      stroke(255);
      strokeWeight(1);
      if (ppos.x < pos.x+of+w/2)
        if (ppos.y < pos.y+of-h/2)
          line(pos.x+of, pos.y+of-h, ppos.x, ppos.y);
        else
          line(pos.x+of, pos.y+of, ppos.x, ppos.y);
      else
        if (ppos.y < pos.y+of-h/2)
          line(pos.x+of+w, pos.y+of-h, ppos.x, ppos.y);
        else
          line(pos.x+of+w, pos.y+of, ppos.x, ppos.y);
      strokeWeight(2);
      fill(0);
      rect(pos.x+of, pos.y+of, w, -h);

      fill(255);
      text("City: "+scity.city, pos.x+of + 5, pos.y+of-h + 25);
      text("Country: "+scity.country, pos.x+of + 5, pos.y+of-h + 48);
      text("Population: "+nfc(scity.pop), pos.x+of + 5, pos.y+of-h + 71);
      cam.endHUD();
    }
  }

  //offset controls
  if (keyPressed) {
    if (key == 'w')
      offy += 50/offs;
    if (key == 's')
      offy -= 50/offs;
    if (key == 'a')
      offx += 50/offs;
    if (key == 'd')
      offx -= 50/offs;
  }
}

void keyReleased() {
  if (key == ' ')
    saveFrame("data/HeightMap.jpg");
}

//HUD
void mousePressed() {
  if (citiess) {
    scity = null;

    for (City c : cities)
      if (dist(mouseX, mouseY, screenX(c.x, c.y, c.z), screenY(c.x, c.y, c.z)) <= s*offs) {
        scity = c;
        pos = new PVector(screenX(c.x, c.y, c.z), screenY(c.x, c.y, c.z));
        return;
      }
  }
}

//scroll controls
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e > 0)
    offs *= 0.9;
  else
    offs *= 1.1;
}

float br(int x, int y) {
  return brightness(img.pixels[int(y*resolution.x*res) + x*res]);
}


color cbr(int x, int y) {
  int xx = floor(map(x, 0, resolution.x/res, 0, cimg.width));
  int yy = floor(map(y, 0, resolution.y/res, 0, cimg.height));

  return color(red(cimg.pixels[yy * cimg.width + xx]),
    green(cimg.pixels[yy * cimg.width + xx]),
    blue(cimg.pixels[yy * cimg.width + xx]));
}

void make() {
  shape = createShape();
  shape.beginShape(QUAD_STRIP);
  shape.noStroke();
  for (int y=0; y<resolution.y/res-2; y+=2) {
    boolean bec = false;
    shape.noFill();
    shape.vertex(0, y*res, 0);
    shape.vertex(0, (y+1)*res, 0);
    for (int x=1; x<resolution.x/res; x++) {
      if (!bec && br(x, y)==0 && br(x, y+1)==0 && br(x+1, y)==0 && br(x+1, y+1)==0) {
        shape.noFill();
        shape.vertex(x*res, y*res, 0);
        shape.vertex(x*res, (y+1)*res, 0);

        bec = true;
        continue;
      }
      if (bec)
        if (br(x+1, y)==0 && br(x+1, y+1)==0 && br(x, y)==0 && br(x, y+1)==0) continue;
        else {
          shape.noFill();
          shape.vertex((x-1)*res, y*res, 0);
          shape.vertex((x-1)*res, (y+1)*res, 0);

          bec = false;
        }

      if (normals) {
        n = calcNormal(x, y, br(x, y)*hcoef, x, y+1, br(x, y+1)*hcoef, x+1, y, br(x+1, y)*hcoef);
        shape.normal(n.x, n.y, n.z);
      }
      if (colorr == 1)
        shape.fill(br(x, y)+offc);
      else if (colorr == 2)
        shape.fill(br(x, y)+offc, 255, 255);
      else if (colorr == 3) {
        colorMode(RGB);
        shape.fill(cbr(x, y));
        colorMode(HSB);
      }
      shape.vertex(x*res, y*res, br(x, y) * hcoef);
      if (colorr == 1)
        shape.fill(br(x, y+1)+offc);
      else if (colorr == 2)
        shape.fill(br(x, y+1)+offc, 255, 255);
      else if (colorr == 3) {
        colorMode(RGB);
        shape.fill(cbr(x, y+1));
        colorMode(HSB);
      }
      shape.vertex(x*res, (y+1)*res, br(x, y+1) * hcoef);
    }
    shape.noFill();
    shape.vertex(resolution.x, y*res, 0);
    shape.vertex(resolution.x, (y+1)*res, 0);

    bec = false;
    shape.vertex(resolution.x, (y+1)*res, 0);
    shape.vertex(resolution.x, (y+2)*res, 0);
    for (int x=(int)resolution.x/res-1; x>0; x--) {
      if (!bec && br(x, y+1)==0 && br(x, y+2)==0 && br(x-1, y+1)==0 && br(x-1, y+2)==0) {
        shape.noFill();
        shape.vertex(x*res, (y+1)*res, 0);
        shape.vertex(x*res, (y+2)*res, 0);

        bec = true;
        continue;
      }
      if (bec)
        if (br(x+1, y+1)==0 && br(x+1, y+2)==0 && br(x, y+1)==0 && br(x, y+2)==0) continue;
        else {
          shape.noFill();
          shape.vertex((x+1)*res, (y+1)*res, 0);
          shape.vertex((x+1)*res, (y+2)*res, 0);

          bec = false;
        }

      if (normals) {
        n = calcNormal(x, y+1, br(x, y+1)*hcoef, x, y+2, br(x, y+2)*hcoef, x-1, y+1, br(x-1, y+1)*hcoef);
        shape.normal(n.x, n.y, n.z);
      }
      if (colorr == 1)
        shape.fill(br(x, y+1)+offc);
      else if (colorr == 2)
        shape.fill(br(x, y+1)+offc, 255, 255);
      else if (colorr == 3) {
        colorMode(RGB);
        shape.fill(cbr(x, y+1));
        colorMode(HSB);
      }
      shape.vertex(x*res, (y+1)*res, br(x, y+1) * hcoef);
      if (colorr == 1)
        shape.fill(br(x, y+2)+offc);
      else if (colorr == 2)
        shape.fill(br(x, y+2)+offc, 255, 255);
      else if (colorr == 3) {
        colorMode(RGB);
        shape.fill(cbr(x, y+2));
        colorMode(HSB);
      }
      shape.vertex(x*res, (y+2)*res, br(x, y+2) * hcoef);
    }
    shape.noFill();
    shape.vertex(0, (y+1)*res, 0);
    shape.vertex(0, (y+2)*res, 0);
  }
  shape.fill(offc);
  shape.endShape();
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
    int y = (int)map(entry.getFloat("lat"), 90, -90.1, 0, resolution.y+0.1);
    int x = (int)map(entry.getFloat("lng"), -180, 180.1, 0, resolution.x+0.1);
    String city = entry.getString("city");
    String country = entry.getString("country");

    if (pop > 0)
      cities.add(new City(x, y, city, country, pop));
  }
}

PVector calcNormal(float x1, float y1, float z1, float x2, float y2, float z2, float x3, float y3, float z3) {
  PVector a = new PVector(x1, y1, z1);
  PVector b = new PVector(x2, y2, z2);
  PVector c = new PVector(x3, y3, z3);

  PVector n = b.sub(a);
  n = n.cross(c.sub(a));

  return n;
}
