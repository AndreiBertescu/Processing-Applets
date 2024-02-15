String[] file;
String fileContent, fileContentCopy;
PImage img;
int w, nr = 0, remainingChars = 0, prevRemainingChars;
float b;

//SETTINGS
String imgPath = "Image.png"; //black and white image to make code pattern
String textPath = "Code_Image.pde"; //text to be used
String fillerText = "/*Filler*/";
int h = 10; //font size

void setup() {
  fullScreen();

  img = loadImage(dataPath(imgPath));
  img.loadPixels();

  file = loadStrings(sketchPath(textPath));
  for (String str : file)
    str = str.trim();
  fileContent = String.join("", file);
  remainingChars = -100000;

  noStroke();
}

void draw() {
  if (remainingChars > 0) {
    h--;
    println("Unused characters: " + prevRemainingChars + "\nFont size: " + h);
    fileContentCopy = processText(fileContent, -prevRemainingChars);
    noLoop();
  } else {
    fileContentCopy = fileContent;
    h++;
  }

  nr = 0;
  textSize(h);
  w = (int)textWidth('H');
  prevRemainingChars = remainingChars;
  remainingChars = fileContent.length();
  background(0);

  for (int y=0; y<1080; y+=h)
    for (int x=0; x<1920; x+=w) {
      b = brightness(img.pixels[y*1920 + x]);

      if (b < 255/2)
        continue;

      fill(b);
      text((nr >= fileContentCopy.length()) ? ' ' : fileContentCopy.charAt(nr++), x, y);
      remainingChars--;
    }
}

void exit() {
  save("data/Code.png");
  super.exit();
}

String processText(String source, int charsToAdd) {
  if (charsToAdd < fillerText.length())
    return source;

  int nr = 0;
  charsToAdd -= 4;
  String text = "";

  int previ = 0;
  for (int i=0; i<source.length(); i++) {
    if (charsToAdd < fillerText.length())
      break;
    if (source.charAt(i) == ';') {
      text += source.substring(previ, i+1) + fillerText;
      previ = i+1;
      charsToAdd -= fillerText.length();
    }
  }
  text += source.substring(previ, source.length());

  return text;
}
