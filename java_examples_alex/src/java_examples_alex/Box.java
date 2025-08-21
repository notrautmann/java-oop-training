package java_examples_alex;

/**
 * Simple generic container that holds a single value of type {@code T}.
 * @param <T> the type of the stored value
 */
public class Box<T> {
	  T value; // T is a placeholder for any data type

	  void set(T value) {
	    this.value = value;
	  }

	  T get() {
	    return value;
	  }
	}
