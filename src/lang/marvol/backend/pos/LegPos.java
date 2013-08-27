package lang.marvol.backend.pos;

public class LegPos {

	
	final float AnklePitch, AnkleRoll,
	HipPitch,
	HipRoll,
	HipYawPitch,
	KneePitch;

	public LegPos(float anklePitch, float ankleRoll,
			float hipPitch, float hipRoll, float hipYawPitch, 
			float kneePitch  ) {
		HipYawPitch = hipYawPitch;
		HipPitch = hipPitch;
		HipRoll = hipRoll;
		KneePitch = kneePitch;
		AnklePitch = anklePitch;
		AnkleRoll = ankleRoll;
	}
	
	public LegPos mirror(){
		return new LegPos(-HipYawPitch,-HipPitch,-HipRoll, -KneePitch,- AnklePitch,-AnkleRoll);
	}
	
	
}
