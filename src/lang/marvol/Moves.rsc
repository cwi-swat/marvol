module lang::marvol::Moves

data LookMove 
  = FarLeft()
  | Left()
  | LForward()
  | Right()
  | FarRight();
  
LookMove mirror(LookMove m) {
  switch(m) {
    case FarLeft()  : return FarRight();
    case Left()     : return Right();
    case LForward()  : return LForward();
    case Right()    : return Left();
    case FarRight() : return FarLeft();
    }
}

data ChinMove
  = CForward()
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
  = LegStretch(); // More to come...

  
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



alias BodyPosition = BodyMove;

BodyPosition initPos = BodyMove (
   LForward(),
   CForward(),
   Down(),    Down(),
   Inwards(), Inwards(),
   Stretch(), Stretch(),
   Close(),   Close(),
   LegStretch(), LegStretch());
   
   
BodyPosition mirror(BodyPosition pos) =
  BodyMove( mirror(pos.look) , pos.chin,
           pos.rightArm, pos.leftArm,
           pos.rightArmTwist, pos.leftArmTwist,
           pos.rightElbow, pos.leftElbow,
           pos.rightHand, pos.leftHand,
           pos.rightLeg, pos.leftLeg); 

public bool isLegalMove(BodyMove m) = true;
public bool isLegalTransition(BodyPosition a, BodyPosition b) = true; 

@javaClass{org.rascalmpl.library.lang.marvol.Moves}
public java void init(str robotAddr);

@javaClass{org.rascalmpl.library.lang.marvol.Moves}
public java void doAsyncDance(list[BodyMove] p);

// blocks until dance is cancelled
@javaClass{org.rascalmpl.library.lang.marvol.Moves}
public java void cancelCurrentDance();
