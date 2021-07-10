							@Carlos Vinícius Araki Oliveira RA:160141

	.org INT_KEYBD*4
	.word trata_teclado
	.org 0x1000

KEYBD_DATA 		.equ 0x80 	@ porta de dados
KEYBD_STAT 		.equ 0x81 	@ porta de estado
DISPLAY_DATA 	.equ 0x20 	@ porta do mostrador
tam_max 		.equ 0x20 	@tamanho da minha pilha
INT_KEYBD 		.equ 0x10 	@ tipo de interrup¸c~ao do teclado



init:
	set sp,ini_pilha		@inicializo a pilha
	sti 					@habilito a interrupção
	call mostra 			@mostro a primeira vez

decrementa:
	cmp r0,0				@comparo vejo se está certo
	jz decrementa			@continuo no loop indefinitivamente
	ld r2,intervalo			@pego o valor para meu intervalo
	stb contador,r0			@coloco meu valor no contador
	call mostra 			@chamo minha função mostra
loop:
	sub r2,1				@subtraio 1
	jge loop				@se for maior ou igual volto para meu loop
	sub r0,1				@subtraio meu r0
	jz mostrazero 			@se for zero vou para motra zero
	jmp decrementa			@ se nao eu decremento

mostrazero:
	ld r2,intervalo			@pego o valor para meu intervalo
loop2:
	sub r2,1				@subtraio 1
	jge loop2				@se for maior ou igual volto para meu loop2
	stb contador,r0			@coloco o valor no contador
	call mostra  			@chamo minha função 
	jmp decrementa 			@volto para decrementa

mostra:
	ldb r0,contador			@ r0  ta com meu parâmetro de 0 à 9
	set r1,tab_digitos 		@seto meu r1 para o endereço de tab_digitos
	add r1,r0 				@ve qual bit que tá
	ldb r3,[r1]				@pego o valor no endereço para tacar no display
	outb DISPLAY_DATA,r3 	@coloco no display
	ret 					@volto

trata_teclado: 				@ rotina de interrup¸c~ao
	inb r0,KEYBD_DATA 		@ l^e porta de dados
	stb contador,r0 		@ armazena valor lido
	iret 					@ e retorna

@ vari´aveis
contador:
	.skip 1
tab_digitos:
	.byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f

intervalo:
	.word 0x400000 			@ para gastar tempo para +- 1 segundo

fim_pilha:					@ aloco tamanho para minha pilha
	.skip 	tam_max
ini_pilha: