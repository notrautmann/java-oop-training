package java_examples_alex;

public class AbstractFactory {}

	// 1. Abstrakte Produkte
	interface Button {
	    void druecken();
	}

	interface Fenster {
	    void anzeigen();
	}

	// 2. Konkrete Produkte – Windows
	class WindowsButton implements Button {
	    public void druecken() {
	        System.out.println("Windows-Button gedrückt");
	    }
	}

	class WindowsFenster implements Fenster {
	    public void anzeigen() {
	        System.out.println("Windows-Fenster angezeigt");
	    }
	}

	// 3. Konkrete Produkte – Linux
	class LinuxButton implements Button {
	    public void druecken() {
	        System.out.println("Linux-Button gedrückt");
	    }
	}

	class LinuxFenster implements Fenster {
	    public void anzeigen() {
	        System.out.println("Linux-Fenster angezeigt");
	    }
	}

	// 4. Abstrakte Fabrik
	interface GUIFactory {
	    Button erzeugeButton();
	    Fenster erzeugeFenster();
	}

	// 5. Konkrete Fabriken
	class WindowsFactory implements GUIFactory {
	    public Button erzeugeButton() {
	        return new WindowsButton();
	    }

	    public Fenster erzeugeFenster() {
	        return new WindowsFenster();
	    }
	}

	class LinuxFactory implements GUIFactory {
	    public Button erzeugeButton() {
	        return new LinuxButton();
	    }

	    public Fenster erzeugeFenster() {
	        return new LinuxFenster();
	    }
	}

	// 6. Client
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
	

