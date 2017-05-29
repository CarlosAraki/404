#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N 20

void triangle(unsigned int n)
{
  int c, i, j, k;
 
  c=1;
  for(i=0; i < n; i++) {
    for(k=0; k <= i; k++) {
      printf("%3d ", c);
      c+=1;
    }
    printf("\n");
  }
}

int main(void)
{
  triangle(N);
  return 0;
}
