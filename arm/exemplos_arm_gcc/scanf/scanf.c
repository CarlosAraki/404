#include <stdio.h>
extern i;

int i;

int main(void) {

  printf("Type a number\n");
  scanf("%i",&i);
  printf("You typed %i (0x%08x)\n",i,i);
}
