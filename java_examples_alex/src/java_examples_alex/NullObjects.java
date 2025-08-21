package java_examples_alex;

import java.util.Objects;

/**
 * Demo class illustrating null-safety and the use of Objects utility methods.
 */
public class NullObjects {
	
	/**
	 * Runs the null-safety demo.
	 */
	public static void run() {
		
		class Person {
		    private String name;

		    /**
		     * Creates a new Person.
		     * @param name the person's name, must not be {@code null}
		     */
		    public Person(String name) {
		        this.name = Objects.requireNonNull(name, "Name darf nicht null sein");
		    }

		    /**
		     * Indicates whether some other object is equal to this one.
		     * @param o the object to compare
		     * @return {@code true} if equal; {@code false} otherwise
		     */
		    @Override
		    public boolean equals(Object o) {
		        if (this == o) return true;
		        if (!(o instanceof Person)) return false;
		        Person person = (Person) o;
		        return Objects.equals(name, person.name);
		    }

		    /**
		     * Returns a hash code value for the object.
		     * @return the hash code
		     */
		    @Override
		    public int hashCode() {
		        return Objects.hash(name);
		    }
		    	    
		}
		try {
		    Person person = new Person(null);
		    }
		    catch (NullPointerException nex) {
		    	System.out.println(nex);
		    }
	}

}
