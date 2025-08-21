package state_example;

public interface AmpelZustand {
    void weiter(AmpelContext context);
    String getFarbe();
}
