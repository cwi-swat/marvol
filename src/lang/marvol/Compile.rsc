module lang::marvol::Compile

import lang::marvol::Marvol;

anno rat Dance@scale;

Dance normalize(Dance d) {
  innermost visit (d) {
    case (Dance)`<Action a> <Nat n>`: {
      x = toInt("<n>");
      as = [ a[@scale=1r / toRat(x)] | i <- [0..x] ];
      insert merge(as); 
      if (i > 1) {
        nMin1 = parse(#Nat, "<i - 1>", n@\loc); 
        insert (Dance)`{<Action a> <Nat nMin1>; <Action a>}`;
      }
    }
  
  }

}