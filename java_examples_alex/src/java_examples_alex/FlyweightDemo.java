package java_examples_alex;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

public class FlyweightDemo {
	public static void run() {
		
		class BaumFabrik {
		    private static final Map<String, BaumTyp> baumTypen = new HashMap<>();

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

		    public Baum(int x, int y, BaumTyp typ) {
		        this.x = x;
		        this.y = y;
		        this.typ = typ;
		    }

		    public void zeichne() {
		        typ.zeichne(x, y);
		    }
		}
		

		class Wald {
		    private List<Baum> baeume = new ArrayList<>();

		    public void pflanzeBaum(int x, int y, String name, String farbe, String textur) {
		        BaumTyp typ = BaumFabrik.gibBaumTyp(name, farbe, textur);
		        Baum baum = new Baum(x, y, typ);
		        baeume.add(baum);
		    }

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
