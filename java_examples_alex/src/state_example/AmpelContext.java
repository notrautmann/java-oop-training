package state_example;

public class AmpelContext {
    private AmpelZustand zustand;

    public AmpelContext() {
        zustand = new Rot(); // Startzustand
    }

    public void setZustand(AmpelZustand zustand) {
        this.zustand = zustand;
    }

    public void weiter() {
        zustand.weiter(this);
    }

    public void aktuelleFarbe() {
        System.out.println("Aktuelle Farbe: " + zustand.getFarbe());
    }
}
