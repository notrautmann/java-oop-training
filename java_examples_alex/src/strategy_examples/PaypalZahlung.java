package strategy_examples;

public class PaypalZahlung implements Zahlungsstrategie {
    private String email;

    public PaypalZahlung(String email) {
        this.email = email;
    }

    @Override
    public void zahle(int betrag) {
        System.out.println(betrag + "€ mit PayPal bezahlt (Konto: " + email + ")");
    }
}
