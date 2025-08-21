package java_examples_alex;

//2. Konkrete Klasse, die klonbar ist
public class Bericht implements Dokument {
 private String titel;
 private String inhalt;

 public Bericht(String titel, String inhalt) {
     this.titel = titel;
     this.inhalt = inhalt;
 }

 @Override
 public Bericht klonen() {
     return new Bericht(this.titel, this.inhalt);
 }

 @Override
 public void anzeigen() {
     System.out.println("Bericht: " + titel);
     System.out.println("Inhalt: " + inhalt);
 }
}
