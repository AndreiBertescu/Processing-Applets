class City {
  int x, y;
  float z;
  String city, country;
  int pop;

  City(int x, int y, String city, String country, int pop) {
    this.x = x;
    this.y = y;
    this.city = city;
    this.country = country;
    this.pop = pop;
    z = brightness(img.pixels[floor(y*resolution.x + x)]) * hcoef + 0.5;
  }
}
