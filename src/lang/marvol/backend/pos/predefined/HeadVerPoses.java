package lang.marvol.backend.pos.predefined;

import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.HeadHorPos;
import lang.marvol.backend.pos.HeadVerPos;

public enum HeadVerPoses {
	Forward(new HeadVerPos(0)),
	Up(new HeadVerPos( -0.12f * MPI.pi)),
	Down(new HeadVerPos( 0.12f * MPI.pi));
	
	
	HeadVerPoses(HeadVerPos pos){
		this.pos = pos;
	}
	
	public final HeadVerPos pos;
}
