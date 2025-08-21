package java_examples_alex;

/**
 * Demo for the Command pattern that defines commands and executes them via a simple invoker.
 */
public class CommandDemo {
	
	/**
	 * Runs the Command pattern demo.
	 */
	public static void run() {
	
	// Receiver-Klassen (z. B. Licht, Radio)
	
	 class Licht {
	    public void einschalten() {
	        System.out.println("Licht eingeschaltet");
	    }
	    public void ausschalten() {
	        System.out.println("Licht ausgeschaltet");
	    }
	}
	
	 class Radio {
	    public void einschalten() {
	        System.out.println("Radio spielt Musik");
	    }
	    public void ausschalten() {
	        System.out.println("Radio ausgeschaltet");
	    }
	}
	//Konkrete Command-Klassen
	
	 class LichtAnCommand implements Command {
	    private Licht licht;

	    /**
	     * Creates the command to turn the light on.
	     * @param licht the receiver
	     */
	    public LichtAnCommand(Licht licht) {
	        this.licht = licht;
	    }

	    public void ausfuehren() {
	        licht.einschalten();
	    }
	}
	
	 class LichtAusCommand implements Command {
	    private Licht licht;

	    /**
	     * Creates the command to turn the light off.
	     * @param licht the receiver
	     */
	    public LichtAusCommand(Licht licht) {
	        this.licht = licht;
	    }

	    public void ausfuehren() {
	        licht.ausschalten();
	    }
	}
	
	 class RadioAnCommand implements Command {
	    private Radio radio;

	    /**
	     * Creates the command to turn the radio on.
	     * @param radio the receiver
	     */
	    public RadioAnCommand(Radio radio) {
	        this.radio = radio;
	    }

	    public void ausfuehren() {
	        radio.einschalten();
	    }
	}
	
	 class RadioAusCommand implements Command {
	    private Radio radio;

	    /**
	     * Creates the command to turn the radio off.
	     * @param radio the receiver
	     */
	    public RadioAusCommand(Radio radio) {
	        this.radio = radio;
	    }

	    public void ausfuehren() {
	        radio.ausschalten();
	    }
	}
	// Der Invoker
	 class Fernbedienung {
	    private Command slot;

	    /**
	     * Sets the command in the single slot.
	     * @param command the command to execute when the button is pressed
	     */
	    public void setCommand(Command command) {
	        this.slot = command;
	    }

	    /**
	     * Triggers the currently set command if available.
	     */
	    public void tasteGedrueckt() {
	        if (slot != null) {
	            slot.ausfuehren();
	        }
	    }
	}
	
	
        Fernbedienung fernbedienung = new Fernbedienung();

        Licht wohnzimmerLicht = new Licht();
        Radio radio = new Radio();

        // Kommandos erstellen
        Command lichtAn = new LichtAnCommand(wohnzimmerLicht);
        Command lichtAus = new LichtAusCommand(wohnzimmerLicht);
        Command radioAn = new RadioAnCommand(radio);
        Command radioAus = new RadioAusCommand(radio);

        // Befehle ausführen
        fernbedienung.setCommand(lichtAn);
        fernbedienung.tasteGedrueckt();

        fernbedienung.setCommand(radioAn);
        fernbedienung.tasteGedrueckt();

        fernbedienung.setCommand(lichtAus);
        fernbedienung.tasteGedrueckt();

        fernbedienung.setCommand(radioAus);
        fernbedienung.tasteGedrueckt();
    
}}
