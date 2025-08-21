package java_examples_alex;

import java.time.LocalDate;

public class Menschx {
	
	public String name;
	public int geburtsjahr;
	
	public Menschx() 
	{
		
	}
	
	public Menschx(String name) 
	{
		this();
		this.name = name;
	}
	
	public Menschx(String name, int geburtsjahr) 
	{
		this(name);
		this.geburtsjahr = geburtsjahr;
	}
	 
	   public int alter()
	   {
	     return alter(LocalDate.now().getYear());
	   }
	   
	   public int alter(int zieljahr)
	   {
	     return zieljahr - geburtsjahr;
	   }
	   
	   public int alter(int zieljahr, int test)
	   {
	     return 0;
	   }
	   
	   public int alter(String zieljahr)
	   {
	     return geburtsjahr;
	   }

}