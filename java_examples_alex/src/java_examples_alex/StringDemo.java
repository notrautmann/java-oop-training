package java_examples_alex;

import java.util.List;
import java.util.StringJoiner;

public class StringDemo {
    public static void run() {
        StringJoiner sj = new StringJoiner(", ", "[", "]");
        sj.add("Apfel").add("Banane").add("Kirsche");
        System.out.println(sj); // [Apfel, Banane, Kirsche]

        String formatted = String.format("Name: %s, Alter: %d", "Alex", 30);
        System.out.println(formatted);
    }
    
    public static void run2() {
    List<String> names = List.of("Anna", "Ben", "Carla");
    String result = String.join(", ", names);
    System.out.println(result); // Ausgabe: Anna, Ben, Carla
    }
}
