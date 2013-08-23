package lang.marvol.backend.pos.predefined;

import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.ArmPos;


public enum ArmPoses {

	Up(new ArmPos(-0.5f * MPI.pi, 0.f)),
	ForwardsUp(new ArmPos(-0.25f * MPI.pi,0f)),
	Forwards(new ArmPos(0.0f, 0.0f)),
	ForwardsDown(new ArmPos(0.25f * MPI.pi,0f)),
	Down(new ArmPos(0.5f * MPI.pi, 0.f)),
	ForwardsUpSideWays(new ArmPos(-0.25f * MPI.pi, 0.25f * MPI.pi)),
	ForwardsSideWays(new ArmPos(-0.0f * MPI.pi, 0.25f * MPI.pi)),
	ForwardsDownSideWays(new ArmPos(0.25f * MPI.pi, 0.25f * MPI.pi)),
	SidewaysUp(new ArmPos(-0.25f * MPI.pi, 0.5f * MPI.pi)),
	Sideways(new ArmPos(0.0f * MPI.pi, 0.5f * MPI.pi)),
	SidewaysDown(new ArmPos(0.25f * MPI.pi, 0.5f * MPI.pi));
	
	
	

	ArmPoses(ArmPos pos){
		this.pos = pos;
	}
	
	public final ArmPos pos;
}
