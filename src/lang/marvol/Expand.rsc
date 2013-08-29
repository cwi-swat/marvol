module lang::marvol::Expand

extend lang::marvol::Marvol;
import lang::marvol::Utils;
import ParseTree;
import util::Math;

/*
 * Expand expands a program into a flat list of dance statements;
 * the elements may only consist of:
 *  - Atomic moves
 *  - A (possibly nested) zip dance with only atoms as arguments.
 *
 * NB: this requires that static checker does not return errors
 * (especially wrt recursion in defs and undefined calls).
 */

list[Dance] expand(Program p) = expand(p.main, getDefinitions(p));

list[Dance] expand(d:(Dance)`zip <Dance d1> and <Dance d2>`, map[Id, Dance] defs)
  = [ (Dance)`zip <Dance e1> and <Dance e2>` | <e1, e2> <- zip(es1[0..l], es2[0..l]) ]
  when 
    l := length(d, defs), // length of zip is minimum of length of d1 and d2
    es1 := expand(d1, defs),
    es2 := expand(d2, defs);  

list[Dance] expand((Dance)`@<Id x>;`, map[Id,Dance] defs) 
  = expand(defs[x], defs);

list[Dance] expand((Dance)`{<Dance* ds>}`, map[Id,Dance] defs) 
  = ( [] | it + expand(d) | d <- ds );

list[Dance] expand((Dance)`repeat <Nat n> <Dance d>`, map[Id,Dance] defs) 
  = ( [] | it + expand(d) | i <- [0..toInt("<n>")] );

default list[Dance] expand(Dance d, map[Id,Dance] defs) = [d];

