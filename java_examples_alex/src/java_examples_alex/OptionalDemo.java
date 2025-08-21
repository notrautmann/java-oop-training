package java_examples_alex;

import java.util.Optional;

/**
 * Demonstrates basic usage of {@link java.util.Optional} in this example package.
 */
public class OptionalDemo {
    /**
     * Executes the Optional demo.
     */
    public static void run() {
        Optional<String> name = Optional.ofNullable(getName());
        name.ifPresentOrElse(
            n -> System.out.println("Hallo, " + n),
            () -> System.out.println("Kein Name vorhanden")
        );
    }

    static String getName() {
        return null; 
    }
}
