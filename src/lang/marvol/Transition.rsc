module lang::marvol::Transition

data Transition
  = transition(list[Positions]);
  
data Move
  = move(Limb limb, int duration, real x, real y, real z, real angle);
  
data Limb
  = lhand() | rhand()
  | lfoot() | rfoot()
  | head()  | torso()
  ;