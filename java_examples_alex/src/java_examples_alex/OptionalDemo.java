package java_examples_alex;

import java.util.Optional;

public class OptionalDemo {
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
