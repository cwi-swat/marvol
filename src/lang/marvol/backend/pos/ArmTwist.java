package lang.marvol.backend.pos;

public class ArmTwist {

	public final float ElbowYaw;

	public ArmTwist(float elbowYaw) {
		ElbowYaw = elbowYaw;
	}
	
	
	ArmTwist mirror() {
		return new ArmTwist(-ElbowYaw);
	}
}
