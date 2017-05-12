					@ Carlos Vinícius Araki Oliveira RA:160141
start:				
	set r0,carac	@r0 percorrerá até o fim do vetor
	add r2,1 		@r2 contador para numero de elementos
	set r4,carac 	@r4 com o começo do vetor 
	ldb r1,[r0]		@pego a primeira informação do vetor
	jmp conta 		@pulo para a contagem de elementos

conta:
	add r0,0x01  	@r0 percorre para o próximo elemento do vetor
	add r2,1        @aumento o valor do contador r2
	ldb r1,[r0]		@pego a informação do proximo elemento do vetor
	cmp r3,r1		@comparo se o valor de r1 é zero	
	jnz conta 		@se nao for zero repete o loop
	sub r0,0x01 	@subtraio a posição em que se encontra o zero  
	jmp troca 		@efetuo a troca

troca:
	ldb r5,[r4] 	@recebo um byte do começo do vetor e guardo em r5
	ldb r6,[r0]		@recebo um byte do final do vetor e guardo em r6
	stb [r4],r6		@coloco no comeco do vetor o valor de r6
	stb [r0],r5		@coloco no final do vetor o valor de r5
	add r4,0x01 	@desloco o começo 
	sub r0,0x01 	@desloco o final
	sub r2,2		@subtraio 2 do contador
	jg troca 		@enquando for maior que zero repete troca

hlt @interrompe o programa

.org 0x1000
carac :
	.skip 15		@aloca 15 bytes de memória nao inicializadas
