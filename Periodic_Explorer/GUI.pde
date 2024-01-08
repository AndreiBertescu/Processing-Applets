class GUI {

  GUI() {
  }

  void show() {
    cam.beginHUD();
    textAlign(CENTER, CENTER);
    rectMode(CORNER);
    //beginDraw

    //background
    fill(50);
    rect(width - hudWidth, 0, hudWidth, height);
    rect(0, 0, hudWidth, height);
    pushMatrix();
    translate(width - hudWidth, 0);

    //element
    rectMode(CENTER);
    strokeWeight(2);
    stroke(255);
    rect(hudWidth/2, 50 + 100, 175, 200);

    fill(255);
    textSize(25);
    text("Z = " + currentElement.currentZ, hudWidth/2, 50 + 20);
    textSize(25);
    if (currentElement.ionization != 0)
      text((currentElement.ionization>0 ? "+" : "") + currentElement.ionization, hudWidth/2 + textWidth(currentElement.symbol) + 10, 50 + 100 - 45);
    textSize(65);
    text(currentElement.symbol, hudWidth/2, 50 + 100 - 15);
    textSize(20);
    text(currentElement.name, hudWidth/2, 50 + 100 + 40);
    textSize(25);
    text("A = " + currentElement.A, hudWidth/2, 50 + 200 - 25);

    //text
    textSize(20);
    text("Element name: " + currentElement.name, hudWidth/2, 350);

    if (textWidth("Chemical group: " + currentElement.chemicalGroup) > hudWidth)
      textSize(17);
    text("Chemical group: " + currentElement.chemicalGroup, hudWidth/2, 350 + 25*1);

    textSize(20);
    text("Element status: " + (currentElement.stableNucleides.contains(currentElement.currentZ) ? "stable" : "radioactive"), hudWidth/2, 350 + 10 + 25*2);

    if (currentElement.ionization != 0) {
      text("Electric charge: " + (currentElement.ionization>0 ? "+" : "") + currentElement.ionization, hudWidth/2, 350 + 10 + 25*3);
      text(currentElement.ionization>0 ? "Increase ammount of electrons" : "Decrease ammount of electrons", hudWidth/2, 350 + 10 + 25*4);
    } else
      text("Electric charge: neutral", hudWidth/2, 350 + 10 + 25*3);


    //particle buttons
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(hudWidth/2, height - 100 - 50*2 - 10*2, hudWidth - 40*2 - 50*2, 50);
    rect(hudWidth/2, height - 100 - 50 - 10, hudWidth - 40*2 - 50*2, 50);
    rect(hudWidth/2, height - 100, hudWidth - 50*2 - 40*2, 50);

    fill(0);
    textSize(20);
    text(protons + " proton" + (protons != 1 ? "s" : ""), hudWidth/2, height - 100 - 50*2 - 10*2 - 4);
    text(neutrons + " neutron" + (neutrons != 1 ? "s" : ""), hudWidth/2, height - 100 - 50 - 10 - 4);
    text(electrons + " electron" + (electrons != 1 ? "s" : ""), hudWidth/2, height - 100 - 4);

    fill(255);
    rect(hudWidth/2 - 90, height - 100 - 50*2 - 10*2, 50, 50);
    rect(hudWidth/2 + 90, height - 100 - 50*2 - 10*2, 50, 50);
    rect(hudWidth/2 - 90, height - 100 - 50 - 10, 50, 50);
    rect(hudWidth/2 + 90, height - 100 - 50 - 10, 50, 50);
    rect(hudWidth/2 - 90, height - 100, 50, 50);
    rect(hudWidth/2 + 90, height - 100, 50, 50);

    stroke(0);
    strokeWeight(4);
    strokeCap(ROUND);
    line(hudWidth/2 - 90 - 14, height - 100 - 50*2 - 10*2, hudWidth/2 - 90 + 14, height - 100 - 50*2 - 10*2);
    line(hudWidth/2 + 90 - 15, height - 100 - 50*2 - 10*2, hudWidth/2 + 90 + 15, height - 100 - 50*2 - 10*2);
    line(hudWidth/2 + 90, height - 100 - 50*2 - 10*2 - 15, hudWidth/2 + 90, height - 100 - 50*2 - 10*2 + 15);
    line(hudWidth/2 - 90 - 14, height - 100 - 50 - 10, hudWidth/2 - 90 + 14, height - 100 - 50 - 10);
    line(hudWidth/2 + 90 - 15, height - 100 - 50 - 10, hudWidth/2 + 90 + 15, height - 100 - 50 - 10);
    line(hudWidth/2 + 90, height - 100 - 50 - 10 - 15, hudWidth/2 + 90, height - 100 - 50 - 10 + 15);
    line(hudWidth/2 - 90 - 14, height - 100, hudWidth/2 - 90 + 14, height - 100);
    line(hudWidth/2 + 90 - 15, height - 100, hudWidth/2 + 90 + 15, height - 100);
    line(hudWidth/2 + 90, height - 100 - 15, hudWidth/2 + 90, height - 100 + 15);

    //endDraw
    noStroke();
    popMatrix();
    cam.endHUD();
  }
}

void mouseReleased() {
  //subtract protons
  if (mouseX - (width - hudWidth) > (hudWidth/2 - 90) - 25 && mouseX - (width - hudWidth) < (hudWidth/2 - 90 + 50) - 25
    && mouseY > (height - 100 - 50*2 - 10*2) - 25 && mouseY < (height - 100 - 50*2 - 10*2 + 50) - 25) {
    if (protons <= 1)
      return;
    protons--;
    for (Particle p : nucleus)
      if (p instanceof Proton) {
        nucleus.remove(p);
        break;
      }
    for (Particle p : nucleus)
      p.nr = 150;
  }

  //add protons
  if (mouseX - (width - hudWidth) > (hudWidth/2 + 90) - 25 && mouseX - (width - hudWidth) < (hudWidth/2 + 90 + 50) - 25
    && mouseY > (height - 100 - 50*2 - 10*2) - 25 && mouseY < (height - 100 - 50*2 - 10*2 + 50) - 25) {
    if (protons + neutrons > 320)
      return;
    protons++;
    nucleus.add(new Proton(rNucleus, PVector.random3D().setMag(2)));
    for (Particle p : nucleus)
      p.nr = 150;
  }

  //subtract neutrons
  if (mouseX - (width - hudWidth) > (hudWidth/2 - 90) - 25 && mouseX - (width - hudWidth) < (hudWidth/2 - 90 + 50) - 25
    && mouseY > (height - 100 - 50 - 10) - 25 && mouseY < (height - 100 - 50 - 10) + 50 - 25) {
    if (neutrons <= 0)
      return;
    neutrons--;
    for (Particle p : nucleus)
      if (p instanceof Neutron) {
        nucleus.remove(p);
        break;
      }
    for (Particle p : nucleus)
      p.nr = 150;
  }

  //add neutrons
  if (mouseX - (width - hudWidth) > (hudWidth/2 + 90) - 25 && mouseX - (width - hudWidth) < (hudWidth/2 + 90 + 50) - 25
    && mouseY > (height - 100 - 50 - 10) - 25 && mouseY < (height - 100 - 50 - 10) + 50 - 25) {
    if (protons + neutrons > 320)
      return;
    neutrons++;
    nucleus.add(new Neutron(rNucleus, PVector.random3D().setMag(2)));
    for (Particle p : nucleus)
      p.nr = 150;
  }

  //subtract electrons
  if (mouseX - (width - hudWidth) > (hudWidth/2 - 90) - 25 && mouseX - (width - hudWidth) < (hudWidth/2 - 90 + 50) - 25
    && mouseY > (height - 100) - 25 && mouseY < (height - 100) + 50 - 25) {
    if (electrons <= 1)
      return;
    electrons--;
    orbitals.remove(electrons);
    arangeElectrons();
  }

  //add electrons
  if (mouseX - (width - hudWidth) > (hudWidth/2 + 90) - 25 && mouseX - (width - hudWidth) < (hudWidth/2 + 90 + 50) - 25
    && mouseY > (height - 100) - 25 && mouseY < (height - 100) + 50 - 25) {
    if (electrons > 118)
      return;
    electrons++;
    orbitals.add(new Electron(rOrbitals));
    arangeElectrons();
  }

  getElement();
}
