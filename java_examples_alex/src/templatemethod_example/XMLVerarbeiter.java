package templatemethod_example;

public class XMLVerarbeiter extends DateiVerarbeiter {
    @Override
    protected void leseDaten() {
        System.out.println("XML-Daten werden gelesen.");
    }

    @Override
    protected void verarbeiteDaten() {
        System.out.println("XML-Daten werden verarbeitet.");
    }
}
