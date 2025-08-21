package observer_example;

public class ObserverDemo {
    public static void run() {
        Wetterstation station = new Wetterstation();

        TemperaturAnzeige anzeige1 = new TemperaturAnzeige("Anzeige A");
        TemperaturAnzeige anzeige2 = new TemperaturAnzeige("Anzeige B");

        station.registrieren(anzeige1);
        station.registrieren(anzeige2);

        station.setTemperatur(22.5f);
        station.setTemperatur(25.0f);
    }
}
