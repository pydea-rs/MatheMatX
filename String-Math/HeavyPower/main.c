#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#define MAX_DIGITS 2142909999
#define CONSOLE_WIDTH 80

void main()
{
	int line = 1;
	//clrscr();
	while(1)
	{
		int p,i,j,t, b, ragh = 0, carry = 0;
		time_t started_at;
		
		int *r = (int *)calloc(MAX_DIGITS, sizeof(int)); // safe version of malloc i suppose!
		if(r == NULL) 
		{
			printf("Cannot allocate memory!");
			exit(1);
		}
		printf("\nBase : ");
		line++;
		scanf("%d",&b);
		printf("Power : ");
		line++;
		scanf("%d",&p);
		started_at = time(NULL);
		printf("\n\t_____________________Progress: 0.0%%_____________________");
		// algorythm is obvious; just do the multiplies ragh by ragh
		for(i = 0;i < p;i++)
		{
			// progress bar
			printf("\r\t_____________________Progress: %.2f%%_____________________", 100 * (float)(i+1) / (float)p);

			if(i == 0)
			{
				r[i] = b;
				continue;
			}
			for(j = 0;j <= ragh;j++)
			{
				t = r[j];
				t = t * b + carry;
				carry = 0;
				if(t < 10)
					r[j] = t;
				else
				{
					carry = t / 10;
					t = t % 10;
					r[j] = t;
					if(j == ragh)
						ragh++;
				}
			}
		}
		printf("\nTotal time passed: %f\n", difftime(time(NULL), started_at));
		printf("\n%d ^ %d = ", b, p);
		for(i = ragh; i >= 0; i--)
			printf("%d",r[i]);
		putchar('\n');

		for(i = 0;i < CONSOLE_WIDTH;i++)
			printf("-");
		if(ragh >= 100 && ragh < 150)
			line++;
		else if(ragh >= 150)
			line += 2;
		line += 2;
		// free memory for next one
		free(r);
	}
}
