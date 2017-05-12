								@Victor Cintra Santos RA:157461
	
	port_dado .equ 0x80			@porta de dados do teclado
	port_est .equ 0x81			@porta estado do teclado
	tipo_inter .equ 0x10 		@tipo de interrupcao do teclado
	port_led .equ 0x20			@porta display led
	tecla_tratada .equ 0x0f		@indica que tecla ja foi tratada

	.org tipo_inter*4			@alocamos na memoria o tipo da interrupcao do teclado
	.word tratamento_inter

	.org 0x1000
	contador: .skip 4			@variavel para armazenar valor da tecla pressionada pelo usuario
	seg_7:						@variavel com os valores dos seguimentos para mostrar os numeros
		.byte 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x73
								@valores em hexadecimal de 0 ate 9 (respectivo ao display)
	intervalo: .word 0x400000	@variavel para fazermos loop de espera


tratamento_inter:				@rotina de tratamento de interrupcao do teclado
	set r13, contador			@apontamos r13 para variavel contador
	in r12, port_dado			@colocamos em r12 o valor da tecla pressionada
	st [r13], r12 				@e atualizamos na memoria
	set r12, 0					@zeramos auxiliares
	set r13, 0
	iret 						@retornamos da rotina de interrupcao

mostra:							@funcao que mostra no display o valor passado por parametro por r0
	set r13, seg_7
	add r13, r0
	ld 	r7,[r13]
	out port_led, r7		@printa no display o valor de r0 (pega a variavel seg_7 e soma r0)
	set r13, 0
	ret 						@retornamos da funcao

decrementa:						@funcao que printa no display um numero e vai decrementando ate 0
	ld r1, intervalo			@pegamos valor do intervalo de espera do loop
	call mostra  				@chamada da funcao para printar no display
	sub r0, 1
	jns loop_espera				@entramos no loop de espera se a subtracao nao der negativa
	set r1, tecla_tratada		@pegamos valor que indica que a tecla ja foi tratada
	stb contador,r1 		 	@e colocamos na memoria
	set r1, 0					@zeramos auxiliar
	ret 						@retornamos da funcao decrementa
loop_espera:					@loop que subtrai 1 de r1 ate 0, voltando a funcao decrementa
	sub r1, 1
	jnz loop_espera
	cmp r1, 0
	jz decrementa

init:
	set sp, 0x8000				@inicializamos pilha
	sti							@habilita interrupcoes
	set r0, tecla_tratada		@pegamos valor que indica que a tecla ja foi tratada
	stb contador, r0			@e colocamos em contador
	set r0, 0					@zeramos display no comeco
	call mostra
loop_init:
	ldb r0, contador			@verificamos o estado da tecla
	cmp r0, tecla_tratada		@e comparamos se ja foi tratada
	jz loop_init
	call decrementa 			@chamamos funcao decrementa
	jmp loop_init				@voltamos ao loop