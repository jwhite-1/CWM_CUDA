#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>

__global__ void count_pi(iterations)

{
	
	// initialise thread ID
	int tid = threadIdx.x + blockIdx.x * blockDim.x;

 	// initialise shared array
        __shared__ int counter[256];
        counter[threadIdx.x] = 0;
 



	// initialise RNG
	curand_init(45287643, index, 0, &state[index]);

	// initialise the counter
	counter[threadId.x] = 0;

	// compute random values and increment counter
	for (int i = 0; i < iterations; i++)
	{

		float x = curand_uniform();
		float y = curand_uniform();
		counter[threadIdx.x] += 1 - int(x*x + y*y);

	}
	
	// reduction
	int i = blockDim.x/2;
	while (i!=0)
	{
		if (threadIdx.x < i)
		{
		counter[threadIdx.x] += cache[threadIdx.x + i];
		}
	i /= 2;
	__syncthreads();
	}

	if (threadIdx.x == 0)
	{
		atomicAdd(count,counter[0]);
	}
}

int main() {

	int N = 100000000;
	int area = 0;

	count_pi<<<10,10>>>(N);
	
	printf("\nPi:	%f\n",(4*counter[0])/(float)N);
	return 0;
}






/*
int main() {
    
    int N=10000000;
    int area=0;

    for(int i=0; i<N; i++) {
        float x = ((float)rand())/RAND_MAX;
        float y = ((float)rand())/RAND_MAX;

        if(x*x + y*y <= 1.0f) area++;
    }
    printf("\nPi:\t%f\n", (4.0*area)/(float)N);

    return(0);
}
*/


