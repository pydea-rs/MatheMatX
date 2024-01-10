#include <iostream>
#include <stdlib.h>

double Det(double **a,const int n)
{
	if (n == 2)
		return a[0][0] * a[1][1] - a[0][1] * a[1][0];
	double det = 0;
	for (int soton = 0; soton < n; soton++)
	{
		if (a[0][soton] == 0)
			continue;
		double **b = new double*[n-1];
		for (int ia = 0, ib = 0; ia < n; ia++)
		{
			if (ia == 0)
				continue;
			b[ib] = new double[n - 1];
			for (int ja = 0, jb = 0; ja < n; ja++)
			{
				if (ja == soton)
					continue;
				b[ib][jb] = a[ia][ja];
				jb++;
			}
			ib++;
		}
		det += ( soton % 2 == 0 ? 1 : -1 ) * a[0][soton] * Det(b, n - 1);
	}
	return det;
}

void main()
{
	int n = 0;
	while (n <= 0)
		std::cin >> n;
	double **a = new double*[n];
	for (int i = 0; i < n; i++)
		a[i] = new double[n];
	for (int i = 0; i < n; i++)
		for (int j = 0; j < n; j++)
		{
			std::cout << "a[ " << i << " ][ " << j << " ] = ";
			std::cin >> a[i][j];
		}
	system("cls");
	if (n != 1)
	{
		std::cout << "det(A) = " << Det(a, n) << std::endl;
	}
	else
		std::cout << "det(A) = " << a[0][0] << std::endl;
	system("pause");
}