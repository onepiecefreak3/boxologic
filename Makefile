all: default

default:
	gcc -o boxologic src/binpack.c
	@echo 'Now try "make demo" for sample results.'

demo: default
	./boxologic -f doc/boxlist.txt

debug:
	gcc -g -o boxologic_debug src/binpack.c

clean:
	rm -f visudat doc/boxlist.txt.out boxologic boxologic_debug