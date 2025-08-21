package java_examples_alex;

/**
 * Demo entry point for the Abstract Factory pattern examples.
 */
public class AbstractFactory {}

	// 1. Abstrakte Produkte
	/**
	 * Abstraktes Produkt: Repräsentiert einen einfachen Button.
	 */
	interface Button {
	    void druecken();
	}

	/**
	 * Abstraktes Produkt: Repräsentiert ein einfaches Fenster.
	 */
	interface Fenster {
	    void anzeigen();
	}

	// 2. Konkrete Produkte – Windows
	/**
	 * Konkretes Produkt für Windows: Implementiert {@link Button}.
	 */
	class WindowsButton implements Button {
	    public void druecken() {
	        System.out.println("Windows-Button gedrückt");
	    }
	}

	/**
	 * Konkretes Produkt für Windows: Implementiert {@link Fenster}.
	 */
	class WindowsFenster implements Fenster {
	    public void anzeigen() {
	        System.out.println("Windows-Fenster angezeigt");
	    }
	}

	// 3. Konkrete Produkte – Linux
	/**
	 * Konkretes Produkt für Linux: Implementiert {@link Button}.
	 */
	class LinuxButton implements Button {
	    public void druecken() {
	        System.out.println("Linux-Button gedrückt");
	    }
	}

	/**
	 * Konkretes Produkt für Linux: Implementiert {@link Fenster}.
	 */
	class LinuxFenster implements Fenster {
	    public void anzeigen() {
	        System.out.println("Linux-Fenster angezeigt");
	    }
	}

	// 4. Abstrakte Fabrik
	/**
	 * Abstrakte Fabrik, die Familien von GUI-Produkten erzeugt.
	 */
	interface GUIFactory {
	    Button erzeugeButton();
	    Fenster erzeugeFenster();
	}

	// 5. Konkrete Fabriken
	/**
	 * Konkrete Fabrik für Windows-Produkte.
	 */
	class WindowsFactory implements GUIFactory {
	    public Button erzeugeButton() {
	        return new WindowsButton();
	    }

	    public Fenster erzeugeFenster() {
	        return new WindowsFenster();
	    }
	}

	/**
	 * Konkrete Fabrik für Linux-Produkte.
	 */
	class LinuxFactory implements GUIFactory {
	    public Button erzeugeButton() {
	        return new LinuxButton();
	    }

	    public Fenster erzeugeFenster() {
	        return new LinuxFenster();
	    }
	}

	// 6. Client
	/**
	 * Einfacher Client, der die passende {@link GUIFactory} wählt und Produkte nutzt.
	 */
	class GUIAnwendung {
	    public static void start() {
	        GUIFactory factory;

	        String os = "linux"; // oder "windows"

	        if (os.equalsIgnoreCase("windows")) {
	            factory = new WindowsFactory();
	        } else {
	            factory = new LinuxFactory();
	        }

	        Button b = factory.erzeugeButton();
	        Fenster f = factory.erzeugeFenster();

	        b.druecken();
	        f.anzeigen();
	    }
	}
	

