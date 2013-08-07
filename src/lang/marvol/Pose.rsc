module lang::marvol::Pose

data Pose
  = pose(int delay, list[Positions]);
  
data Position
  = position(Limb limb, int x, int y, int z);
  
data Limb
  = lhand() | rhand()
  | lfoot() | rfoot()
  | head()  | torso()
  ;