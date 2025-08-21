package event_example;

import java.util.*;

// Event-Quelle mit Listener-Verwaltung
public class Thermometer {
    private final List<TemperatureChangeListener> listeners = new ArrayList<>();
    private double temperature;

    public void addTemperatureChangeListener(TemperatureChangeListener listener) {
        listeners.add(listener);
    }

    public void setTemperature(double temp) {
        if (temp != this.temperature) {
            this.temperature = temp;
            notifyListeners();
        }
    }

    private void notifyListeners() {
        TemperatureChangeEvent event = new TemperatureChangeEvent(this, temperature);
        for (TemperatureChangeListener l : listeners) {
            l.temperatureChanged(event);
        }
    }
}