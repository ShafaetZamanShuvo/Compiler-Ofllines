flex -o 1705086_lex.c 1705086.l
g++ 1705086_lex.c -lfl -o lex.out
./lex.out input.txt
