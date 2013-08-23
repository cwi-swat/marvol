package lang.marvol.backend.pos.predefined;

import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.ArmPos;
import lang.marvol.backend.pos.ArmTwist;

public enum ArmTwistPoses {
	FarInwards(new ArmTwist(0.35f * MPI.pi)),
	Inwards(new ArmTwist(0.0f)),
	Outwards(new ArmTwist(-0.5f * MPI.pi));

	ArmTwistPoses(ArmTwist pos){
		this.pos = pos;
	}
	
	public final ArmTwist pos;
}
