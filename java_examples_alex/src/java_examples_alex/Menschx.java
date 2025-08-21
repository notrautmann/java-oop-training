package java_examples_alex;

import java.time.LocalDate;

/**
 * Simple demo class representing a person with name and year of birth,
 * providing basic age calculations for different target years.
 */
public class Menschx {
	
	public String name;
	public int geburtsjahr;
	
	/**
	 * Creates a new Menschx instance.
	 */
	public Menschx() 
	{
		
	}
	
	/**
	 * Creates a new Menschx with the given name.
	 * @param name the person's name
	 */
	public Menschx(String name) 
	{
		this();
		this.name = name;
	}
	
	/**
	 * Creates a new Menschx with the given name and year of birth.
	 * @param name the person's name
	 * @param geburtsjahr the year of birth
	 */
	public Menschx(String name, int geburtsjahr) 
	{
		this(name);
		this.geburtsjahr = geburtsjahr;
	}
	 
	   /**
	    * Calculates the current age based on the current year.
	    * @return the computed age
	    */
	   public int alter()
	   {
	     return alter(LocalDate.now().getYear());
	   }
	   
	   /**
	    * Calculates the age in the specified target year.
	    * @param zieljahr the target year
	    * @return the computed age for the target year
	    */
	   public int alter(int zieljahr)
	   {
	     return zieljahr - geburtsjahr;
	   }
	   
	   /**
	    * Overloaded example method for age calculation with an extra parameter.
	    * @param zieljahr the target year
	    * @param test an additional parameter for demonstration
	    * @return the result
	    */
	   public int alter(int zieljahr, int test)
	   {
	     return 0;
	   }
	   
	   /**
	    * Overloaded example method accepting the target year as a string.
	    * @param zieljahr the target year as a string
	    * @return the result
	    */
	   public int alter(String zieljahr)
	   {
	     return geburtsjahr;
	   }

}
