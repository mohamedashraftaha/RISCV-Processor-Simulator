#include<iostream>
#include<fstream>
using namespace std;
int main()
{
	int n,x=0;
	cin >> n;
	ofstream myfile;
	myfile.open("ay text");
	for (int i = 0; i < n; i++)
	{
		myfile << "{mem[" << x+3 << "],mem[" << x + 2 << "],mem[" << x + 1 << "],mem[" << x << "]}" << endl;
		x += 4;
	}
	myfile.close();



	system("pause");
	return 0;
}