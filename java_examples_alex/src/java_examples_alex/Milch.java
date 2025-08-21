package java_examples_alex;

/**
 * Decorator that adds milk to a {@link Kaffee}, adjusting description and price.
 */
public class Milch extends KaffeeDecorator {
    /**
     * Creates a Milch decorator wrapping the given coffee.
     * @param kaffee the base coffee to decorate
     */
    public Milch(Kaffee kaffee) {
        super(kaffee);
    }

    @Override
    /**
     * Returns the description of the decorated coffee with milk appended.
     * @return the description including ", Milch"
     */
    public String getBeschreibung() {
        return kaffee.getBeschreibung() + ", Milch";
    }

    @Override
    /**
     * Returns the price of the decorated coffee with the cost of milk added.
     * @return the price including the milk surcharge
     */
    public double getPreis() {
        return kaffee.getPreis() + 0.50;
    }
}
