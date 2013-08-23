package lang.marvol.backend.pos.predefined;

import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.HandPos;

public enum HandPoses {

	
	Closed(new HandPos(0)),
	Open(new HandPos(0.9f * MPI.pi));
	
	HandPoses(HandPos pos){
		this.pos = pos;
	}
	
	public final HandPos pos;
	
}
