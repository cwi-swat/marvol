module lang::marvol::Utils

import lang::marvol::Marvol;
import util::Math;
import List;

map[Id, Dance] getDefs(Program p) 
  = ( x: d | /(Definition)`def <Id x> = <Dance d> end` := p );
  
int length((Dance)`@<Id x>;`, map[Id, Dance] defs) = length(defs[x], defs);  
  
int length((Dance)`{<Dance* ds>}`, map[Id, Dance] defs) 
  = ( 0 | it + length(d, defs) | d <- ds ); 

int length((Dance)`|<Dance* ds>|`, map[Id, Dance] defs)
  = max([ length(d, defs) | d <- ds ]);
  
int length((Dance)`repeat <Nat n> <Dance d>`, map[Id, Dance] defs) 
  = toInt("<n>") * length(d, defs);

int length((Dance)`backforth <Nat n> <Dance d>`, map[Id, Dance] defs) 
  = 2 * toInt("<n>") * length(d, defs) - 1;
  
int length((Dance)`mirror <Dance d>`, map[Id, Dance] defs) = length(d, defs);
  
  
default int length(Dance d, map[Id, Dance] defs) = 1;