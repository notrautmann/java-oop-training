package java_examples_alex;
import java.util.Arrays;
import java.util.List;

public class ProxyDemo {
	public static void run() {
		
		interface Internet {
		    void verbindeMit(String server) throws Exception;
		}
		
		class EchtesInternet implements Internet {
		    @Override
		    public void verbindeMit(String server) {
		        System.out.println("Verbinde mit " + server);
		    }
		}
			

		class InternetProxy implements Internet {
		    private Internet internet = new EchtesInternet();
		    private static final List<String> gesperrt = Arrays.asList("facebook.com", "instagram.com");

		    @Override
		    public void verbindeMit(String server) throws Exception {
		        if (gesperrt.contains(server.toLowerCase())) {
		            throw new Exception("Zugriff auf " + server + " ist blockiert.");
		        }
		        internet.verbindeMit(server);
		    }
		}
		
        Internet internet = new InternetProxy();
        try {
            internet.verbindeMit("google.com");
            internet.verbindeMit("facebook.com");
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

}
