package strategy_examples;

public class Einkaufswagen {
    private Zahlungsstrategie strategie;

    public void setStrategie(Zahlungsstrategie strategie) {
        this.strategie = strategie;
    }

    public void bezahle(int betrag) {
        if (strategie == null) {
            System.out.println("Keine Zahlungsstrategie gewählt!");
        } else {
            strategie.zahle(betrag);
        }
    }
}
