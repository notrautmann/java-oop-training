package java_examples_alex;

public class Datei implements DateisystemElement {
    private String name;

    public Datei(String name) {
        this.name = name;
    }

    @Override
    public void anzeigen(String einzug) {
        System.out.println(einzug + "- Datei: " + name);
    }
}
