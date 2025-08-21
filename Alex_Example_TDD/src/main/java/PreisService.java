/**
 * Die Klasse PreisService berechnet rabattierte Preise abhängig vom Kundentyp.
 * 
 * Aktuell wird ein fester Rabatt von 10 % für Bestandskunden gewährt.
 * Der Kundentyp wird über die übergebene Datenbankverbindung ermittelt.
 */
public class PreisService {

    private final Datenbankverbindung dbVerbindung;

    /**
     * Konstruktor zum Erzeugen eines PreisService mit einer Datenbankverbindung.
     *
     * @param dbVerbindung Verbindung zur Datenbank, um Kundentypen abzufragen
     */
    public PreisService(Datenbankverbindung dbVerbindung) {
        this.dbVerbindung = dbVerbindung;
    }

    /**
     * Ermittelt den rabattierten Preis für einen Kunden anhand seiner ID.
     *
     * Falls der Kunde ein Bestandskunde ist, wird ein Rabatt von 10 % auf den
     * übergebenen Preis gewährt. Für alle anderen Kundentypen bleibt der Preis unverändert.
     *
     * @param kundenId die ID des Kunden
     * @param preis der ursprüngliche Preis
     * @return der rabattierte oder unveränderte Preis abhängig vom Kundentyp
     */
    public double ermittleRabattierterPreis(Integer kundenId, double preis) {
        String typ = dbVerbindung.ermittleKundenTyp(kundenId);
        if ("Bestandskunde".equalsIgnoreCase(typ)) {
            return preis * 0.9;
        }
        if ("TEST".equalsIgnoreCase(typ)) {
            return preis * 0.1;
        }
        return preis;
    }
}
