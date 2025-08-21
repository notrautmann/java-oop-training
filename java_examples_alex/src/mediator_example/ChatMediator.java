package mediator_example;

import java.util.ArrayList;
import java.util.List;

public class ChatMediator {
    private List<Benutzer> benutzerListe = new ArrayList<>();

    public void registriereBenutzer(Benutzer benutzer) {
        benutzerListe.add(benutzer);
    }

    public void sendeNachricht(String nachricht, Benutzer sender) {
        for (Benutzer benutzer : benutzerListe) {
            if (benutzer != sender) {
                benutzer.empfange(nachricht);
            }
        }
    }
}
