package java_examples_alex;

import java.nio.file.*;
import java.io.IOException;

public class FileDemo {
    public static void run() throws IOException {
        Path path = Paths.get("example.txt");
        System.out.println(path.toUri().toString());
        Files.writeString(path, "Hallo Welt!");
        String content = Files.readString(path);
        System.out.println("Inhalt: " + content);
    }
}
