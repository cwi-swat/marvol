module lang::marvol::Compile

import lang::marvol::Marvol;
import lang::marvol::Moves;
import ParseTree;
import IO;

/* Assumes expansion */

alias Move = tuple[str part, set[str] moves];


list[BodyMove] compile(list[Dance] ds) {

  lst = [];
  for (d <- ds) {
    cur = INIT_POS;
    ms = toMoves(d);
    cur = ( cur | compile(m.part, m.moves, it) | m <- ms );
    lst += [cur];
  }
  return lst;
}

     

set[Move] toMoves((Dance)`nop;`) = {};
     
set[Move] toMoves((Dance)`<Part p> <Move+ ms>;`) 
  = {<"<p>", { "<m>" | m <- ms }>};

set[Move] toMoves((Dance)`{|<Dance* ds>|}`) 
  = ( {} | it + toMoves(d) | d <- ds, bprintln("D = <d>") );


set[Move] toMoves((Dance)`mirror <Dance d>`) {
  ms = {}; 
  for (m <- toMoves(d)) {
    if ("left" in m.moves) {
      ms += {<m.part, m.moves - {"left"} + {"right"}>};
    }
    else if ("right" in m.moves) {
      ms += {<m.part, m.moves - {"right"} + {"left"}>};
    }
    else {
      ms += {m};
    }
  }
  return ms;
}


bool hasConflicts({<"arm", {str x, *_}>, <"arm", {x, *_}>, *_}) = true; 
bool hasConflicts({<"hand", {str x, *_}>, <"hand", {x, *_}>, *_}) = true; 
bool hasConflicts({<"elbow", {str x, *_}>, <"elbow", {x, *_}>, *_}) = true; 
bool hasConflicts({<"look", set[str] ms>, <"look", ms>, *_}) = true; 
bool hasConflicts({<"chin", set[str] ms>, <"chin", ms>, *_}) = true; 
bool hasConflicts({<"legs", set[str] ms>, <"legs", ms>, *_}) = true; 
default bool hasConflicts(set[Move] _) = false;


/* Unfortunate heavy coupling with Config. */
/* Todo: allow twists with forward etc. */

BodyMove compile("arm", {"right", "up"}, BodyMove m) = m[rightArm=ArmMove::Up()]; 
BodyMove compile("arm", {"right", "down"} , BodyMove m) = m[rightArm=ArmMove::Down()];
BodyMove compile("arm", {"right", "forwards"} , BodyMove m) = m[rightArm=Forwards()];
BodyMove compile("arm", {"right", "forwards", "up"} , BodyMove m) = m[rightArm=ForwardsUp()];
BodyMove compile("arm", {"right", "forwards", "down"} , BodyMove m) = m[rightArm=ForwardsDown()];
BodyMove compile("arm", {"right", "forwards", "up", "sideways"} , BodyMove m) = m[rightArm=ForwardsUpSideways()];
BodyMove compile("arm", {"right", "forwards", "down", "sideways"} , BodyMove m) = m[rightArm=ForwardsDownSideways()];
BodyMove compile("arm", {"right", "forwards", "sideways"} , BodyMove m) = m[rightArm=ForwardsSideways()];
BodyMove compile("arm", {"right", "sideways"} , BodyMove m) = m[rightArm=Sideways()];
BodyMove compile("arm", {"right", "sideways", "up"} , BodyMove m) = m[rightArm=SidewaysUp()];
BodyMove compile("arm", {"right", "sideways", "down"} , BodyMove m) = m[rightArm=SidewaysDown()];

BodyMove compile("arm", {"right", "twist", "inwards"} , BodyMove m) = m[rightArmTwist=Inwards()];
BodyMove compile("arm", {"right", "twist", "outwards"} , BodyMove m) = m[rightArmTwist=Outwards()];
BodyMove compile("arm", {"right", "twist", "far", "inwards"} , BodyMove m) = m[rightArmTwist=FarInwards()];

BodyMove compile("arm", {"left", "up"}, BodyMove m) = m[leftArm=ArmMove::Up()]; 
BodyMove compile("arm", {"left", "down"} , BodyMove m) = m[leftArm=ArmMove::Down()];
BodyMove compile("arm", {"left", "forwards"} , BodyMove m) = m[leftArm=Forwards()];
BodyMove compile("arm", {"left", "forwards", "up"} , BodyMove m) = m[leftArm=ForwardsUp()];
BodyMove compile("arm", {"left", "forwards", "down"} , BodyMove m) = m[leftArm=ForwardsDown()];
BodyMove compile("arm", {"left", "forwards", "up", "sideways"} , BodyMove m) = m[leftArm=ForwardsUpSideways()];
BodyMove compile("arm", {"left", "forwards", "down", "sideways"} , BodyMove m) = m[leftArm=ForwardsDownSideways()];
BodyMove compile("arm", {"left", "forwards", "sideways"} , BodyMove m) = m[leftArm=ForwardsSideways()];
BodyMove compile("arm", {"left", "sideways"} , BodyMove m) = m[leftArm=Sideways()];
BodyMove compile("arm", {"left", "sideways", "up"} , BodyMove m) = m[leftArm=SidewaysUp()];
BodyMove compile("arm", {"left", "sideways", "down"} , BodyMove m) = m[leftArm=SidewaysDown()];

BodyMove compile("arm", {"left", "twist", "inwards"} , BodyMove m) = m[leftArmTwist=Inwards()];
BodyMove compile("arm", {"left", "twist", "outwards"} , BodyMove m) = m[leftArmTwist=Outwards()];
BodyMove compile("arm", {"left", "twist", "far", "inwards"} , BodyMove m) = m[leftArmTwist=FarInwards()];

  
  
BodyMove compile("elbow", {"right", "stretch"}, BodyMove m) = m[rightElbow=Stretch()];
BodyMove compile("elbow", {"right", "bend"}, BodyMove m) = m[rightElbow=Bend()];

BodyMove compile("hand", {"right", "open"}, BodyMove m) = m[rightHand=Open()];
BodyMove compile("hand", {"right", "close"}, BodyMove m) = m[rightHand=Close()];

BodyMove compile("elbow", {"left", "stretch"}, BodyMove m) = m[leftElbow=Stretch()];
BodyMove compile("elbow", {"left", "bend"}, BodyMove m) = m[leftElbow=Bend()];

BodyMove compile("hand", {"left", "open"}, BodyMove m) = m[leftHand=Open()];
BodyMove compile("hand", {"left", "close"}, BodyMove m) = m[leftHand=Close()];
  
BodyMove compile("chin", {"forward"}, BodyMove m) = m[chin=CForward()];
BodyMove compile("chin", {"up"}, BodyMove m) = m[chin=ChinMove::Up()];
BodyMove compile("chin", {"down"}, BodyMove m) = m[chin=ChinMove::Down()];

BodyMove compile("legs", {"forward"}, BodyMove m) = m[legs=Stretch()];
BodyMove compile("legs", {"squat"}, BodyMove m) = m[legs=Squat()];
BodyMove compile("legs", {"hawaii", "left"}, BodyMove m) = m[legs=HawaiiLeft()];
BodyMove compile("legs", {"hawaii", "right"}, BodyMove m) = m[legs=HawaiiRight()];
BodyMove compile("legs", {"luckyluke"}, BodyMove m) = m[legs=LuckyLuke()];

BodyMove compile("look", {"far", "left"}, BodyMove m) = m[look=FarLeft()];
BodyMove compile("look", {"far", "right"}, BodyMove m) = m[look=FarRight()];
BodyMove compile("look", {"left"}, BodyMove m) = m[look=Left()];
BodyMove compile("look", {"right"}, BodyMove m) = m[look=Right()];
BodyMove compile("look", {"forward"}, BodyMove m) = m[look=LForward()];
  
