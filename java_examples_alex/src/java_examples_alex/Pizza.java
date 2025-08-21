package java_examples_alex;

/**
 * Represents a pizza configuration built using the Builder pattern with required and optional toppings.
 */
public class Pizza {

    // Pflichtfelder
    private final String groesse;

    // Optionale Felder
    private final boolean kaese;
    private final boolean salami;
    private final boolean pilze;
    private final boolean ananas;

    // Privater Konstruktor – nur über Builder erzeugbar
    /**
     * Creates a new Pizza instance using the provided builder configuration.
     * @param builder the builder carrying the chosen configuration
     */
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

        /**
         * Creates a builder with the required size.
         * @param groesse the required pizza size
         */
        public Builder(String groesse) {
            this.groesse = groesse;
        }

        /**
         * Adds cheese to the pizza configuration.
         * @return this builder instance for chaining
         */
        public Builder mitKaese() {
            this.kaese = true;
            return this;
        }

        /**
         * Adds salami to the pizza configuration.
         * @return this builder instance for chaining
         */
        public Builder mitSalami() {
            this.salami = true;
            return this;
        }

        /**
         * Adds mushrooms to the pizza configuration.
         * @return this builder instance for chaining
         */
        public Builder mitPilzen() {
            this.pilze = true;
            return this;
        }

        /**
         * Adds pineapple to the pizza configuration.
         * @return this builder instance for chaining
         */
        public Builder mitAnanas() {
            this.ananas = true;
            return this;
        }

        /**
         * Builds a Pizza instance from the current builder configuration.
         * @return the constructed {@code Pizza}
         */
        public Pizza bauen() {
            return new Pizza(this);
        }
    }

    // Zum Anzeigen der Pizza-Konfiguration
    /**
     * Returns a textual representation of the pizza configuration.
     * @return a string describing the current pizza settings
     */
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
