package java_examples_alex;

public abstract class SupportHandler {
    protected SupportHandler naechsterHandler;

    public void setNaechsterHandler(SupportHandler handler) {
        this.naechsterHandler = handler;
    }

    public abstract void bearbeiteAnfrage(String anfrage);
}
