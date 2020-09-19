#!/bin/bash
bison -d -v -r all myanalyzer.y
echo "Bison completed successfully";
flex mylexer.l
echo "Flex completed successfully";
gcc -o mycomp myanalyzer.tab.c lex.yy.c cgen.c -lfl
echo "Passing the test.ms file to the compiler";
./mycomp < test.ms
echo "Creating the myprog.c file "
./mycomp < test.ms > myprog.c
