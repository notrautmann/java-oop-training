package java_examples_alex;

class Superklasse {
    void zeigeInstanz() {
        System.out.println("Instanzmethode der Superklasse");
    }
    
    void zeigeVerdecken() {
    	System.out.println("zeigeVerdecken der Superklasse");
    }
}

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