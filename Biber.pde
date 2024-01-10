class Knoten<InhaltsTyp> {
  InhaltsTyp inhalt;
  Knoten<InhaltsTyp> davor;
  Knoten<InhaltsTyp> danach;
}

class Liste<InhaltsTyp> {
  Knoten<InhaltsTyp> anfang;
  Knoten<InhaltsTyp> ende;
  Knoten<InhaltsTyp> aktuell;
  
  boolean istLeer() {
    return anfang == null;
  }
  
  void zumAnfang() {
    aktuell = anfang;
  }
  
  void zumEnde() {
    aktuell = ende;
  }
  
  InhaltsTyp gibInhalt() {
    if (aktuell == null) return null;
    return aktuell.inhalt;
  }
  
  void setzInhalt(InhaltsTyp inhalt) {
    if (aktuell == null) return;
    aktuell.inhalt = inhalt;
  }
  
  void zumNaechsten() {
    if (aktuell == null) return;
    aktuell = aktuell.danach;
  }
  
  boolean hatZugriff() {
    return aktuell != null;
  }
  
  void anfuegen(InhaltsTyp inhalt) {
    Knoten<InhaltsTyp> knoten = new Knoten<InhaltsTyp>();
    knoten.inhalt = inhalt;
    if (anfang == null) {
      anfang = ende = knoten;
      return;
    }
    ende.danach = knoten;
    knoten.davor = ende;
    ende = knoten;
  }
  
  void entfernen() {
    if (aktuell == null) return;
    
    if (anfang == ende) {
      aktuell = anfang = ende = null;
      return;  
    }
    
    if (aktuell == anfang) {
      aktuell = anfang.danach;
      anfang.danach.davor = null;
      anfang = anfang.danach;
      return;
    }
    
    if (aktuell == ende) {
      aktuell = null;
      ende.davor.danach = null;
      ende = ende.davor;
      return;
    }
    
    aktuell.davor.danach = aktuell.danach;
    aktuell.danach.davor = aktuell.davor;
    aktuell = aktuell.danach;
  }
}

PImage biber;
NervenderBiber biberN = new NervenderBiber();
boolean ai = false;
PartikelManager partikel = new PartikelManager();
Liste<String> einkaufen = new Liste<String>();
String eingabe = "";

void setup() {
   size(800, 800);
   biber = loadImage("biber.png");
   biberNervigBild = loadImage("biber_nervig.png");
}

void keyPressed() {
  if (key == CODED) {
    return;
  }
  
  if (key == BACKSPACE) {
    if (!eingabe.isEmpty()) eingabe = eingabe.substring(0, eingabe.length()-1);
    return;
  }
  
  if ((key == ENTER || key == RETURN) && !eingabe.isEmpty()) {
    if (eingabe.equalsIgnoreCase("Biber")) {
       ai = true;
    }
    einkaufen.anfuegen(eingabe);
    return;
  }
  
  if (key == '-') {
    einkaufen.zumAnfang();
    while (einkaufen.hatZugriff()) {
      if (einkaufen.gibInhalt().equals(eingabe)) {
        einkaufen.entfernen();
      } else {
        einkaufen.zumNaechsten();
      }
    }
    return;
  }
  
  if (key == '1') {
    einkaufen.anfuegen("Biberfutter");
    return;
  }
  if (key == '2') {
    einkaufen.anfuegen("Biberkäfig");
    return;
  }
  
  eingabe += key;
}

void draw() {
  if (frameCount % 30 == 0) {
    listeAbrufen();
  }
  
  
  background(255);
  
  biberN.draw();
  
  partikel.spawnPartikel(mouseX, mouseY, 2);
  partikel.draw();
  
  if (ai) {
    // Biber
    image(biber, 0, height-300, 300, 200);
    textAlign(LEFT, BOTTOM);
    textSize(50);
    text("Biber-GPT 4.0", 0, height);
  }
  
  // Titel
  fill(0);
  textAlign(CENTER, TOP);
  textSize(50);
  text("Intelligente Einkaufsliste", width/2, 30);
  
  // Eingabe
  fill(0);
  textAlign(CENTER, TOP);
  textSize(30);
  text(eingabe, width/2, 80);
  
  // Eintraege
  int i = 0;
  einkaufen.zumAnfang();
  while (einkaufen.hatZugriff()) {
    textAlign(CENTER, TOP);
    textSize(30);
    fill(0);
    text(einkaufen.gibInhalt(), width/2, 150+30*i);
    einkaufen.zumNaechsten();
    i++;
  }
}
