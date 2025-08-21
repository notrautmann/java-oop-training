package visitor_example;

public class Buch implements Produkt {
    private String titel;
    private double gewicht; // in kg

    public Buch(String titel, double gewicht) {
        this.titel = titel;
        this.gewicht = gewicht;
    }

    public double getGewicht() {
        return gewicht;
    }

    public String getTitel() {
        return titel;
    }

    @Override
    public void akzeptiere(VersandVisitor visitor) {
        visitor.besuche(this);
    }
}
