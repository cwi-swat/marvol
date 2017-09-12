module Plugin

import util::IDE;
//import util::ContentCompletion;
import ParseTree;
import lang::marvol::Marvol;
import lang::marvol::Check;
import lang::marvol::Expand;
import lang::marvol::Compile;
import lang::marvol::Moves;
//import lang::marvol::Proposer;
import lang::marvol::REPL;
import Message;
import IO;
import String;
import util::REPL;
 
public str IP = "192.168.1.102";
  
void main() {
  init(IP);
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
     
    // proposer(list[CompletionProposal] (Tree fd, str prefix, int requestOffset) {
    // 	if (Program p := fd.top) {
    //		return propose(prefix, findDanceDefinitions(p));
    //	}  
    //	return {error("Invalid tree", input@\loc)}; 		
    //}, alphaNumeric),
     
     outliner(node (Tree input) {
            if (Program p := input.top) {
              return marvolOutline(p);
            }
            return "NO_OUTLINE"();
          }),
          
     popup(edit("Normalize", str (Tree input, loc selection) {
            if (Program p := input.top) {
             return unparse(expandToSource(p));
            }
            return unparse(input);
          })), 
     popup(action("Marve... Dance!", void (Tree tree, loc selection) {
            if (Program p := tree.top) {
              moves = compile(expand(p));
              f = p@\loc;
              if (/^<fname:.*>\.marvol$/ := f.path) {
                f.path = "<fname>.compiled";
                writeFile(f.top, "MOVES\n");          
                for (m <- moves) {
                  appendToFile(f, "<m>\n");
                }
              }
              doAsyncDance(moves);
            }
          })), 
     popup(action("Marv... Stop it!", void (Tree tree, loc selection) {
            cancelCurrentDance();
          })),  
     popup(action("Marv... Move!", void (Tree tree, loc selection) {
            tsr = treeAt(#Dance, selection, tree);
            if (Program p0 := tree.top, treeFound(Dance d) := tsr) {
              ds = p0.defs;
              p = (Program)`<Definition* ds> <Dance d>`;
              moves = compile(expand(p));
              doAsyncDance(moves);
            }
          })),
        
     builder(set[Message] ((&T<:Tree) tree) {
        if (Program p := tree.top) {
          src = unparse(expandToSource(p));
          f = p@\loc;
          if (/^<fname:.*>\.marvol$/ := f.path) {
            f.path = "<fname>-normalized.marvol";
            writeFile(f.top, src);
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

node marvolOutline(Program p) {
  return "root"([ 
    "def"()[@label="<d.name>"][@\loc=d.name@\loc] | d <- p.defs 
  ]);
}


void marvolShell() {
	startREPL(getREPL());
}
