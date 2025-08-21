package java_examples_alex;

//1. Interface mit clone-Methode
/**
 * Simple document abstraction that supports cloning and displaying itself.
 */
public interface Dokument extends Cloneable {
Dokument klonen();
void anzeigen();
}
