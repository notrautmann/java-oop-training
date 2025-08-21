package java_examples_alex;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

/**
 * Demo for the Flyweight pattern using reusable tree types and a simple forest.
 */
public class FlyweightDemo {
/**
	 * Runs the Flyweight pattern demo by creating a forest and rendering it.
	 */
	public static void run() {
		
		class BaumFabrik {
		    private static final Map<String, BaumTyp> baumTypen = new HashMap<>();

		    /**
		     * Returns a shared BaumTyp instance for the given attributes, creating it if necessary.
		     * @param name the tree type name
		     * @param farbe the color
		     * @param textur the texture description
		     * @return a shared {@code BaumTyp} for the key composed of name, color, and texture
		     */
		    public static BaumTyp gibBaumTyp(String name, String farbe, String textur) {
		        String schluessel = name + "-" + farbe + "-" + textur;
		        if (!baumTypen.containsKey(schluessel)) {
		            baumTypen.put(schluessel, new BaumTyp(name, farbe, textur));
		            System.out.println("Erzeuge neuen BaumTyp: " + schluessel);
		        }
		        return baumTypen.get(schluessel);
		    }
		}
		
		class Baum {
		    private int x;
		    private int y;
		    private BaumTyp typ;

		    /**
		     * Creates a new tree at the given coordinates using the provided tree type.
		     * @param x the x coordinate
		     * @param y the y coordinate
		     * @param typ the shared tree type
		     */
		    public Baum(int x, int y, BaumTyp typ) {
		        this.x = x;
		        this.y = y;
		        this.typ = typ;
		    }

		    /**
		     * Draws this tree using its shared type at its coordinates.
		     */
		    public void zeichne() {
		        typ.zeichne(x, y);
		    }
		}
		

		class Wald {
		    private List<Baum> baeume = new ArrayList<>();

		    /**
		     * Plants a tree in the forest, reusing an existing {@code BaumTyp} if available.
		     * @param x the x coordinate
		     * @param y the y coordinate
		     * @param name the tree type name
		     * @param farbe the color
		     * @param textur the texture description
		     */
		    public void pflanzeBaum(int x, int y, String name, String farbe, String textur) {
		        BaumTyp typ = BaumFabrik.gibBaumTyp(name, farbe, textur);
		        Baum baum = new Baum(x, y, typ);
		        baeume.add(baum);
		    }

		    /**
		     * Renders all trees in the forest.
		     */
		    public void zeichneWald() {
		        for (Baum b : baeume) {
		            b.zeichne();
		        }
		    }
		}
		
        Wald wald = new Wald();

        // Viele Bäume derselben Art
        for (int i = 0; i < 5; i++) {
            wald.pflanzeBaum(i * 10, i * 5, "Eiche", "Grün", "Rau");
        }

        // Andere Baumart
        for (int i = 0; i < 3; i++) {
            wald.pflanzeBaum(i * 8, i * 4, "Kiefer", "Dunkelgrün", "Glatt");
        }

        wald.zeichneWald();
    }
}
