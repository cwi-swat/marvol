package lang.marvol.backend.pos;

import com.aldebaran.proxy.ALTextToSpeechProxy;

public class Say {
	private final String uttering;
	public static final Say Nothing = new Say("");
	
	public Say(String uttering) {
		this.uttering = uttering;
	}

	public void speak(ALTextToSpeechProxy speech) {
		if (uttering != null && !"".equals(uttering)) {
			speech.say(uttering);
		}
	}

}
