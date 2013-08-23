package lang.marvol.backend.pos.predefined;


import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.LegPos;

public enum LegPoses {
	Init(new LegPos(0,0,0,0,0, 0)),
	Kick(new LegPos(0,0,0.1f * MPI.pi,0,0, 0)),
	Weird(new LegPos(0.5f * MPI.pi,0,0,0,0, 0)),
	ToSide(new LegPos(0,0,0.15f *MPI.pi,0,0, 0));
	
	LegPoses(LegPos pos){
		this.pos = pos;
	}
	
	public final LegPos pos;
}
