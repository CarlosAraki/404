@Créditos ao Monstro(lago) que fizemos juntos esse

.global	_start				 				 				@ istanciando inicio do montador

.equ		FIQ		,0x40
.equ		FIQ_MODE	,0x11
.equ		USER_MODE	,0x10

.set		botao		,0x90000							@ enderecos dos dispositivos
.set		keyboardD	,0x90020
.set		keyboardE	,0x90021
.set		leds		,0x90035
.set		mostrador1	,0x90040
.set		mostrador2	,0x90041
.set		slider		,0x90050
.set		timer		,0x90030
.set		desliga		,0x00

.set		verde		,0x01								@ constantes de cores
.set		amarelo		,0x02
.set		vermelho	,0x04

.set		desligado	,0x00
.set		ligado		,0x01

.org        7*4                 							@ preenche apenas a posição 7 (FIQ)
		b		tratador_interrupcao

.org        0x800



_start:
		mov 		sp,#0x400       						@ seta pilha do modo supervisor
		mov		r0,#FIQ_MODE    							@ coloca processador no modo FIQ (interrupção externa)
		msr 		cpsr,r0         						@ instrução especial, processador agora no modo FIQ
		mov		sp,#0x300       							@ seta pilha de interrupção do modo FIQ
		mov		r0,#USER_MODE   							@ coloca processador no modo usuário
		bic		r0,r0,#(FIQ)    							@ com interrupções FIQ habilitadas
		msr		cpsr,r0         							@ instrução especial, processador agora no modo usuário
		mov		sp,#0x80000									@ inicia a pilha de USER_MODE
															@ setup do jogo
		mov		r5,#1										@ coloca 1 em r5 que funcionara como a variavel que guarda a fase do jogo
		mov		r7,#0										@ coloca 0 em r7 que salva a dificuldade do jogo
deslig:

		ldr		r4,=desligado								@ zera r4 para que ele sirva de flag do botao quando o jogo esta desligado
		ldr		r4,[r4]
		ldr		r6,=desligado								@ seta r6 para saber o estado do jogo
		ldr		r6,[r6]
		ldr		r1,=desliga									@ seta r1 para apagar os leds, os mostradores e o timer
		ldr		r1,[r1]
		ldr		r0,=timer									@
		str		r1,[r0]										@ desliga o timer
		ldr		r0,=leds									@
		str		r1,[r0]										@ apaga os leds
		ldr		r0,=mostrador1								@
		str		r1,[r0]										@ apaga o primeiro mostrador
		ldr		r0,=mostrador2								@
		str		r1,[r0]										@ apaga o segundo mostrador

loop_deslig:
		cmp		r4,#1										@ verifica se o botao foi pressionado
		bne		loop_deslig									@ volta ao loop caso o botao nao tenha sido pressionado

lig:

		mov		r4,#0										@ zera r4 para que ele sirva como contador de numeros mostrados quando o jogo esta ligado
		mov		r6,#1										@ coloca r6 com 1 para indicar que o jogo esta ligado

gera_numeros:
		cmp		r4,r5										@ compara a quantidade de numeros mostrados com a fase do jogo
		bge		resposta_jogador							@ caso ja tenha mostrado todos os numeros vai esperar a entrada do jogador
		bl		genrand_int32								@ chama o gerador de numeros aleatorios que retorna o numero em r0 para o numero menos significativo
		mov		r1,#0x0f									@ coloca 15 em r1
		and		r0,r1										@ limita o numero gerado para ser entre 0 e 15
		cmp		r0,#10										@ comparo r0 com 10
		subge	r0,r0,#10									@ subtraio 10 do numero caso seja maior que 10
		addge	r0,r0,#3									@ somo 3 ao numero para tentar manter a aleatoriedade do numero randomico mas mantendo-o entre 0 e 9
		ldr		r1,=sequencia_dezena						@
		add		r1,r1,r4									@ vou ate a casa do vetor correspondente a quantidade de numeros que ja foram gerados
		strb	r0,[r1]										@ guardo o numero gerado no vetor da unidade
		ldr		r1,=vetor_mostrador							@
		add		r1,r1,r0									@ pega o endereco do numero correspondente
		ldrb	r1,[r1]										@ pego o valor em 7seg correspondente ao numero
		ldr		r0,=mostrador1								@
		str		r1,[r0]										@ coloca o valor no mostrador menos significativo
		bl		genrand_int32								@ chama o gerador de numeros aleatorios que retorna o numero em r0 para o numero mais significativo
		mov		r1,#0x0f									@
		and		r0,r1										@ limita o numero gerado para ser entre 0 e 15
		cmp		r0,#10										@ comparo r0 com 10
		subge	r0,r0,#10									@ subtraio 10 do numero caso seja maior que 10
		addge	r0,r0,#3									@ somo 3 ao numero para tentar manter a aleatoriedade do numero randomico mas mantendo-o entre 0 e 9
		ldr		r1,=sequencia_unidade						@
		add		r1,r1,r4									@ vou ate a casa do vetor correspondente a quantidade de numeros que ja foram gerados
		strb	r0,[r1]										@ guardo o numero gerado no vetor da dezena
		ldr		r1,=vetor_mostrador							@
		add		r1,r1,r0
		ldrb	r1,[r1]										@ pego o valor em 7seg correspondente ao numero
		ldr		r0,=mostrador2
		str		r1,[r0]										@ coloca o valor no mostrador mais significativo
		add		r4,r4,#1									@ incremento a quantidade de numeros mostrados
		b		mostra_numeros

resposta_jogador:

		ldr		r1,=tempo_resposta
		add		r1,r1,r7									@ ajusta o tempo de resposta a dificuldade do jogo
		ldr		r1,[r1]										@ pega o valor do vetor
		mul		r1,r5,r1									@ multiplica o tempo de resposta com a fase
		mov		r0,#0										@ coloca 0 em r0
		mov		r8,r1,lsr #2								@ shift right de dois bits dividindo r1 por 4
		mov		r9,r1,lsr #1								@ divide r1 por 2
		mov		r3,#0										@ garante que nao ha lixos em r3
		mov		r4,#0										@ zera r4 para ser o contador de numeros da seuqencia

loop_resposta_jogador:

		cmp		r1,r9										@ compara o tempo restante com metade do tempo
		ldreq	r2,=amarelo
		ldrgt	r2,=verde
		cmp		r1,r8										@ compara o tempo restante com 1/4 do tempo
		ldreq	r2,=vermelho
		cmp		r1,#0										@ compara o tempo restante com 0
		ble		jogador_perdeu								@ caso o tempo tenha estourado ele pula para a funcao jogador errou
		ldr		r0,=leds
		str		r2,[r0]										@ acende o led correspondente ao tempo restante
		cmp		r3,#1										@ compara r3 com 1 para saber se a interrupcao do teclado ocorreu
		ldreq	r2,=sequencia_dezena_jogador
		ldreqb	r2,[r2]										@ pega o valor que esta guardado na variavel
		ldreq	r0,=vetor_mostrador
		addeq	r2,r2,r0									@ pega o endereco correto do valor correspondente em 7seg
		ldreq	r2,[r2]										@ pega o valor em 7seg correspondente
		ldreq	r0,=mostrador1
		streqb	r2,[r0]										@ coloca o input do jogador da dezena no mostrador da dezena
		cmp		r3,#2										@ compara r3 com 2 para saber se interrupcao do teclado ocorreu
		ldreq	r2,=sequencia_unidade_jogador
		ldreqb	r2,[r2]										@ pega o valor que esta guardado na variavel
		ldreq	r0,=vetor_mostrador
		addeq	r2,r2,r0									@ pega o endereco correto do valor correspondente em 7seg
		ldreq	r2,[r2]										@ pega o valor em 7seg correspondente
		ldreq	r0,=mostrador2
		streqb	r2,[r0]										@ coloca o input do jogador da dezena no mostrador da dezena
		moveq	r3,#0										@ zera r3 para o proximo input caso o jogador tenha acertado
		beq		verifica_correcao							@ vai para uma funcao que verifica se os numeros colocados estao corretos
		b		loop_resposta_jogador

verifica_correcao:

		ldr		r0,=sequencia_dezena
		add		r0,r0,r4									@ ajusta o numero da sequencia
		ldrb	r0,[r0]										@ coloca em r0 o valor da sequencia que deve ser verificado
		ldr		r2,=sequencia_dezena_jogador
		ldrb	r2,[r2]										@ coloca o valor do input do jogador em r2
		cmp		r0,r2										@ compara r2 e r0
		bne		jogador_perdeu								@ caso os valores nao sejam iguais o jogador perdeu
		ldr		r0,=sequencia_unidade
		add		r0,r0,r4									@ ajusta o numero da sequencia
		ldrb	r0,[r0]										@ coloca em r0 o valor da seuqencia que deve ser verificado
		ldr		r2,=sequencia_unidade_jogador
		ldrb	r2,[r2]										@ coloca o valor do input do jogador em r2
		cmp		r0,r2										@ compara r2 e r0
		bne		jogador_perdeu								@ caso os valores nao sejam iguais o jogador perdeu
		add		r4,r4,#1									@ adiciona 1 no valor de numeros inseridos
		mov		r0,#5										@ coloca 5 em r0 para marcar os 50ms ligados da entrada
		mov		r2,#0x100									@ coloca 1042 em r2
loop_50ms:
		cmp		r0,#0										@ compara r0 com 0 para saber se a contagem dos 50ms ja passou
		bne		loop_50ms									@ fica no loop enquanto nao passar os 50ms
		cmp		r4,r5										@ compara r4 com r5
		beq		jogador_ganhou								@ vai para a funcao onde o jogador ganhou
		ldr		r2,=desliga
		ldr		r0,=mostrador1
		str		r2,[r0]										@ desliga o mostrador1
		ldr		r0,=mostrador2
		str		r2,[r0]										@ desliga o mostrador2
		b		loop_resposta_jogador						@ volta para o loop de inputs do jogador_perdeu

jogador_ganhou:
		ldr		r2,=desliga
		ldr		r2,[r2]										@ coloca o valor dos leds desligados em r2
		ldr		r0,=leds
		str		r2,[r0]										@ apaga os leds
		mov		r2,#11										@ coloca 11 que eh correspondente a C
		ldr		r0,=vetor_mostrador
		add		r2,r2,r0									@ pega o endereco de C para o 7segs
		ldr		r2,[r2]										@ pega o valor de C para o 7segs
		mov		r1,#10										@ coloca o valor de 100ms em r1
		mov		r3,#5										@ numero de vezes que tem que piscar
		ldr		r0,=mostrador1
		str		r2,[r0]										@ coloca C no mostrador 1
		ldr		r0,=mostrador2
		str		r2,[r0]										@ coloca C no mostrador 2

loop_acertou_ligado:
		cmp		r1,#0										@ compara r1 com 0
		bne		loop_acertou_ligado							@ volta ao loop enquanto nao se passar 100ms
		mov		r1,#10										@ coloca 100ms em r1
		ldr		r2,=desliga
		ldr		r0,=mostrador1
		str		r2,[r0]										@ apaga mostrador 1
		ldr		r0,=mostrador2
		str		r2,[r0]										@ apaga mostrador 2

loop_acertou_desligado:
		cmp		r1,#0										@ compara com 0
		bne		loop_acertou_desligado						@ volta ao loop enquanto nao se passar 100ms
		subs	r3,#1										@ subtrai 1 do numero de vezes a se piscar
		movne	r1,#11										@ coloca 100ms em r1 se nao foram piscadas as 5 vezes
		movne	r2,#11										@ coloca 10 que eh correspondente a E se nao foram piscadas as 5 vezes
		ldrne	r0,=vetor_mostrador
		addne	r2,r2,r0									@ pega o endereco de E para o 7segs se nao foram piscadas as 5 vezes
		ldrne	r2,[r2]										@ pega o valor de E para o 7segs se nao foram piscadas as 5 vezes
		ldrne	r0,=mostrador1
		strne	r2,[r0]										@ coloca E no mostrador 1 se nao foram piscadas as 5 vezes
		ldrne	r0,=mostrador2
		strne	r2,[r0]										@ coloca E no mostrador 2 se nao foram piscadas as 5 vezes
		bne		loop_acertou_ligado							@ volta ao loop com o mostrador mostrando E se nao foram piscadas as 5 vezes
		add		r5,r5,#1									@ soma 1 na fase do jogo
		b		deslig

jogador_perdeu:

		ldr		r2,=desliga
		ldr		r2,[r2]										@ coloca o valor dos leds desligados em r2
		ldr		r0,=leds
		str		r2,[r0]										@ apaga os leds
		mov		r2,#10										@ coloca 10 que eh correspondente a E
		ldr		r0,=vetor_mostrador
		add		r2,r2,r0									@ pega o endereco de E para o 7segs
		ldr		r2,[r2]										@ pega o valor de E para o 7segs
		mov		r1,#10										@ coloca o valor de 100ms em r1
		mov		r3,#3										@ numero de vezes que tem que piscar
		ldr		r0,=mostrador1
		str		r2,[r0]										@ coloca E no mostrador 1
		ldr		r0,=mostrador2
		str		r2,[r0]										@ coloca E no mostrador 2

loop_errou_ligado:
		cmp		r1,#0										@ compara r1 com 0
		bne		loop_errou_ligado							@ volta ao loop enquanto nao se passar 100ms
		mov		r1,#10										@ coloca 100ms em r1
		ldr		r2,=desliga
		ldr		r0,=mostrador1
		str		r2,[r0]										@ apaga mostrador 1
		ldr		r0,=mostrador2
		str		r2,[r0]										@ apaga mostrador 2

loop_errou_desligado:
		cmp		r1,#0										@ compara com 0
		bne		loop_errou_desligado						@ volta ao loop enquanto nao se passar 100ms
		subs	r3,#1										@ subtrai 1 do numero de vezes a se piscar
		movne	r1,#10										@ coloca 100ms em r1 se nao foram piscadas as 3 vezes
		movne	r2,#10										@ coloca 10 que eh correspondente a E se nao foram piscadas as 3 vezes
		ldrne	r0,=vetor_mostrador
		addne	r2,r2,r0									@ pega o endereco de E para o 7segs se nao foram piscadas as 3 vezes
		ldrne	r2,[r2]										@ pega o valor de E para o 7segs se nao foram piscadas as 3 vezes
		ldrne	r0,=mostrador1
		strne	r2,[r0]										@ coloca E no mostrador 1 se nao foram piscadas as 3 vezes
		ldrne	r0,=mostrador2
		strne	r2,[r0]										@ coloca E no mostrador 2 se nao foram piscadas as 3 vezes
		bne		loop_errou_ligado							@ volta ao loop com o mostrador mostrando E se nao foram piscadas as 3 vezes
		b		deslig

mostra_numeros:
		mov		r1,#10										@ coloca r1 como 10ms
		ldr		r0,=timer
		str		r1,[r0]										@ coloca o timer para rodar 10ms
		ldr		r1,=tempo_ligado
		add		r1,r1,r7
		ldr		r1,[r1]										@ ajusta o tempo para a dificuldade do jogo

loop_ligado:
		cmp		r1,#0										@ verifica se o tempo do 7seg ligado ja passou
		bne		loop_ligado									@ retorna para o loop ate que o tempo tenha passado
		ldr		r1,=desliga
		ldr		r1,[r1]
		ldr		r0,=mostrador1
		str		r1,[r0]										@ apaga o primeiro mostrador
		ldr		r0,=mostrador2
		str		r1,[r0]										@ apaga o segundo mostrador
		ldr		r1,=tempo_desligado
		add		r1,r1,r7									@ ajusta o tempo para a dificuldade do jogo
		ldr		r1,[r1]										@ coloca o valor que o timer deve percorrer com o mostrador desligado


loop_desligado:
		cmp		r1,#0										@ verifica se o tempo do 7seg desligado ja passou
		bne		loop_desligado								@ retorna para o loop ate que o tempo tenha passado
		b		gera_numeros								@ volta ao mostrador de numeros



tratador_interrupcao:

		cmp		r6,#0x00									@ verifica se a interrupcao ocorreu quando o jogo estava desligado
		beq		tratador_desligado							@ pula para o tratador de interrupcoes deligado
		cmp		r6,#0x01									@ verifica se a interrupcao ocorreu quando o jogo estava ligado
		beq		tratador_ligado								@ pula para o tratador de interrupcoes ligado
		movs		pc,lr									@ finaliza o processo

tratador_ligado:

		ldr		r8,=keyboardE
		ldr		r8,[r8]										@ pega o valor do estado de keyboard
		cmp		r8,#0x01									@ compara o estado do keyboard com 1 para saber se a interrupcao foi causada pelo keyboard
		beq		tratador_keyboard							@ caso seja uma interrupcao causada pelo keyboard pula para o tratamento
		bne		tratador_timer								@ caso seja uma interrupcao causada pelo timer pula para o tratamento

tratador_timer:

		sub		r1,#1										@ subtrai 1 do contador de tempo
		cmp		r2,#0x100									@ verifica se r0 esta no modo de timer
		subeq	r0,#1										@ subtrai 1 de r0
		movs		pc,lr									@ volta para a parte do programa onde ocorreu a interrupcao

tratador_keyboard:
		mov		r2,#0x01									@ coloca 1 em r2
		and		r2,r3										@ coloca em r2 se o numero de r3 eh par ou impar
		cmp		r2,#0x00									@ verifica se r2 eh impar ou par
		ldreq	r2,=keyboardD
		ldreq	r2,[r2]										@ pega o valor do dado de keyboardD	se r3 for par
		ldreq	r0,=sequencia_dezena_jogador
		streqb	r2,[r0]										@ guarda o valor do dado na variavel de dezena do jogador se r3 for par
		ldrne	r2,=keyboardD
		ldrne	r2,[r2]										@ pega o valor do dado de keyboardD se r3 for impar
		ldrne	r0,=sequencia_unidade_jogador
		strneb	r2,[r0]										@ guarda o valor do dado na variavel de unidade do jogador se r3 for impar
		add		r3,r3,#1									@ soma 1 no numero de inputs feitos pelo jogador
		movs	pc,lr										@ volta para a parte do programa onde ocorreu a interrupcao


tratador_desligado:

		ldr		r0,=slider
		ldr		r1,[r0]										@ salva em r1 o valor que esta no slider
		sub		r1,r1,#1									@ modifica r1 para que possa ser usado no vetor de velocidades
		add		r1,r1,r1									@ multiplica r1 por 2
		add		r1,r1,r1									@ multiplica r1 por 4
		cmp		r7,r1										@ compara r1 com r7, sendo que r7 salva a dificuldade do jogo
		bne		muda_dificuldade							@ vai para a funcao que muda a dificuldade

		ldr		r0,=botao
		ldr		r1,[r0]										@ coloca em r1 o estado do botao
		cmp		r1,#1										@ verifica se o botao foi pressionado
		moveq		r4,#1									@ coloca a flag de que o botao foi pressionado em r4
		movs		pc,lr									@ finaliza o tratamento de interrupcoes quando o jogo esta desligado


muda_dificuldade:

		mov		r7,r1										@ seta a nova dificuldade do jogo
		movs		pc,lr									@ finaliza o tratamento de interrupcao quando se muda o slider

sequencia_unidade_jogador:									@ variavel da unidade
	.skip	0x0f

sequencia_dezena_jogador:									@ variavel da dezena
	.skip	0x0f

sequencia_unidade:											@ sequencia da unidade
	.skip	0x0f

sequencia_dezena:											@ sequencia da dezena
	.skip	0x0f

vetor_mostrador:											@ vetor de 7seg 0 a 9, E, C
	.byte   0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x73, 0x4f, 0x4e

tempo_resposta:												@ vetor de tempo Tlig
	.word	500, 450, 400, 350, 300

tempo_ligado:												@ vetor de tempo Tlig
	.word	200, 190, 180, 170, 160

tempo_desligado:											@ vetor de tempo Tdesl
	.word	100, 90, 80, 70, 60
