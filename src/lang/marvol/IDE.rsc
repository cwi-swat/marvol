module lang::marvol::IDE

import util::IDE;
import ParseTree;
import lang::marvol::Marvol;
import lang::marvol::Check;
import lang::marvol::Expand;
import lang::marvol::Compile;
import lang::marvol::Moves;
import Message;
import IO;

void setup() {
  //init("127.0.0.1");
  registerLanguage("Marvol", "marvol", Tree (str src, loc org) {
     return parse(#start[Program], src, org);
  });
  
  registerContributions("Marvol", {
     annotator(Tree (Tree input) {
       input = crossRef(input);
       if (Program p := input.top) {
         return input[@messages=checkMarvol(p)];
       }
       return {error("Invalid tree", input@\loc)};
     }),
     popup(menu("Marvol", 
        [
          edit("Normalize", str (Tree input, loc selection) {
            if (Program p := input.top) {
             return unparse(expandToSource(p));
            }
            return unparse(input);
          }),
          
          action("Dance!", void (Tree tree, loc selection) {
            if (Program p := tree.top) {
              moves = compile(expand(p));
              f = p@\loc;
              if (/^<fname:.*>\.marvol$/ := f.path) {
                f.path = "<fname>.compiled";
                writeFile(f, "MOVES\n");          
                for (m <- moves) {
                  appendToFile(f, "<m>\n");
                }
              }
              doAsyncDance(moves);
            }
          }),
          action("Stop it!", void (Tree tree, loc selection) {
            cancelCurrentDance();
          })  
        ])),
        
     builder(set[Message] ((&T<:Tree) tree) {
        if (Program p := tree.top) {
          src = unparse(expandToSource(p));
          f = p@\loc;
          if (/^<fname:.*>\.marvol$/ := f.path) {
            f.path = "<fname>-normalized.marvol";
            writeFile(f, src);
            return {};
          }
          return {error("Could not obtain filename", tree@\loc)};
        }
        return {error("Not a Marvol program", tree@\loc)};
     })
  });
}

// bug, need start[Program]
Tree crossRef(Tree p) {
  ds = ( d.name: d.name | /Definition d := p );
  return visit (p) {
//    case d:(Dance)`@<Id x>;` => d[@link=ds[x]@\loc]
    case Dance d => d[@link=ds[d.name]@\loc]
      when d is call, d.name in ds
  }
}