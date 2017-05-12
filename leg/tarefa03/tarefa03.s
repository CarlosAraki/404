										@ Carlos Vinícius Araki Oliveira RA:160141
tam_max .equ 20			@tamanho máximo da pilha
.org 0x100
num_elem: 					@numero de elementos em 32 bits
	.skip 4
vetor:							@rótulo do vetor na posição 0x104

.org  0x1000

add64:							@começo da função
	ld r7,[sp+4]			@pego primeiro valor do meu parâmetro
	ld r8,[sp+8]			@pego o segundo parâmetro
	ld r2,[sp+12]			@pego primeiro valor do meu parâmetro
	ld r3,[sp+16]			@pego o segundo parâmetro
	add r0,r7   			@te valor do menos significativo
	jc soma						@se tiver carry somo mais 1
	add r0,r2 				@somo o segundo parametros
	jc  soma2					@se der carry vou para soma2
	add r1,r8					@somo o valor mais significativo
	add r1,r3					@se nao somo normal e retorno
	jmp fim 					@se passou em tudo retorno
soma:
	add r1,1 	  			@somo o carry
	add r0,r3 				@somo o segundo valor em r3
	jc soma2 					@ se tiver carry somo mais 1 em r1
	add r1,r8					@somo o primeiro valor mais significativo
	add r1,r3   			@te valor do mais significativo
	jmp fim 					@acabou a soma
soma2:
	add r1,1 	  			@somo o carry
	add r1,r8					@ somo o primeiro valor mais significativo
	add r1,r3					@somo o segundo valor mais significativo
	jmp fim 					@ acabou a soma
fim:
	ret								@retorna da funcao


.org 0x2000
init:
	set sp,ini_pilha 	@aponto para o inicio da ini_pilha
	ld r4,num_elem 		@pego o numero de elementos
	set r5,vetor 			@endereço do vetor
loop:
	ld r6,[r5+12]			@r6 tem o valor
	push r6 					@coloco valor em r6
	ld r6,[r5+8]			@pego a segunda parte do valor
	push r6 					@coloco na pilha
	ld r6,[r5+4]			@pego o segundo valor para soma
	push r6						@coloco na pilha de parametros
	ld r6,[r5]				@pego a segunda parte do valor2
	push r6						@coloco na pilha de parametros
	add r5,16					@movo o a posição do vetor
	call add64 				@chamo a função
	add sp,16					@removo os dados da pilha usados como parametros
	sub r4,1 					@diminuo um elemento
	jl acabou 				@se for negativo interrompo o programa
	jmp loop 					@se nao loop
acabou:
	hlt

fim_pilha:					@aloco tamanho para minha pilha
	.skip 	tam_max
ini_pilha:
