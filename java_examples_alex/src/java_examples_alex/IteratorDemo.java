package java_examples_alex;

/**
 * Demo for the Iterator pattern over a simple bookshelf.
 */
public class IteratorDemo {
	/**
	 * Executes the demo.
	 */
	public static void run() {
        Buecherregal regal = new Buecherregal(3);
        regal.buchHinzufuegen(new Buch("Design Patterns"));
        regal.buchHinzufuegen(new Buch("Clean Code"));
        regal.buchHinzufuegen(new Buch("Refactoring"));

        Iterator iterator = regal.iterator();
        while (iterator.hasNext()) {
            Buch buch = (Buch) iterator.next();
            System.out.println("Buch: " + buch.getTitel());
        }
    }
}
