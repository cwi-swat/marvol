package lang.marvol.backend.pos;

public class WristPos {
	
	final float 	WristYaw;

	public WristPos(float wristYaw) {
		WristYaw = wristYaw;
	}

	WristPos mirror(){
		return new WristPos(-WristYaw);
	}
}
