											@Carlos Vinícius Araki Oliveira RA:160141
.global _start
_start:
	mov  r0, #0    			@ fd -> stdin
	ldr  r1, =buffer		@ buf -> buffer
	mov  r2, #32				@	 count -> len(msg)
	mov  r7, #3					@ write é syscall #3
	svc  #0x55   				@ executa syscall
											@tenho meus dados em ascii  no meu buffer  e o numero de caracteres lidos em r0
	sub r0,r0,#1				@converto meus ascii em binário mas antes verifico se é zero

	cmp r0,#1 					@verifico se tenho apenas 1 valor que tem q ser o zero
	mov r5,r0 					@r5 auxiliar de quantidade de dados lidos
	beq soum

converto:
	cmp r0,#0 					@verifico se acabou
	beq acabou
	ldrb r2,[r1] 				@pego o elemento do meu vetor
	cmp r2,#0x3a  			@ comparo com o maior o valor acima de 9
	bgt letra   				@ se for maior é letra se nao é numero
	sub r2,r2,#0x30 		@ se for numero só subtraio 0x30 para ficar apenas o numero
	strb r2,[r1]				@coloco o meu novo valor de r1
	add r1,r1,#1 				@vou para o proximo elemneto do vetor
	sub r0,r0,#1 				@diminuo meu contador
	b converto 					@volto para loop

letra:
	sub r2,r2,#0x41 		@subtraio A em hexa
	add r2,r2,#0x0a 		@somo A para virar o valor a em hexa
	strb r2,[r1]				@coloco o valor atualizado no meu vetor again
	add r1,r1,#1 				@vou para o proximo elemneto do vetor
	sub r0,r0,#1 				@diminuo meu contador
	b converto 					@volto para loop

soum:
	ldrb r2,[r1] 				@ pego o primeiro valor do meu vetor e veridico se é zero
	cmp r2,#0x30				@se o valor lido for zero eu saio
	beq exit 						@diretiva de saida
	b converto
exit:
	mov r0, #0 					@ status -> 0
	mov r7, #1  				@ exit é syscall #1
	svc  #0x55      		@ executa syscall

											@a partir daqui tenho o dado em binário espero
acabou:
	mov r0,r5 					@r0 tem o numero de valores lidos
	ldr r1,=buffer 			@pego o começo do meu vetor ja convertido em binários
	ldr r3,=vetorinv		@ r3 tem meu vetor de inversos convertidos
	mov r9,#8 					@r9 pode nao ser zero
	sub r9,r9,r0
	sub r0,r0,#1 				@ pq tem 8
	mov r7,#0

pali:
	cmp r0,r6 					@se o final do vetor ultrapassar a metade acabou
	blt escreve
	ldrb r2,[r1,+r0]		@pego o ultimo elemento do meu vetor
	ldrb r2,[r3,+r2]		@pego elemento correspondente no vetor de inversas
	subs r9,r9,#1
	ldrltb r4,[r1,+r6] 	@pego meu primeiro elemento do meu vetor normal
	addlt r6,r6,#1 			@somo para proximo elemento do vetor
	movge r4,#0
	cmp r2,r4 					@se forem iguais vou para o proximo elemento se nao ativo a flag r9
	beq prox
	mov r7,#1						@ativo flag
	b escreve
prox:
	sub r0,r0,#1  			@diminuo o meu final do vetor
	b pali 							@proximo elemento

escreve:
	mov r0, #1    			@ fd -> stdin
	cmp r7,#1						@ se for igual a 1 nao e pali
	beq naoepali
	ldr r1, =sim				@ buf -> buffer
	mov r2, #2					@ count -> len(msg)
	mov r7, #4					@ write é syscall #4
	svc #0x55   				@ executa syscall
	b _start
naoepali:
	ldr r1, =nao				@ buf -> buffer
	mov r2, #2					@ count -> len(msg)
	mov r7, #4					@ write é syscall #4
	svc #0x55   				@ executa syscall
	b _start

buffer:
	.skip	32
vetorinv:
	.byte 0, 0x8, 0x4, 0xc, 0x2,0xa, 0x6, 0xe, 0x1, 0x9, 0x5, 0xd, 0x3, 0xb, 0x7, 0xf
sim:
	.ascii "S\n"
nao:
 	.ascii "N\n"
