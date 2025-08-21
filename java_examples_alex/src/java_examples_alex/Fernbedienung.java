package java_examples_alex;

/**
 * Abstrakte Fernbedienung, die ein {@link Geraet} steuert.
 * Dient als Basisklasse für konkrete Fernbedienungen im Beispielcode.
 */
public abstract class Fernbedienung {
    protected Geraet geraet;

    /**
     * Erstellt eine neue Fernbedienung für das angegebene Gerät.
     * @param geraet das zu steuernde Gerät
     */
    public Fernbedienung(Geraet geraet) {
        this.geraet = geraet;
    }

    public abstract void einschalten();
    public abstract void ausschalten();
    public abstract void lauter();
    public abstract void leiser();
}
