static final int precision = 1000; // gradations per degree, adjust to suit

static final int modulus = 360*precision;
static final float[] sin = new float[modulus]; // lookup table
static {
  // a static initializer fills the table
  // in this implementation, units are in degrees
  for (int i = 0; i<sin.length; i++) {
    sin[i]=(float)Math.sin((i*Math.PI)/(precision*180));
  }
}
// Private function for table lookup
private static float sinLookup(int a) {
  return a>=0 ? sin[a%(modulus)] : -sin[-a%(modulus)];
}

// These are your working functions:
public static float sinn(float a) {
  return sinLookup((int)(degrees(a) * precision + 0.5f));
}
public static float coss(float a) {
  return sinLookup((int)((degrees(a)+90f) * precision + 0.5f));
}

float sqrtt(double d) {
  return (float)Double.longBitsToDouble( ( ( Double.doubleToLongBits( d )-(1l<<52) )>>1 ) + ( 1l<<61 ) );
}
