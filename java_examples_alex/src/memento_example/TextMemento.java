package memento_example;

//Memento: speichert den Zustand
public class TextMemento {
 private final String text;

 public TextMemento(String text) {
     this.text = text;
 }

 public String getText() {
     return text;
 }
}
