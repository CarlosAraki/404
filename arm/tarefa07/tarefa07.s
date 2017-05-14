                    @Carlos Vinícius Araki Oliveira RA:160141
.global _start
.org 0x1000
_start:


 mov     r0, #1     @ fd -> stdout
 ldr     r1, =msg   @ buf -> msg
 ldr     r2, =len   @ count -> len(msg)
 mov     r7, #4     @ write is syscall #4
 swi     #0x55      @ invoke syscall


 mov     r0, #0     @ status -> 0
 mov     r7, #1     @ exit is syscall #1
 swi     #0x55      @ invoke syscall

msg:
 .ascii      "Um teste simples"
len = . - msg
