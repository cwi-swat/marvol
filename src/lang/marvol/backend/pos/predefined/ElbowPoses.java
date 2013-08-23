package lang.marvol.backend.pos.predefined;

import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.ElbowPos;

public enum ElbowPoses {
	
	Stretch(new ElbowPos(0.0f)),
	Bend(new ElbowPos(-0.5f * MPI.pi));
	
	ElbowPoses(ElbowPos pos){
		this.pos = pos;
	}
	
	public final ElbowPos pos;

}
