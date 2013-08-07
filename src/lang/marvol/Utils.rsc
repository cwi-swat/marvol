module lang::marvol::Utils

import lang::marvol::Marvol;

map[Id, Dance] getDefs(Program p) 
  = ( x: d | /(Definition)`<Id x> = <Dance d>.` := p );