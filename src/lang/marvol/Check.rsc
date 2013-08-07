module lang::marvol::Check

import lang::marvol::Marvol;
import lang::marvol::Utils;
import Message;
import Relation;

/* To check
 * - Recursion
 * - Duplicate defs
 * - Undefined calls
 */

set[Message] detectRecursion(Program p) {
  ds = getDefinitions(p);
  deps = { <a, b> | a <- ds, /(Dance)`<Id b>` := ds[a] };
  depsTr = deps+;
  return { error("Recursion", a@\loc) | <a, b> <- deps, a in depsTr[a] }; 
}
