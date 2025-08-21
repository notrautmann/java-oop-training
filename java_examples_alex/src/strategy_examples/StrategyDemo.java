package strategy_examples;

public class StrategyDemo {
	public static void run() {
        Einkaufswagen wagen = new Einkaufswagen();

        wagen.setStrategie(new PaypalZahlung("kunde@example.com"));
        wagen.bezahle(50);

        wagen.setStrategie(new KreditkartenZahlung("1234-5678-9012-3456"));
        wagen.bezahle(100);
    }
}
