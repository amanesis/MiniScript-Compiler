#!/bin/bash
bison -d -v -r all myanalyzer.y
echo "Bison completed successfully";
flex mylexer.l
echo "Flex completed successfully";
gcc -o mycomp myanalyzer.tab.c lex.yy.c cgen.c -lfl
echo "Passing the test.tc file to the compiler";
./mycomp < test.tc 
echo "Creating the myprog.c file "
./mycomp < test.tc > myprog.c
