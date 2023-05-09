
#include <iostream>
#include "mex.h"
#include <cmath>



void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){	

	double *E,*NL,*NL2,*matEC,*matED;
	double index,maxNL;


	E = mxGetPr(prhs[0]); 
	NL = mxGetPr(prhs[1]);
	NL2 = mxGetPr(prhs[2]);
	index = mxGetScalar(prhs[3]);
	maxNL = mxGetScalar(prhs[4]);
	matEC = mxGetPr(prhs[5]);
	matED = mxGetPr(prhs[6]);

	//序号：    1      2      3      4      5      6      7       8     9
    //2D bin：(0,0), (0,1), (1,0), (1,1), (0,2), (2,0), (1,2), (2,1), (2,2)    

	int mBB = (int)mxGetM(prhs[4]); // 行数mBB
	int nBB = (int)mxGetN(prhs[4]); // 列数nBB

	double *F,*NL3,*ec1,*ed1,*Exx,*Eyy;
	double *indextri;

	plhs[0]=mxCreateDoubleMatrix(1,2*index,mxREAL); 
	plhs[1]=mxCreateDoubleMatrix(1,2*index,mxREAL); 
	plhs[2]=mxCreateDoubleMatrix(1,maxNL,mxREAL); 
	plhs[3]=mxCreateDoubleMatrix(1,maxNL,mxREAL); 
	plhs[4]=mxCreateDoubleMatrix(1,index,mxREAL); 
	plhs[5]=mxCreateDoubleMatrix(1,index,mxREAL); 
	plhs[6]=mxCreateDoubleMatrix(1,1,mxREAL); 


	

	F=mxGetPr(plhs[0]); 
	NL3 = mxGetPr(plhs[1]);
	ec1 = mxGetPr(plhs[2]);
	ed1 = mxGetPr(plhs[3]);
	Exx = mxGetPr(plhs[4]);
	Eyy = mxGetPr(plhs[5]);
	indextri = mxGetPr(plhs[6]);

	int T,i,j;
	//indextri[0] = 0;
	

	for(T=1;T<=maxNL;T++)
	{
		int indexbis = 0;

		for(i=1;i<=2*index;i++)
		{
			//int dif = i - 2*((int)(i/2));
			//int ii;

			//if(dif == 1)
			//{ii = (int)(i/2+1);}
			//else if(dif == 0)
			//{ii = (int)(i/2);}

			//if( NL2[i-1] <= T && E[i-1]  < 2)
			//{
			//	indextri[0] = indextri[0] + 1;
			//	int dd = indextri[0];
			//	Exx[dd-1] = E[2*i-1-1];
			//	Eyy[dd-1] = E[2*i-1];
			//}



			if( NL2[i-1] <= T && E[i-1]  < 3)
			{
				indexbis = indexbis + 1;
				F[indexbis-1] = E[i-1];
				NL3[indexbis-1] = NL2[i-1];

			}
		}



		for(i=1;i<=(int)(indexbis/2);i++)
		{
			double x,y;
			x = F[2*i-1-1];
			y = F[2*i-1];

			//indextri[0] = indextri[0] + 1;
			//int dd = indextri[0];
			//Exx[dd-1] = F[2*i-1-1];
			//Eyy[dd-1] = F[2*i-1];

			int ind = 0;

			if(x == 0 && y == 0)
			{
				ind = 1;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 0 && y == 1)
			{
				ind = 2;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 1 && y == 0)
			{
				ind = 3;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 1 && y == 1)
			{
				ind = 4;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 0 && y == 2)
			{
				ind = 5;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 2 && y == 0)
			{
				ind = 6;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 1 && y == 2)
			{
				ind = 7;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 2 && y == 1)
			{
				ind = 8;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}

			if(x == 2 && y == 2)
			{
				ind = 9;
				ec1[T-1] = ec1[T-1] + matEC[ind-1];
				ed1[T-1] = ed1[T-1] + matED[ind-1];
				continue;
			}




		}
		//indextri[0] = indexbis;

	}







}
