package java_examples_alex;



import java.util.Date;

abstract class Mitarbeiter
{
  int persnr;
  String name;
  Date eintritt;

  public Mitarbeiter()
  {
  }
/**
 * Berechne super Sachen
 * @return
 */
  public abstract double berechneMonatsBrutto();
}

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
public double berechneMonatsBrutto()
  {
    return stundenlohn*anzahlstunden;
  }
}

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

  public double berechneMonatsBrutto()
  {
    return grundgehalt+           
    		bonus;
  }
}

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

  public double berechneMonatsBrutto()
  {
    return fixgehalt+          
           umsatz*provision/100;
  }
}


