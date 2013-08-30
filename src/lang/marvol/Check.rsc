module lang::marvol::Check

import lang::marvol::Marvol;
import lang::marvol::Utils;
import Message;
import Relation;
import ParseTree;

/* To check
 * - Recursion
 * - Duplicate defs
 * - Undefined calls
 * - Valid combinations of part/move
 * - Zip args should be equal length
 */

rel[str, set[str]] PART_MOVES = {
  <"arm", {"right", "up"}>,
  <"arm", {"right", "down"}>,
  <"arm", {"right", "forwards"}>,
  <"arm", {"right", "forwards", "up"}>,
  <"arm", {"right", "forwards", "down"}>,
  <"arm", {"right", "forwards", "up", "sideways"}>,
  <"arm", {"right", "forwards", "down", "sideways"}>,
  <"arm", {"right", "forwards", "sideways"}>,
  <"arm", {"right", "sideways"}>,
  <"arm", {"right", "sideways", "up"}>,
  <"arm", {"right", "sideways", "down"}>,
  <"arm", {"right", "twist", "inwards"}>,
  <"arm", {"right", "twist", "outwards"}>,
  <"arm", {"right", "twist", "far", "inwards"}>,
  
  <"arm", {"left", "up"}>,
  <"arm", {"left", "down"}>,
  <"arm", {"left", "forwards"}>,
  <"arm", {"left", "forwards", "up"}>,
  <"arm", {"left", "forwards", "down"}>,
  <"arm", {"left", "forwards", "up", "sideways"}>,
  <"arm", {"left", "forwards", "down", "sideways"}>,
  <"arm", {"left", "forwards", "sideways"}>,
  <"arm", {"left", "sideways"}>,
  <"arm", {"left", "sideways", "up"}>,
  <"arm", {"left", "sideways", "down"}>,
  <"arm", {"left", "twist", "inwards"}>,
  <"arm", {"left", "twist", "outwards"}>,
  <"arm", {"left", "twist", "far", "inwards"}>,

  <"elbow", {"right", "stretch"}>,
  <"elbow", {"right", "bend"}>,
  <"hand", {"right", "open"}>,
  <"hand", {"right", "close"}>,

  <"elbow", {"left", "stretch"}>,
  <"elbow", {"left", "bend"}>,
  <"hand", {"left", "open"}>,
  <"hand", {"left", "close"}>,

  <"chin", {"forward"}>,
  <"chin", {"up"}>,
  <"chin", {"down"}>,
  <"leg", {"stretch"}>,
  <"leg", {"squat"}>,
  <"leg", {"hawaii", "left"}>,
  <"leg", {"hawaii", "right"}>,
  <"leg", {"luckyluke"}>,
  <"look", {"far", "left"}>,
  <"look", {"far", "right"}>,
  <"look", {"left"}>,
  <"look", {"right"}>,
  <"look", {"forward"}>
};

set[Message] checkMarvol(Program p) {
  errs = detectRecursion(p);
  errs += duplicateDefs(p);
  errs += undefinedDefs(p);
  errs += unusedDefs(p);
  errs += zeroRepeats(p);
  errs += checkDances(p);
  return errs;
}

set[Message] detectRecursion(Program p) {
  ds = getDefs(p);
  deps = { <a, b> | a <- ds, /(Dance)`@<Id b>;` := ds[a] };
  depsTr = deps+;
  return { error("Recursion", a@\loc) | <a, b> <- deps, a in depsTr[a] }; 
}


set[Message] duplicateDefs(Program p) {
  seen = {};
  errs = {};
  for (/Definition d := p) {
    if (d.name in seen) 
      errs += {error("Duplicate definition", d.name@\loc)};
    else 
      seen += {d.name};
  }
  return errs;
}

set[Message] undefinedDefs(Program p) {
  ds = getDefs(p);
  return { error("Undefined dance", b@\loc) 
            | /(Dance)`@<Id b>;` := p, b notin ds };
}

set[Message] unusedDefs(Program p) {
 ds = getDefs(p);
 calls = { x | /(Dance)`@<Id x>;` := p };
 return { warning("Unused definition", d@\loc) | d <- ds, d notin calls };
}

set[Message] zeroRepeats(Program p)
  = { warning("Empty repetition", r@\loc) 
       | /r:(Dance)`repeat 0 <Dance _>` := p };
         


set[Message] checkDances(Program p) = ( {} | it + check(d) | /Dance d := p );

set[Message] check(d:(Dance)`<Part p> <Move+ ms>;`) = 
  { error("Invalid part/move combination", d@\loc) 
     | <"<p>", { "<m>" | m <- ms }> notin PART_MOVES };
     
set[Message] check((Dance)`repeat <Nat _> <Dance d>`) = check(d);

set[Message] check((Dance)`backforth <Nat _> <Dance d>`) = check(d);

set[Message] check((Dance)`{<Dance* ds>}`) = 
  ( {} | it + check(d) | d <- ds );

set[Message] check(d:(Dance)`|<Dance* ds>|`) 
  = ( {} | it + check(d) | d <- ds );
  
set[Message] check((Dance)`mirror <Dance d>`) = check(d);

default set[Message] check(Dance _) = {};     


