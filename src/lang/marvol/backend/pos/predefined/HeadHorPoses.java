package lang.marvol.backend.pos.predefined;

import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.HeadHorPos;

public enum HeadHorPoses {
	
	Forward(new HeadHorPos(0)),
	Left(new HeadHorPos( 0.19f * MPI.pi)),
	FarLeft(new HeadHorPos( 0.4f * MPI.pi)),
	Right(new HeadHorPos( -0.19f * MPI.pi)),
	FarRight(new HeadHorPos(-0.4f * MPI.pi));
	
	HeadHorPoses(HeadHorPos pos){
		this.pos = pos;
	}
	
	public final HeadHorPos pos;

	public HeadHorPoses mirror() {
		switch(this){
		case Forward : return Forward;
		case Left : return Right;
		case FarLeft : return FarRight;
		case Right : return Left;
		case FarRight : return FarLeft;
		
		}
		return Forward;
	}
}
