package lang.marvol.backend;

import java.util.ArrayList;

import lang.marvol.backend.pos.NewPose;


public class MoveRunnable implements Runnable{


		final ArrayList<NewPose> poses;
		
		public MoveRunnable( ArrayList<NewPose> poses){
			this.poses = poses;
		}
		
		@Override
		public void run() {
			for(NewPose i : poses){
				i.goToMe(DanceInterpreter.mp, 1.75f);
				if(DanceInterpreter.shouldStop) return;
			}
			DanceInterpreter.curThread = null;
		}
		
}

