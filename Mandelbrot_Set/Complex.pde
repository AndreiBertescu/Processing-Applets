class Complex{
  float re, im;
  
  Complex() {
    this.re = 0;
    this.im = 0;
  }

  Complex(float re, float im) {
    this.re = re;
    this.im = im;
  }
  
  public float len(){
    return re * re + im * im;
  }
  
  public void square() {
    float aux = re;
    re = re*re - im*im;
    im = 2 * aux*im;
  }
  
  public void add(Complex c){
    re += c.re;
    im += c.im;
  }
}
