package java_examples_alex;

/**
 * Demo class representing a simple bookshelf holding books and providing an iterator.
 */
public class Buecherregal {
    private Buch[] buecher;
    private int index = 0;

    /**
     * Creates a new bookshelf with a fixed capacity.
     * @param groesse the maximum number of books
     */
    public Buecherregal(int groesse) {
        buecher = new Buch[groesse];
    }

    /**
     * Adds a book to the shelf if capacity allows.
     * @param buch the book to add
     */
    public void buchHinzufuegen(Buch buch) {
        if (index < buecher.length) {
            buecher[index++] = buch;
        }
    }

    /**
     * Returns an iterator over the books in this shelf.
     * @return an iterator for traversing the stored books
     */
    public Iterator iterator() {
        return new BuecherregalIterator(buecher);
    }
}
