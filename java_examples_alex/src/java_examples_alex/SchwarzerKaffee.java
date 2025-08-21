package java_examples_alex;

/**
 * Konkrete Kaffee-Implementierung ohne Zusätze.
 */
public class SchwarzerKaffee implements Kaffee {
	    @Override
	    /**
	     * Liefert die textuelle Beschreibung dieses Kaffees.
	     * @return die Beschreibung
	     */
	    public String getBeschreibung() {
	        return "Schwarzer Kaffee";
	    }

	    @Override
	    /**
	     * Gibt den Preis dieses Kaffees zurück.
	     * @return der Preis
	     */
	    public double getPreis() {
	        return 2.00;
	    }
	}
