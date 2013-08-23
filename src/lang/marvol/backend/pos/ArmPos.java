package lang.marvol.backend.pos;

public class ArmPos {

	final float ShoulderPitch,
	ShoulderRoll;
	
	public ArmPos(float shoulderPitch, float shoulderRoll) {
		ShoulderPitch = shoulderPitch;
		ShoulderRoll = shoulderRoll;
	}

	public ArmPos mirror(){
		return new ArmPos(ShoulderPitch, -ShoulderRoll);
	}
	
}
