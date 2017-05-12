 .org 0x1000
 
    multiplica:
            ld r2,[sp+4]                @ salva em r2 o segundo parametro
            ld r3,[sp+8]                @ salva em r3 o primeiro parametro
        loop_soma:                      @ loop de somar para fazer a multiplicação
            add r0,r2                   @ r0 armazena a multiplicação
            sub r3, 0x01        
            jg loop_soma               @ verifica se precisa somar mais vezes
            
            ret                         @ retorna para a main
        
    
    read:
            in r5,0x81                  @ verifica se houve entrada de numero
            sub r5,0x01         
            jnz read            
            inb r6,0x80                 @ pega o valor inserido
            mov r1,r6                   @ verifica se o valor é um * ou #
            sub r1,0x0a
            jge termino_de_leitura
            add r0,r6                   @ salva o numero lido
            shl r0,0x04                 @ coloca o numero na posição mais significativa
            jmp read
        termino_de_leitura:
            shr r0,0x04                 @ arruma a posicao dos valores em r0
            add r1,0x0a                 @ arruma o valor de * e #
            ret 
            
    
    init:
    
        set r7,0x01                     @ valor 1 para os leds
        out 0x40,r7                    
        set sp,inicio_de_pilha          @ inicia a pilha 
    mult:
        set r0,0x00                     @ reseta r0 para read
        call read                       @ chama a leitura 
        mov r8,r0
        set r0,0x00                     @ reseta r0 para multiplica
        push r7                         @ empilha os argumentos
        push r8                         
        call multiplica                 @ chama a multiplicação
        mov r7,r0                       @ manda o valor da multiplicação para o leds
        out 0x40,r7
        add sp,0x08                     @ limpa a pilha
        cmp r1,0x0a                     @ verifica se acabou as multiplicações
        jz mult 
        
        hlt
    fim_de_pilha:
        .skip 0x100
    inicio_de_pilha:
        
