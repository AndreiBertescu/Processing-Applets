int i, x, m;

//SETTINGS
int len = 10; //length of each line
int n = 15000;  //no. of lines
float ang = radians(14.5); //angle of rotation

void setup() {
  size(1920, 1080);
  colorMode(HSB);
  background(20);
  stroke(0, 0, 255, 20);
  strokeWeight(2);


  translate(width/2-200, height/2-100);

  for (int i=1; i<=n; i++) {
    IntList seq = new IntList();

    seq.append(i);
    x=i;
    while (x!=1) {
      if (x%2==0)
        x = x/2;
      else
        x = (3*x+1)/2;
      seq.append(x);
    }
    seq.append(1);
    seq.reverse();

    stroke(map(seq.size(), 1, 166, 0, 255), 255, 255, 150);

    pushMatrix();
    for (int j=0; j<seq.size(); j++) {
      x = seq.get(j);

      if (x%2==0)
        rotate(ang);
      else
        rotate(-ang/1.01);

      line(0, 0, len, 0);
      translate(len + 1, 0);
    }
    popMatrix();
  }

  println("Done!");
}

int lll(int n) {
  int maxi=0, nr;
  for (int i=1; i<=n; i++) {
    nr=1;

    x=i;
    while (x!=1) {
      if (x%2==0)
        x /= 2;
      else
        x = (3*x+1)/2;
      nr++;
    }

    if (nr>maxi)
      maxi=nr;
  }

  print(maxi);
  return maxi;
}

void exit() {
  save("data/Collatz.png");
  super.exit();
}
