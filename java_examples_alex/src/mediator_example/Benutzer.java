package mediator_example;

public class Benutzer {
    private String name;
    private ChatMediator mediator;

    public Benutzer(String name, ChatMediator mediator) {
        this.name = name;
        this.mediator = mediator;
    }

    public void sende(String nachricht) {
        System.out.println(this.name + " sendet: " + nachricht);
        mediator.sendeNachricht(nachricht, this);
    }

    public void empfange(String nachricht) {
        System.out.println(this.name + " empfängt: " + nachricht);
    }
}
