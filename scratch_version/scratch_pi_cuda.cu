#include <stdio.h>
#include <stlib.h>



// reduction from lectures
__global__ void reduction(float *d_input, float *d_output)
{
	// allocate memory
	__shared__ float smem_array[NUM_ELS];

	int tid = threadIdx.x + blockDim.x*blockIdx.x;

	// each thread loads data into shared memory

	smem_array[tid] = d_input[tid];
	__syncthreads();

	// perform binary tree reduction

	for (int d = blockDim.x/2; d>0; d /= 2)
	{
	__syncthreads();
	if (tid<d) smem_array[tid] += smem_array[tid+d];
	}
	
	// first thread puts result into global memory
	
	if (tid==0) d_output[0] = smem_array[0];

}

// kernel to calculate pi
__global__ void pi_cuda(int iterations)
{
/*
Pseudocode:
	-Initialise RNGs per thread
	-Generate N pairs of random x,y per thread
		-Is x*x + y*y < 1? if so tick up counter
	-Total up number of counts across all threads and multiply
	-Divide by total number of trials to estimate PI
*/


	// initialise thread ID
	int tid = threadIdx.x + blockDim.x * blockIdx.x;
	int counter = 0


	// 1. Create a new generator of the desired type (see Generator Types ) with curandCreateGenerator().
	curandCreateGenerator(CURAND_RNG_PSEUDO_XORWOW, seed, offset


	// 2. Set the generator options (see Generator Options); for example, use curandSetPseudoRandomGeneratorSeed() to set the seed.



	// 3. Allocate memory on the device with cudaMalloc().



	// 4. Generate random numbers with curandGenerate() or another generation function.
	int i;
	float x_coor, y_coor;
	for (i=0; i<=iterations; i++) 
		{
		x_coor = curandGenerate();
		y_coor = curandGenerate();

		if (x_coor*x_coor + y_coor*y_coor) <= 1
			{
			counter++;		
			}
		}


	// 5. Use the results.



	// 6. If desired, generate more random numbers with more calls to curandGenerate().



	// 7. Clean up with curandDestroyGenerator(). 



atomicAdd()
}


int main() {

// run kernel to calculate many values with which to guess pi
pi_cuda<<<5,10>>>(iterations);


return(0);
}

