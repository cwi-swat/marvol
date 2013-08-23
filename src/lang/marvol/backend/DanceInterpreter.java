package lang.marvol.backend;

import java.util.ArrayList;
import java.util.Vector;

import javax.naming.InitialContext;

import lang.marvol.backend.pos.ArmPos;
import lang.marvol.backend.pos.HeadHorPos;
import lang.marvol.backend.pos.NewPose;
import lang.marvol.backend.pos.WristPos;
import lang.marvol.backend.pos.predefined.ArmPoses;
import lang.marvol.backend.pos.predefined.ArmTwistPoses;
import lang.marvol.backend.pos.predefined.ElbowPoses;
import lang.marvol.backend.pos.predefined.HandPoses;
import lang.marvol.backend.pos.predefined.HeadHorPoses;
import lang.marvol.backend.pos.predefined.HeadVerPoses;
import lang.marvol.backend.pos.predefined.LegPoses;



import com.aldebaran.proxy.*;

public class DanceInterpreter {

	
	
	static String addr = null ;
	static int curPos = 0;
	static ALMotionProxy mp = null; 
	 static Thread curThread = null;
	static boolean shouldStop = false;
	
	// This is required so that we can use the 'Variant' object
	static {
	System.loadLibrary("jnaoqi");
	}
	
	static void stiffnessOn(ALMotionProxy proxy){
		proxy.stiffnessInterpolation(new Variant(new String[]{"Body"}),
				                new Variant(new float[]{1f}),
				                		new Variant(new float[]{1f}));
	}
	
	public static void init(String addr){
		mp = new ALMotionProxy(addr, 9559);
		stiffnessOn(mp);
		
		curPos = 0;
	}
	

	
	// gives back current position
	public static void interrupt() throws InterruptedException{
		if(curThread==null){
			return ;
		}
		shouldStop = true;
		curThread.join();
	}
	
	public static void  asyncDoMove(ArrayList<NewPose> p){
		if(curThread!= null){
			return;
		}
		curThread = new Thread(new MoveRunnable(p));
		curThread.start();
	}
	
	public static void main(String[] argv){
		init("127.0.0.1");
		ArrayList<NewPose> p = new ArrayList<NewPose>();
		NewPose i = NewPose.Init;
		
		
		NewPose rightPoint = i.moveRightArm(ArmPoses.ForwardsUpSideWays).rightElbow(ElbowPoses.Stretch).rightHand(HandPoses.Open).look(HeadHorPoses.Right).chin(HeadVerPoses.Up).moveLeftArm(ArmPoses.ForwardsDownSideWays);
	
		
		NewPose leftFirst = i.moveArms(ArmPoses.Sideways).elbows(ElbowPoses.Bend).twistArms(ArmTwistPoses.Inwards);
		NewPose leftFirst2 = i.moveArms(ArmPoses.Sideways).elbows(ElbowPoses.Bend).twistLeftArm(ArmTwistPoses.Outwards).leftHand(HandPoses.Open).look(HeadHorPoses.FarLeft).twistRightArm(ArmTwistPoses.FarInwards);
		NewPose leftFirst3 = leftFirst2.mirror();
		for(int z = 0 ; z < 3 ; z ++){
		for (int j = 0 ; j < 2 ; j++){
		
			p.add(leftFirst3);
			p.add(leftFirst2);
		}
		for (int j = 0 ; j < 2 ; j++){
			p.add(rightPoint);
			p.add(rightPoint.mirror());	
		}
		NewPose rightHere = i.moveRightArm(ArmPoses.ForwardsDown).rightElbow(ElbowPoses.Bend).rightHand(HandPoses.Closed).look(HeadHorPoses.Right).chin(HeadVerPoses.Down).moveLeftArm(ArmPoses.Sideways).leftElbow(ElbowPoses.Bend);
		for (int j = 0 ; j < 2 ; j++){
			p.add(rightHere);
			p.add(rightHere.mirror());
			}
		}
		asyncDoMove(p);
		try {
			curThread.join();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
