package java_examples_alex;

/**
 * Base decorator for Kaffee implementations that forwards behavior to a wrapped instance.
 */
public abstract class KaffeeDecorator implements Kaffee {
    protected Kaffee kaffee;

    /**
     * Creates a new decorator wrapping the given Kaffee.
     * @param kaffee the wrapped coffee
     */
    public KaffeeDecorator(Kaffee kaffee) {
        this.kaffee = kaffee;
    }
}
