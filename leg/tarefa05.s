@Joao Vitor da Silva Borsari - RA:170752


FIM_MEMORIA  .equ 0x10000		
TRATADA      .equ 0x0f			

KEYBD_DATA   .equ 0x80   		
KEYBD_STAT   .equ 0x81   		
DISPLAY_DATA .equ 0x20   		
KEYBD_READY  .equ 1      		
KEYBD_OVRN   .equ 2      		

INT_KEYBD    .equ 0x10   		

	.org  INT_KEYBD*4        	
					
					
					
.word trata_int_teclado

	.org 0X1024
@ variaveis
contador:
  	.skip 1
tab_digitos:
  	.byte  0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f
intervalo:   
  	.word 0x1000000

mostra:					@funcao que atualiza valor do display
	push r1
  	set r1, tab_digitos			@acessa enderecos de digitos	
  	add r1, r0				@encontra combinacao de segmentos correspondente
  	ldb r0, [r1]
  	outb DISPLAY_DATA, r0			@liga segmentos do display
  	pop r1
  	ret

decrementa:
  	cmp r0, 0				@verifica se digito de entrada e zero
  	jz retorno				@se for, nao faz nada
  	mov r1, r0				@guarda valor do digito de entrada
atualiza:
  	ld r2, intervalo			@set de valor para loop de espera
  	call mostra
  	cmp r1, 0				@verifica se contador chegou em 0
  	jz retorno
loop:
  	sub r2, 1				@loop de espera
  	jnz loop
  	sub r1, 1				@decrementa digito guardado
  	mov r0, r1				@passa valor em r0 para chamada da funcao mostra (r0 e parametro)
  	jmp atualiza
retorno:
  	ret

init:
  	set sp, FIM_MEMORIA			@inicializa pilha
  	sti					@possibilita interrupcao
  	set r0, 0x7e				@display inicia no valor 0
  	outb DISPLAY_DATA, r0	
  	set r0, TRATADA
  	stb contador, r0			@guarda valor de comparacao em 'contador'
mostra_tecla_espera:
  	ldb r0, contador			@loop que verifica se houve interrupcao
  	cmp r0, TRATADA
  	jz mostra_tecla_espera
  	call decrementa
  	set r0, TRATADA
  	stb contador, r0			@volta contador ao valor de comparacao
  	jmp mostra_tecla_espera

trata_int_teclado:			@tratamento da interrupcao guarda em contador o digito de entrada
	  push r0
	  inb r0, KEYBD_DATA
	  stb contador, r0
	  pop r0
	  iret
