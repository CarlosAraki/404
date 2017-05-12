														@ Carlos Vinicius Araki Oliveira RA:160141
READ    .equ    3       		@ tipo de chamada ao sistema
WRITE   .equ    4       		@ tipo de chamada ao sistema
STDOUT  .equ    1       		@ descritor do dispositivo de saída padrão
STDIN   .equ    0       		@ descritor do dispositivo de entrada padrão
tam_max .equ 		0x30 				@ tam_max da minha pilha para inicialização

.org 0x1000 								@ começo no endreco 0x1000
init:
	set  	r0,STDIN   					@ dispositivo
	set 	sp,ini_pilha 				@inicializo minha pilha
	set  	r1,vetor  					@ endereço onde devem ser armazenados os caracteres lidos
	set  	r2,256     					@ lê no máximo 256 caracteres
	set  	r7,READ    					@ tipo de chamada é de leitura
	sys  	0x55       					@ chamada a sistema
                  					@ r0 retorna com número de bytes lidos

	set 	r8,0x20 						@ minha mascara para ligar o bit de maiuscula
	call 	troca       				@ troco meus valores
	set	 	r1,vetor						@ tem o começo do meu vetor
	mov  	r2,r0      					@ bytes lidos em r2
	set  	r0,STDOUT  					@ dispositivo
	set  	r7,WRITE   					@ tipo de chamada é de escrita
	sys  	0x55       					@ chamada a sistema
	set 	r0,0 								@	para chamada de exit
	set 	r7,1								@ para chamada ao sistema exit
	sys 	0x55            		@ chamada ao sistema exit
troca:
	sub 	r2,1 								@ subtraio o meu contador
	jl 		acabou 							@ se o número de elementos for negativo acabou
	ldb 	r5,[r1]							@	pego o valor na posição r1 do meu vetor
	cmp 	r5,0x61 						@ se for menor que 'a' vou para o proximo elemento do vetor .
	jl 		prox_num
	cmp 	r5,0x7a 						@ se o valor r5 for maior que z vou para o prox_num
	jg 		prox_num
	jmp 	trans_min_mai 		 	@ se nao tenho q transformar em maiusculas

prox_num:
	add 	r1,1 								@ somo para ir par ao proximo elementos
	jmp 	troca 							@	volto para o loop

trans_min_mai:
	add 	r10,1 							@ somo meu contador
	xor 	r5,r8 							@	desligo o bit na posição 0x20 para tornar maiuscula
	stb 	[r1],r5 						@ coloco novamente no vetor
	add 	r1,1 								@ vou para o próximo elemento do vetor
	jmp 	troca 							@ volto para troca

acabou:
	ret

.org 0x2000 								@vetor deve ficar nessa posição
vetor:
	.skip 256       					@ área para armazenar caracteres lidos
fim_pilha:									@ aloco tamanho para minha pilha
		.skip tam_max
ini_pilha:
