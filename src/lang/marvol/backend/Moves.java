package lang.marvol.backend;

import java.util.ArrayList;

import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.IString;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;

import lang.marvol.backend.pos.NewPose;
import lang.marvol.backend.pos.Say;
import lang.marvol.backend.pos.predefined.ArmPoses;
import lang.marvol.backend.pos.predefined.ArmTwistPoses;
import lang.marvol.backend.pos.predefined.ElbowPoses;
import lang.marvol.backend.pos.predefined.HandPoses;
import lang.marvol.backend.pos.predefined.HeadHorPoses;
import lang.marvol.backend.pos.predefined.HeadVerPoses;
import lang.marvol.backend.pos.predefined.LegPoses;

public class Moves {
	public Moves(IValueFactory values) {
	}

	ArmTwistPoses armTwistFromR(IConstructor c) {
		if (c.getName().equals("FarInwards")) {
			return ArmTwistPoses.FarInwards;
		}
		if (c.getName().equals("Inwards")) {
			return ArmTwistPoses.Inwards;
		}
		if (c.getName().equals("Outwards")) {
			return ArmTwistPoses.Outwards;
		}
		return null;
	}

	HeadHorPoses lookFromR(IConstructor c) {
		if (c.getName().equals("FarLeft")) {
			return HeadHorPoses.FarLeft;
		}
		if (c.getName().equals("Left")) {
			return HeadHorPoses.Left;
		}
		if (c.getName().equals("LForward")) {
			return HeadHorPoses.Forward;
		}
		if (c.getName().equals("Right")) {
			return HeadHorPoses.Right;
		}
		if (c.getName().equals("FarRight")) {
			return HeadHorPoses.FarRight;
		}

		return null;
	}

	HeadVerPoses chinFromR(IConstructor c) {
		if (c.getName().equals("CForward")) {
			return HeadVerPoses.Forward;
		}
		if (c.getName().equals("Up")) {
			return HeadVerPoses.Up;
		}
		if (c.getName().equals("Down")) {
			return HeadVerPoses.Down;
		}

		return null;
	}

	ArmPoses armFromR(IConstructor c) {
		if (c.getName().equals("Up")) {
			return ArmPoses.Up;
		}
		if (c.getName().equals("ForwardsUp")) {
			return ArmPoses.ForwardsUp;
		}
		if (c.getName().equals("Forwards")) {
			return ArmPoses.Forwards;
		}
		if (c.getName().equals("ForwardsDown")) {
			return ArmPoses.ForwardsDown;
		}
		if (c.getName().equals("Down")) {
			return ArmPoses.Down;
		}
		if (c.getName().equals("ForwardsUpSideways")) {
			return ArmPoses.ForwardsUpSideWays;
		}

		if (c.getName().equals("ForwardsSideways")) {
			return ArmPoses.ForwardsSideWays;
		}
		if (c.getName().equals("ForwardsDownSideways")) {
			return ArmPoses.ForwardsDownSideWays;
		}
		if (c.getName().equals("SidewaysUp")) {
			return ArmPoses.SidewaysUp;
		}
		if (c.getName().equals("Sideways")) {
			return ArmPoses.Sideways;
		}
		if (c.getName().equals("SidewaysDown")) {
			return ArmPoses.SidewaysDown;
		}
		return null;
	}

	ElbowPoses elbowFromR(IConstructor c) {
		if (c.getName().equals("Stretch")) {
			return ElbowPoses.Stretch;
		}
		if (c.getName().equals("Bend")) {
			return ElbowPoses.Bend;
		}
		return null;
	}

	HandPoses handsFromR(IConstructor c) {
		if (c.getName().equals("Open")) {
			return HandPoses.Open;
		}
		if (c.getName().equals("Close")) {
			return HandPoses.Closed;
		}
		return null;
	}

	LegPoses legsFromR(IConstructor c) {
		if (c.getName().equals("LegStretch")) {
			return LegPoses.Init;
		}
		if (c.getName().equals("Squat")) {
			return LegPoses.Squat;
		}
		if (c.getName().equals("HawaiiLeft")) {
			return LegPoses.HawaiiLeft;
		}
		if (c.getName().equals("HawaiiRight")) {
			return LegPoses.HawaiiRight;
		}
		if (c.getName().equals("LuckyLuke")) {
			return LegPoses.LuckyLuke;
		}
		return null;
	}

	NewPose fromRascalPose(IConstructor c) {
		return NewPose.Init
				.look(lookFromR((IConstructor) c.get("look")))
				.chin(chinFromR((IConstructor) c.get("chin")))
				.moveLeftArm(armFromR((IConstructor) c.get("leftArm")))
				.moveRightArm(armFromR((IConstructor) c.get("rightArm")))
				.twistLeftArm(
						armTwistFromR((IConstructor) c.get("leftArmTwist")))
				.twistRightArm(
						armTwistFromR((IConstructor) c.get("rightArmTwist")))
				.leftElbow(elbowFromR((IConstructor) c.get("leftElbow")))
				.rightElbow(elbowFromR((IConstructor) c.get("rightElbow")))
				.leftHand(handsFromR((IConstructor) c.get("leftHand")))
				.rightHand(handsFromR((IConstructor) c.get("rightHand")))
				.moveLegs(legsFromR((IConstructor) c.get("legs")))
				.say(sayFromR((IConstructor) c.get("mouth")));

	}

	private Say sayFromR(IConstructor parameter) {
		System.err.println("say " + parameter);
		if (parameter == null) {
			return Say.Nothing;
		}
		else if (!"silence".equals(parameter.getName())) {
			return new Say(((IString) parameter.get("uttering")).getValue());
		}
		else {
			return Say.Nothing;
		}
	}

	public void init(IString s) {
		DanceInterpreter.init(s.getValue());
	}

	public void cancelCurrentDance() {
		try {
			DanceInterpreter.interrupt();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	public void doAsyncDance(IList moves) {
		ArrayList<NewPose> poses = new ArrayList<NewPose>();
		for (IValue i: moves) {
			System.err.println("move: " + i);
			poses.add(fromRascalPose((IConstructor) i));
		}
		DanceInterpreter.asyncDoMove(poses);
	}

}
