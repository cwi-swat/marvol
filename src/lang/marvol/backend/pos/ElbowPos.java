package lang.marvol.backend.pos;


public class ElbowPos {
	
	public ElbowPos(float elbowRoll) {
		ElbowRoll = elbowRoll;
	}

	public final float ElbowRoll;

	public ElbowPos mirror(){
		return new ElbowPos(-ElbowRoll);
	}
	
}
