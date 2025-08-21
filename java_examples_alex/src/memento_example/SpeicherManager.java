package memento_example;

//Caretaker: verwaltet gespeicherte Zustände
import java.util.Stack;

public class SpeicherManager {
 private Stack<TextMemento> speicher = new Stack<>();

 public void sichern(TextMemento memento) {
     speicher.push(memento);
 }

 public TextMemento rueckgaengig() {
     if (!speicher.isEmpty()) {
         return speicher.pop();
     }
     return null;
 }
}
