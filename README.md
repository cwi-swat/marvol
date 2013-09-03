marvol
======

A DSL to make Marv [Dance](http://haskell.cs.yale.edu/?post_type=publication&p=168).

Marvol Install:


Get Rascal & Marvol https://github.com/cwi-swat/marvol

Get Java JNI NAO library from Maarten’s NAO DVD
On linux & Mac set your LD_LIBRARY_PATH environment variable (on windows I do not know what to do)
 to include the directory where the shared library (.so file on linux/mac) file is at
import the marvol project into eclipse and add the .jar file as build-time dependency (the jar file is in the same directory as the shared library).
Set the ip adress of the NAO in compile.rsc
run in Rascal console: 

import lang::marvol::IDE;
setup();

Open example file and it should work!
