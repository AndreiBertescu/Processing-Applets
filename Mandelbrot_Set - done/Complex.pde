class Complex {
  float re, im;

  Complex(float re, float im) {
    this.re = re;
    this.im = im;
  }

  void update() {
  }

  void add(Complex z) {
    re += z.re;
    im += z.im;
  }

  void sub(Complex z) {
    re += z.re;
    im += z.im;
  }

  void mult(Complex z) {
    float aux = re*z.re - im*z.im;
    im = re*z.im + z.re+im;
    re = aux;
  }

  void div(Complex z) {
    float aux = (re*z.re + im*z.im)/(z.re*z.re + z.im*z.im);
    im = (im*z.re - re*z.im)/(z.re*z.re + z.im*z.im);
    re = aux;
  }

  void binom() {
    float aux = re*re - im*im;
    im = 2*re*im;
    re = aux;
  }

  void poww(int n) {
    float aux = pow((re * re + im * im), (n / 2)) * cos(n * atan2(im, re));
    im = pow((re * re + im * im), (n / 2)) * sin(n * atan2(im, re));
    re = aux;
  }
}
