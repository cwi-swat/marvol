module lang::marvol::Moves

data LookMove 
  = FarLeft()
  | Left()
  | LForward()
  | Right()
  | FarRight();
  
LookMove mirror(LookMove m) {
  switch (m) {
    case FarLeft()  : return FarRight();
    case Left()     : return Right();
    case LForward() : return LForward();
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
  
data SayMove 
  = say(str uttering) 
  | silence()
  ; 
  
data ElbowMove
  = Stretch()
  | Bend();
  
data HandMove
  = Close()
  | Open();
  
data LegsMove 
  = LegStretch()
  | Squat() 
  | HawaiiLeft()
  | HawaiiRight()
  | LuckyLuke(); // More to come...

LegsMove mirror(LegsMove m) {
  switch(m) {
    case LegStretch()  : return LegStretch();
    case Squat()     : return Squat();
    case HawaiiLeft()  : return HawaiiRight();
    case LuckyLuke()    : return LuckyLuke();
    }
}
  
data BodyMove = BodyMove(
	  LookMove look, 
	  ChinMove chin, 
	  ArmMove leftArm, ArmMove rightArm,
	  ArmTwistMove leftArmTwist, ArmTwistMove rightArmTwist,
	  ElbowMove leftElbow, ElbowMove rightElbow,
	  HandMove leftHand, HandMove rightHand,
	  LegsMove legs,
	  SayMove mouth
	);

alias BodyPosition = BodyMove;

public BodyPosition INIT_POS = BodyMove (
   LForward(),
   CForward(),
   ArmMove::Down(),    ArmMove::Down(),
   Inwards(), Inwards(),
   Stretch(), Stretch(),
   Close(),   Close(),
   LegStretch(), 
   silence());
   
   
   
BodyPosition mirror(BodyPosition pos) =
  BodyMove( mirror(pos.look) , pos.chin,
           pos.rightArm, pos.leftArm,
           pos.rightArmTwist, pos.leftArmTwist,
           pos.rightElbow, pos.leftElbow,
           pos.rightHand, pos.leftHand,
           mirror(pos.legs)); 

bool armIsStraightDown(ArmMove arm, ElbowMove elbow) = (arm == Down() && elbow == Stretch());

bool armInsideSelf(ArmMove arm, ElbowMove elbow, ArmTwistMove twist) = (arm == Down() && elbow == Bend() && twist != Outwards);
bool armIsForward(ArmMove arm) = arm == Forward() || arm == ForwardsUp() || arm == ForwardsDown();

bool isIllegalMove(BodyMove m) = 
	(m.legs == Squat() && armIsStraightDown(leftArm,leftElbow) || armIsStraightDown(rightArm,rightElbow)) ||
	(armForward(m.leftArm) && armIsForward(m.rightArm) && m.leftArm == m.rightArm && m.leftElbow == Bend() && m.rightElbow == Bend() && m.leftArmTwist == Inwards() && m.rightArmTwist == Inwards()) ||
	armInsideSelf(m.leftArm, m.leftElbow, m.leftArmTwist) || 
        armInsideSelf(m.rightArm, m.rightElbow, m.rightArmTwist) 
	;
bool isLegalTransition(BodyPosition a, BodyPosition b) = true; 

@javaClass{lang.marvol.backend.Moves}
java void init(str robotAddr);

@javaClass{lang.marvol.backend.Moves}
java void doAsyncDance(list[BodyMove] p);

// blocks until dance is cancelled
@javaClass{lang.marvol.backend.Moves}
java void cancelCurrentDance();