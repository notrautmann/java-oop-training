package event_example;

/**
 * Demonstrates the event/listener pattern with a Thermometer and a TemperatureChangeListener.
 */
public class EventDemo {
    /**
     * Runs the demo by creating a Thermometer, registering a listener, and changing the temperature.
     */
    public static void run() {
        Thermometer thermo = new Thermometer();
        
        thermo.addTemperatureChangeListener(event -> {
            System.out.println("Neue Temperatur: " + event.getNewTemperature());
        });

        thermo.setTemperature(22.5);
        thermo.setTemperature(25.0);
    }
}
