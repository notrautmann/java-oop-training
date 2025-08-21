package state_example;

public class StateDemo {
	public static void run() {
        AmpelContext ampel = new AmpelContext();

        for (int i = 0; i < 6; i++) {
            ampel.aktuelleFarbe();
            ampel.weiter();
        }
    }
}
