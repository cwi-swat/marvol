module lang::marvol::Marvol

extend lang::std::Whitespace;
extend lang::std::Layout;
extend lang::std::Comment;

start syntax Program = Definition* Dance; 

syntax Definition = "def" Id name "=" Dance dance ".";

syntax Part
  = "arm"
  | "leg"
  | "elbow"
  | "hand"
  | "chin"
  | "look"
  ;

syntax Dance
  = Part Move+ ";"
  | "repeat" Nat Dance
  | "{" Dance* "}"
  | "mirror" Dance
  | "zip" Dance "and" Dance
  | "@" Id ";"
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
  | "far" "left"
  | "left"
  | "forward"
  | "right"
  | "far" "right"
  | "squat" 
  | "luckyluke" 
  ;

keyword Reserved = ;

lexical Id = ([a-zA-Z_] !<< [a-zA-Z_][a-zA-Z0-9_]* !>> [a-zA-Z0-9_]) \ Reserved;

lexical Nat = [0-9]+ !>> [0-9];
