module lang::marvol::Utils

import lang::marvol::Marvol;
import util::Math;

map[Id, Dance] getDefs(Program p) 
  = ( x: d | /(Definition)`def <Id x> = <Dance d>.` := p );
  
int length((Dance)`@<Id x>;`, map[Id, Dance] defs) = length(defs[x], defs);  
  
int length((Dance)`{<Dance* ds>}`, map[Id, Dance] defs) 
  = ( 0 | it + length(d, defs) | d <- ds ); 
  
int length((Dance)`repeat <Nat n> <Dance d>`, map[Id, Dance] defs) 
  = toInt("<n>") * length(d, defs);
  
int length((Dance)`zip <Dance d1> and <Dance d2>`, map[Id, Dance] defs)
  = min(length(d1, defs), length(d2, defs));
  
default int length(Dance d, map[Id, Dance] defs) = 1;