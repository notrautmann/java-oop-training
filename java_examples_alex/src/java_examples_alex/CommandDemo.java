package java_examples_alex;

public class CommandDemo {
	
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

	    public LichtAnCommand(Licht licht) {
	        this.licht = licht;
	    }

	    public void ausfuehren() {
	        licht.einschalten();
	    }
	}
	
	 class LichtAusCommand implements Command {
	    private Licht licht;

	    public LichtAusCommand(Licht licht) {
	        this.licht = licht;
	    }

	    public void ausfuehren() {
	        licht.ausschalten();
	    }
	}
	
	 class RadioAnCommand implements Command {
	    private Radio radio;

	    public RadioAnCommand(Radio radio) {
	        this.radio = radio;
	    }

	    public void ausfuehren() {
	        radio.einschalten();
	    }
	}
	
	 class RadioAusCommand implements Command {
	    private Radio radio;

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

	    public void setCommand(Command command) {
	        this.slot = command;
	    }

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
