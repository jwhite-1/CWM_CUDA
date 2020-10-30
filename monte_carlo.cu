#include <stdio.h>
#include <stdlib.h>

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