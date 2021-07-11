      							@Carlos Vinícius Araki Oliveira RA:160141
.global _start
.EQU P_sem_p,0x90000        	@Declaração das minhas constantes e modos de interrupção
.EQU P_sem_s,0x90001
.EQU verde,0x1
.EQU verm,0x4
.EQU amar,0x2
.EQU P_timer,0x90030
.EQU P_7menos1,0x90010
.EQU P_7mais1,0x90011
.EQU P_7menos2,0x90020
.EQU P_7mais2,0x90021
.EQU IRQ, 0x80
.EQU IRQ_MODE,0x12
.EQU USER_MODE,0x10
								@ vetor de interrupções
.org  7*4     		          	@ preenche apenas a posição 7 (IRQ)
	b tratatempo
.org 0x1000 					@Pulo um espaço para nao ficar próximo ao meu vetor de interrupções
_start:
	mov sp,#0x400       		@ seta pilha do modo supervisor
	mov r0,#IRQ_MODE    		@ coloca processador no modo IRQ (interrupção externa)
	msr cpsr,r0         		@ instrução especial, processador agora no modo IRQ
	mov sp,#0x300       		@ seta pilha de interrupção do modo IRQ
	mov r0,#USER_MODE   		@ coloca processador no modo usuário
	bic r0,r0,#(IRQ)    		@ com interrupções IRQ habilitadas
	msr cpsr,r0         		@ instrução especial, processador agora no modo usuário
	mov sp,#0x80000     		@ seta pilha do usuário no final da memória

	ldr r0,=P_timer				@porta do meu timer
	mov r1,#1000				@devo colocar 1 segundo
	str r1,[r0]					@coloco esse valor como padrão (espero que assim que funcione)
	ldr r0,=verde               @coloco verde no primeiro semáforo
	ldr r1,=P_sem_p
	str r0,[r1]
	ldr r0,=verm                @coloco vermelho no segundo semáforo
	ldr r1,=P_sem_s
	str r0,[r1]
	ldr r2,=tab_digitos         @pego o endereço do meu vetor de dígitos em r2
	ldr r0,[r2]
	ldr r1,=P_7menos1           @coloco zero no 7 segmentos menos significativo
	str r0,[r1]
	ldr r1,=P_7menos2 			@seggundo semáforo contador
	str r0,[r1]
	ldr r0,[r2,#3]
	ldr r1,=P_7mais1            @coloco 3 no meu mais significativo
	str r0,[r1]
	ldr r1,=P_7mais2
	str r0,[r1]					@aqui acaba valores padrões colocados
	mov r7,#30 					@r7 será meu contador começando em 30
	mov r6,#0                   @r6 será minha variável de estado

loop:
	ldr r8,=flag
	ldr r8,[r8]					@pego meu valor da flag
	cmp r8,#1                   @comparo se o bit ligou
	bne loop                   	@se for diferente de zero espero a entrada do loop
	ldr r8,=flag
	str r4,[r8]					@zero minha flag
	subs r7,r7,#1				@tiro 1 do meu contador
	blt mudoestado				@se for menor que zero mudo meu estado
	cmp r7,#20 					@ vejo se é menor que 20
	blt menorque20
	ldr r0,[r2,#2]
	ldr r1,=P_7mais1            @coloco 2 no meu mais significativo
	str r0,[r1]
	ldr r1,=P_7mais2			@2no segundo semáforo
	str r0,[r1]
	sub r3,r7,#20 				@pego meu valor do segundo algarismo
	ldr r0,[r2,r3]
	ldr r1,=P_7menos1           @coloco o valor menos significativo no 7 segmentos menos significativo
	str r0,[r1]
	ldr r1,=P_7menos2 			@segundo semáforo contador menos significativo
	str r0,[r1]
	b loop

menorque20:
	cmp r7,#10 					@verifico se menor que 10
	blt menorque10
	ldr r0,[r2,#1]
	ldr r1,=P_7mais1            @coloco 1 no meu mais significativo
	str r0,[r1]
	ldr r1,=P_7mais2			@1 no segundo semáforo
	str r0,[r1]
	sub r3,r7,#10 				@pego meu valor do segundo algarismo
	ldr r0,[r2,r3]
	ldr r1,=P_7menos1           @coloco o valor menos significativo no 7 segmentos menos significativo
	str r0,[r1]
	ldr r1,=P_7menos2 			@segundo semáforo contador menos significativo
	str r0,[r1]
	b loop
menorque10:
	ldr r0,[r2]
	ldr r1,=P_7mais1            @coloco 0 no meu mais significativo
	str r0,[r1]
	ldr r1,=P_7mais2			@0 no segundo semáforo
	str r0,[r1]
	ldr r0,[r2,r7]
	ldr r1,=P_7menos1           @coloco o valor menos significativo no 7 segmentos menos significativo
	str r0,[r1]
	ldr r1,=P_7menos2 			@segundo semáforo contador menos significativo
	str r0,[r1]
	cmp r7,#6 					@ se ficar com 5 segudos vou para o estado intermediário de amarelos
	blt amestado
	b loop

mudoestado:
	mov r7,#30 					@valor 30 padrão
	ldr r0,[r2]
	ldr r1,=P_7menos1           @coloco zero no 7 segmentos menos significativo
	str r0,[r1]
	ldr r1,=P_7menos2 			@seggundo semáforo contador
	str r0,[r1]
	ldr r0,[r2,#3]
	ldr r1,=P_7mais1            @coloco 3 no meu mais significativo
	str r0,[r1]
	ldr r1,=P_7mais2			@3 no segundo semáforo
	str r0,[r1]
	cmp r6,#0                   @vejo se estou no meu primeiro estado
	beq pestado                 @se sim tenho que ir para meu primeiro estado
	b   sestado                 @se nao vou para meu segundo estado

amestado:
	ldr r0,=amar                @meus dois semáforos ficam amarelos
	ldr r1,=P_sem_p
	str r0,[r1]
	ldr r1,=P_sem_s
	str r0,[r1]
	b loop                     	@volto para minha entrada do meu loop

pestado:
	mov r6,#1                  	@meu terceiro estado e ligado
	ldr r0,=verm
	ldr r1,=P_sem_p
	str r0,[r1]                	@meu primeiro semáforo fecha
	ldr r0,=verde
	ldr r1,=P_sem_s
	str r0,[r1]                	@meu segundo semáforo abre
	b loop                     	@volto para minha entrada do meu loop


sestado:
	mov r6,#0                  	@meu primeiro estado e ligado
	ldr r0,=verde
	ldr r1,=P_sem_p
	str r0,[r1]                 @meu primeiro semáforo abre
	ldr r0,=verm
	ldr r1,=P_sem_s
	str r0,[r1]                 @meu segundo semáforo fecha
	b loop                     	@volto para minha entrada do meu loop


tratatempo:
	ldr r8,=flag
	mov r9,#1 					@r8 minha flag de segundos
	str r9,[r8]
	movs pc,lr           		@ e retorna

flag:
	.word 0						@minha flag pra ver se entrou em interrupção
tab_digitos:
		.byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f
