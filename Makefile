default:
	gcc -o boxologic src/binpack.c
	@echo 'Now try "make demo" for sample results.'

demo: default
	./boxologic -f bin/boxlist.txt
