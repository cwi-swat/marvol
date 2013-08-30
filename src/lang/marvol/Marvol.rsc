module lang::marvol::Marvol

extend lang::std::Whitespace;
extend lang::std::Layout;
extend lang::std::Comment;

start syntax Program = Definition* defs Dance main; 

syntax Definition = "def" Id name "=" Dance dance "end";

syntax Dance
  = Part Move+ ";"
  | "repeat" Nat Dance
  | "backforth" Nat Dance
  | "{" Dance* "}"
  | "mirror" Dance
  | "|" Dance* "|" 
  | "@" Id ";"
  | "nop" ";"
  ;

syntax Part
  = "arm"
  | "leg"
  | "elbow"
  | "hand"
  | "chin"
  | "look"
  ;
  
syntax Move
  = "up"
  | "down"
  | "twist"
  | "bend"
  | "stretch"
  | "close"
  | "open"
  | "far"
  | "forwards"
  | "sideways"
  | "inwards"
  | "outwards"
  | "left"
  | "right"
  | "forward"
  | "squat" 
  | "luckyluke" 
  ;

keyword Reserved = ;

lexical Id = ([a-zA-Z_] !<< [a-zA-Z_][a-zA-Z0-9_]* !>> [a-zA-Z0-9_]) \ Reserved;

lexical Nat = [0-9]+ !>> [0-9];
