package java_examples_alex;

/**
 * Leaf element in a simple file system composite representing a single file.
 */
public class Datei implements DateisystemElement {
    private String name;

    /**
     * Constructs a file with the given name.
     * @param name the display name of the file
     */
    public Datei(String name) {
        this.name = name;
    }

    @Override
    /**
     * Displays this file’s name with indentation.
     * @param einzug the indentation string to prefix
     */
    public void anzeigen(String einzug) {
        System.out.println(einzug + "- Datei: " + name);
    }
}
