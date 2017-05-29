// programa que usa um teclado e um mostrador de sete segmentos

#include<stdio.h>

// endereços de portas
#define DISPLAY    0x90000
#define KBD_DATA   0x90010
#define KBD_STATUS 0x90011

// constantes
#define KBD_READY  0x1
#define KBD_OVRN   0x2

char *kbd_status=(char *) KBD_STATUS;
char *kbd_data=(char *) KBD_DATA;
char *display=(char *) DISPLAY;
char digitos[]={0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f};

int main() {

  while (1) {
    // espera por tecla pressionada
    while ((*kbd_status & KBD_READY) == 0)
      ;
    // escreve padrão de bits correspondente à tecla no mostrador
    *display=digitos[(int)*kbd_data];
  }
}
