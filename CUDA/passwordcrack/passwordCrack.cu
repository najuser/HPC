#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>


__device__ int is_a_match(char *attempt) {
	char mypassword1[] = "AV4567";
	char mypassword2[] = "FG7868";
	char mypassword3[] = "HJ7654";
	char mypassword4[] = "DE6789";


	char *b = attempt;
	char *i = attempt;
	char *s = attempt;
	char *h = attempt;
	char *p1 = mypassword1;
	char *p2 = mypassword2;
	char *p3 = mypassword3;
	char *p4 = mypassword4;

	while(*b == *p1) { 
		if(*b == '\0') 
		{
			printf("Password: %s\n",mypassword1);
			break;
		}

		b++;
		p1++;
	}
	
	while(*i == *p2) { 
		if(*i == '\0') 
		{
			printf("Password: %s\n",mypassword2);
			break;
		}

		i++;
		p2++;
	}

	while(*s == *p3) { 
		if(*s == '\0') 
		{
			printf("Password: %s\n",mypassword3);
			break;
		}

		s++;
		p3++;
	}

	while(*h == *p4) { 
		if(*h == '\0') 
		{
			printf("Password: %s\n",mypassword4);
			return 1;
		}

		h++;
		p4++;
	}
	return 0;

}

__global__ void  kernel() {
	char i1,i2,i3,i4;

	char password[7];
	password[6] = '\0';

	int i = blockIdx.x+65;
	int j = threadIdx.x+65;
	char firstMatch = i; 
	char secondMatch = j; 

	password[0] = firstMatch;
	password[1] = secondMatch;
	for(i1='0'; i1<='9'; i1++){
		for(i2='0'; i2<='9'; i2++){
			for(i3='0'; i3<='9'; i3++){
				for(i4='0'; i4<='9'; i4++){
					password[2] = i1;
					password[3] = i2;
					password[4] = i3;
					password[5] = i4; 
					if(is_a_match(password)) {
					} 
					else {
	     			//printf("tried: %s\n", password);		  
					}
				}
			}
		}
	}
}

int time_difference(struct timespec *start, 
	struct timespec *finish, 
	long long int *difference) {
	long long int ds =  finish->tv_sec - start->tv_sec; 
	long long int dn =  finish->tv_nsec - start->tv_nsec; 
	if(dn < 0 ) {
		ds--;
		dn += 1000000000; 
	} 
	*difference = ds * 1000000000 + dn;
	return !(*difference > 0);
}


int main() {

	struct  timespec start, finish;
	long long int time_elapsed;
	clock_gettime(CLOCK_MONOTONIC, &start);

	kernel <<<26,26>>>();
	cudaThreadSynchronize();

	clock_gettime(CLOCK_MONOTONIC, &finish);
	time_difference(&start, &finish, &time_elapsed);
	printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9)); 

	return 0;
}


