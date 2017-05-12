@ZL


.org 0x1000
	KEYBD_DATA		.equ 	0x80  @ porta de dados
	KEYBD_STAT		.equ 	0x81  @ porta de estado
	DISPLAY_DATA	.equ 	0x00
	KEYBD_READY 	.equ 	1
	LED				.equ	0x40
	CONTADOR  		.equ 	0x02  @ valor para contador temporizador




multiplica:
	ld    r3,[sp+8]
	ld    r4,[sp+4]
	cmp   r3,r4
	jnc   mult1		@ usa menor valor para controlar repetição 
	mov	r0,r3	@ troca valores de sp+8 e sp+4 usando 
	mov	r3,r4	@ r0 como temporário
	mov	r4,r0	@ inicializa valor do produto
mult1:
	set	r0,0
mult2:
	sub	r4,1	@ vamos realizar 2 adições 
	jc	mult3		@ desvia se terminamos
	add	r0,r3	@ adiciona mais uma parcela
	jmp	mult2		@ retorna quando todas as adições terminaram
mult3: ret


read:
	in r7,KEYBD_STAT
	cmp r7,KEYBD_READY
	jnz	read
	cmp	r6,0x02
	jz 	dezena
	cmp	r6,0x01
	jz 	unidade
	in	r1,KEYBD_DATA
	ret

dezena:
	in r0,KEYBD_DATA
	shl	r0,0x04
	sub r6,0x01
	jmp read

unidade:
	in	r3,KEYBD_DATA
	add	r0,r3
	sub r6,0x01
	jmp	read

init:
	set	sp,Pilhacom
	set	r2,1
	out	LED,r2
calcula:
	set r6,CONTADOR
	call read
	push r0
	push r2
	set	r0,0x00
	call multiplica
	add	sp,0x08
	out	LED,r0
	mov	r2,r0
	cmp	r1,10
	jz 	calcula
	hlt






PILHA:	
	.skip	0x20
Pilhacom:



