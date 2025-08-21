package java_examples_alex;

public class Pizza {

    // Pflichtfelder
    private final String groesse;

    // Optionale Felder
    private final boolean kaese;
    private final boolean salami;
    private final boolean pilze;
    private final boolean ananas;

    // Privater Konstruktor – nur über Builder erzeugbar
    private Pizza(Builder builder) {
        this.groesse = builder.groesse;
        this.kaese = builder.kaese;
        this.salami = builder.salami;
        this.pilze = builder.pilze;
        this.ananas = builder.ananas;
    }

    // Statischer Builder (innere Klasse)
    public static class Builder {
        private final String groesse;

        private boolean kaese = false;
        private boolean salami = false;
        private boolean pilze = false;
        private boolean ananas = false;

        public Builder(String groesse) {
            this.groesse = groesse;
        }

        public Builder mitKaese() {
            this.kaese = true;
            return this;
        }

        public Builder mitSalami() {
            this.salami = true;
            return this;
        }

        public Builder mitPilzen() {
            this.pilze = true;
            return this;
        }

        public Builder mitAnanas() {
            this.ananas = true;
            return this;
        }

        public Pizza bauen() {
            return new Pizza(this);
        }
    }

    // Zum Anzeigen der Pizza-Konfiguration
    @Override
    public String toString() {
        return "Pizza{" +
                "Größe='" + groesse + '\'' +
                ", Käse=" + kaese +
                ", Salami=" + salami +
                ", Pilze=" + pilze +
                ", Ananas=" + ananas +
                '}';
    }

    

    
}
