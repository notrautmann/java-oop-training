package java_examples_alex;

public class DecoratorDemo {
    public static void run() {
        Kaffee kaffee = new SchwarzerKaffee();
        System.out.println(kaffee.getBeschreibung() + " kostet " + kaffee.getPreis() + "€");
        kaffee = new Milch(kaffee);
        kaffee = new Zucker(kaffee);
        kaffee = new Zucker(kaffee); // Doppelt Zucker!
        System.out.println(kaffee.getBeschreibung() + " kostet " + kaffee.getPreis() + "€");
    }
}