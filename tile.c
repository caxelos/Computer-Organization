#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 4
#define M 33


int main(int argc, char *argv[])  {
      int array[N][N];
      int final_array[N][N];
      int i, j;
      
      clock_t start, end;
      
      
      start = clock();
      for (i = 0; i < N; i++)  {
            for (j = 0; j < N; j++)  {
                  array[i][j] = rand()%100;
                  printf("%d ", array[i][j]);
            }
            putchar('\n');
      }            
                  
      for (i = 0; i < N; i++)
            for (j = 0; j < N; j++)
                  final_array[j][i] = array[i][j];
                  
      printf("\n*********** The final array is  **********\n");
      for (i = 0; i < N; i++)  {
            for (j = 0; j < N; j++)
                  printf("%d ", final_array[i][j]);
            putchar('\n');
      }
      
      end = clock();
      printf("end is %lu\n", (long int)end );
      printf("** TOTAL TIME: %ld secs\n", (end - start) / CLOCKS_PER_SEC );                       
            
                              

      return 0;
}




/*
int main(int argc, char *argv[])  {
      int array[N][N];
      int final_array[N][N];
      int buffer[M][M];
      
      int i, j, k, l, x, y;
      
      for (i = 0; i < N; i++)  {
            for (j = 0; j < N; j++)  { 
                  array[i][j] = rand()%100;
                  printf("%d  ", array[i][j]);
            }
            printf("\n\n");
      }            
      
      
      for (i = 0; i < N; i++)  {
            for (j = 0; j < N; j++)  {    
                  k = 0;
                  while ((k < M)  && (k + i < N) )  {
                        l = 0;
                        while ( (l < M) && (l + j < N) )  {
                              buffer[k][l] = array[i+k][j+l];
                              //printf("%d ", buffer[k][l]); 
                              l++;
                        }
                        k++;
                        //printf("\n");
                  }
                  // edw ypologizw ton anastrofo
                  for (x = 0; x < l; x++)
                        for (y = 0; y < k; y++)
                              final_array[j+x][i+y] = buffer[y][x];
                              
                  
            }
      }
      
      printf("*********** THE FINAL ARRAY IS ***************\n");
      for (i = 0; i < N; i++) {
            for (j = 0; j < N; j++)
                  printf("%d ", final_array[i][j]);
            putchar('\n');
      }                   
 
            
      return 0;
}
*/