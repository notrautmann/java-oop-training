/**
 * 
 */
package java_examples_alex;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;

/**
 * Demo entry class for the Bridge pattern example, connecting {@link Fernbedienung}
 * abstractions with {@link Geraet} implementations.
 */
public class Bridge_Main {

	/**
	 * Demo entry point showcasing the Bridge pattern wiring between Fernbedienung and Geraet.
	 * @param args the command-line arguments
	 */
	public static void ___main(String[] args) {
		
		
		
		class Fernseher implements Geraet {
		    @Override
		    public void einschalten() {
		        System.out.println("Fernseher eingeschaltet");
		    }

		    @Override
		    public void ausschalten() {
		        System.out.println("Fernseher ausgeschaltet");
		    }

		    @Override
		    public void lautstaerkeErhoehen() {
		        System.out.println("Fernseher Lautstärke erhöht");
		    }

		    @Override
		    public void lautstaerkeVerringern() {
		        System.out.println("Fernseher Lautstärke verringert");
		    }
		}
		
		class Radio implements Geraet {
		    @Override
		    public void einschalten() {
		        System.out.println("Radio eingeschaltet");
		    }

		    @Override
		    public void ausschalten() {
		        System.out.println("Radio ausgeschaltet");
		    }

		    @Override
		    public void lautstaerkeErhoehen() {
		        System.out.println("Radio Lautstärke erhöht");
		    }

		    @Override
		    public void lautstaerkeVerringern() {
		        System.out.println("Radio Lautstärke verringert");
		    }
		}		
		
		class EinfacheFernbedienung extends Fernbedienung {

		    /**
		     * Creates a simple remote control bound to the given device.
		     * @param geraet the device implementation to control
		     */
		    public EinfacheFernbedienung(Geraet geraet) {
		        super(geraet);
		    }

		    @Override
		    public void einschalten() {
		        geraet.einschalten();
		    }

		    @Override
		    public void ausschalten() {
		        geraet.ausschalten();
		    }

		    @Override
		    public void lauter() {
		        geraet.lautstaerkeErhoehen();
		    }

		    @Override
		    public void leiser() {
		        geraet.lautstaerkeVerringern();
		    }
		}
		
		 
		        Geraet fernseher = new Fernseher();
		        Fernbedienung fb1 = new EinfacheFernbedienung(fernseher);
		        fb1.einschalten();
		        fb1.lauter();

		        System.out.println("---");

		        Geraet radio = new Radio();
		        Fernbedienung fb2 = new EinfacheFernbedienung(radio);
		        fb2.einschalten();
		        fb2.leiser();
		   
		}
    }

	

	 
	  
	




