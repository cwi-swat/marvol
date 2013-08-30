module lang::marvol::Expand

extend lang::marvol::Marvol;
import lang::marvol::Utils;
import ParseTree;
import util::Math;

/*
 * Expand expands a program into a flat list of dance statements;
 * the elements may only consist of:
 *  - Atomic moves
 *  - A (possibly nested) parallel composite dance with only atoms as arguments.
 *  - A mirrored atomic move.
 * TODO: grammar for normal form.
 *
 * NB: this requires that static checker does not return errors
 * (especially wrt recursion in defs and undefined calls).
 */

list[Dance] expand(Program p) = expand(p.main, getDefinitions(p));

list[Dance] expand(d:(Dance)`|<Dance* ds>|`, map[Id, Dance] defs) {
  l = length(d, defs);
  ess = [ expand(d, defs) | d <- ds ];
  return for (i <- [0..l]) {
    elts = for (j <- [0..size(ess)]) {
      if (i < size(ess[j])) {
        append ess[j][i];
      }
      else {
        append (Dance)`nop;`;
      }
    }
    append makePar(elts);
  }
}

Dance makePar([]) = (Dance)`||`;
Dance makePar([Dance d, Dance *ds]) = (Dance)`|<Dance d> <Dance* dss>|`
  when (Dance)`|<Dance* dss>|` := makePar(ds);

list[Dance] expand((Dance)`@<Id x>;`, map[Id,Dance] defs) 
  = expand(defs[x], defs);

list[Dance] expand((Dance)`{<Dance* ds>}`, map[Id,Dance] defs) 
  = ( [] | it + expand(d) | d <- ds );

list[Dance] expand((Dance)`repeat <Nat n> <Dance d>`, map[Id,Dance] defs) 
  = ( [] | it + expand(d) | i <- [0..toInt("<n>")] );

list[Dance] expand((Dance)`backforth <Nat n> <Dance d>`, map[Id,Dance] defs) 
  = ( [] | it + expand(d) + reverse(expand(d))[1..] | i <- [0..toInt("<n>")] );

list[Dance] expand((Dance)`mirror <Dance d>`, map[Id,Dance] defs)
  = [ (Dance)`mirror <Dance e>` | e <- expand(d, defs) ];

default list[Dance] expand(Dance d, map[Id,Dance] defs) = [d];

