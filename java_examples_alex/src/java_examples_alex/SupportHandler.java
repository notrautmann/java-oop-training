package java_examples_alex;

/**
 * Abstract handler in a simple Chain of Responsibility for support requests.
 * Subclasses decide whether to handle an inquiry or forward it to the next handler.
 */
public abstract class SupportHandler {
    protected SupportHandler naechsterHandler;

    /**
     * Sets the next handler in the chain.
     * @param handler the next handler to forward requests to
     */
    public void setNaechsterHandler(SupportHandler handler) {
        this.naechsterHandler = handler;
    }

    public abstract void bearbeiteAnfrage(String anfrage);
}
