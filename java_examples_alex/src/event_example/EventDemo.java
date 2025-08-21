package event_example;

public class EventDemo {
    public static void run() {
        Thermometer thermo = new Thermometer();
        
        thermo.addTemperatureChangeListener(event -> {
            System.out.println("Neue Temperatur: " + event.getNewTemperature());
        });

        thermo.setTemperature(22.5);
        thermo.setTemperature(25.0);
    }
}
