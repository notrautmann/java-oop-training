package java_examples_alex;

public class Box<T> {
	  T value; // T is a placeholder for any data type

	  void set(T value) {
	    this.value = value;
	  }

	  T get() {
	    return value;
	  }
	}
