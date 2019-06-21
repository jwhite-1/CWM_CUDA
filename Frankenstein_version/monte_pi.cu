/*
modified from

https://bitbucket.org/jsandham/algorithms_in_cuda/src/master/monti_carlo_pi/

https://gist.github.com/akiross/17e722c5bea92bd2c310324eac643df6




*/

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>
#include <curand.h>
#include <math.h>

__global__ void setup_kernel(curandState *state)
{
	int index = threadIdx.x + blockDim.x*blockIdx.x;
	curand_init(134872847, index, 0, &state[index]);
}



__global__ void count_pi(curandState *state,int *count,int iterations)
{
	
	// initialise thread ID
	int tid = threadIdx.x + blockIdx.x * blockDim.x;

 	// initialise shared array
        __shared__ int counter[256];
        counter[threadIdx.x] = 0;
	__syncthreads();



	// initialise RNG
	curand_init(45287643, index, 0, &state[tid]);

	// initialise the counter
	counter[threadId.x] = 0;

	// compute random values and increment counter
	for (int i = 0; i < iterations; i++)
	{

		float x = curand_uniform(&state[tid]);
		float y = curand_uniform(&state[tid]);
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
	// sum the values without threads clashing
	if (threadIdx.x == 0)
	{
		atomicAdd(count,counter[0]);
	}
}

int main() {

	// initialise variables
	int n = 256*256;
	int m = 100000000;
	int *h_count;
	int *d_count;
	curandState *d_state;
	float pi;

	// allocate mem
	h_count = (int*)malloc(n*sizeof(int));
	cudaMalloc((void**)&d_count, n*sizeof(int));
	cudaMalloc((void**)&d_state, n*sizeof(curandState));
	cudaMemset(d_count, 0, sizeof(int));

	// set up timing stuff
	float gpu_elapsed_time;
	cudaEvent_t gpu_start, gpu_stop;
	cudaEventCreate(&gpu_start);
	cudaEventCreate(&gpu_stop);
	cudaEventRecord(gpu_start, 0);

	// set kernel
	dim3 gridSize = 256;
	dim3 blockSize = 256;

	setup_kernel<<<gridSize, blockSize>>>(d_state, d_count, m);

	// run simulation
	monte_pi<<<gridSize, blockSize>>(d_state,d_count,m);

	// copy results back to the host
	cudaMemcpy(h_count, d_count, sizeof(int), cudaMemcpyDeviceToHost);
	cudaEventRecord(gpu_stop, 0);
	cudaEventSynchronize(gpu_stop);
	cudaEventElapsedTime(&gpu_elapsed_time, gpu_start, gpu_stop);
	cudaEventDestroy(gpu_start);
	cudaEventDestroy(gpu_stop);

	pi = *h_count*4.0/(n*m);
	printf("Value of pi calculated is: %f",pi);


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


