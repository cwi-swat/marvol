module lang::marvol::IDE

import util::IDE;
import ParseTree;
import lang::marvol::Marvol;
import lang::marvol::Check;
import Message;
import IO;

void setup() {
  registerLanguage("Marvol", "marvol", Tree (str src, loc org) {
     return parse(#start[Program], src, org);
  });
  
  registerContributions("Marvol", {
     annotator(Tree (Tree input) {
       input = crossRef(input);
       if (Program p := input.top) {
         return input[@messages=checkMarvol(p)];
       }
       return {error("Invalid tree", input@\loc)};
     })
  });
}

// bug, need start[Program]
Tree crossRef(Tree p) {
  ds = ( d.name: d.name | /Definition d := p );
  println("DS = ");
  iprintln(ds);
  return visit (p) {
//    case d:(Dance)`@<Id x>;` => d[@link=ds[x]@\loc]
    case Dance d => d[@link=ds[d.name]@\loc]
      when d is call, d.name in ds, bprintln("Annotating")
  }
}