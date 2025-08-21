package event_example;

import java.util.*;

// Event-Quelle mit Listener-Verwaltung
/**
 * Event source that manages TemperatureChangeListeners and emits events when
 * the internal temperature changes.
 */
public class Thermometer {
    private final List<TemperatureChangeListener> listeners = new ArrayList<>();
    private double temperature;

    /**
     * Registers a listener that will be notified when the temperature changes.
     *
     * @param listener the listener to add
     */
    public void addTemperatureChangeListener(TemperatureChangeListener listener) {
        listeners.add(listener);
    }

    /**
     * Sets the current temperature; if it differs from the previous value,
     * notifies all registered listeners.
     *
     * @param temp the new temperature value
     */
    public void setTemperature(double temp) {
        if (temp != this.temperature) {
            this.temperature = temp;
            notifyListeners();
        }
    }

    /**
     * Notifies all registered listeners of the current temperature value.
     */
    private void notifyListeners() {
        TemperatureChangeEvent event = new TemperatureChangeEvent(this, temperature);
        for (TemperatureChangeListener l : listeners) {
            l.temperatureChanged(event);
        }
    }
}
