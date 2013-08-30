module lang::marvol::IDE

import util::IDE;
import ParseTree;
import lang::marvol::Marvol;
import lang::marvol::Check;
import Message;

void setup() {
  registerLanguage("Marvol", "marvol", Tree (str src, loc org) {
     return parse(#start[Program], src, org);
  });
  
  registerContributions("Marvol", {
     annotator(Tree (Tree input) {
       if (Program p := input.top) {
         return input[@messages=checkMarvol(p)];
       }
       return {error("Invalid tree", input@\loc)};
     })
  });
}