import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import static org.mockito.Mockito.*;
import static org.assertj.core.api.Assertions.*;

class PreisServiceTest {
	
	/**
	 * Testet, ob der PreisService für einen Testkunden einen Rabatt von 10 % korrekt anwendet.
	 *
	 * Erwartetes Verhalten:
	 * - Bei einem Basispreis von 200,00 € wird ein Rabatt von 10 % abgezogen.
	 * - Der Endpreis sollte somit 180,00 € betragen.
	 * - Es wird überprüft, ob ermittleKundenTyp(123) auf der Mock-Datenbankverbindung aufgerufen wurde.
	 */
	@Test
    void sollXProzentRabattGebenFuerBestandskunde() {
        Datenbankverbindung mockDbVerbindung = mock(Datenbankverbindung.class);
        when(mockDbVerbindung.ermittleKundenTyp(123)).thenReturn("TEST");

        PreisService service = new PreisService(mockDbVerbindung);
        double result = service.ermittleRabattierterPreis(123, 200.0);

        assertThat(result).isEqualTo(180.0);
        verify(mockDbVerbindung).ermittleKundenTyp(123);
    }
	

	/**
	 * Testet, ob der PreisService für einen Bestandskunden einen Rabatt von 10 % korrekt anwendet.
	 *
	 * Erwartetes Verhalten:
	 * - Bei einem Basispreis von 200,00 € wird ein Rabatt von 10 % abgezogen.
	 * - Der Endpreis sollte somit 180,00 € betragen.
	 * - Es wird überprüft, ob ermittleKundenTyp(123) auf der Mock-Datenbankverbindung aufgerufen wurde.
	 */
	@Test
    void soll10ProzentRabattGebenFuerBestandskunde() {
        Datenbankverbindung mockDbVerbindung = mock(Datenbankverbindung.class);
        when(mockDbVerbindung.ermittleKundenTyp(123)).thenReturn("Bestandskunde");

        PreisService service = new PreisService(mockDbVerbindung);
        double result = service.ermittleRabattierterPreis(123, 200.0);

        assertThat(result).isEqualTo(180.0);
        verify(mockDbVerbindung).ermittleKundenTyp(123);
    }
	
	/**
	 * Testet, ob der PreisService für einen Neukunden keinen Rabatt anwendet.
	 *
	 * Erwartetes Verhalten:
	 * - Der Basispreis von 100,00 € bleibt unverändert.
	 * - Kein Rabatt wird abgezogen.
	 * - Es wird überprüft, ob ermittleKundenTyp(456) auf der Mock-Datenbankverbindung aufgerufen wurde.
	 */
	@Test
    void sollKeinenRabattGebenFuerNeukunde() {
        Datenbankverbindung mockDbVerbindung = mock(Datenbankverbindung.class);
        when(mockDbVerbindung.ermittleKundenTyp(456)).thenReturn("Neukunde");

        PreisService service = new PreisService(mockDbVerbindung);
        double result = service.ermittleRabattierterPreis(456, 100.0);

        assertThat(result).isEqualTo(100.0);
        verify(mockDbVerbindung).ermittleKundenTyp(456);
    }
	
	
	
	
	
	
	@Test
	void sollExceptionWerfen() {
	    try {
	        // Diese Methode könnte eine Exception werfen
	        methodeDieExceptionWerfenKann();
	    } catch (Exception e) {
	        // Leerer Catch-Block – die Exception wird einfach ignoriert
	    }
	}
	
	
	@Test
	void testetNurDassMethodeLäuft() {
	    PreisService service = new PreisService(null);
	    service.ermittleRabattierterPreis(123, 100.0); 
	}
	
	
	
	
	
	
	
	
	
	
	
}
