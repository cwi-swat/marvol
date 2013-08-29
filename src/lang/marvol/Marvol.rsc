module lang::marvol::Marvol

extend lang::std::Whitespace;
extend lang::std::Layout;
extend lang::std::Comment;

start syntax Program = Definition* Dance?; 

syntax Definition = Id "=" Dance ".";

syntax Dance
  = Action action Nat beats
  | Action action
  | "rest" Nat beats
  | "with" Part Dance
  | {Dance "|"}+ 
  | "{" {Dance ";"}* "}"
  | "repeat" Nat Dance
  | Id
  ;

keyword Reserved = ;

lexical Id = ([a-zA-Z_] !<< [a-zA-Z_][a-zA-Z0-9_]* !>> [a-zA-Z0-9_]) \ Reserved;

lexical Nat = [0-9]+ !>> [0-9];

syntax Direction
 = "left"
 | "right"
 | "forward"
 | "backward"
 | "center"
 | "lfd"
 | "lbd"
 | "rfd"
 | "rbd"
 ;
 
syntax Level = "low" | "mid" | "high";
    
lexical Double = [0-9]+ "." [0-9]+ !>> [0-9];
  
syntax Action
  = "move" Direction Level
  | "turn" Direction
  ;
  
  
syntax Part
  = Side Limb
  | "head"
  | "torso"
  ;
  
syntax Side = "left" | "right";
syntax Part = "foot" | "hand";

