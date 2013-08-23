package lang.marvol.backend.pos;

public class LegPos {

	
	final float HipYawPitch,
	HipPitch,
	HipRoll,
	KneePitch,
	AnklePitch,
	AnkleRoll;

	public LegPos(float hipYawPitch, float hipPitch, float hipRoll,
			float kneePitch, float anklePitch, float ankleRoll) {
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
