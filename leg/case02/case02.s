					@ Carlos Vinícius Araki Oliveira RA:160141
.org 0x100
divisor:
	.skip 4			@aloca 1 palavra para o divisor potencia de 2 
num_elem:
	.skip 4			@aloca 1 palavra pelo numero de elementos na posicao 0x104
vetor:				@posicao 0x108 para o começo do vetor
.org 0x1000			@pulo para a posição 0x100 para o vetor nao sobrescrever meu codigo
init:				
	ld r0,divisor 	@coloco o valor do divisor em r0
	ld r1,num_elem 	@coloco o numeor de elementos em r1
	mov r5,r1 		@cópia para não dar um reload
	set r2,vetor 	@ r2 setado para o comeco do vetor
	set r6,aux 		@ r6 aponta para o começo do vetor auxiliar
	add r4,1 		@somo o contador
	sub r0,2 		@se divisor for 2 r4 fica com valor 2
	jz 	dado		@vou para manipulacao do dado
	add r4,1 		@somo novamente o contador
	sub r0,2 		@verifico se divisor é 4
	jz dado			@vou para manipulacao do dado
	add r4,1 		@somo mais um para o contador de divisão
	jmp dado 		@o limite do divisor é 8 portanto vamos para manipulacao de dados
dado:
	ld r3,[r2]		@pego o valor que tem na posição do vetor
	shl r3,0x10		@apago os 16 bits anteriores
	shr r3,0x10		@volto o 16 bits para ter apenas o dado bruto
	shr r3,r4  		@desloco a quantidade de bits necessárias para divisão atravez de r4
	st [r6],r3		@coloco o valor alterado no vetor aux
	add r6,0x04    	@desloco uma palavra de 4 bytes no vetor aux
	add r2,0x02 	@desloco apenas para a próxima informação
	sub r5,1 		@ subtrario do numero de elementos para saber se acabou
	jge dado 		@ se nao acabou o numero de dados continua o loop 
	set r2,aux 		@seto para o comeco do vetor auxiliar
	set r0,0 		@zero r0 que utilizei antes
	jmp soma 		@se nao eu somo meus dados
soma:
	ld r3,[r2] 		@pego o valor na primeira posição do vetor auxiliar
	add r0,r3 		@somo em r0
	add r2,0x04 	@ando para o proximo elemento do vetor
	sub r1,1 		@tiro um elemento
	jnz soma 		@enquanto não acabar os elementos continua
	hlt 			@interrompe o programa
.org 0x1500			@vetor aux
aux:
	.skip 0x40  	@tamanho o vetor em que cada palavra tem um valor já dividido