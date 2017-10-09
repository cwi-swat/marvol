package lang.marvol.backend;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

import com.aldebaran.qi.Application;
import com.aldebaran.qi.CallError;
import com.aldebaran.qi.Session;
import com.aldebaran.qi.helper.proxies.ALMotion;
import com.aldebaran.qi.helper.proxies.ALTextToSpeech;

import lang.marvol.backend.pos.NewPose;
import lang.marvol.backend.pos.predefined.ArmPoses;
import lang.marvol.backend.pos.predefined.ArmTwistPoses;
import lang.marvol.backend.pos.predefined.ElbowPoses;
import lang.marvol.backend.pos.predefined.HandPoses;
import lang.marvol.backend.pos.predefined.HeadHorPoses;
import lang.marvol.backend.pos.predefined.HeadVerPoses;
import lang.marvol.backend.pos.predefined.LegPoses;

public class DanceInterpreter {

	static String addr = null;
	static int curPos = 0;
	static ALMotion mp = null;
	static Thread curThread = null;
	static boolean shouldStop = false;
	static ALTextToSpeech speech;

	// This is required so that we can use the 'Variant' object
//	static {
//		System.loadLibrary("libqi");
//	}

	static void stiffnessOn(ALMotion proxy) {
		try {
			ArrayList<String> parts = new ArrayList<String>();
			parts.add("Body");
			
			ArrayList<Float> stiffness = new ArrayList<Float>();
			stiffness.add(1f);

			ArrayList<Float> times = new ArrayList<Float>();
			times.add(1f);
			
			proxy.stiffnessInterpolation(parts, stiffness, times);
		} catch (InterruptedException | CallError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void init(String addr) {
		Application application = new Application(new String[] {}, "tcp://" + addr + ":9559");
		application.start();
		
//		Session session = new Session();
//		session.connect(addr + ":9559");
		try {
			mp = new ALMotion(application.session());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.err.println(e);
		}
		try {
			speech = new ALTextToSpeech(application.session());
			speech.setVolume(1.0f);
			speech.say("Let's dance!");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.err.println(e);
		}
		stiffnessOn(mp);

		curPos = 0;
	}

	// gives back current position
	public static void interrupt() throws InterruptedException {
		if (curThread == null) {
			return;
		}
		shouldStop = true;
		curThread.join();
		shouldStop = false;
		curThread = null;
		
	}

	public static void asyncDoMove(ArrayList<NewPose> p) {
		if (curThread != null) {
			return;
		}
		curThread = new Thread(new MoveRunnable(p));
		curThread.start();
	}

	public static void main(String[] argv) {
		 init("192.168.1.102");
		//init("127.0.0.1");
		ArrayList<NewPose> p = new ArrayList<NewPose>();
		NewPose i = NewPose.Init;

		NewPose rightPoint = i.moveRightArm(ArmPoses.ForwardsUpSideWays)
				.rightElbow(ElbowPoses.Stretch).rightHand(HandPoses.Open)
				.look(HeadHorPoses.Right).chin(HeadVerPoses.Up)
				.moveLeftArm(ArmPoses.ForwardsDownSideWays);

		NewPose leftFirst = i.moveArms(ArmPoses.Sideways)
				.elbows(ElbowPoses.Bend).twistArms(ArmTwistPoses.Inwards);

		// NewPose leftFirst3 = leftFirst2.mirror();
		NewPose maarten = i.moveArms(ArmPoses.Sideways);
		p.add(i);
		p.add(i.moveArms(ArmPoses.ForwardsDown).elbows(ElbowPoses.Bend)
				.twistArms(ArmTwistPoses.FarInwards));

		for (int z = 0; z < 3; z++) {
			NewPose bla = i.moveLegs(LegPoses.HawaiiLeft)
					.moveRightArm(ArmPoses.Sideways)
					.twistRightArm(ArmTwistPoses.Outwards)
					.rightHand(HandPoses.Open).look(HeadHorPoses.FarRight)
					.moveLeftArm(ArmPoses.Forwards)
					.twistLeftArm(ArmTwistPoses.Inwards)
					.leftElbow(ElbowPoses.Bend);
			for (int j = 0; j < 3; j++) {
				p.add(i.moveLegs(LegPoses.LuckyLuke)
						.moveArms(ArmPoses.ForwardsUp).hands(HandPoses.Open));
				p.add(bla);
				p.add(i.moveLegs(LegPoses.LuckyLuke)
						.moveArms(ArmPoses.ForwardsUp).hands(HandPoses.Open));
				p.add(bla.mirror());
			}

			for (int q = 0; q < 3; q++) {
				NewPose leftFirst2 = i.moveArms(ArmPoses.Sideways)
						.elbows(ElbowPoses.Bend)
						.twistLeftArm(ArmTwistPoses.Outwards)
						.leftHand(HandPoses.Open).look(HeadHorPoses.FarLeft)
						.twistRightArm(ArmTwistPoses.FarInwards)
						.moveLegs(LegPoses.HawaiiLeft);
				p.add(leftFirst2);
				p.add(leftFirst2.mirror());

				// p.add(i.moveLegs(LegPoses.HawaiiRight));
				// p.add(i.moveLegs(LegPoses.Squat));
				// p.add(i.moveArms(ArmPoses.Down));
				// p.add(i.moveLegs(LegPoses.Squat).moveArms(ArmPoses.Sideways));
				// .add(i.moveLegs(LegPoses.Init));

			}

		}
		for (int j = 0; j < 3; j++) {
			NewPose bla = i.moveLegs(LegPoses.Squat)
					.moveLeftArm(ArmPoses.ForwardsUp)
					.moveRightArm(ArmPoses.ForwardsDown)
					.elbows(ElbowPoses.Bend).chin(HeadVerPoses.Up)
					.look(HeadHorPoses.Right);
			p.add(bla);
			NewPose fly = i.moveLeftArm(ArmPoses.SidewaysUp).moveRightArm(
					ArmPoses.SidewaysDown);
			p.add(fly);
			p.add(bla.mirror());
			p.add(fly.mirror());
		}
		NewPose rightHere = i.moveRightArm(ArmPoses.ForwardsDown)
				.rightElbow(ElbowPoses.Bend).rightHand(HandPoses.Closed)
				.look(HeadHorPoses.Right).chin(HeadVerPoses.Down)
				.moveLeftArm(ArmPoses.Sideways).leftElbow(ElbowPoses.Bend);
		for (int j = 0; j < 2; j++) {
			p.add(rightHere);
			p.add(rightHere.mirror());
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
