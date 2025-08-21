package state_example;

public class Rot implements AmpelZustand {
    @Override
    public void weiter(AmpelContext context) {
        context.setZustand(new Gruen());
    }

    @Override
    public String getFarbe() {
        return "Rot";
    }
}