module lang::marvol::REPL

import String;
import ParseTree;
import lang::marvol::Marvol;
import lang::marvol::Check;
import lang::marvol::Expand;
import lang::marvol::Compile;
import lang::marvol::Moves;
import util::REPL;

public REPL getREPL() 
    = repl("Marvol", "Let\'s dance", "? ", |tmp:///marv.history|, handler, completor);
    
private CommandResult handler(str line) {
    try {
        Dance dance;
        try {
            dance = parse(#Dance, trim(line));
        }
        catch ParseError(_): {
            dance = parse(#Dance, trim("<line>;"));
        }
        program = (Program)`<Dance dance>`;
        moves = compile(expand(program));
        doAsyncDance(moves);
        return <"dance started!", [], "? ">;
    }
    catch ParseError(e): {
        return <"Syntax error at column <e.begin.column>", [], "? ">;
    }
}

private Completion completor(str line, int cursor) {
    return <0, []>;
}