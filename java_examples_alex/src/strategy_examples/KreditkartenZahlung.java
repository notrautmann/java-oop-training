package strategy_examples;

public class KreditkartenZahlung implements Zahlungsstrategie {
    private String kartennummer;

    public KreditkartenZahlung(String kartennummer) {
        this.kartennummer = kartennummer;
    }

    @Override
    public void zahle(int betrag) {
        System.out.println(betrag + "€ mit Kreditkarte bezahlt (Karte: " + kartennummer + ")");
    }
}
