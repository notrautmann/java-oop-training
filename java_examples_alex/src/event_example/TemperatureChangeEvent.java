package event_example;

import java.util.EventObject;

// Eigene Eventklasse
public class TemperatureChangeEvent extends EventObject {
    private final double newTemperature;

    public TemperatureChangeEvent(Object source, double newTemp) {
        super(source);
        this.newTemperature = newTemp;
    }

    public double getNewTemperature() {
        return newTemperature;
    }
}
