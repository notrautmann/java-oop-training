package exception_example;

public class ExceptionVsLogik {

    static final int ITERATIONS = 100_000_000;

    public static void run() {

        // Variante mit regulärer Logik
        long startLogic = System.nanoTime();
        int countLogic = 0;
        for (int i = 0; i < ITERATIONS; i++) {
            countLogic += useLogic(i);
        }
        long endLogic = System.nanoTime();
        System.out.println("Logik-Zeit: " + (endLogic - startLogic) / 1_000_000 + " ms");

        // Variante mit Exceptions als Kontrollfluss
        long startException = System.nanoTime();
        int countException = 0;
        for (int i = 0; i < ITERATIONS; i++) {
            try {
                countException += useException(i);
            } catch (IllegalArgumentException e) {
                // ignore
            }
        }
        long endException = System.nanoTime();
        System.out.println("Exception-Zeit: " + (endException - startException) / 1_000_000 + " ms");
    }

    // Kontrollfluss über normale Logik
    public static int useLogic(int value) {
        if (value % 10 != 0) {
            return 1;
        } else {
            return 0;
        }
    }

    // Kontrollfluss über Exceptions
    public static int useException(int value) {
        if (value % 10 == 0) {
            throw new IllegalArgumentException("Unerlaubter Wert: " + value);
        }
        return 1;
    }
}
