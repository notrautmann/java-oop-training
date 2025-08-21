package java_examples_alex;

import java.util.ArrayList;
import java.util.List;

/**
 * Composite element representing a directory that can contain {@link DateisystemElement} children.
 */
public class Ordner implements DateisystemElement {
    private String name;
    private List<DateisystemElement> inhalt = new ArrayList<>();

    /**
     * Creates a new directory with the given name.
     * @param name the directory name
     */
    public Ordner(String name) {
        this.name = name;
    }

    /**
     * Adds a child element to this directory.
     * @param element the element to add
     */
    public void hinzufuegen(DateisystemElement element) {
        inhalt.add(element);
    }

    @Override
    /**
     * Displays the directory name and recursively displays its children with increased indentation.
     * @param einzug the indentation string to prefix
     */
    public void anzeigen(String einzug) {
        System.out.println(einzug + "+ Ordner: " + name);
        for (DateisystemElement element : inhalt) {
            element.anzeigen(einzug + "  ");
        }
    }
}
