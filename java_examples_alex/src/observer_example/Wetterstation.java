package observer_example;

import java.util.ArrayList;
import java.util.List;

public class Wetterstation {
    private List<WetterBeobachter> beobachterListe = new ArrayList<>();
    private float temperatur;

    public void registrieren(WetterBeobachter beobachter) {
        beobachterListe.add(beobachter);
    }

    public void entferne(WetterBeobachter beobachter) {
        beobachterListe.remove(beobachter);
    }

    public void setTemperatur(float temperatur) {
        this.temperatur = temperatur;
        benachrichtigeBeobachter();
    }

    private void benachrichtigeBeobachter() {
        for (WetterBeobachter beobachter : beobachterListe) {
            beobachter.aktualisieren(temperatur);
        }
    }
}
