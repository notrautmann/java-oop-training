package java_examples_alex;

/**
 * A concrete Dokument implementation representing a simple report with a title and content.
 * Supports cloning to create a copy with the same field values.
 */
public class Bericht implements Dokument {
 private String titel;
 private String inhalt;

 /**
  * Creates a new Bericht instance.
  * @param titel the report title
  * @param inhalt the report content
  */
 public Bericht(String titel, String inhalt) {
     this.titel = titel;
     this.inhalt = inhalt;
 }

 /**
  * Creates a copy of this Bericht with identical field values.
  * @return a new Bericht with the same title and content
  */
 @Override
 public Bericht klonen() {
     return new Bericht(this.titel, this.inhalt);
 }

 /**
  * Prints the report title and content to standard output.
  */
 @Override
 public void anzeigen() {
     System.out.println("Bericht: " + titel);
     System.out.println("Inhalt: " + inhalt);
 }
}
