package java_examples_alex;

public class Milch extends KaffeeDecorator {
    public Milch(Kaffee kaffee) {
        super(kaffee);
    }

    @Override
    public String getBeschreibung() {
        return kaffee.getBeschreibung() + ", Milch";
    }

    @Override
    public double getPreis() {
        return kaffee.getPreis() + 0.50;
    }
}
