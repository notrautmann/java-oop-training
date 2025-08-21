package java_examples_alex;

public abstract class KaffeeDecorator implements Kaffee {
    protected Kaffee kaffee;

    public KaffeeDecorator(Kaffee kaffee) {
        this.kaffee = kaffee;
    }
}
