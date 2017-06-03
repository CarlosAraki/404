@ Programa para ligar/desligar um led, atuando um botão
        
        .global _start         @ ligador precisa do símbolo _start

@ flag para habilitar interrupções externas no registrador de status
        .equ IRQ, 0x80
        
@ modos de interrupção no registrador de status
        .equ IRQ_MODE,0x12
        .equ USER_MODE,0x10
        
@ endereços dos dispositivos
        .equ LIGA,0x90000
        .equ LED, 0xa0000

@ vetor de interrupções
        .org  7*4               @ preenche apenas a posição 7 (IRQ)
        b      tratador_botao
        
        .org 0x800
_start:
        mov     sp,#0x400       @ seta pilha do modo supervisor
        mov     r0,#IRQ_MODE    @ coloca processador no modo IRQ (interrupção externa)
        msr     cpsr,r0         @ instrução especial, processador agora no modo IRQ
        mov     sp,#0x300       @ seta pilha de interrupção do modo IRQ
        mov     r0,#USER_MODE   @ coloca processador no modo usuário
        bic     r0,r0,#(IRQ)    @ com interrupções IRQ habilitadas
        msr     cpsr,r0         @ instrução especial, processador agora no modo usuário
        mov     sp,#0x80000     @ seta pilha do usuário no final da memória 

        mov     r3,#1           @ liga led no início, r3 vai manter valor do led 
        ldr     r4,=LED         @ e r4 o endereço da porta do led
        strb    r3,[r4]         @ liga led
loop:
        ldr     r1,=flag_button @ verifica se ocorreu interrupção do botão
        ldr     r0,[r1]
        cmp     r0,#1           @ flag ligada?
        bne     loop            @ se não, continua no loop principal

@ aqui quando botão pressionado
        mov     r0,#0
        str     r0,[r1]         @ reseta flag_button para indicar que tratou
        eor     r3,#1           @ inverte valor do led
        strb    r3,[r4]         @ coloca novo valor no led
        b       loop            @ e fica em loop
        
@ tratador da interrupcao
@ vamos usar apenas os registradores r8 e r9, para não precisar usar a pilha para salvar
tratador_botao:
        ldr     r8,=flag_button @ apenas liga a flag
        mov     r9,#1           @ vamos tratar no código em modo usuário
        str     r9,[r8]         @ note que não precisamos ler o botão! Se ocorreu interrupção é porque foi pressionado.
        movs    pc,lr           @ e retorna
        
flag_button:
     .word 0                    @ variável usada para indicar se ocorreu interrupção do botão
