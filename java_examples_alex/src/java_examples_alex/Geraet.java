package java_examples_alex;

/**
 * Abstraction for a generic device that can be switched on/off and adjust volume.
 */
public interface Geraet {
    /**
     * Switches the device on.
     */
    void einschalten();

    /**
     * Switches the device off.
     */
    void ausschalten();

    /**
     * Increases the device volume by one step or an implementation-defined amount.
     */
    void lautstaerkeErhoehen();

    /**
     * Decreases the device volume by one step or an implementation-defined amount.
     */
    void lautstaerkeVerringern();
}
