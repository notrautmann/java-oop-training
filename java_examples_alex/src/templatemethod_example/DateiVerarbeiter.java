package templatemethod_example;

public abstract class DateiVerarbeiter {
    public final void verarbeiteDatei() {
        oeffneDatei();
        leseDaten();
        verarbeiteDaten();
        schliesseDatei();
    }

    private void oeffneDatei() {
        System.out.println("Datei wird geöffnet...");
    }

    private void schliesseDatei() {
        System.out.println("Datei wird geschlossen.");
    }

    protected abstract void leseDaten();
    protected abstract void verarbeiteDaten();
}
