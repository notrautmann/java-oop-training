package java_examples_alex;

public class Buecherregal {
    private Buch[] buecher;
    private int index = 0;

    public Buecherregal(int groesse) {
        buecher = new Buch[groesse];
    }

    public void buchHinzufuegen(Buch buch) {
        if (index < buecher.length) {
            buecher[index++] = buch;
        }
    }

    public Iterator iterator() {
        return new BuecherregalIterator(buecher);
    }
}
