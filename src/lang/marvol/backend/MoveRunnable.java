package lang.marvol.backend;

import java.util.ArrayList;

import lang.marvol.backend.pos.NewPose;

public class MoveRunnable implements Runnable {

	public static final float Duration = 1.75f;
	final ArrayList<NewPose> poses;

	public MoveRunnable(ArrayList<NewPose> poses) {
		this.poses = poses;
	}

	@Override
	public void run() {
		//NewPose.Init.goToMe(DanceInterpreter.mp, Duration);
		for (NewPose i : poses) {
			i.goToMe(DanceInterpreter.mp, Duration);
			if (DanceInterpreter.shouldStop)
				return;
		}
		DanceInterpreter.curThread = null;
	}

}
