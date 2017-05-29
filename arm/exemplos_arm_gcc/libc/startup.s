@ arquivo de inicialização para ARM
@ inicializa pilha e define rótulos utilizados pelo ligador (_start)
@ e pelas bibliotecas da linguagem C (_heap_end)

	.equ HEAP_SIZE, 0x10000
	.equ STACK_SIZE, 0x10000
	
	.text
	.align 2
	.global _start,_heap_end_

	.org 0x100
_start:
	LDR sp, =_the_stack  @ inicializa pilha 
	BL main              @ chama programa do usuário
	MOV r7,#1            @ quando (se) retorna,
	MOV r0,#0            @ executa chamada a sistema exit(0)
	SVC #0x55

	
	.data
@ espaço para heap
	.skip HEAP_SIZE
_heap_end_:

@ espaço para pilha
	.skip STACK_SIZE
_the_stack:	
	