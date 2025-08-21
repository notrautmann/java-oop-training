package java_examples_alex;

public class BaumTyp {
    private String name;
    private String farbe;
    private String textur;

    public BaumTyp(String name, String farbe, String textur) {
        this.name = name;
        this.farbe = farbe;
        this.textur = textur;
    }

    public void zeichne(int x, int y) {
        System.out.println("Zeichne " + name + " in " + farbe + " bei (" + x + ", " + y + ")");
    }
}
