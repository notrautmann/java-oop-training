package visitor_example;

public interface VersandVisitor {
    void besuche(Buch buch);
    void besuche(Elektronik elektronik);
}
