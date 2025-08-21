package java_examples_alex;

public class ChainOfResponsibilityDemo {
	public static void run() {
		
		class Level1Support extends SupportHandler {
		    @Override
		    public void bearbeiteAnfrage(String anfrage) {
		        if (anfrage.contains("Passwort") || anfrage.contains("Allgemein")) {
		            System.out.println("Level 1 Support bearbeitet: " + anfrage);
		        } else if (naechsterHandler != null) {
		            naechsterHandler.bearbeiteAnfrage(anfrage);
		        }
		    }
		}
		
		class Level2Support extends SupportHandler {
		    @Override
		    public void bearbeiteAnfrage(String anfrage) {
		        if (anfrage.contains("Technik") || anfrage.contains("Fehler")) {
		            System.out.println("Level 2 Support bearbeitet: " + anfrage);
		        } else if (naechsterHandler != null) {
		            naechsterHandler.bearbeiteAnfrage(anfrage);
		        }
		    }
		}
		
		class Level3Support extends SupportHandler {
		    @Override
		    public void bearbeiteAnfrage(String anfrage) {
		        if (anfrage.contains("Sicherheit") || anfrage.contains("Datenleck")) {
		            System.out.println("Level 3 Support bearbeitet: " + anfrage);
		        } else {
		            System.out.println("Keine passende Support-Stufe gefunden für: " + anfrage);
		        }
		    }
		}
		
        // Kette aufbauen
        SupportHandler level1 = new Level1Support();
        SupportHandler level2 = new Level2Support();
        SupportHandler level3 = new Level3Support();

        level1.setNaechsterHandler(level2);
        level2.setNaechsterHandler(level3);

        // Beispielanfragen
        level1.bearbeiteAnfrage("Ich habe mein Passwort vergessen");
        level1.bearbeiteAnfrage("Technik Problem beim Einloggen");
        level1.bearbeiteAnfrage("Es gab ein Datenleck");
        level1.bearbeiteAnfrage("Unbekanntes Anliegen");
    }
}
