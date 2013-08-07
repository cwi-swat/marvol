module lang::marvol::Expand

import lang::marvol::Marvol;
import lang::marvol::Utils;

// requires non-recursive
Program expand(Program p) {
  defs = getDefinitions(p);
  return innermost visit (p) {
    case (Dance)`<Id x>` => defs[x]
  }
}
