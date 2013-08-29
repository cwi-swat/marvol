module lang::marvol::Expand

import lang::marvol::Marvol;
import lang::marvol::Utils;
import ParseTree;
import util::Math;

// requires non-recursive
Program expand(Program p) {
  defs = getDefinitions(p);
  p = innermost visit (p) {
    case (Dance)`@<Id x>;` => defs[x]
    case (Dance)`repeat 0 <Dance _>` => (Dance)`{}`
    case (Dance)`repeat <Nat n> <Dance d>` => (Dance)`{repeat <Nat nMin1> <Dance d> <Dance d>}`
      when nMin1 := parse(#Nat, "<toInt("<n>") - 1>")
  }
  
}
