package state_example;

public class Gruen implements AmpelZustand {
    @Override
    public void weiter(AmpelContext context) {
        context.setZustand(new Gelb());
    }

    @Override
    public String getFarbe() {
        return "Grün";
    }
}

