					@ Carlos Vinícius Araki Oliveira RA:160141
.org 0x200			@ começo o ponto de montagem no 0x200
start:				
	set r0, 0x5000	@coloco o valor de 0x5000 no registrador r0
	set r1, 0x200	@coloco o valor de 0x200 no registrados r1
	add r0,r1		@somo o registrador r1 no r0
	add r0,r0		@somo r0 com r0 para 2*r0
	add r0,r0		@somo r0 com r0 para 4*r0
hlt 				@ interrompo a execução