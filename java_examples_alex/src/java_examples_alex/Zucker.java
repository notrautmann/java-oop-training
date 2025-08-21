package java_examples_alex;

public class Zucker extends KaffeeDecorator {
    public Zucker(Kaffee kaffee) {
        super(kaffee);
    }

    @Override
    public String getBeschreibung() {
        return kaffee.getBeschreibung() + ", Zucker";
    }

    @Override
    public double getPreis() {
        return kaffee.getPreis() + 0.20;
    }
}
