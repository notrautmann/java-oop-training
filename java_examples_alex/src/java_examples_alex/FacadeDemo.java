package java_examples_alex;

/**
 * Demo class showcasing the Facade design pattern by orchestrating a simple home theater setup.
 */
public class FacadeDemo {
	
	
	/**
	 * Starts the facade demo by orchestrating the home theater components.
	 */
	public static void start() {
		
		class DVDPlayer {
		    public void einschalten() {
		        System.out.println("DVD-Player eingeschaltet");
		    }
		    public void abspielen(String film) {
		        System.out.println("Spiele Film ab: " + film);
		    }
		    public void ausschalten() {
		        System.out.println("DVD-Player ausgeschaltet");
		    }
		}

		class Projektor {
		    public void einschalten() {
		        System.out.println("Projektor eingeschaltet");
		    }
		    public void ausschalten() {
		        System.out.println("Projektor ausgeschaltet");
		    }
		}

		class Soundsystem {
		    public void einschalten() {
		        System.out.println("Soundsystem eingeschaltet");
		    }
		    public void ausschalten() {
		        System.out.println("Soundsystem ausgeschaltet");
		    }
		}

		class Beleuchtung {
		    public void dimmen(int prozent) {
		        System.out.println("Licht gedimmt auf " + prozent + "%");
		    }
		}
		
		class HeimkinoFassade {
		    private DVDPlayer dvdPlayer;
		    private Projektor projektor;
		    private Soundsystem soundsystem;
		    private Beleuchtung beleuchtung;

		    public HeimkinoFassade(DVDPlayer dvd, Projektor proj, Soundsystem sound, Beleuchtung light) {
		        this.dvdPlayer = dvd;
		        this.projektor = proj;
		        this.soundsystem = sound;
		        this.beleuchtung = light;
		    }

		    public void abendStarten(String film) {
		        System.out.println("Heimkino wird vorbereitet...\n");
		        beleuchtung.dimmen(20);
		        projektor.einschalten();
		        soundsystem.einschalten();
		        dvdPlayer.einschalten();
		        dvdPlayer.abspielen(film);
		    }

		    public void abendBeenden() {
		        System.out.println("\nHeimkino wird heruntergefahren...");
		        dvdPlayer.ausschalten();
		        projektor.ausschalten();
		        soundsystem.ausschalten();
		        beleuchtung.dimmen(100);
		    }
		}
		
		
        DVDPlayer dvd = new DVDPlayer();
        Projektor projektor = new Projektor();
        Soundsystem sound = new Soundsystem();
        Beleuchtung licht = new Beleuchtung();

        HeimkinoFassade kino = new HeimkinoFassade(dvd, projektor, sound, licht);

        kino.abendStarten("Der Pate");
        kino.abendBeenden();
    }
}
