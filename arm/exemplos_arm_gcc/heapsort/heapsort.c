#include <stdio.h>

void swapi(int *x, int *y)
{
    int z;
     
    z = *x;
    *x = *y;
    *y = z;
}

int heapsort(int *arr, int n)
{
    int start, end;
 
    // heapify the array
    for(start = (n - 2) / 2; start >= 0; --start) // for every root
        siftDown(arr, start, n); // sift through it
     
    // sort the array
    for(end = n - 1; end; --end) // for every element of the heap
    {
        swapi(&arr[end], &arr[0]); // swap it with the top root
        siftDown(arr, 0, end); // rebuild the heap
    }
}
 
int siftDown(int *arr, int start, int end)
{
  int root, child;
  
  root = start; // pick the root index
  while(2 * root + 1 < end) // while the root has a child
    {
      child = 2 * root + 1; // pick its index
      if((child + 1 < end) && (arr[child] < arr[child+1]))
	++child; // if the other child is bigger, pick it instead
      if(arr[root] < arr[child]) { // if root is smaller than the child
	  swapi(&arr[child], &arr[root]); // swap them
	  root = child; // go down the heap
      }
      else // if the child is smaller than the root
	return; // that root is in the right spot
    }
}

#define N 10
int array[N];
int main(){
  int i;
  for (i=0; i<N; i++){
    array[i]= rand();
  }
  printf("before sorting:\n");
  showarray(array);
  heapsort(array, N);
  printf("after sorting:\n");
  showarray(array);
}

int showarray(int * a){
  int i;
  printf("N=%d ", N);
  for (i=0; i<N; i++){
    printf("%10d ",a[i]);
  }
  printf ("\n");
}

