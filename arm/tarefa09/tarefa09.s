                        @Carlos Vinícius Araki Oliveira RA:160141
  .global _start
  .EQU P_sem_p,0x90000  @Declaração das minhas constantes
  .EQU P_sem_s,0x90001
  .EQU Botao,0xa0000
  .EQU verde,0x1
  .EQU verm,0x4
  .EQU amar,0x2

_start:

  ldr r0,=verde         @de r0 à r2 terá minhas cores
  ldr r1,=amar
  ldr r2,=verm
  ldr r3,=P_sem_p       @r3 terá meu primeiro semaforo
  ldr r4,=P_sem_s       @r4 terá meu segundo semaforo
  ldr r5,=Botao         @r5 terá meu estado do botão
  mov r6,#0             @r6 será meu estado "comeca no estado 00"
  str r0,[r3]
  str r2,[r4]           @atualizo meus valores padrão antes da minha entrada do botão

botao:
  ldr r7,[r5]
  cmp r7,#1             @comparo se o bit ligou
  bne botao             @ se for diferente de zero espero a entrada do botao
  cmp r6,#0             @vejo se estou no meu primeiro estado
  beq pestado           @se sim tenho que ir para meu segundo estado
  cmp r6,#1             @vejo se estou no meu segundo estado
  beq sestado           @se sim tenho que ir para meu terceiro estado
  cmp r6,#2             @ vejo se estou no meu terceiro estado
  beq testado           @se sim tenho que ir para meu quarto estado
  b   qestado           @se nao vou para meu primeiro estado

pestado:
  mov r6,#1             @meu segundo estado e ligado
  str r1,[r3]           @meus dois semáforos ficam amarelos
  str r1,[r4]
  b botao               @volto para minha entrada do meu botão
sestado:
  mov r6,#2             @meu terceiro estado e ligado
  str r2,[r3]           @meu primeiro semáforo fecha
  str r0,[r4]           @meu segundo semáforo abre
  b botao               @volto para minha entrada do meu botão
testado:
  mov r6,#3             @meu quarto estado e ligado
  str r1,[r3]           @meus dois semáforos ficam amarelos
  str r1,[r4]
  b botao               @volto para minha entrada do meu botão
qestado:
  mov r6,#0             @meu primeiro estado e ligado
  str r0,[r3]           @meu primeiro semáforo abre
  str r2,[r4]           @meu segundo semáforo fecha
  b botao               @volto para minha entrada do meu botão
