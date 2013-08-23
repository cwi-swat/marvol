package lang.marvol.backend.pos;

public class HandPos {
	final float Hand;

	public HandPos(float hand) {
		Hand = hand;
	}
	
	
	public HandPos mirror(){
		return new HandPos(Hand);
	}
}
