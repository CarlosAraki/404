						@Laura Marchione RA:156169

.org 0x1000
keyle   .equ  0x80		@endereço do valor no keyboard
keyest  .equ  0x81		@endereço do estado do keyboard
led 	.equ  0x40 		@endereço de saida do led
multiplica:
	set r0,0 			@r0 pode não ser zero
	ld r1,[sp+4]   		@pego um dos parâmetros
	ld r2,[sp+8]		@pego outro parâmetros
mult:
	sub r2,1			@subtraio um contador
	jl cabo 			@se for menor que zero acabou minhas somas
	add r0,r1			@se nao somo em r0
	jmp mult 		 	@volto para a próxima soma
cabo:
	ret

read:
	set r0,0 			@zero o r0 porque ele pode ter outro valor
	set r1,1 			@para testar se o estado está ligado
	in r2,keyest 		@pego o valor do estado 
	tst r2,r1 			@testo se o estado está ligado
	jz read 			@se o teste der zero volto para o loop
	in r1,keyle 		@leio o dado e coloco em r1
	rol r1,4 			@rotaciono 4 bits para pegar o segundo elemento
	add r0,r1 			@somo na saida
read2:	
	set r1,1 			@para testar o proximo estado
	in r2,keyest 		@testo se o segundo estado está ligado
	tst r2,r1 			@testo para ver se o estado esta ligado
	jz read2 			@se nao continuo testando
	in r1,keyle 		@leio o valor no keyboard
	add r0,r1 			@somo normalmente
read3:
	set r1,1 			@para testar 
	in r2,keyest 		@ve se o estado estáligado
	tst r2,r1 			@ testo se está ligado
	jz read3 			@continuo no loop 
	in r1,keyle 		@coloco a saida * ou # no r1
	ret 				@retorno a funcao

init:
	set sp,com_plha 	@inicializo meu sp na pilha
	set r3,1 			@meu valor padrão
	out led,r3  		@coloco no led o valor
init2:
	call read 			@chamo minha leitura
	push r0 			@coloco meu primeiro parâmetros
	push r3 			@coloco meu segundo parametro
	call multiplica		@entro na funcao de multiplicacao
	out led,r0 			@solta a multiplicacao no led
	mov r3,r0 			@mando para o valor padrão
	pop r0 				@ desempilho primeiro parametro
	pop r0  			@ desempilho segundo parametro
	sub r1,0xb 			@subtraio para saber se saio
	jz sai 				@se for zero eu saio do programa
	jmp init2 			@se nao eu volto para leitura

sai:
	hlt
	
	.skip 0x20
com_plha: