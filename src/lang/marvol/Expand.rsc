module lang::marvol::Expand

extend lang::marvol::Marvol;
import lang::marvol::Utils;
import ParseTree;
import util::Math;
import List;
import IO;
import String;

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


list[Dance] expand(Program p) = expand(p.main, getDefs(p));

list[Dance] expand(d:(Dance)`{|<Dance* ds>|}`, map[Id, Dance] defs) {
  l = length(d, defs);
  ess = [ expand(d2, defs) | d2 <- ds ];

  for (e <- ess) println("e = <intercalate(", ", e)>");
  return for (i <- [0..l]) {
    list[Dance] elts = [];
    for (j <- [0..size(ess)]) {
      if (i < size(ess[j])) {
        println("Appending <ess[j][i]>");
        elts += [ess[j][i]];
      }
      else {
        println("Appending nop");
        elts += [(Dance)`nop;`];
      }
    }
    println("Elts: ");
    for (x <- elts) println(x);
    append makePar(elts);
  }
}

//Dance makePar([]) = (Dance)`||`;
//Dance makePar([Dance d, *list[Dance] ds]) = (Dance)`|<Dance d> <Dance* dss>|`
//  when (Dance)`|<Dance* dss>|` := makePar(ds);

Dance makePar(list[Dance] ds) {
  if (ds == []) {
    return (Dance)`{||}`;
  }
  if ((Dance)`{|<Dance* dss>|}` := makePar(tail(ds))) {
    Dance d = ds[0];
    if ((Dance)`{|<Dance* dss2>|}` := d) {
      return (Dance)`{|<Dance* dss2> <Dance* dss>|}`;
    }
    return (Dance)`{|<Dance d> <Dance* dss>|}`;
  }
  throw "Should not happen";
}


list[Dance] expand((Dance)`{<Dance* ds>}`, map[Id,Dance] defs) 
  = ( [] | it + expand(d, defs) | d <- ds );

list[Dance] expand((Dance)`repeat <Nat n> <Dance d>`, map[Id,Dance] defs) 
  = ( [] | it + expand(d, defs) | i <- [0..toInt("<n>")] );

list[Dance] expand((Dance)`backforth <Nat n> <Dance d>`, map[Id,Dance] defs) {
    ds = expand(d, defs);
    forward = ds[0..-1];
    backward = reverse(ds[1..]);
    return ( [] | it + forward + backward | i <- [0..toInt("<n>")] ) + [head(ds)];
    }
    	
list[Dance] backForth(Dance d, map[Id, Dance] defs) {

  ds += tail(reverse(ds));
  return ds;
}

list[Dance] expand((Dance)`mirror <Dance d>`, map[Id,Dance] defs)
  = [ (Dance)`mirror <Dance e>` | e <- expand(d, defs) ];


list[Dance] expand((Dance)`arms <Move+ ms>;`, map[Id, Dance] defs)
  = expand((Dance)`{|arm left <Move+ ms>; arm right <Move+ ms>;|}`, defs);

list[Dance] expand((Dance)`hands <Move+ ms>;`, map[Id, Dance] defs)
  = expand((Dance)`{|hand left <Move+ ms>; hand right <Move+ ms>;|}`, defs);

list[Dance] expand((Dance)`elbows <Move+ ms>;`, map[Id, Dance] defs)
  = expand((Dance)`{|elbow left <Move+ ms>; elbow right <Move+ ms>;|}`, defs);

list[Dance] expand((Dance)`<Id x>;`, map[Id,Dance] defs) 
  = expand(defs[x], defs);

default list[Dance] expand(Dance d, map[Id,Dance] defs) = [d];

Program expandToSource(Program p) {
  Dance makeSeq(list[Dance] ds) {
    if (ds == []) {
      return (Dance)`{}`;
    }
    if ((Dance)`{<Dance* dss>}` := makeSeq(tail(ds))) {
      Dance d = ds[0];
      return (Dance)`{<Dance d>
                    '<Dance* dss>}`;
    }
    throw "Should not happen";
  }
  Dance d = makeSeq(expand(p));
  return (Program)`<Dance d>`;
}
