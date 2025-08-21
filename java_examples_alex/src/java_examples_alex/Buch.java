package java_examples_alex;

/**
 * Repräsentiert ein Buch mit einem Titel als einfaches Domänenobjekt
 * für die Beispielanwendungen.
 */
public class Buch {
    private String titel;

    /**
     * Erstellt eine neue Instanz.
     * @param titel der Buchtitel
     */
    public Buch(String titel) {
        this.titel = titel;
    }

    /**
     * Liefert den Titel.
     * @return der Titel
     */
    public String getTitel() {
        return titel;
    }
}
