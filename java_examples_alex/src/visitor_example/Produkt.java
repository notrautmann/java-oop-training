package visitor_example;

public interface Produkt {
    void akzeptiere(VersandVisitor visitor);
}
