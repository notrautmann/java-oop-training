package java_examples_alex;

public class FibuExample {

    public void showFibu() {
        FibuUebergebbar lager = new Lagerbewegung("LB123", 100.0, "Wareneingang");
        FibuUebergebbar rechnung = new Rechnung("RE456", 250.0, "Dienstleistung");

        Fibu fibuA = getFibuInstance(FibuType.A);
        Fibu fibuB = getFibuInstance(FibuType.B);

        fibuA.uebergeben(lager);
        fibuA.uebergeben(rechnung);
    }

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

    // Interface für übergebbare Objekte an die Fibu
    interface FibuUebergebbar {
        String getBelegnummer();

        double getBetrag();

        String getBeschreibung();
    }

    // Implementierung 1: Lagerbewegung
    class Lagerbewegung implements FibuUebergebbar {
        private String belegnummer;
        private double betrag;
        private String beschreibung;

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

    // Implementierung 2: Rechnung
    class Rechnung implements FibuUebergebbar {
        private String belegnummer;
        private double betrag;
        private String beschreibung;

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

    // Interface für Fibu-Systeme
    interface Fibu {
        void uebergeben(FibuUebergebbar daten);
    }

    // Implementierung für Fibu A
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

    // Implementierung für Fibu B
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

