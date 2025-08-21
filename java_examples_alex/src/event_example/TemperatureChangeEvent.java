package event_example;

import java.util.EventObject;

// Eigene Eventklasse
/**
 * Event representing a temperature change emitted by a Thermometer.
 */
public class TemperatureChangeEvent extends EventObject {
    private final double newTemperature;

    /**
     * Creates a new TemperatureChangeEvent.
     *
     * @param source the event source
     * @param newTemp the new temperature value
     */
    public TemperatureChangeEvent(Object source, double newTemp) {
        super(source);
        this.newTemperature = newTemp;
    }

    /**
     * Returns the new temperature value carried by this event.
     *
     * @return the new temperature
     */
    public double getNewTemperature() {
        return newTemperature;
    }
}
