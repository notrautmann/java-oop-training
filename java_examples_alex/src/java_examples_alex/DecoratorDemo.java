package java_examples_alex;

/**
 * Demo class showcasing the Decorator pattern with Kaffee, Milch, and Zucker.
 */
public class DecoratorDemo {
    /**
     * Runs the Decorator pattern demo by composing Kaffee with Milch and Zucker decorators
     * and printing their descriptions and prices.
     */
    public static void run() {
        Kaffee kaffee = new SchwarzerKaffee();
        System.out.println(kaffee.getBeschreibung() + " kostet " + kaffee.getPreis() + "€");
        kaffee = new Milch(kaffee);
        kaffee = new Zucker(kaffee);
        kaffee = new Zucker(kaffee); // Doppelt Zucker!
        System.out.println(kaffee.getBeschreibung() + " kostet " + kaffee.getPreis() + "€");
    }
}
