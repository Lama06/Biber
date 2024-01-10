import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

class PartikelManager {
    List<Partikel> partikel = new ArrayList<>();

    void draw() {
        Iterator<Partikel> partikelIterator = partikel.iterator();
        while (partikelIterator.hasNext()) {
            Partikel partikel = partikelIterator.next();
            if (partikel.istUnsichtbar()) {
                partikelIterator.remove();
                continue;
            }
            partikel.draw();
        }
    }

    void spawnPartikel(float x, float y, int anzahl) {
        for (int i = 0; i < anzahl; i++) {
            partikel.add(new Partikel(x, y));
        }
    }

    void spawnPartikel(float x, float y) {
        spawnPartikel(x, y, 150);
    }
}

class Partikel {
        private static final float SIZE = 3;
        private static final float MAX_GESCHWINDIGKEIT = 6;
        private static final float TRANSPARENZ_AENDERUNG = -3f;

        float xGeschwindigkeit = random(-MAX_GESCHWINDIGKEIT, MAX_GESCHWINDIGKEIT);
        float yGeschwindigkeit = random(-MAX_GESCHWINDIGKEIT, MAX_GESCHWINDIGKEIT);
        int farbe = color((int) random(255), (int) random(255), (int) random(255));
        float x;
        float y;
        float transparenz = 255;

        Partikel(float x, float y) {
            this.x = x;
            this.y = y;
        }

        boolean istUnsichtbar() {
            return transparenz <= 0;
        }

        void draw() {
            x += xGeschwindigkeit;
            y += yGeschwindigkeit;
            transparenz += TRANSPARENZ_AENDERUNG;

            rectMode(PConstants.CENTER);
            noStroke();
            fill(farbe, transparenz);
            rect(x, y, SIZE, SIZE);
        }
    }
