package templatemethod_example;

public class TemplatemethodDemo {
	public static void run() {
        DateiVerarbeiter csv = new CSVVerarbeiter();
        DateiVerarbeiter xml = new XMLVerarbeiter();

        System.out.println("== CSV-Verarbeitung ==");
        csv.verarbeiteDatei();

        System.out.println("\n== XML-Verarbeitung ==");
        xml.verarbeiteDatei();
    }
}
