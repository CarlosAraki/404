#include <stdio.h>
#include <stdlib.h>
#define SWAP(a,b)   { int t; t=a; a=b; b=t; }  // Macro for swapping
#define INDEX 8

void bubble_sort( int a[], int n )  
{   
    int i, j;
       
    for(i = 0; i < n; i++)         // Make a pass through the array for each element
    {              
        for(j = 1; j < (n-i); j++) // Go through the array beginning to end
        {              
           if(a[j-1] > a[j])       // If the the first number is greater, swap it 
              SWAP(a[j-1],a[j]);   
        }
    }
}

int main(void) 
{
   int i;
   int array[INDEX] = {12, 9, 4, 99, 120, 1, 3, 10};
   
   printf("Before sorting:\n");     // Show array elements before sort
   for(i = 0; i < INDEX; i++) {
     printf("%d ", array[i]);
   }
   printf("\n");
   bubble_sort(array, INDEX);        // Sort the array
   printf("After sorting:\n");     // Show results after the sort
   for(i = 0; i < INDEX; i++) {
     printf("%d ", array[i]);
   }
   printf("\n");   
   return 0;
} 
