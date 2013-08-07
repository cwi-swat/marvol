module lang::marvol::IDE

import util::IDE;
import ParseTree;
import lang::marvol::Marvol;

void setup() {
  registerLanguage("Marvol", "marvol", Tree (str src, loc org) {
     return parse(#start[Program], src, org);
  });
}