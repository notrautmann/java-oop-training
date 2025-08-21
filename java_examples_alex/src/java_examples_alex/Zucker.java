package java_examples_alex;

/**
 * Decorator that adds sugar to a {@link Kaffee}, extending its description and price.
 */
public class Zucker extends KaffeeDecorator {
    /**
     * Creates a Zucker decorator that adds sugar to the given coffee.
     * @param kaffee the wrapped coffee
     */
    public Zucker(Kaffee kaffee) {
        super(kaffee);
    }

    @Override
    /**
     * Returns the description including sugar.
     * @return the description with sugar appended
     */
    public String getBeschreibung() {
        return kaffee.getBeschreibung() + ", Zucker";
    }

    @Override
    /**
     * Returns the total price including the cost of sugar.
     * @return the price with sugar added
     */
    public double getPreis() {
        return kaffee.getPreis() + 0.20;
    }
}
