package memento_example;

public class MementoDemo {
	public static void run() {
        TextEditor editor = new TextEditor();
        SpeicherManager speicher = new SpeicherManager();

        editor.schreibe("Hallo");
        speicher.sichern(editor.speichere());

        editor.schreibe(" Welt!");
        speicher.sichern(editor.speichere());

        editor.schreibe(" Noch mehr Text...");
        editor.anzeigen();

        System.out.println("Rückgängig:");
        editor.wiederherstellen(speicher.rueckgaengig());
        editor.anzeigen();

        System.out.println("Nochmals Rückgängig:");
        editor.wiederherstellen(speicher.rueckgaengig());
        editor.anzeigen();
    }
}
