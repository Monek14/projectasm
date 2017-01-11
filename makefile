prog: main.o proj.o
	gcc -m64 main.o proj.o -o prog

main.o: main.c
	gcc -m64 -c main.c -o main.o
	
proj.o: proj.asm
	nasm -felf64 proj.asm -o proj.o
