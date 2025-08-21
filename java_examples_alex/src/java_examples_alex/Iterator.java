package java_examples_alex;

/**
 * Minimal iterator abstraction for sequential access to a collection of elements.
 */
public interface Iterator {
    /**
     * Indicates whether another element is available.
     * @return {@code true} if there is a next element; {@code false} otherwise
     */
    boolean hasNext();

    /**
     * Returns the next element in the sequence.
     * @return the next element
     * @throws java.util.NoSuchElementException if no next element exists
     */
    Object next();
}
