package lang.marvol.backend.pos.predefined;


import lang.marvol.backend.MPI;
import lang.marvol.backend.pos.LegPos;

public enum LegPoses {
	Init(new LegPos(0,0,0,0,0, 0),new LegPos(0,0,0,0,0, 0)),
	Squat(new LegPos(-1.18944f, -1.37641e-2f, -0.552198f, 7.82759e-2f, -0.58748f, 2.11255f),
			new LegPos(-1.1863f, 3.53239e-2f, -0.556884f, -0.101202f, -0.58748f, 2.11255f)),
	HawaiiLeft(new LegPos(9.04641e-2f, 0.242414f, 0.358998f, -0.369652f, -0.320564f, -9.23279e-2f),
			new LegPos(0.177986f, 0.397761f, 0.124212f, -0.653442f, -0.320564f, -3.52399e-2f)),
	HawaiiRight(new LegPos(0.177986f, -0.397761f, 0.124212f, 0.653442f, -0.320564f, -3.52399e-2f),
			new LegPos(9.04641e-2f, -0.242414f, 0.358998f, 0.369652f, -0.320564f, -9.23279e-2f)),
			
	LuckyLuke(new LegPos(-0.78545f, -0.237728f, -0.483168f, 0.33292f, 0.564554f, 0.915756f),
			new LegPos(-0.768492f, 0.274628f, -0.503194f, -0.392662f, 0.564554f, 0.912772f));
	
	

	
	LegPoses(LegPos posl, LegPos posr){
		this.posl = posl;
		this.posr = posr;
	}
	
	public final LegPos posl;
	public final LegPos posr;
	
	public LegPoses mirror(){
		switch(this){
		case Init: return Init;
		case Squat: return Squat;
		case HawaiiLeft: return HawaiiRight;
		case HawaiiRight: return HawaiiLeft;
		case LuckyLuke: return LuckyLuke;

		}
		return Init;
	}
}
