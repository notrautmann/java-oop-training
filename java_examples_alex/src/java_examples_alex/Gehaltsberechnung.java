package java_examples_alex;



import java.util.Date;

/**
 * Basisklasse für Mitarbeiter mit Personalnummer, Name und Eintrittsdatum.
 * Definiert die Schnittstelle zur Berechnung des monatlichen Bruttogehalts.
 */
abstract class Mitarbeiter
{
  int persnr;
  String name;
  Date eintritt;

  /**
   * Default constructor.
   */
  public Mitarbeiter()
  {
  }
/**
 * Berechne super Sachen
 * @return
 */
  public abstract double berechneMonatsBrutto();
}

/**
 * Konkrete Mitarbeiter-Art mit Vergütung auf Basis von Stundenlohn und -anzahl.
 */
class Arbeiter
extends Mitarbeiter
{
  double stundenlohn, anzahlstunden; 
  

  /**
 * @param stundenlohn
 * @param anzahlstunden
 */
public Arbeiter(double stundenlohn, double anzahlstunden) {
	super();
	this.stundenlohn = stundenlohn;
	this.anzahlstunden = anzahlstunden;
}

@Override 
  /**
   * Berechnet das monatliche Bruttogehalt.
   * @return das Bruttogehalt für den Monat
   */
public double berechneMonatsBrutto()
  {
    return stundenlohn*anzahlstunden;
  }
}

/**
 * Konkrete Mitarbeiter-Art mit festem Grundgehalt und variablem Bonus.
 */
class Angestellter
extends Mitarbeiter
{
  /**
	 * @param grundgehalt
	 * @param bonus
	 */
	public Angestellter(double grundgehalt, double bonus) {
		super();
		this.grundgehalt = grundgehalt;
		this.bonus = bonus;
	}

double grundgehalt;
  double bonus;

  /**
   * Berechnet das monatliche Bruttogehalt.
   * @return das Bruttogehalt für den Monat
   */
  public double berechneMonatsBrutto()
  {
    return grundgehalt+           
    		bonus;
  }
}

/**
 * Konkrete Mitarbeiter-Art mit fixem Gehalt und umsatzabhängiger Provision.
 */
class Manager
extends Mitarbeiter
{
  

/**
	 * @param fixgehalt
	 * @param provision
	 * @param umsatz
	 */
	public Manager(double fixgehalt, double provision, double umsatz) {
		super();
		this.fixgehalt = fixgehalt;
		this.provision = provision;
		this.umsatz = umsatz;
	}

double fixgehalt;
  double provision;
  double umsatz;

  /**
   * Berechnet das monatliche Bruttogehalt.
   * @return das Bruttogehalt für den Monat
   */
  public double berechneMonatsBrutto()
  {
    return fixgehalt+          
           umsatz*provision/100;
  }
}


