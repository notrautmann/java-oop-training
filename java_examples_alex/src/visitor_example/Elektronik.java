package visitor_example;

public class Elektronik implements Produkt {
    private String name;
    private boolean istZerbrechlich;

    public Elektronik(String name, boolean istZerbrechlich) {
        this.name = name;
        this.istZerbrechlich = istZerbrechlich;
    }

    public String getName() {
        return name;
    }

    public boolean isZerbrechlich() {
        return istZerbrechlich;
    }

    @Override
    public void akzeptiere(VersandVisitor visitor) {
        visitor.besuche(this);
    }
}
