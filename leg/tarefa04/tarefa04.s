						@ Carlos Vinícius Araki Oliveira RA:160141

.org 0x1000   			@tenho que começar nesse endereço
KEYBD_DATA 	.equ 0x80 	@ porta de dados do teclado
KEYBD_STAT 	.equ 0x81 	@ porta de estado do teclado
KEYBD_TEM 	.equ 1 		@ bit para comparação se tem algo no teclado
LEDS 		.equ 0X40   @ saida para LEDS
tam_max 	.equ 0x10	@ tamanho máximo da pilha

multiplica:
	set  r0,0 			@ r0 pode ter valor devido a outra função temos que zera-lo
	ld r1,[sp+4]		@ pego primeiro valor do meu parâmetro
	ld r2,[sp+8]		@ pego o segundo parâmetro
	cmp r1,r2			@ para minimizar os passos da multiplicação
	jnc mult1 			@ usa menor valor para controlar repetição
	mov r5,r1 			@ troca valores de r1 e r2 usando
	mov r1,r2 			@ r5 como temporário
	mov r2,r5

mult1:
	sub r2,1 			@ vamos realizar r2 adições
	jc mult2 			@ desvia se terminamos
	add r0,r1 			@ adiciona mais uma parcela
	jmp mult1 			@ volta para o loop para somar outra parcela ou terminar a função

mult2:
	ret 	 			@ retorna quando todas as omas acabarem



read:
	set r3,KEYBD_TEM 	@ seto r3 para comparação posterior
	set r2,0x01 		@ contador para saber se estamos na dezena ou na unidade
	set r0,0x00 		@ r0 pode conter algo por causa do loop de multiplicação devemos zera-lo

le_tecla1:
	inb r4,KEYBD_STAT 	@ lê porta de estado
	tst r4,r3			@ testa se o estado foi ligado
	jz le_tecla1 		@ espera que dado esteja pronto pelo estado
	inb r4,KEYBD_DATA 	@ le porta de dados e deixa em r4
	cmp r4,0x0b       	@ comparo para ver se nao está em #
	jz saida1 			@ se estiver devo retornar o valor de 11 em r1
	cmp r4,0x0a 		@ se for outro final *
	jz saida2	 		@ se estiver noutro final devo retornar o valor 10 em r1
	cmp r2,0x01 		@ se for zero é o primeiro elemento
	jz prim_ele  		@ comparo com o contador para saber se é o primeiro elemento
	jmp seg_ele 		@ se nao é o segundo elemento

saida1:
	set r1,11 			@ seto r1 de saida para 11 
	ret

saida2:
	set r1,10			@ seto r1 de saida para 10
	ret

prim_ele:
	shl r4,4  			@ shifto 4 bytes para esquerda para fazer a dezena
	or r0,r4 			@ coloco no r0
	sub r2,0x01 		@ diminuo o contador
	jmp le_tecla1 		@ volta pro loop

seg_ele:
	or r0,r4 			@ coloco no r0 a unidade
	jmp le_tecla1 		@ volto para o loop


init:
	set sp,ini_pilha 	@ aponto para o inicio da ini_pilha
	set r7,0x01 		@ valor corrente
	outb LEDS,r7 		@ padrão do led ligado "1"
	jmp dados

dados:
	call read  			@ pega valores do teclado r0 tenho meu valor e r1 se continuo a operação
	push r0 			@ coloco primeiro parametro na pilha
	push r7 			@ coloco o segundo parâmetro na pilha
	call multiplica 	@ multiplico os 2
	add sp,8 			@ apago os parâmetros da pilha
	mov r7,r0 			@ coloco valor da multiplicação no valor corrente
	outb LEDS,r7 		@ mando para os leds
	cmp r1,11 			@ se for # termino o programa
	jz acabou			
	jmp dados			@ se não volto para o loop

acabou:
	hlt					@ encerro o programa

fim_pilha:				@ aloco tamanho para minha pilha
	.skip 	tam_max
ini_pilha:
