package java_examples_alex;

/**
 * Demo class showcasing the Composite pattern with a simple file system structure.
 */
public class CompositeDemo {
	/**
	 * Executes the composite demo by building a small folder structure and displaying it.
	 */
	public static void run() {
		Datei datei1 = new Datei("Lebenslauf.pdf");
        Datei datei2 = new Datei("Bild.png");
        Ordner ordner1 = new Ordner("Dokumente");
        ordner1.hinzufuegen(datei1);
        Ordner ordner2 = new Ordner("Bilder");
        ordner2.hinzufuegen(datei2);
        Ordner hauptOrdner = new Ordner("Home");
        hauptOrdner.hinzufuegen(ordner1);
        hauptOrdner.hinzufuegen(ordner2);
        hauptOrdner.hinzufuegen(new Datei("Notiz.txt"));
        hauptOrdner.anzeigen("");
	}
}
