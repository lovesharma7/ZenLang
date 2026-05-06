all:
	bison -d src/parser.y
	flex src/lexer.l
	gcc parser.tab.c lex.yy.c src/symbol_table.c src/icg.c src/optimizer.c src/codegen.c -Iinclude -o zenlang

run:
	./zenlang test/sample.zen
	gcc output/output.c -o output/program
	./output/program

clean:
	rm -f parser.tab.c
	rm -f parser.tab.h
	rm -f lex.yy.c
	rm -f zenlang.exe
	rm -f output/program.exe
