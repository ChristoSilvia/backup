#include <stdio.h>

typedef enum {prime, composite, unit, zero } divisibility;

int main(int argc, char *argv) {
	
	printf("Enter a number:\n");

	int n;
	scanf("%d", &n);

	printf("Up to: %d\n", n);

	divisibility primes[n];
	int i;

	primes[1] = unit;
	for (i=2; i<n; i++) {
		primes[i] = prime;
	}

	int j;
	for (i=2; i<n; i++) {
		if (primes[i] == prime) {
			for (j = 2*i; j < n; j = j+i) {
				primes[j] = composite;
			}
		}
	}

	for (i=0; i<n; i++) {
		if (primes[i] == prime) {
			printf("%d is prime\n", i);
		} else if (primes[i] == unit) {
			printf("%d is a unit\n", i);
		} else {
			printf("%d is not prime\n", i);
		}
	}

	return 0;
}
