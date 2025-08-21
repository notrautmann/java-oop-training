package java_examples_alex;

/**
 * Simple singleton logger used in the examples to print messages.
 */
public class Logger {

    // Statische Variable, die die einzige Instanz hält
    private static Logger instanz;

    // Privater Konstruktor – niemand außerhalb kann new Logger() aufrufen
    /**
     * Erstellt eine neue Logger-Instanz.
     * Wird nur intern innerhalb des Singletons aufgerufen.
     */
    private Logger() {
        System.out.println("Logger wurde erstellt");
    }

    // Öffentliche Zugriffsmethode (Lazy Initialization)
    /**
     * Liefert die Singleton-Instanz des Loggers. Erstellt sie bei Bedarf (lazy).
     * @return die globale Logger-Instanz
     */
    public static Logger getInstance() {
        if (instanz == null) {
            instanz = new Logger();
        }
        return instanz;
    }

    // Beispiel-Methode
    /**
     * Gibt eine Protokollnachricht auf der Konsole aus.
     * @param nachricht die auszugebende Nachricht
     */
    public void log(String nachricht) {
        System.out.println("Log: " + nachricht);
    }
   
}
