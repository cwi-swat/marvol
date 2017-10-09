package lang.marvol.backend.pos;

import java.util.concurrent.ExecutionException;

import com.aldebaran.qi.CallError;
import com.aldebaran.qi.helper.proxies.ALTextToSpeech;

public class Say {
	private final String uttering;
	public static final Say Nothing = new Say("");
	
	public Say(String uttering) {
		this.uttering = uttering;
	}

	public void speak(ALTextToSpeech speech) {
		if (uttering != null && !"".equals(uttering)) {
			try {
				speech.say(uttering);
			} catch (InterruptedException | CallError e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}
