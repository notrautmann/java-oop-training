package java_examples_alex;

/**
 * Example demonstrating a flexible interface for handing accounting-relevant data (Fibu)
 * to different systems using simple abstractions and implementations.
 */
public class FibuExample {

    /**
     * Demonstrates transferring example data to different Fibu systems.
     */
    public void showFibu() {
        FibuUebergebbar lager = new Lagerbewegung("LB123", 100.0, "Wareneingang");
        FibuUebergebbar rechnung = new Rechnung("RE456", 250.0, "Dienstleistung");

        Fibu fibuA = getFibuInstance(FibuType.A);
        Fibu fibuB = getFibuInstance(FibuType.B);

        fibuA.uebergeben(lager);
        fibuA.uebergeben(rechnung);
    }

    /**
     * Returns a Fibu implementation for the given type.
     * @param fibuType the requested implementation type
     * @return the Fibu instance, or {@code null} if unsupported
     */
    private Fibu getFibuInstance(FibuType fibuType) {

        return switch (fibuType) {
            case A -> new FibuA();
            case B -> new FibuB();
            default      -> null;
        };
    }

    enum FibuType {
        A, B
    }

    /**
     * Abstraction for data objects that can be transferred to a Fibu system.
     */
    interface FibuUebergebbar {
        String getBelegnummer();

        double getBetrag();

        String getBeschreibung();
    }

    /**
     * Simple implementation representing a stock movement to be handed over to Fibu.
     */
    class Lagerbewegung implements FibuUebergebbar {
        private String belegnummer;
        private double betrag;
        private String beschreibung;

        /**
         * Creates a new Lagerbewegung.
         * @param belegnummer the document number
         * @param betrag the amount
         * @param beschreibung the description
         */
        public Lagerbewegung(String belegnummer, double betrag, String beschreibung) {
            this.belegnummer = belegnummer;
            this.betrag = betrag;
            this.beschreibung = beschreibung;
        }

        @Override
        public String getBelegnummer() {
            return belegnummer;
        }

        @Override
        public double getBetrag() {
            return betrag;
        }

        @Override
        public String getBeschreibung() {
            return beschreibung;
        }
    }

    /**
     * Simple implementation representing an invoice to be handed over to Fibu.
     */
    class Rechnung implements FibuUebergebbar {
        private String belegnummer;
        private double betrag;
        private String beschreibung;

        /**
         * Creates a new Rechnung.
         * @param belegnummer the document number
         * @param betrag the amount
         * @param beschreibung the description
         */
        public Rechnung(String belegnummer, double betrag, String beschreibung) {
            this.belegnummer = belegnummer;
            this.betrag = betrag;
            this.beschreibung = beschreibung;
        }

        @Override
        public String getBelegnummer() {
            return belegnummer;
        }

        @Override
        public double getBetrag() {
            return betrag * 2;
        }

        @Override
        public String getBeschreibung() {
            return beschreibung;
        }
    }

    /**
     * Abstraction for Fibu systems that can receive accounting data.
     */
    interface Fibu {
        void uebergeben(FibuUebergebbar daten);
    }

    /**
     * Example Fibu system that transfers data via a database.
     */
    class FibuA implements Fibu {
        @Override
        public void uebergeben(FibuUebergebbar daten) {
            System.out.println("Fibu A überträgt Daten per Datenbank:");
            System.out.println("Beleg: " + daten.getBelegnummer());
            System.out.println("Betrag: " + daten.getBetrag());
            System.out.println("Beschreibung: " + daten.getBeschreibung());
            System.out.println();
        }
    }

    /**
     * Example Fibu system that transfers data via a file interface.
     */
    class FibuB implements Fibu {
        @Override
        public void uebergeben(FibuUebergebbar daten) {
            System.out.println("Fibu B überträgt Daten per Datei-Schnittstelle:");
            System.out.println("Beleg: " + daten.getBelegnummer());
            System.out.println("Betrag: " + daten.getBetrag());
            System.out.println("Beschreibung wird ignoriert");
            System.out.println();
        }
    }

}

