#include <stdio.h>
#include <stdlib.h>

struct node {
	int x;
	struct node *next;
};

int main(int argc, char* argv[]) {

	int i = 1000;

	struct node *two;
	two = (struct node *) malloc( sizeof(struct node) );

	two->next = 0;

	int j;
	int k;
	for (j = 0; j < i; j++) {
		int prime = 1;
		for (k = 2; k < j; k++) {
			if (j % k == 0) {
				prime = 0;
				break;
			}
		}
		if ( prime ) {

			printf("%d is prime\n", j);
		}
	}
	return 0;
}

