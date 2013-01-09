all: default

default: boxologic
	@echo 'Now try "make demo" for sample results.'

demo: boxologic
	./boxologic -f doc/boxlist.txt

boxologic_debug: src/binpack.c
	gcc -g -o boxologic_debug src/binpack.c

boxologic: src/binpack.c
	gcc -o boxologic src/binpack.c

clean:
	rm -f visudat doc/boxlist.txt.out boxologic boxologic_debug test/*.out A B

.PHONY: test

test: boxologic
	./test/run_all.sh
