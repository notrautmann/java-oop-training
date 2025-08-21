package java_examples_alex;

import java.util.List;
import java.util.StringJoiner;

/**
 * Demonstrates basic String utilities such as joining collections and formatting.
 */
public class StringDemo {
    /**
     * Runs the first String demonstration.
     */
    public static void run() {
        StringJoiner sj = new StringJoiner(", ", "[", "]");
        sj.add("Apfel").add("Banane").add("Kirsche");
        System.out.println(sj); // [Apfel, Banane, Kirsche]

        String formatted = String.format("Name: %s, Alter: %d", "Alex", 30);
        System.out.println(formatted);
    }
    
    /**
     * Runs the second String demonstration.
     */
    public static void run2() {
    List<String> names = List.of("Anna", "Ben", "Carla");
    String result = String.join(", ", names);
    System.out.println(result); // Ausgabe: Anna, Ben, Carla
    }
}
