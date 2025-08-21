package java_examples_alex;

/**
 * Iterator over a collection of {@link Buch} elements in a bookshelf-like array.
 * Provides sequential access, skipping trailing null entries.
 */
public class BuecherregalIterator implements Iterator {
    private Buch[] buecher;
    private int position = 0;

    /**
     * Creates an iterator over the provided array of books.
     * @param buecher the array of {@link Buch} elements (may contain trailing nulls)
     */
    public BuecherregalIterator(Buch[] buecher) {
        this.buecher = buecher;
    }

    /**
     * Indicates whether another non-null book is available.
     * @return {@code true} if a next element exists; {@code false} otherwise
     */
    public boolean hasNext() {
        return position < buecher.length && buecher[position] != null;
    }

    /**
     * Returns the next available book in the sequence.
     * @return the next {@link Buch}
     */
    public Object next() {
        return buecher[position++];
    }
}
