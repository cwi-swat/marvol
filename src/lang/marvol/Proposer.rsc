module lang::marvol::Proposer

import util::ContentCompletion;

import ParseTree;
import List;
import IO;

import lang::marvol::Marvol;

alias PartsAndMoves = tuple[set[str] parts, set[str] moves];

list[CompletionProposal] propose(str prefix, set[str] definitions) {
	PartsAndMoves pm = minePartsAndMovesFromGrammar();
	list[CompletionProposal] proposals = createProposals(pm, definitions);
	proposals = sort(proposals);
	proposals = filterPrefix(proposals, prefix);
	
	return proposals;	
}

private list[CompletionProposal] createProposals(PartsAndMoves pm, set[str] definitions) = 
	[sourceProposal("<p>", "<p> - Part") | p <- pm.parts] +
	[sourceProposal("<m>", "<m> - Move") | m <- pm.moves] +
	[sourceProposal("<d>", "<d> - Dance") | d <- definitions];

private bool isCursosWithin(loc location, int offset) {
	if (offset < 0) return false;

	int begin = location.offset;
	int end = begin + location.length;	
	return begin <= offset && end >= offset;
}

set[str] findDanceDefinitions(Program prog) =
	{"<def.name>" | /Definition def := prog};

@memo
PartsAndMoves minePartsAndMovesFromGrammar() = <mineGrammar(#Part), mineGrammar(#Move)>;

private set[str] mineGrammar(&T t) = 
	{kw | /prod(sort(prodName), [lit(str kw)], _) := t.definitions}
	when sort(str prodName) := t[0];
