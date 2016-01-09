#include <stdio.h>

int main(int argc, char *argv){

	int i;	
	for (i= 0; i < 1024; i++) {
		printf("Counter Says: %04d\n", i);
	}
	return 0;
}
