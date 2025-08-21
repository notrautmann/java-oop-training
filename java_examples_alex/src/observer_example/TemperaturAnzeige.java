package observer_example;

public class TemperaturAnzeige implements WetterBeobachter {
    private String name;

    public TemperaturAnzeige(String name) {
        this.name = name;
    }

    @Override
    public void aktualisieren(float temperatur) {
        System.out.println(name + " zeigt neue Temperatur an: " + temperatur + "°C");
    }
}
