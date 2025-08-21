package java_examples_alex;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class __Main {
/*
	private static final int ANZ_MA = 3;
	  
	  public static void main2(String[] args)
	  {
		  Mitarbeiter[] ma = new Mitarbeiter[ANZ_MA];
	    ma[0] = new Manager(65000d, 5d, 1500000d);
	    ma[1] = new Arbeiter(20d,40d*52d);
	    ma[2] = new Angestellter(50000d, 5000d);	    
        double bruttosumme = 0.0;
	    for (int i=0; i<ma.length; ++i) {
	    	double brutto = 	    	ma[i].berechneMonatsBrutto();
	    	System.out.println(ma[i].getClass().getName() + " Brutto = " +brutto);
	    	
	      bruttosumme += brutto;
	    }
	    System.out.println("Bruttosumme = "+bruttosumme);
	  }
	  
	  public static long ermittleBenoetigteFlaeche(Groesse g)
	     {
	       return (long)g.laenge() * g.breite();
	     }
	   
	     public static void main(String[] args)
	     {
	       
	       Mensch mensch = new Mensch ();
	       mensch.koerpergroesse = 180;
	       mensch.schulterbreite = 50;
	       FussballPlatz platz = new FussballPlatz();
	       System.out.println("Mensch: " + ermittleBenoetigteFlaeche(mensch));
	       System.out.println("Platz: " + ermittleBenoetigteFlaeche(platz));
	     }
}
interface Groesse 
{ 
	int laenge(); 
    int breite(); 
} 

interface Bewegung 
{ 
	boolean vorwaerts(); 
    boolean rueckwaerts(); 
} 

class Auto
implements Groesse, Bewegung
{
  public String name;
  public int    koerpergroesse;
  public int    schulterbreite;
  public int position;
  public int laenge;
  public int breite;
  public int hoehe;

  public int laenge()
  {
    return this.laenge;
  }

  public int breite()
  {
    return this.breite;
  }
	
	public boolean vorwaerts() {
position++;
		return true;
	}	
	
	public boolean rueckwaerts() {
		if (position <= 0)
		{return false;}
		position--;
		return true;
	}
}


class FussballPlatz
 implements Groesse
 {
   public int laenge()
   {
     return 10500;
   }
  
   public int breite()
   {
     return 7500;
   }
}

 class Mensch
 implements Groesse
 {
   public String name;
   public int    koerpergroesse;
   public int    schulterbreite;

   public int laenge()
   {
     return this.koerpergroesse;
   }

   public int breite()
   {
     return this.schulterbreite;
   }
 }
 
 interface EinDimensional
 {
   public int laenge();
 }

 interface ZweiDimensional
 extends EinDimensional
 {
   public int breite();
 }

 interface DreiDimensional
 extends ZweiDimensional
 {
   public int hoehe();
 }

 interface VierDimensional
 extends DreiDimensional
 {
   public int lebensdauer();
 }

 class Test
 implements VierDimensional
 {
   public int laenge() { return 0; }
   public int breite() { return 0; }
   public int hoehe() { return 0; }
   public int lebensdauer() { return 0; }
 }
 
 
//BAD: Poor naming, interface too broad, unnecessary method
interface IThing {
  void doStuff();
  void printAllData();
  void connectToDatabase(); // Why should every "Thing" connect to a database?
}

//Class forced to implement unrelated behavior
class Book implements IThing {
  public void doStuff() {
      System.out.println("Reading book...");
  }

  public void printAllData() {
      System.out.println("Title, Author, Pages...");
  }

  public void connectToDatabase() {
      // HACK: Unrelated to Book, but forced to implement
      throw new UnsupportedOperationException("Book doesn't use database");
  }
  
  public static long berechneFlaeche(Object obj)
  {
     long flaeche = 0;
     if (obj instanceof Groesse) {
       Groesse groesse = (Groesse)obj; 
       flaeche = (long)groesse.laenge() * groesse.breite();
     }
     return flaeche;
  }
}

class papapapa implements Comparable {

	@Override
	public int compareTo(Object o) {
		// TODO Auto-generated method stub
		return 0;
	}
}

interface Auslieferbar 
{
	static final double Release = 7.5d;   
}

class App implements Auslieferbar
{
	public int test1;
	
	public void Test(int test1) {
	      System.out.println(Release);
	      
	      
	  }
}


class Constants 
{
	static final double Release = 7.5d;   
}

class App2
{
	public void Test() {
	      System.out.println(Constants.Release);
	  }
}


interface Fibuuebergebbar 
{
	default void uebergebe() 
	{
		System.out.println("Ausgabe");
	};
}

*/
/*


static void fillList(List<String> list)
{
    for (int i = 0; i < 10; ++i) {
      list.add("" + i);
    }
    list.remove(3);
    list.remove("5");
  }

  static void printList(List<String> list)
  {
    for (int i = 0; i < list.size(); ++i) {
      System.out.println((String)list.get(i));
    }
    System.out.println("---");
  }

  public static void main(String[] args)
  {
	  Level a = Level.LOW;
	  switch (a) {
	case HIGH:
		break;
	case LOW:
		break;
	case MEDIUM:
		break;
	default:
		break;
	  
	  }
	  
	  
	  	    System.out.println(Level.MEDIUM.getValue());
	  	    
	  	  for (Level lvl : Level.values()) {
	  		  System.out.println(lvl);
	  		}
	  	System.out.println(Level.MEDIUM.getValue());
	  }
  
  public enum Level {
	    LOW(1), MEDIUM(2), HIGH(3);

	    private final int value;
	    Level(int value) { this.value = value; }
	    public int getValue() { return value; }
	}

  


	

		
		  public static void main(String[] args) {
			  int i, j, base = 0;
			       String[] numbers = new String[3];
			   
			       numbers[0] = "10";
			       numbers[1] = "20";
			       numbers[2] = "30";
			       try {
			         for (base = 10; base >= 2; --base) {
			           for (j = 0; j <= 3; ++j) {
			             i = Integer.parseInt(numbers[j],base);
			             System.out.println(
			               numbers[j]+" base "+base+" = "+i
			             );
			             throw new Exception();
			           }
			         }
			       } catch (IndexOutOfBoundsException e1) {
			         System.out.println(
			           "***IndexOutOfBoundsException: " + e1.toString()
			         );
			       } catch (NumberFormatException e2) {
			         System.out.println(
			           "***NumberFormatException: " + e2.toString()
			         );
			       }
			       finally 
			       {
			       }
			       }
		  }
		    */
	
	public static void main(String[] args) {
        new FibuExample().showFibu();
    }
		  
		
}






 
 
