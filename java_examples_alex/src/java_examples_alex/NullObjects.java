package java_examples_alex;

import java.util.Objects;

public class NullObjects {
	
	public static void run() {
		
		class Person {
		    private String name;

		    public Person(String name) {
		        this.name = Objects.requireNonNull(name, "Name darf nicht null sein");
		    }

		    @Override
		    public boolean equals(Object o) {
		        if (this == o) return true;
		        if (!(o instanceof Person)) return false;
		        Person person = (Person) o;
		        return Objects.equals(name, person.name);
		    }

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
