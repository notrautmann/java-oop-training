package java_examples_alex;

import java.util.ArrayList;
import java.util.List;

public class Ordner implements DateisystemElement {
    private String name;
    private List<DateisystemElement> inhalt = new ArrayList<>();

    public Ordner(String name) {
        this.name = name;
    }

    public void hinzufuegen(DateisystemElement element) {
        inhalt.add(element);
    }

    @Override
    public void anzeigen(String einzug) {
        System.out.println(einzug + "+ Ordner: " + name);
        for (DateisystemElement element : inhalt) {
            element.anzeigen(einzug + "  ");
        }
    }
}
