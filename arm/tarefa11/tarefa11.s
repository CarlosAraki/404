                                        @Carlos Vinícius Araki Oliveira RA:160141
.global _start
.EQU verde,0x1
.EQU verm,0x4
.EQU amar,0x2
.EQU P_LEDS,0x90000        	@Declaração das minhas constantes e modos de interrupção
.EQU P_TIMER,0x90010
.EQU P_7menos,0x90020
.EQU P_7mais,0x90021
.EQU P_botao,0x90030
.EQU P_teclado_dado,0x90040
.EQU P_teclado_estado,0x90041
.EQU P_slider,0x90050
.equ IRQ, 0x80
.equ FIQ, 0x40
.equ irf, 0xc0
.equ FIQ_MODE,0x11+FIQ+IRQ
.equ IRQ_MODE,0x12+FIQ+IRQ


.equ USER_MODE,0x10

.text

.org 6*4
	b tratairq
     		          			@ preenche apenas a posição 7 (fiq)
.org 7*4
	b tratainterrupcao

.org 0x1000 					@Pulo um espaço para nao ficar próximo ao meu vetor de interrupções
_start:
    	mov sp,#0x400       	@ seta pilha do modo supervisor
    	mov r0,#FIQ_MODE    	@ coloca processador no modo fiq (interrupção externa)
    	msr cpsr,r0         	@ instrução especial, processador agora no modo fiq
    	mov sp,#0x300       	@ seta pilha de interrupção do modo fiq
		mov r0,#IRQ_MODE		@para irq
		msr cpsr,r0
		mov sp,#0x500
    	mov r0,#USER_MODE   	@ coloca processador no modo usuário
    	bic r0,r0,#(irf)    	@ com interrupções fiq/irq habilitadas

    	msr cpsr,r0         	@ instrução especial, processador agora no modo usuário
    	mov sp,#0x80000     	@ seta pilha do usuário no final da memória

comeco:
		ldr r0,=P_botao
		ldr r0,[r0]
		cmp r0,#1
		bne comeco				@enquanto o estado do meu botão for 0 volto para a espera da minha entrada

		ldr r0,=P_slider
		ldr r0,[r0]
		ldr r1,=velo
		str r0,[r1]				@velocidade do meu programa deve seguir
		sub r0,r0,#1

		mov r2,#100				@são 100 ms
		mul r3,r2,r0 			@r3 tem o tempo perdido pelo slider

		mov r2,#2000			@são 2 segundos
		sub r2,r2,r3 			@valor de r2 tem o tempo rela do tempo ligado
		ldr r1,=t_ligado
		str r2,[r1]				@coloco esse valor na minha variável t_ligado

		mov r2,#1000			@é 1 segundo
		sub r2,r2,r3
		ldr r1,=t_desligado
		str r2,[r1]				@coloco meu tempo desligado na minha variável

		mov r1,#500 			@são 500 ms
		mul r2,r1,r0 			@vejo quantos segundos sao perdidos
		ldr r0,=cincoseg		@sao 5s
		ldr r0,[r0]
		sub r1,r0,r2			@subtraio a variação de resposta da velocidade do slider
		ldr r0,=fase
		ldr r0,[r0]
		mul r2,r1,r0 			@multiplico para saber o tempo de resposta que está em r0
		ldr r1,=t_resp
		str r2,[r1]				@coloco meu tempo encontrado no tempo de resposta
		mov r1,r2,lsr#1			@divido meu valor por 2
		ldr r0,=metade
		str r1,[r0]				@coloco na minha variavel metade
		mov r1,r2,lsr#2 		@divido meu valor por 4
		mov r0,#3				@coloco 3 no meu r0
		mul r2,r1,r0 			@multiplico os 2
		ldr r1,=trequat
		str r2,[r1]				@coloco meu valor de 3/4 do tempo total em trequat
		ldr r0,=P_TIMER
		mov r1,#1
		str r1,[r0]				@coloco 1ms de interrupção (é o menor possivel graças ao 3/4 do led vermelho .-.)
		ldr r9,=vetordedados	@r4 terá meu vetor de dados

seq:							@gero a sequencia de numeros random
		ldr r4,=fase  			@primeiro meu contador
		ldr r4,[r4]
seqliga:
		subs r4,#1				@subtraio 1 no meu contador
		blt temp_de_espera
		ldr r0,=numeros        	@ carrega primeiro parâmetro
		mov r1,#4           	@ carrega segundo parâmetro
		bl  init_by_array   	@ inicializa
		bl  genrand_int32  		@ chama gerador, resultado em r0
		mov r1,#0xf				@minha mascara
		and r0,r0,r1			@só fica ligado os 4 ultimos bits
		cmp r0,#9				@comparo para ver se é maior q o numero comportado
		movgt r0,#0 			@se for maior é automaticamente 0
		ldr r6,=tab_digitos		@r6 tem o começo co meu vetor de digitos
		ldrb r1,[r6,r0]  		@pego byte do valor no meu veotr de tab_digitos
		ldr r0,=P_7menos
		str r1,[r0]				@coloco no 7 seg
		strb r1,[r9],#1 		@ coloco no meu vetor e pulo para o proximo elemento



		ldr r0,=numeros        	@ carrega primeiro parâmetro
		mov r1,#2           	@ carrega segundo parâmetro
		bl  init_by_array   	@ inicializa
		bl  genrand_int32  		@ chama gerador, resultado em r0
		mov r1,#0xf				@minha mascara
		and r0,r0,r1			@só fica ligado os 4 ultimos bits
		cmp r0,#9				@comparo para ver se é maior q o numero comportado
		movgt r0,#0 			@se for maior é automaticamente 0
		ldrb r1,[r6,r0]  		@pego byte do valor no meu veotr de tab_digitos
		ldr r0,=P_7mais 		@segundo valor no 7 seg
		str r1,[r0]
		strb r1,[r9],#1 		@ coloco no meu vetor e pulo para o proximo elemento
		ldr r1,=t_ligado 		@2s em ms...será meu contador
		ldr r1,[r1]


loop_liga2s:
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1
		bne loop_liga2s			@enquanto nao ligo minha interrupção continuono loop
		mov r8,#0 				@zero minha flag
		ldr r0,=flag
		str r8,[r0]
		subs r1,r1,#1			@subtraio 1 no meu contador de tempo
		blt apago				@se for menor q zero apago meus 7 seg
		b loop_liga2s			@se nao volto para meu loop_liga2s
apago:
		mov r1,#0 				@apago o que tiver no r0
		ldr r0,=P_7menos
		str r1,[r0]				@coloco no 7 seg
		ldr r0,=P_7mais 		@segundo valor no 7 seg mais significativo
		str r1,[r0]
		ldr r1,=t_desligado
		ldr r1,[r1]				@r1 terá meu tempo desligado e será meu contador de tempo desligado


loop_desliga1s:
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1
		bne loop_desliga1s		@enquanto nao ligo minha interrupção continuono loop
		mov r8,#0 				@zero minha flag
		ldr r0,=flag
		str r8,[r0]
		subs r1,r1,#1			@subtraio 1 no meu contador de tempo
		blt seqliga				@se for menor q zero volto para ligar novamente outro numero aleatorio
		b loop_desliga1s		@se nao volto para meu loop_liga2s
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@certo



temp_de_espera:
		mov r3,#0				@será meu contador de tempo para meus leds
		mov r1,#verde
		ldr r0,=P_LEDS
		ldr r2,=tab_digitos
		str r1,[r0]				@coloco o verde no led para começar a contagem do tempo
		ldr r4,=t_resp
		ldr r4,[r4]				@r4 tem meu tempo total de resposta
		ldr r5,=metade
		ldr r5,[r5]				@r5 tem metade do meu tempo
		ldr r6,=trequat
		ldr r6,[r6]				@r6 tem 3/4 do meu tempo de resposta
		ldr r7,=fase			@r7 é o contador de fase
		ldr r7,[r7]
		ldr r9,=vetordedados	@r9 tem meu vetor auxiliar de daos q coletei na primeira parte do codigo

esperoprimeirovalor:
		ldr r8,=flag2
		ldr r8,[r8]
		cmp r8,#0
		bne trato_teclado1
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1				@verifico minha interrupção
		bne esperoprimeirovalor
		mov r8,#0
		ldr r0,=flag
		str r8,[r0]
		add r3,r3,#1			@somo 1 no meu contador de tempo

		cmp r3,r4				@verifico se meu contador chegou no tempo final
		bgt perdeu				@se passou o jogador perdeu
		cmp r3,r6				@verifico se meu contador chegou em 3/4 do tempo
		bgt ledsvermelhos1
		cmp r3,r5				@verifico se meu contador chegou na metade do tempo
		bgt ledsamarelos1

		b esperoprimeirovalor	@se nao volto para o loop

ledsamarelos1:					@coloco amarelo nos leds
		mov r1,#amar
		ldr r0,=P_LEDS
		str r1,[r0]
		b esperoprimeirovalor

ledsvermelhos1:					@coloco vermelho nos leds
		mov r1,#verm
		ldr r0,=P_LEDS
		str r1,[r0]
		b esperoprimeirovalor

trato_teclado1:
		ldr r2,=tab_digitos
		ldr r0,=P_teclado_dado
		ldr r0,[r0]				@r0 tem meu dado
		ldrb r0,[r2,r0]			@vejo qual hexa tem o valor
		ldr r1,=P_7menos		@7seg mais significativo
		strb r0,[r1]			@coloco o valor no 7 seg
		ldr r1,=aux1
		str r0,[r1]
		mov r10,r0
esperosegundovalor:
		ldr r8,=flag2
		ldr r8,[r8]
		cmp r8,#0
		bne trato_teclado2
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1				@verifico minha interrupção
		bne esperosegundovalor
		mov r8,#0
		ldr r0,=flag
		str r8,[r0]

		add r3,r3,#1			@somo 1 no meu contador de tempo
		cmp r3,r4				@verifico se meu contador chegou no tempo final
		bgt perdeu				@se nao o jogador perdeu
		cmp r3,r6				@verifico se meu contador chegou em 3/4 do tempo
		bgt ledsvermelhos2
		cmp r3,r5				@verifico se meu contador chegou na metade do tempo
		bgt ledsamarelos2

		b esperosegundovalor	@se nao volto para o loop

ledsamarelos2:					@coloco amarelo nos leds
		mov r1,#amar
		ldr r0,=P_LEDS
		str r1,[r0]
		b esperosegundovalor

ledsvermelhos2:					@coloco vermelho nos leds
		mov r1,#verm
		ldr r0,=P_LEDS
		str r1,[r0]
		b esperosegundovalor

trato_teclado2:

		ldr r0,=P_teclado_dado
		ldr r0,[r0]				@r0 tem meu dado
		ldrb r0,[r2,r0]			@vejo qual hexa tem o valor
		ldr r1,=P_7mais			@7seg mais significativo
		strb r0,[r1]				@coloco o valor no 7 seg
		ldr r1,=aux2
		str r0,[r1]

		ldr r0,=aux1			@comparo o mais significativo
		ldr r0,[r0]
		ldrb r1,[r9],#1
		cmp r0,r1
		bne perdeu

		ldr r0,=aux2			@comparo o menos significativo
		ldr r0,[r0]
		ldrb r1,[r9],#1
		cmp r0,r1
		bne perdeu
		subs r7,r7,#1			@diminuo o contador de fases
		beq ganhou 				@se acabou o cara ganhou
		mov r0,#50				@conto meus 50 ms
acertou:
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1
		bne acertou
		mov r8,#0
		ldr r1,=flag
		str r8,[r1]
		subs r0,r0,#1			@subtraio 1 ms
		beq apagou2
		b acertou

apagou2:
		mov r1,#0 				@apago o que tiver no r0
		ldr r0,=P_7menos
		str r1,[r0]				@coloco no 7 seg
		ldr r0,=P_7mais 		@segundo valor no 7 seg mais significativo
		str r1,[r0]				@apago meu display
		b esperoprimeirovalor
ganhou:
		mov r3,#5 				@contador de pisca pisca

		ldr r0,=fase
		ldr r1,[r0]
		add r1,r1,#1			@aumento uma fase
		str r1,[r0]
		ldr r2,[r2,#11]			@r2 tem c
		ldr r0,=P_7mais			@ligo cc
		str r2,[r0]
		ldr r0,=P_7menos
		str r2,[r0]
		mov r4,#1				@estado 1 ligado
prepapisca:
		mov r1,#100 			@100 ms
		cmp r3,#0
		beq finish
		cmp r4,#1
		beq desligav
		b ligav
desligav:
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1
		bne desligav
		mov r8,#0
		ldr r0,=flag
		str r8,[r0]
		subs r1,r1,#1
		blt  apagaluzes
		b desligav
ligav:
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1
		bne ligav
		mov r8,#0
		ldr r0,=flag
		str r8,[r0]
		subs r1,r1,#1
		blt acendeluzes
		b ligav

apagaluzes:
		mov r1,#0 				@apago o que tiver no r0
		ldr r0,=P_7menos
		str r1,[r0]				@coloco no 7 seg
		ldr r0,=P_7mais 		@segundo valor no 7 seg mais significativo
		str r1,[r0]				@apago meu display
		mov r4,#0
		b prepapisca
acendeluzes:
		ldr r0,=P_7menos
		str r2,[r0]				@coloco no 7 seg
		ldr r0,=P_7mais 		@segundo valor no 7 seg mais significativo
		str r2,[r0]				@apago meu display
		sub r3,r3,#1
		mov r4,#1
		b prepapisca

perdeu:
		mov r3,#3
		ldr r2,=tab_digitos
		ldr r2,[r2,#10]			@r2 tem c
		ldr r0,=P_7mais			@ligo cc
		str r2,[r0]
		ldr r0,=P_7menos
		str r2,[r0]
		mov r4,#1				@estado 1 ligado
prepapisca2:
		mov r1,#100 			@100 ms
		cmp r3,#0
		beq finish
		cmp r4,#1
		beq desligav2
		b ligav2
desligav2:
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1
		bne desligav2
		mov r8,#0
		ldr r0,=flag
		str r8,[r0]
		subs r1,r1,#1
		blt  apagaluzes2
		b desligav2
ligav2:
		ldr r8,=flag
		ldr r8,[r8]
		cmp r8,#1
		bne ligav2
		mov r8,#0
		ldr r0,=flag
		str r8,[r0]
		subs r1,r1,#1
		blt acendeluzes2
		b ligav2

apagaluzes2:
		mov r1,#0 				@apago o que tiver no r0
		ldr r0,=P_7menos
		str r1,[r0]				@coloco no 7 seg
		ldr r0,=P_7mais 		@segundo valor no 7 seg mais significativo
		str r1,[r0]				@apago meu display
		mov r4,#0
		b prepapisca2
acendeluzes2:
		ldr r0,=P_7menos
		str r2,[r0]				@coloco no 7 seg
		ldr r0,=P_7mais 		@segundo valor no 7 seg mais significativo
		str r2,[r0]				@apago meu display
		sub r3,r3,#1
		mov r4,#1
		b prepapisca2

finish:
		ldr r0,=P_TIMER
		mov r1,#0
		str r1,[r0]				@desligo meu timer
		ldr r0,=P_7menos
		str r1,[r0]				@coloco no 7 seg
		ldr r0,=P_7mais 		@segundo valor no 7 seg mais significativo
		str r1,[r0]				@apago meu display
		ldr r0,=P_LEDS
		str r1,[r0]
		b comeco

tratairq:
		ldr r8,=flag 			@minha flag de 1 ms será r8
		mov r0,#1
		str r0,[r8]
		movs pc,lr 				@volto da interrupção
flag:
	.word 0

tratainterrupcao:
		ldr r1,=flag2
		mov r0,#1
		str r0,[r1]
		movs pc,lr


flag2:
	.word 0
aux1:
	.byte 0x7e
aux2:
	.byte 2
vetordedados:					@ 2 vezes o numero de fases possiveis é o numero de bytes do meu vetor auxiliar 100 pq pode andar 1 a mais
	.skip 2*100
t_ligado:
	.word 0
t_desligado:
	.word 0
fase:
	.word 1
velo:
	.word 1
t_resp:
	.word 0
metade:
	.word 0
trequat:
	.word 0
cincoseg:
	.word 5000
tab_digitos:
        .byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4e @0-9 E C
.data
numeros:
        .long 0x123
        .long 0x234
        .long 0x345
        .long 0x456
