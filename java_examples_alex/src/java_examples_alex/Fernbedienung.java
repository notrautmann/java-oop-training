package java_examples_alex;

public abstract class Fernbedienung {
    protected Geraet geraet;

    public Fernbedienung(Geraet geraet) {
        this.geraet = geraet;
    }

    public abstract void einschalten();
    public abstract void ausschalten();
    public abstract void lauter();
    public abstract void leiser();
}
