package state_example;

public class Gelb implements AmpelZustand {
    @Override
    public void weiter(AmpelContext context) {
        context.setZustand(new Rot());
    }

    @Override
    public String getFarbe() {
        return "Gelb";
    }
}
