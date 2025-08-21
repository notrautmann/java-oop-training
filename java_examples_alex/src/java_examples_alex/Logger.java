package java_examples_alex;

public class Logger {

    // Statische Variable, die die einzige Instanz hält
    private static Logger instanz;

    // Privater Konstruktor – niemand außerhalb kann new Logger() aufrufen
    private Logger() {
        System.out.println("Logger wurde erstellt");
    }

    // Öffentliche Zugriffsmethode (Lazy Initialization)
    public static Logger getInstance() {
        if (instanz == null) {
            instanz = new Logger();
        }
        return instanz;
    }

    // Beispiel-Methode
    public void log(String nachricht) {
        System.out.println("Log: " + nachricht);
    }
   
}
