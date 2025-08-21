package java_examples_alex;

/**
 * Represents a tree type (flyweight) characterized by name, color, and texture.
 * Instances of this type can be reused to reduce memory consumption.
 */
public class BaumTyp {
    private String name;
    private String farbe;
    private String textur;

    /**
     * Creates a new tree type.
     * @param name the tree name
     * @param farbe the color
     * @param textur the texture description
     */
    public BaumTyp(String name, String farbe, String textur) {
        this.name = name;
        this.farbe = farbe;
        this.textur = textur;
    }

    /**
     * Draws a tree of this type at the given coordinates.
     * @param x the x position
     * @param y the y position
     */
    public void zeichne(int x, int y) {
        System.out.println("Zeichne " + name + " in " + farbe + " bei (" + x + ", " + y + ")");
    }
}
