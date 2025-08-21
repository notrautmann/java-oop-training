package java_examples_alex;

public class BuecherregalIterator implements Iterator {
    private Buch[] buecher;
    private int position = 0;

    public BuecherregalIterator(Buch[] buecher) {
        this.buecher = buecher;
    }

    public boolean hasNext() {
        return position < buecher.length && buecher[position] != null;
    }

    public Object next() {
        return buecher[position++];
    }
}
