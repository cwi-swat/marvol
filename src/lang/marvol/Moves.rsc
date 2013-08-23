module lang::marvol::Moves

data LookMove 
  = FarLeft()
  | Left()
  | Forward()
  | Right()
  | FarRight();
  
data ChinMove
  = Forward()
  | Down()
  | Up();

data ArmMove
  = Up()
  | ForwardsUp()
  | Forwards()
  | ForwardsDown()
  | Down()
  | ForwardsUpSideways()
  | ForwardsSideways()
  | ForwardsDownSideways()
  | SidewaysUp()
  | Sideways()
  | SidewaysDown();
  
  
data ArmTwistMove
  = FarInwards()
  | Inwards()
  | Outwards();
  
  
data ElbowMove
  = Stretch()
  | Bend();
  
data HandMove
  = Close()
  | Open();
  
data LegMove 
  = Stretch(); // More to come...

  
data BodyMove = BodyMove(
	LookMove look, 
	ChinMove chin, 
	ArmMove leftArm, ArmMove rightArm,
	ArmTwistMove leftArmTwist, ArmTwistMove rightArmTwist,
	ElbowMove leftElbow, ElbowMove rightElbow,
	HandMove leftHand, HandMove rightHand,
	LegMove legLeg, LegMove rightLeg
	);


  
data BodyMove = BodyMove(
	LookMove look, 
	ChinMove chin, 
	ArmMove leftArm, ArmMove rightArm,
	ArmTwistMove leftArmTwist, ArmTwistMove rightArmTwist,
	ElbowMove leftElbow, ElbowMove rightElbow,
	HandMove leftHand, HandMove rightHand,
	LegMove legLeg, LegMove rightLeg
	);

type BodyPosition = BodyMove;

public bool isLegalMove(BodyMove m) = true;
public bool isLegalTransition(BodyPosition a, BodyPosition b) = true; 

@javaClass{lang.marvol.Moves}
public java void init(str robotAddr);

@javaClass{lang.marvol.Moves}
public java void doAsyncDance(list[BodyMove] p);

// blocks until dance is cancelled
@javaClass{lang.marvol.Moves}
public java void cancelCurrentDance();