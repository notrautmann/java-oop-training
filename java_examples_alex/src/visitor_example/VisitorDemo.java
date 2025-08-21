package visitor_example;

import java.util.List;

public class VisitorDemo {
	public static void run() {
        List<Produkt> warenkorb = List.of(
            new Buch("Java Grundlagen", 0.8),
            new Elektronik("Tablet", true),
            new Buch("Entwurfsmuster", 1.2),
            new Elektronik("Ladekabel", false)
        );

        VersandkostenBerechner berechner = new VersandkostenBerechner();

        for (Produkt p : warenkorb) {
            p.akzeptiere(berechner);
        }

        System.out.println("\nGesamte Versandkosten: " + berechner.getGesamtKosten() + " €");
    }
}
