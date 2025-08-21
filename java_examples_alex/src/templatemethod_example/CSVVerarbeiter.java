package templatemethod_example;

public class CSVVerarbeiter extends DateiVerarbeiter {
    @Override
    protected void leseDaten() {
        System.out.println("CSV-Daten werden gelesen.");
    }

    @Override
    protected void verarbeiteDaten() {
        System.out.println("CSV-Daten werden verarbeitet.");
    }
}
