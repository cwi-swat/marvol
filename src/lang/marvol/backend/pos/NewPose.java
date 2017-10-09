package lang.marvol.backend.pos;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.concurrent.ExecutionException;

import com.aldebaran.qi.CallError;
import com.aldebaran.qi.helper.proxies.ALMotion;
import com.aldebaran.qi.helper.proxies.ALTextToSpeech;

import lang.marvol.backend.pos.predefined.ArmPoses;
import lang.marvol.backend.pos.predefined.ArmTwistPoses;
import lang.marvol.backend.pos.predefined.ElbowPoses;
import lang.marvol.backend.pos.predefined.HandPoses;
import lang.marvol.backend.pos.predefined.HeadHorPoses;
import lang.marvol.backend.pos.predefined.HeadVerPoses;
import lang.marvol.backend.pos.predefined.LegPoses;

public class NewPose {
	
	private HeadHorPoses hhead;
	private HeadVerPoses vhead;
	private ElbowPoses lElbow, rElbow;
	private ArmTwistPoses lTwistArm, rTwistArm;
	private ArmPoses lArm,rArm;
	private Say uttering;

	private HandPoses lHand,rHand;
	private LegPoses legs;
	
	public final static NewPose Init = new NewPose(
			HeadHorPoses.Forward, 
			HeadVerPoses.Forward,
			ElbowPoses.Stretch,
            ElbowPoses.Stretch,
            ArmPoses.Down,
            ArmPoses.Down,
            ArmTwistPoses.Inwards,
            ArmTwistPoses.Inwards,
            HandPoses.Closed,
            HandPoses.Closed,
            LegPoses.Init,
            Say.Nothing);
	

	private NewPose(HeadHorPoses hhead, HeadVerPoses vhead, ElbowPoses lElbow,
			ElbowPoses rElbow, ArmPoses lArm, ArmPoses rArm, 
			ArmTwistPoses lTwistArm, ArmTwistPoses rTwistArm, HandPoses lHand,
			HandPoses rHand, LegPoses leg, Say uttering) {
		this.hhead = hhead;
		this.vhead = vhead;
		this.lElbow = lElbow;
		this.rElbow = rElbow;
		this.lArm = lArm;
		this.rArm = rArm;
		this.lTwistArm = lTwistArm;
		this.rTwistArm = rTwistArm;
		this.lHand = lHand;
		this.rHand = rHand;
		this.legs = leg;
		this.uttering = uttering;
	}
	
	private NewPose(NewPose p) {
		this.hhead = p.hhead;
		this.vhead = p.vhead;
		this.lElbow = p.lElbow;
		this.rElbow = p.rElbow;
		this.lArm = p.lArm;
		this.rArm = p.rArm;
		this.lTwistArm = p.lTwistArm;
		this.rTwistArm = p.rTwistArm;
		this.lHand = p.lHand;
		this.rHand = p.rHand;
		this.legs = p.legs;
	}
	
	public NewPose look(HeadHorPoses p){
		NewPose x = new NewPose(this);
		x.hhead = p;
		return x;
	}
	
	public NewPose say(Say s) {
		NewPose x = new NewPose(this);
		x.uttering = s;
		return x;
	}
	
	public NewPose chin(HeadVerPoses p){
		NewPose x = new NewPose(this);
		x.vhead = p;
		return x;
	}
	
	public NewPose leftHand(HandPoses p){
		NewPose x = new NewPose(this);
		x.lHand = p ;
		return x;
	}
	
	public NewPose rightHand(HandPoses p){
		NewPose x = new NewPose(this);
		x.rHand = p ;
		return x;
	}
	
	public NewPose hands(HandPoses p){
		return leftHand(p).rightHand(p);
	}
	
	public NewPose leftElbow(ElbowPoses p){
		NewPose x = new NewPose(this);
		x.lElbow = p ;
		return x;
	}
	
	public NewPose rightElbow(ElbowPoses p){
		NewPose x = new NewPose(this);
		x.rElbow = p ;
		return x;
	}
	
	public NewPose elbows(ElbowPoses p){
		return leftElbow(p).rightElbow(p);
	}
	
	public NewPose twistLeftArm(ArmTwistPoses p){
		NewPose x = new NewPose(this);
		x.lTwistArm = p ;
		return x;
	}
	
	public NewPose twistRightArm(ArmTwistPoses p){
		NewPose x = new NewPose(this);
		x.rTwistArm = p ;
		return x;
	}
	
	public NewPose twistArms(ArmTwistPoses p){
		return twistLeftArm(p).twistRightArm(p);
	}
	
	public NewPose moveLeftArm(ArmPoses p){
		NewPose x = new NewPose(this);
		x.lArm = p ;
		return x;
	}
	
	
	public NewPose moveRightArm(ArmPoses p){
		NewPose x = new NewPose(this);
		x.rArm = p ;
		return x;
	}
	
	public NewPose moveArms(ArmPoses p){
		return moveLeftArm(p).moveRightArm(p);
	}
	
	
	public NewPose moveLegs(LegPoses p){
		NewPose x = new NewPose(this);
		x.legs = p ;
		return x;
	}
	

	
	


	
	private static ArrayList<String> jointNames = new ArrayList<>(Arrays.asList(
			"HeadPitch",
			"HeadYaw",
			"RShoulderPitch",
			"RShoulderRoll",
			"RElbowYaw",
			"RElbowRoll",
			"LShoulderPitch",
			"LShoulderRoll",
			"LElbowYaw",
			"LElbowRoll",
			"LHipYawPitch",
			"RHipYawPitch",
			"RHipPitch",
			"RHipRoll",
			"LHipPitch",
			"LHipRoll",
			"RKneePitch",
			"LKneePitch",
			"RAnklePitch",
			"RAnkleRoll",
			"LAnklePitch",
			"LAnkleRoll",
			"LWristYaw",
			"RWristYaw",
			"RHand",
			"LHand"));
	
	
	public NewPose mirror(){
		return new NewPose(hhead.mirror(),vhead,rElbow,lElbow,rArm,lArm,rTwistArm,lTwistArm,rHand,lHand,legs.mirror(), null);
	}

	ArrayList<Float> angles() {
		ArmPos rArmpos = rArm.pos.mirror();
		ArmTwist rTwistArmpos = rTwistArm.pos.mirror();
		ElbowPos rElbowpos = rElbow.pos.mirror();
		HandPos rHandpos = rHand.pos.mirror();
		return new ArrayList<>(Arrays.asList(
						vhead.pos.HeadPitch,
						hhead.pos.HeadYaw,
						rArmpos.ShoulderPitch,
						rArmpos.ShoulderRoll,
						rTwistArmpos.ElbowYaw,
						rElbowpos.ElbowRoll,
						lArm.pos.ShoulderPitch,
						lArm.pos.ShoulderRoll,
						lTwistArm.pos.ElbowYaw,
						lElbow.pos.ElbowRoll,
						legs.posl.HipYawPitch,
						legs.posr.HipYawPitch,
						legs.posr.HipPitch,
						legs.posr.HipRoll,
						legs.posl.HipPitch,
						legs.posl.HipRoll,
						legs.posr.KneePitch,
						legs.posl.KneePitch,
						legs.posr.AnklePitch,
						legs.posr.AnkleRoll,
						legs.posl.AnklePitch,
						legs.posl.AnkleRoll,
						0f,
						0f,
						rHandpos.Hand,
						lHand.pos.Hand
				));
	}
	
	public void goToMe(ALMotion p, ALTextToSpeech speech, float seconds) {
//		uttering.speak(speech);
		try {
			p.angleInterpolation(jointNames, angles(), times(seconds), true);
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (CallError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	ArrayList<Float> times(float seconds){
		ArrayList<Float> times = new ArrayList<>(jointNames.size());
		for(int i = 0 ; i < jointNames.size(); i++){
			times.add((float)seconds);
		}
		return times;
	}
	

}
