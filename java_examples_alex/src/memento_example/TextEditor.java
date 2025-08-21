package memento_example;

//Originator: erstellt Mementos und stellt Zustand wieder her
public class TextEditor {
 private String inhalt = "";

 public void schreibe(String text) {
     inhalt += text;
 }

 public void anzeigen() {
     System.out.println("Aktueller Text: " + inhalt);
 }

 public TextMemento speichere() {
     return new TextMemento(inhalt);
 }

 public void wiederherstellen(TextMemento memento) {
     this.inhalt = memento.getText();
 }
}
