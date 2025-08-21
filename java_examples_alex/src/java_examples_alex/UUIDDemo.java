package java_examples_alex;

import java.util.UUID;

/**
 * Demo class that generates and prints a random UUID string.
 */
public class UUIDDemo {
    /**
     * Runs the demo to generate and print a random UUID.
     */
    public static void run() {
        String uniqueID = UUID.randomUUID().toString();
        System.out.println("UUID: " + uniqueID);
    }
}
