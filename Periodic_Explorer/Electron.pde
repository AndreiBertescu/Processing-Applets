class Electron extends Particle {
  float hAng, vAng, dist;

  Electron(float r) {
    super(r, new PVector());

    dist = 4;
    hAng = vAng = 0;
  }

  @Override
    void update() {
    hAng += PI/360 * dtOrbitals;
    hAng %= 2*PI;

    pos.x = dist * sin(hAng) * sin(vAng);
    pos.y = dist * sin(hAng) * cos(vAng);
    pos.z = dist * cos(hAng);
  }

  @Override
    void show() {
    fill(241, 255, 38);

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(0.15);
    popMatrix();
  }
}

void arangeElectrons() {
  sOrbitals = 0;
  pOrbitals = 0;
  dOrbitals = 0;
  fOrbitals = 0;

  int lastSOrbital = Integer.MAX_VALUE;
  int lastPOrbital = Integer.MAX_VALUE;
  int lastDOrbital = Integer.MAX_VALUE;
  int lastFOrbital = Integer.MAX_VALUE;

  //s orbitals
  if (electrons > 2-2) {
    sOrbitals++;
    lastSOrbital = 2-electrons;
  }
  if (electrons > 4-2) {
    sOrbitals++;
    lastSOrbital = 4-electrons;
  }
  if (electrons > 12-2) {
    sOrbitals++;
    lastSOrbital = 12-electrons;
  }
  if (electrons > 20-2) {
    sOrbitals++;
    lastSOrbital = 20-electrons;
  }
  if (electrons > 38-2) {
    sOrbitals++;
    lastSOrbital = 38-electrons;
  }
  if (electrons > 56-2) {
    sOrbitals++;
    lastSOrbital = 56-electrons;
  }
  if (electrons > 88-2) {
    sOrbitals++;
    lastSOrbital = 88-electrons;
  }

  //p orbitals
  if (electrons > 10-6) {
    pOrbitals++;
    lastPOrbital = 6-(10-electrons);
  }
  if (electrons > 18-6) {
    pOrbitals++;
    lastPOrbital = 6-(18-electrons);
  }
  if (electrons > 36-6) {
    pOrbitals++;
    lastPOrbital = 6-(36-electrons);
  }
  if (electrons > 54-6) {
    pOrbitals++;
    lastPOrbital = 6-(54-electrons);
  }
  if (electrons > 86-6) {
    pOrbitals++;
    lastPOrbital = 6-(86-electrons);
  }
  if (electrons > 118-6) {
    pOrbitals++;
    lastPOrbital = 6-(118-electrons);
  }

  //d orbitals
  if (electrons > 30-10) {
    dOrbitals++;
    lastDOrbital = 10-(30-electrons);
  }
  if (electrons > 48-10) {
    dOrbitals++;
    lastDOrbital = 10-(48-electrons);
  }
  if (electrons > 80-10) {
    dOrbitals++;
    lastDOrbital = 10-(80-electrons);
  }
  if (electrons > 112-10) {
    dOrbitals++;
    lastDOrbital = 10-(112-electrons);
  }

  //f orbitals
  if (electrons > 70-14) {
    fOrbitals++;
    lastFOrbital = 14-(70-electrons);
  }
  if (electrons > 102-14) {
    fOrbitals++;
    lastFOrbital = 14-(102-electrons);
  }

  if (lastSOrbital <= 0)
    lastSOrbital = 2;
  if (lastPOrbital <= 0 || lastPOrbital > 6)
    lastPOrbital = 6;
  if (lastDOrbital <= 0 || lastDOrbital > 10)
    lastDOrbital = 10;
  if (lastFOrbital <= 0 || lastFOrbital > 14)
    lastFOrbital = 14;

  if (lastSOrbital == Integer.MAX_VALUE)
    lastSOrbital = 0;
  if (lastPOrbital == Integer.MAX_VALUE)
    lastPOrbital = 0;
  if (lastDOrbital == Integer.MAX_VALUE)
    lastDOrbital = 0;
  if (lastFOrbital == Integer.MAX_VALUE)
    lastFOrbital = 0;

  int nr = 0;
  for (int i=0; i<sOrbitals; i++)
    for (int j=0; j<2; j++) {
      if (i == sOrbitals-1 && j >= lastSOrbital)
        break;

      orbitals.get(nr).dist = 4;
      orbitals.get(nr).vAng = i*(PI/sOrbitals);
      if (i == sOrbitals-1)
        orbitals.get(nr).hAng = j * (2*PI / lastSOrbital);
      else
        orbitals.get(nr).hAng = j * (2*PI / 2);
      nr++;
    }

  for (int i=0; i<pOrbitals; i++)
    for (int j=0; j<6; j++) {
      if (i == pOrbitals-1 && j >= lastPOrbital)
        break;

      orbitals.get(nr).dist = 6;
      orbitals.get(nr).vAng = i*(PI/pOrbitals);
      if (i == pOrbitals-1)
        orbitals.get(nr).hAng = j * (2*PI / lastPOrbital);
      else
        orbitals.get(nr).hAng = j * (2*PI / 6);
      nr++;
    }

  for (int i=0; i<dOrbitals; i++)
    for (int j=0; j<10; j++) {
      if (i == dOrbitals-1 && j >= lastDOrbital)
        break;

      orbitals.get(nr).dist = 8;
      orbitals.get(nr).vAng = PI/2 + i*(PI/dOrbitals);
      if (i == dOrbitals-1)
        orbitals.get(nr).hAng = j * (2*PI / lastDOrbital);
      else
        orbitals.get(nr).hAng = j * (2*PI / 10);
      nr++;
    }

  for (int i=0; i<fOrbitals; i++)
    for (int j=0; j<14; j++) {
      if (i == fOrbitals-1 && j >= lastFOrbital)
        break;

      orbitals.get(nr).dist = 10;
      orbitals.get(nr).vAng = i*(PI/fOrbitals);
      if (i == fOrbitals-1)
        orbitals.get(nr).hAng = j * (2*PI / lastFOrbital);
      else
        orbitals.get(nr).hAng = j * (2*PI / 14);
      nr++;
    }

  //println(electrons);
  //println(sOrbitals, lastSOrbital);
  //println(pOrbitals, lastPOrbital);
  //println(dOrbitals, lastDOrbital);
  //println(fOrbitals, lastFOrbital);
}
