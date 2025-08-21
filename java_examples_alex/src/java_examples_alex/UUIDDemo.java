package java_examples_alex;

import java.util.UUID;

public class UUIDDemo {
    public static void run() {
        String uniqueID = UUID.randomUUID().toString();
        System.out.println("UUID: " + uniqueID);
    }
}
