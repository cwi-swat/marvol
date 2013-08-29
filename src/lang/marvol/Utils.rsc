module lang::marvol::Utils

import lang::marvol::Marvol;

map[Id, Dance] getDefs(Program p) 
  = ( x: d | /(Definition)`def <Id x> = <Dance d>.` := p );