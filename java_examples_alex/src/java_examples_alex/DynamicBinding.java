package java_examples_alex;

/**
 * Demonstrates a superclass used for dynamic binding examples.
 */
class Superklasse {
    void zeigeInstanz() {
        System.out.println("Instanzmethode der Superklasse");
    }
    
    void zeigeVerdecken() {
    	System.out.println("zeigeVerdecken der Superklasse");
    }
}

/**
 * Subclass overriding methods to illustrate dynamic dispatch and method hiding.
 */
class Subklasse extends Superklasse {
    @Override
    void zeigeInstanz() {
        System.out.println("Instanzmethode der Subklasse");
    }

    @Override
    void zeigeVerdecken() {
        zeigeInstanz();
        super.zeigeInstanz();
    }
}
