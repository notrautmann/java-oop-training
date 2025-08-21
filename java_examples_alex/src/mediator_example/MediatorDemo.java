package mediator_example;

public class MediatorDemo {
	public static void run() {
        ChatMediator chat = new ChatMediator();

        Benutzer alice = new Benutzer("Alice", chat);
        Benutzer bob = new Benutzer("Bob", chat);
        Benutzer carol = new Benutzer("Carol", chat);

        chat.registriereBenutzer(alice);
        chat.registriereBenutzer(bob);
        chat.registriereBenutzer(carol);

        alice.sende("Hallo zusammen!");
    }
}
