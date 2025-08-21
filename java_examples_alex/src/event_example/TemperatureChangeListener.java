package event_example;

// Listener-Interface
/**
 * Listener for receiving notifications when the temperature changes.
 */
public interface TemperatureChangeListener {
    /**
     * Invoked when the temperature changes.
     *
     * @param event the temperature change event
     */
    void temperatureChanged(TemperatureChangeEvent event);
}
