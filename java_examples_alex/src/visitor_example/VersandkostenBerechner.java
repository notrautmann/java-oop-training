package visitor_example;

public class VersandkostenBerechner implements VersandVisitor {
    private double gesamtKosten = 0.0;

    @Override
    public void besuche(Buch buch) {
        double kosten = 1.5 + buch.getGewicht() * 2;
        System.out.println("Versand für Buch \"" + buch.getTitel() + "\": " + kosten + " €");
        gesamtKosten += kosten;
    }

    @Override
    public void besuche(Elektronik elektronik) {
        double kosten = elektronik.isZerbrechlich() ? 10.0 : 5.0;
        System.out.println("Versand für Elektronik \"" + elektronik.getName() + "\": " + kosten + " €");
        gesamtKosten += kosten;
    }

    public double getGesamtKosten() {
        return gesamtKosten;
    }
}
