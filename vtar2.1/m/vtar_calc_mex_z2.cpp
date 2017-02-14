// this version is for susceptance plot, 
////////////////////////////////////////////////////////
/*  VTAR (Vocal Tract Acoustic Response calculation)
 *        Author: Xinhui Zhou
 *        Date: 01/25/2004
 *
 *
 *  This program is modified to be mex function recalled by VTAR matlab program.
 *   - xinhui, 06/2/2004
 * 
 *  Recalled by matlab in the following method: 
 *    [f, AR] = vtar_calc_mex(Fupper, df, Mode, root, currentTube, Property) ;
 *	  Output :
 *			f			-	frequncy
 *			AR			-	acoustic response (complex number)
 *    Input arguments: 
 *			Fupper		-	Upper limit of frequency for calculation
 *			df			-	frequency step for calculation
 *			Mode		-   determine the output of vocal tract from LIPS and/or NOSTIRL1 and/or NOSTIRL2. 
 *			root		-	index of tube in the root of tree stucture (tree stucture is geometric configuration of vocal tract)
 *			currentTube	-   tree struture to store tube information
 *			Property	-	property of fluid and vocal tract wall, also includes the radiation property On/Off
 *
 *
 * 1.  
 *  General idea is to model the vocal tract geometry as a tree structure of tube connections , with its root at the tube 
 *  which starts from GLOTTIS. Only in tree structure, the acoustic response can be calculated recursively.
 * 
 *  The output of vocal tract is from LIPS, NOSTRIL1 and NOSTRIL2, which depends on which mode the user chooses to model 
 *  the sound. Except the tubes connected to glottis , lips and nostrils, all other tubes  are connection tubes and no acoustic 
 *  signal output from them.
 *
 *  So this program is to calculate the transfer function from GLOTTIS to LIPS and/or NOSTIRL1 and/or NOSTIRL2. 
 *			Mode		-   determine the output of vocal tract from LIPS and/or NOSTIRL1 and/or NOSTIRL2. 
 *          if Mode == Oral_mode		output of vocal tract from LIPS
 *          if Mode == Nasal_mode		output of vocal tract from NOSTIRL1 and/or NOSTIRL2
 *          if Mode == OralNasal_mode	output of vocal tract from LIPS and/or NOSTIRL1 and/or NOSTIRL2
 *         
 *   If the sound source is not from GLOTTIS, such as in FRICATIVE, the calculation has to be treated specially.
 *
 * 2. Constraints on geometry configuration
 *    - Only one tube can start at GLOTTIS
 *    - Only one tube can end at LIPS or NOSTRIL1 or NOSTRIL2
 *    - No loops exist in cofiguration
 *    - if one tube is 2-channel module, it can not connect to LIPS or NOSTRIL1 or NOSTRIL2 at the middle of tube, i.e. no side branch of this tube 
 *      can be connected to LIPS or NOSTRIL1 or NOSTRIL2.
 *
 * 3. Many steps to avoid false geometry configuration are taken in Maltab function arbitrary_model() in get_acouticresponse.m    
 *  
 * 4. Data strcutre for each tube
 *		typedef struct treenode
 *			{
 *			int IndexOfBranch ; // the numbering of each tube, may do not need due to the tree structure
 *
 *			int numOfSections;  // how many sections 
 *			double* secLen;     // length of each sections
 *			double* secArea;    // area of each sections
 *
 *			 // for two_channels module
 *			int numOfSections1; // if tube is a two-channle module, here is the information of second channel
 *			double* secLen1; 
 *			double* secArea1; 
 *	
 *			int typeOfModule; // SINGLECHANNEL, TWOCHANNEL (see the reference paper in VTAR) 
 *			int typeOfStartofTube; // GLOTTIS or INTERMEDIATE , which root of tree structure is
 *			int typeOfEndofTube;   // LIPS, NOSTRIL1, NONSTRIL2 or INTERMEDIATE ;
 
 *			// ALL OF THE TUBES AT LEAF OF TREE WHICH DO NOT LIPS, NOSTRIL1 OR 2 AT END OF EACH ONE WILL BE REGARDED
 *			// AS CLOSED END, WITH INFINITE IMPEDANCE
 *			// LIPS, NOSTRIL1 OR 2, AND GLOTTIS CAN BE USED ONLY ONCE 
 *
 *			int K[3] ;  // K[0] if oral K should be calculated
 *					    // K[1] if left nose K should be calculated, NOSTRIL1
 *		   				// K[2] if right nose K should be calculated, NOSTRIL2
 *						// (see function markMultipleTree in this program)
 *			// in order to fit the format of matlab, use double instead of int, (int does not exist in Matlab6.5, but exists in 7.0)
 *			double nextBranches[MAXNUMCHILDREN] ;    //  number of each children branch
 *			double nextBranchesLoc[MAXNUMCHILDREN] ; //   location of each children branch, may at the end of each branch, so use END to denote this .
 *
 *			treenode* child[MAXNUMCHILDREN];  // pointer to tubes in lower level of tree structure, which are connected to this tube
 *			treenode* left;    // for the case of 2-channel module with side branch in the middle conneted to channel 1 (see function createMultipleTree in this program)
 *			treenode* right;   // for the case of 2-channel module with side branch in the middle conneted to channel 2 
 *			}treenode;
 * 
 *  5. main functions in this program. 
 *
 *     - treenode *createTree( const mxArray *prhs, int rootNum) ;
 *			create a tree structure by reading data from matlab
 *
 *     - void createMultipleTree(treenode *root) ;
 *			modify the tree structure to make all the children tubes are at the end of parent tube 
 *
 *	   - void markMultipleTree(treenode *root, int *valid) ; // determine k[3]
 *          determine if transfer matrix K1-3 should be calculated
 *
 *     - int  calcKZ(double f, double* A, double* l, int nLength, Complex Zterm, property *p, Complex K[2][2], Complex *Z);
 *           calculation K and Z for one single channel

 *     - void calcTransFunc(treenode *node, Complex K1[2][2], Complex K2[2][2], Complex K3[2][2], Complex *Z, Complex *Zlip, Complex *Znoseleft, Complex *Znoseright, double f, property *p);
 *           calculate transfer function for the tree 'node'
 *
 *  6. 
 *  Here are the steps done based on Tarun's work , in this c program 
 *		1). modify the data structure to include some symbols to indicate 
 *			which ones of K1, K2, K3 should be updated 
 * 
 *		2). modify the data structure to include more modules such as one branch , 
 *			2 channels for lateral sounds, if there is a side branch in lateral channel , 
 *        further steps should be taken to get the K 
 *
 *		3). change to mex function
 *		4). property and radiation on/off modified
 *		5). The binary tree is modified to more than 2 children in tree structure
 *		6). Breaking the tube with many children into several tubes, so that node in the new tree 
 *			will have children only at the end of parent tube
 *		7). due to compiling problem in gcc in matlab of unix , Complex.h is used and its member function is modified , 
 *    so the compiler does only rely on Complex.h , not on Matrix.h
 */


#include "mex.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "Complex.h"

#define MAXNUMCHILDREN   11  //
#define MAXNUMTUBES      31  //  No. 0 unused, since matlab does not have 0 element
#define SINGLECHANNEL     1 //
#define TWOCHANNELS       2 //
#define NONVALID          0
#define END               99900000  //


// just for programming convenience  at this moment
#define   OTB   2
#define   NLTB  3
#define   NRTB  4
#define   LIPS             OTB
#define   NOSTRIL1	   	   NLTB
#define   NOSTRIL2		   NRTB
#define   INTERMEDIATE     0 

#define GLOTTIS			 2

#define CHANNEL_1        20000000 
#define CHANNEL_2        40000000 
   
//define the modes of calculation
#define ORAL_MODE 		2
#define NASAL_MODE 		3
#define ORALNASAL_MODE	4
#define FRICATIVE_MODE	5

//General definitions
#define MAXLINELENGTH	1000

#define PI  3.1415926535897932
#define EPS 1E-12

typedef struct treenode
{
	int IndexOfBranch ; // the numbering of each tube, may do not need due to the tree structure

	int numOfSections;
	double* secLen;
	double* secArea;

	 // for two_channels module
	int numOfSections1;
	double* secLen1; 
	double* secArea1; 
	
	// ALL OF THE TUBES AT LEAF OF TREE WHICH DO NOT LIPS, NOSTRIL1 OR 2 AT END OF EACH ONE WILL BE REGARDED
	// AS CLOSED END, WITH INFINITE IMPEDANCE
	// LIPS, NOSTRIL1 OR 2, AND GLOTTIS CAN BE USED ONLY ONCE
	int typeOfModule; // SINGLECHANNEL, TWOCHANNEL 
	int typeOfStartofTube; // GLOTTIS or INTERMEDIATE , which root of tree structure is
	int typeOfEndofTube;   // LIPS, NOSTRIL1, NONSTRIL2 or INTERMEDIATE ;

	//xinhui added 
	int K[3] ; // K[0] if oral K should be calculated
						   // K[1] if left nose K should be calculated
							// K[2] if right nose K should be calculated	
	// in order to fit the format of matlab, use double instead of int
    double nextBranches[MAXNUMCHILDREN] ; //  number of each children branch
	double nextBranchesLoc[MAXNUMCHILDREN] ; //   may at the end of each branch, so use END to denote this .

	treenode* left;
	treenode* right;
	treenode* child[MAXNUMCHILDREN];  
}treenode;


// air and wall property
typedef struct property {
    double RHO  ;
    double MU   ;
    double C0   ;
    double CP   ;
    double LAMDA;
    double ETA  ;
    double WALL_L ;
    double WALL_R ;
    double WALL_K ;
	double RADIATION_ON ;
} property;


// Prototype declerations
treenode *createNode(void) ;
treenode *createTree( const mxArray *prhs, int rootNum) ;

void copyNode(treenode *root, treenode *node) ;
double *copyData(double *data,  int startPos, int endPos) ;
void updateAreaFunction(treenode *root, treenode *node, double location) ;
void createBinaryTree(treenode *root) ;
void createMultipleTree(treenode *root) ;
void pruneMultipleTree(treenode *root) ;

void markMultipleTree(treenode *root, int *valid) ; // determine k[3]

void parseOriginalTree(treenode *root);
void parseTree(treenode *root);
void freeTree(treenode* root);
char *readAndParse(treenode *node, short *mode, FILE *inFilePtr, char *lineString, short *lineNumber);
int  calcKZ(double f, double* A, double* l, int nLength, Complex Zterm, property *p, Complex K[2][2], Complex *Z);
void calcTransFunc(treenode *node, Complex K1[2][2], Complex K2[2][2], Complex K3[2][2], Complex *Z, Complex *Zlip, Complex *Znoseleft, Complex *Znoseright, double f, property *p);

void bubbleSort(double locations[], double branches[], int array_size) ;
void multiply(Complex K[2][2], Complex K1[2][2], Complex K2[2][2]) ;  // K = K1*K2


/*	
 *  Recalled by matlab in the following method: 
 *    [f, AR] = vtar_calc_mex(Fupper, df, Mode, root, currentTube, Property) ;
 *	  Output :
 *			f			-	frequncy
 *			AR			-	acoustic response (complex number)
 *    Input arguments: 
 *			Fupper		-	Upper limit of frequency for calculation
 *			df			-	frequency step for calculation
 *			Mode		-   determine the output of vocal tract from LIPS and/or NOSTIRL1 and/or NOSTIRL2. 
 *			root		-	index of tube in the root of tree stucture (tree stucture is geometric configuration of vocal tract)
 *			currentTube	-   tree struture to store tube information
 *			Property	-	property of fluid and vocal tract wall, also includes the radiation property On/Off
 *
 *
 */
	void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	treenode *root;
	int mode = 0;
	property *p;
	Complex Z, Zlip, Znoseleft, Znoseright;
	Complex Koral[2][2], KnoseLeft[2][2], KnoseRight[2][2];
	Complex transFuncOut;
	Complex j(0,1);

    int iRow ;
    double	*f ;
    double  *AR , *ARreal, *ARimg;  // ARreal - real part of acoustic response, ARimg - image part of acoustic response
    double  *Zreal, *Zimg;  // real part and imaginary part of impedance
    
	double	fupper, df ;
    int		nFrequency ;
    int		rootNum ;
    int     valid = 1 ;


   	if(nrhs < 6)
   	{
   	   	   mexPrintf("Not enough arguments:   [f, AR] = vtar_calc_mex3(Fupper, df, VT.Arbitrary.Geometry.Mode, root, currentTube, VT.Property)");
   	   	   return ;
   	}

    //get maximum frequency and step value -  fupper, df , f[]
    fupper = *(mxGetPr(prhs[0])) ; 
    df	 = *(mxGetPr(prhs[1])) ; 
    nFrequency = (int)(floor(fupper/df)+1) ;	   

	
	// create the output arguments
	plhs[0] = mxCreateDoubleMatrix(nFrequency, 1, mxREAL);
    // plhs[1] = mxCreateDoubleMatrix(nFrequency, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(nFrequency, 1, mxCOMPLEX);
    
	// for impdeance, Z  , returning value
    plhs[2] = mxCreateDoubleMatrix(nFrequency, 1, mxCOMPLEX);
    Zreal   = mxGetPr(plhs[2]);
    Zimg    = mxGetPi(plhs[2]);

	
	/* Get pointers to real and imaginary parts of the matrix */
    f  = mxGetPr(plhs[0]);
    //AR = mxGetPr(plhs[1]);
    ARreal = mxGetPr(plhs[1]);
    ARimg  = mxGetPi(plhs[1]);

	
	// frequency value
	for(iRow=0; iRow<nFrequency; iRow++)
	{ 
 	  f[iRow]   = df*(iRow)+1 ;  // +1 means to remove f=0
	}

	// property of fluid and wall setup
	p = (property *) malloc(sizeof(property));
	// get p for property
	if(nrhs >= 6)
	{
		p->RHO		= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 0) ) ) ;
		p->MU		= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 1) ) );
		p->C0		= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 2) ) ) ;
		p->CP		= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 3) ) ) ;
		p->LAMDA	= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 4) ) ) ;
		p->ETA		= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 5) ) ) ;
		p->WALL_L	= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 6) ) ) ;
		p->WALL_R	= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 7) ) ) ;
		p->WALL_K	= *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 8) ) ) ;
		p->RADIATION_ON = *(mxGetPr( mxGetFieldByNumber(prhs[5], 0, 9) ) ) ;
	}
	else
	{
		p->RHO		= 1.14e-3; 
		p->MU		= 1.86e-4; 
		p->C0		= 3.5e4; 
		p->CP		= 0.24; 
		p->LAMDA	= 5.5e-5; 
		p->ETA		= 1.4;  
		p->WALL_L	=  1.5; 
		p->WALL_R	= 1600; 
		p->WALL_K	= 3e5; 
		p->RADIATION_ON = 0 ;  
	}


   // Mode : oral , nasal , or OralNasal, (Fricative is special case)
    mode  = (int) (*(mxGetPr(prhs[2]))) ; 

  // root number of tubes
    rootNum = (int) (*(mxGetPr(prhs[3]))) ; 


	// reading geometry data and creating nonbinary tree  
	root = 	createTree(prhs[4], rootNum) ;

	//mexPrintf("-------parseOriginalTree(root);-------------------------------------------------------------------------\n") ;
	//parseOriginalTree(root);
	//parseTree(root);
	//mexPrintf("--------------------------------------------------------------------------------\n") ;

	
	// changing original tree into a tree  with branch locaton only at the end of its parent node so that 
	// calculation of acoustic response can be done recursively
	createMultipleTree(root) ;

	pruneMultipleTree(root) ;  // get rid of tubes with zero area at first section
	markMultipleTree(root, &valid) ;  // determine which node should be marked to calculate transfer matrix

   	//parseTree(root);
	//return ;

	if (valid == 0)  // sth wrong with the setup of geometry, specifically side branches in 2-channel linked to lips or nose 
	{
		mxArray  *x[3];
		/* Allocate x matrix */
		x[0] =	mxCreateString("Side branch of two-channel module can not be conneted to LIPS or NOSTRIL");
		x[1] =	mxCreateString("Error");
		x[2] =	mxCreateString("modal");
		/* print out the error message */
		mexCallMATLAB(0,NULL,3, x, "errordlg");
 	    return ;
	}
	

	// For fricative sound, our implementation is using the model from Flanagan(1986)
	// 
    if (mode == FRICATIVE_MODE)
	{
		Complex K[2][2] ;
		Complex j(0,1) ;
		treenode *backNode, *frontNode ;
		Complex Zrad_lip, Zb, Zf, Zterm;
		double r_lip ;

		backNode  = root ; // backcavity
		frontNode = root->child[0] ; //frontcavity
		if(frontNode == NULL)
			r_lip = sqrt(backNode->secArea[0]/PI);  // no front cavity
		else 
			r_lip = sqrt(frontNode->secArea[frontNode->numOfSections-1]/PI);

		// 
		// calculation for fricative sound
		for(iRow=0; iRow<nFrequency; iRow++)
		{
			transFuncOut = 0 ;
			
			// back cavity to get Zb ;
			Zterm = -1.0 ; // infinity
			calcKZ(f[iRow], backNode->secArea, backNode->secLen, backNode->numOfSections, Zterm, p, K, &Zb);

			if (p->RADIATION_ON == 1)
				Zrad_lip = p->RHO*f[iRow]/p->C0*2.0*PI*f[iRow]+j*f[iRow]*p->RHO*16.0/3.0/PI/r_lip ;
			else
				Zrad_lip = 0 ;
	
			if(frontNode != NULL) // front cavity exists
				calcKZ(f[iRow], frontNode->secArea, frontNode->secLen, frontNode->numOfSections, Zrad_lip, p, K, &Zf);
			else
			{
				K[0][0] = 1;
				K[0][1] = 0;
				K[1][0] = 0;
				K[1][1] = 1;
				Zf = Zrad_lip ;
			}
			transFuncOut = 1.0/(K[1][0]*Zrad_lip+K[1][1]) /(Zb + Zf) ;
			//AR[iRow] = 20*log10( sqrt(pow(transFuncOut.Real(),2) + pow(transFuncOut.Imag(),2) ) );
			ARreal[iRow] = transFuncOut.Real() ;
			ARimg[iRow]  = transFuncOut.Imag() ;
		}
		return ;
	}  // done with the fricative

    
	for(iRow=0; iRow<nFrequency; iRow++)
	{
		Koral[0][0] = 1;
		Koral[0][1] = 0;
		Koral[1][0] = 0;
		Koral[1][1] = 1;
		
		KnoseLeft[0][0] = 1;
		KnoseLeft[0][1] = 0;
		KnoseLeft[1][0] = 0;
		KnoseLeft[1][1] = 1;
		
		KnoseRight[0][0] = 1;
		KnoseRight[0][1] = 0;
		KnoseRight[1][0] = 0;
		KnoseRight[1][1] = 1;
        
		Zlip		= -1.0 ;
		Znoseleft	= -1.0 ;
		Znoseright	= -1.0 ;

    	// pass Zlip as parameters into this function
	  	if(nrhs >6 )
			Zlip = *(mxGetPr(prhs[6])) + j*(*(mxGetPi(prhs[6]))); 

//			Zreal[iRow] = Zlip.Real() ;
//    		Zimg[iRow]  = Zlip.Imag() ;


		calcTransFunc(root, Koral, KnoseLeft, KnoseRight, &Z, &Zlip, &Znoseleft, &Znoseright, f[iRow], p);
#ifdef TRACE
		cout << "Koral = \n" << Koral;
		cout << "KnoseLeft = \n" << KnoseLeft;
		cout << "KnoseRight = \n" << KnoseRight;
#endif
		transFuncOut = 0 ;
		if (mode == ORAL_MODE)
		{
			if (Zlip != -1.0)  // no obstruction to lips
				transFuncOut = 1.0/(Koral[1][0]*Zlip+Koral[1][1]);	
		}
		else if (mode == NASAL_MODE || mode == ORALNASAL_MODE)
		{
			// in case just one nostirl open and the other one is not defined or obstructed
			// or bother are obstructed
			if (Znoseleft != -1.0 )  // left nostril open
				transFuncOut = transFuncOut + (1.0/(KnoseLeft[1][0]*Znoseleft+KnoseLeft[1][1])) ;

			if (Znoseright != -1.0 ) // right nostril  open
				transFuncOut = transFuncOut + (1.0/(KnoseRight[1][0]*Znoseright+KnoseRight[1][1]));
			
			if (Zlip != -1.0  &&  mode == ORALNASAL_MODE)
				transFuncOut     = transFuncOut + (1.0/(Koral[1][0]*Zlip+Koral[1][1]));
		}
//		AR[iRow] = 20*log10( sqrt(pow(transFuncOut.Real(),2) + pow(transFuncOut.Imag(),2) ) );
		ARreal[iRow] = transFuncOut.Real() ;
		ARimg[iRow]  = transFuncOut.Imag() ;
		////////////////////////////////////
		Zreal[iRow] = Z.Real() ;
		Zimg[iRow]  = Z.Imag() ;

	}
	
	return;
}



// reading geometry data and creating nonbinary tree  
treenode *createTree( const mxArray *prhs, int rootNum) 
{	
	treenode *Ptr[MAXNUMTUBES] ;
	treenode *root ;
	treenode *node ;
    double *ptr1 , *ptr2 ;

	int numOfStructure ;

	int i, j ;

	// initialize Ptr[] as NULL
	for (i=0; i<(MAXNUMTUBES-1); i++)
		Ptr[i] = NULL ;

    numOfStructure =  mxGetNumberOfElements(prhs);

	// reading data  
	for (i=1; i<=numOfStructure; i++)  // starting from 1 is to fit to the data from Matlab
	{
		//create a new node
		node = createNode() ;
		node->IndexOfBranch		= i ;
		node->typeOfModule		= (int) ( *mxGetPr(mxGetField(prhs, i-1, "typeOfModule")) ) ;
		node->typeOfStartofTube = (int) ( *mxGetPr(mxGetField(prhs, i-1, "typeOfStartofTube")) ) ;
		node->typeOfEndofTube   = (int) ( *mxGetPr(mxGetField(prhs, i-1, "typeOfEndofTube")) ) ;

		// channel 1
		node->numOfSections     = (int) ( *mxGetPr(mxGetField(prhs, i-1, "numOfSections")) ) ;
		if (node->numOfSections != 0)
		{
			node->secLen	=  	(double *) malloc(node->numOfSections*sizeof(double)) ;	
			node->secArea	=  	(double *) malloc(node->numOfSections*sizeof(double)) ;	
			ptr1 = 		(  mxGetPr(mxGetField(prhs, i-1, "secLen")) ) ;
			ptr2 =		(  mxGetPr(mxGetField(prhs, i-1, "secArea")) ) ;
			for(j=0; j<node->numOfSections; j++)
			{
				node->secLen[j]		=		ptr1[j] ;
				node->secArea[j]	=		ptr2[j] ;
			}
		}
					
		//channel 2
		node->numOfSections1     = (int) ( *mxGetPr(mxGetField(prhs, i-1, "numOfSections1")) ) ;
		if ((node->typeOfModule == TWOCHANNELS) && (node->numOfSections1 != 0))
		{
			node->secLen1	=  	(double *) malloc(node->numOfSections1*sizeof(double)) ;	
			node->secArea1	=  	(double *) malloc(node->numOfSections1*sizeof(double)) ;	
           	ptr1 = 		(  mxGetPr(mxGetField(prhs, i-1, "secLen1")) ) ;
			ptr2 =		(  mxGetPr(mxGetField(prhs, i-1, "secArea1")) ) ;
			for(j=0; j<node->numOfSections1; j++)
			{
				node->secLen1[j]	=		ptr1[j] ;
				node->secArea1[j]	=		ptr2[j] ;
			}
		}
		
        ptr1 =  mxGetPr(mxGetField(prhs, i-1, "nextBranches")) ;
		ptr2 =  mxGetPr(mxGetField(prhs, i-1, "nextBranchesLoc")) ; 
		for(j=0; j<(MAXNUMCHILDREN-1); j++)
		{
			node->nextBranches[j]		=		ptr1[j] ;
			node->nextBranchesLoc[j]	=		ptr2[j] ;
		}

		Ptr[i] = node ;
	}

	// root of tree 
    root = Ptr[rootNum] ;

	// create LinkList for the tree
	for (i=1; i<numOfStructure; i++)
	{

		    // sort the branches based on their locations
			//bubbleSort(double locations[], int branches[], int array_size) ;
			bubbleSort(Ptr[i]->nextBranchesLoc, Ptr[i]->nextBranches, (MAXNUMCHILDREN)) ;
			
			// linked to its children
			for (j=0; j<(MAXNUMCHILDREN-1); j++)
				if(Ptr[i]->nextBranches[j] != NONVALID)
					Ptr[i]->child[j] = Ptr[(int)(Ptr[i]->nextBranches[j])] ;
		
	}

	// return the root of tree
	return root ; 
}






void parseTree(treenode *root)
{

	int i, j=0 ;
	
	if (root != NULL)
	{
//		mexPrintf("typeOfBranch = 0x%0x\n",root->typeOfBranch);
//		mexPrintf("numOfBranches = %d\n",root->numOfBranches);
//		mexPrintf("numOfSections = %d\n",root->numOfSections);
		
		
		mexPrintf("-----\n") ;
		mexPrintf("IndexOfBranch = %d\n",root->IndexOfBranch);
		if(root->typeOfStartofTube==GLOTTIS)
			mexPrintf(" GLOTTIS \n");
		if(root->typeOfEndofTube == LIPS)
			mexPrintf(" LIPS \n");
		if(root->typeOfEndofTube == NOSTRIL1)
			mexPrintf(" NOSTRIL1 \n");
		if(root->typeOfEndofTube == NOSTRIL2)
			mexPrintf(" NOSTRIL2 \n");



	    for(i=0; i<MAXNUMCHILDREN; i++)
		{
   			if (root->child[i] != NULL) 
				mexPrintf(" branch %2d: = %d\n", j++, root->child[i]->IndexOfBranch);
		}

//		if (root->left != NULL) 
//			printf("Left branch: = %d\n",root->left->IndexOfBranch);
//		if (root->right != NULL) 
//			printf("Right branch: = %d\n",root->right->IndexOfBranch);

		
//		for(i=0; i<MAXNUMCHILDREN; i++)
//			if(root->nextBranches[i] != NONVALID) 
//				printf("Branches = %d  Location = %f \n",root->nextBranches[i], root->nextBranchesLoc[i]);

		mexPrintf("numOfSections =  %d \n", root->numOfSections);
		mexPrintf("secLen = ");
		for (i = 0; i < root->numOfSections; i++) mexPrintf("%0.4f ",root->secLen[i]);
		mexPrintf("\nsecArea = ");
		for (i = 0; i < root->numOfSections; i++) mexPrintf("%0.4f ",root->secArea[i]);
		mexPrintf("\n");

		if(root->typeOfModule == TWOCHANNELS) 
		{
			mexPrintf(" TWOCHANNELS \n");
			mexPrintf("numOfSections1 =  %d \n", root->numOfSections1);
			mexPrintf("secLen1 = ");
			for (i = 0; i < root->numOfSections1; i++) mexPrintf("%0.4f ",root->secLen1[i]);
			mexPrintf("\nsecArea1 = ");
			for (i = 0; i < root->numOfSections1; i++) mexPrintf("%0.4f ",root->secArea1[i]);
			mexPrintf("\n");
		}

	}

	// scan every child
	for(i=0; i<MAXNUMCHILDREN; i++)
		if (root->child[i] != NULL) parseTree(root->child[i]);
	if (root->left != NULL) parseTree(root->left);
	if (root->right != NULL) parseTree(root->right);

	return;

/*	int i;


	if (root != NULL)
	{
		printf("typeOfBranch = 0x%0x\n",root->typeOfBranch);
		printf("numOfBranches = %d\n",root->numOfBranches);
		printf("numOfSections = %d\n",root->numOfSections);
		printf("secLen = ");
		for (i = 0; i < root->numOfSections; i++) printf("%0.2f ",root->secLen[i]);
		printf("\nsecArea = ");
		for (i = 0; i < root->numOfSections; i++) printf("%0.2f ",root->secArea[i]);
		printf("\n\n");
	}
	if (root->left != NULL) parseTree(root->left);
	if (root->right != NULL) parseTree(root->right);
	return;
 */
}



void parseTree_old(treenode *root)
{

	int i ;
	
	if (root != NULL)
	{
//		printf("typeOfBranch = 0x%0x\n",root->typeOfBranch);
//		printf("numOfBranches = %d\n",root->numOfBranches);
//		printf("numOfSections = %d\n",root->numOfSections);
		
		
		printf("-----\n") ;
		printf("IndexOfBranch = %d\n",root->IndexOfBranch);
		if(root->typeOfStartofTube==GLOTTIS)
			printf(" GLOTTIS \n");
		if(root->typeOfEndofTube == LIPS)
			printf(" LIPS \n");
		if(root->typeOfEndofTube == NOSTRIL1)
			printf(" NOSTRIL1 \n");
		if(root->typeOfEndofTube == NOSTRIL2)
			printf(" NOSTRIL2 \n");


		if (root->left != NULL) 
			printf("Left branch: = %d\n",root->left->IndexOfBranch);
		if (root->right != NULL) 
			printf("Right branch: = %d\n",root->right->IndexOfBranch);

		
//		for(i=0; i<MAXNUMCHILDREN; i++)
//			if(root->nextBranches[i] != NONVALID) 
//				printf("Branches = %d  Location = %f \n",root->nextBranches[i], root->nextBranchesLoc[i]);

		printf("numOfSections =  %d \n", root->numOfSections);
		printf("secLen = ");
		for (i = 0; i < root->numOfSections; i++) printf("%0.4f ",root->secLen[i]);
		printf("\nsecArea = ");
		for (i = 0; i < root->numOfSections; i++) printf("%0.4f ",root->secArea[i]);
		printf("\n");

		if(root->typeOfModule == TWOCHANNELS) 
		{
			printf(" TWOCHANNELS \n");
			printf("numOfSections1 =  %d \n", root->numOfSections1);
			printf("secLen1 = ");
			for (i = 0; i < root->numOfSections1; i++) printf("%0.4f ",root->secLen1[i]);
			printf("\nsecArea1 = ");
			for (i = 0; i < root->numOfSections1; i++) printf("%0.4f ",root->secArea1[i]);
			printf("\n");
		}

	}

	// scan every child
//	for(i=0; i<MAXNUMCHILDREN; i++)
//		if (root->child[i] != NULL) parseOriginalTree(root->child[i]);
	if (root->left != NULL) parseTree(root->left);
	if (root->right != NULL) parseTree(root->right);

	return;

/*	int i;


	if (root != NULL)
	{
		printf("typeOfBranch = 0x%0x\n",root->typeOfBranch);
		printf("numOfBranches = %d\n",root->numOfBranches);
		printf("numOfSections = %d\n",root->numOfSections);
		printf("secLen = ");
		for (i = 0; i < root->numOfSections; i++) printf("%0.2f ",root->secLen[i]);
		printf("\nsecArea = ");
		for (i = 0; i < root->numOfSections; i++) printf("%0.2f ",root->secArea[i]);
		printf("\n\n");
	}
	if (root->left != NULL) parseTree(root->left);
	if (root->right != NULL) parseTree(root->right);
	return;
 */
}
void freeTree(treenode* root)
{
	if (root->left != NULL)
	{
		freeTree(root->left);
		root->left = NULL;
	}
	if (root->right != NULL)
	{
		freeTree(root->right);

     	// corrected , xinhui
		//		root->right == NULL;
	    root->right = NULL;

	}
	free(root->secLen);
	free(root->secArea);
	free(root);
	
	return;
}

/*<indexOfBranch>  3
	<typeOfStartofTube>
	<typeOfEndofTube>   
	<nextBranches> 4 5
	<nextBranchesLocation> END END
	<typeOfModule> SINGLECHANNEL
	<numOfSections> 20
	<secLen> 0.4087 0.4087 0.4087 0.4087 0.4087
	<secArea> 1.0400 2.7469 3.5218 3.8678 4.3178
*/
char *readAndParse(treenode *node, short *mode, FILE *inFilePtr, char *lineString, short *lineNumber)
{
    char *statusString, *firsttoken, *commandString, *tempString;
	int i;

    statusString = fgets(lineString, MAXLINELENGTH, inFilePtr);
    *lineNumber = *lineNumber + 1;
    if (statusString != NULL)
    {
#ifdef TRACE
        printf("Status string = %s\n", statusString);
#endif
        firsttoken = strtok(lineString, " \t\n");
        if (firsttoken == NULL || firsttoken[0] == '%')
        {
            return readAndParse(node, mode, inFilePtr, lineString, lineNumber);
        }
        else if ((firsttoken[0] == '<') && (firsttoken[strlen(firsttoken)-1] == '>'))
        {
			// Remove the < and > braces from the token and get commandString
			commandString = firsttoken+1;
			commandString[strlen(commandString)-1] = '\0';		
			if (*mode == 0)
			{
				if (strcmp(commandString,"Mode") == 0)
				{
					tempString = strtok(NULL," \t\n");
					if (strcmp(tempString,"Oral") == 0) *mode = ORAL_MODE;
					else if (strcmp(tempString,"Nasal") == 0) *mode = NASAL_MODE;
					else if (strcmp(tempString,"OralNasal") == 0) *mode = ORALNASAL_MODE;
				}
				else
				{
					printf("ERROR: <Mode> must be the first definition in the file\n");
					#ifdef MEX
						mexErrMsgTxt("Error in .dll ")  ;  // exit(1);
					#else
						exit(1) ;
					#endif
				}
			}
			else if (strcmp(commandString,"indexOfBranch") == 0)
				node->IndexOfBranch = atoi(strtok(NULL," \t\n"));

			else if (strcmp(commandString,"typeOfStartofTube") == 0)
			{
				tempString = strtok(NULL," \t\n");
				if(tempString != NULL)
					if (strcmp(tempString,"GLOTTIS") == 0) node->typeOfStartofTube = GLOTTIS;
			}

			else if (strcmp(commandString,"typeOfEndofTube") == 0)
			{
				tempString = strtok(NULL," \t\n");
				if(tempString != NULL)
				{
					if (strcmp(tempString,"LIPS") == 0) node->typeOfEndofTube = LIPS;
					else if (strcmp(tempString,"NOSTRIL1") == 0) node->typeOfEndofTube = NOSTRIL1;
					else if (strcmp(tempString,"NOSTRIL2") == 0) node->typeOfEndofTube = NOSTRIL2;
				}
			}


			else if (strcmp(commandString,"nextBranches") == 0)
			{  // reading index of branches  
				for(i=0; i<MAXNUMCHILDREN; i++)
				{
					tempString = strtok(NULL," \t\n");
					if (tempString != NULL)
						 (node->nextBranches[i])= atoi(tempString);
					else
						break ;
				}
			}

			else if (strcmp(commandString,"nextBranchesLocation") == 0)
			{  // reading location of branches 
				for(i=0; i<MAXNUMCHILDREN; i++)
				{
					tempString = strtok(NULL," \t\n");
					if (tempString != NULL)
					{
						if(strcmp(tempString,"CHANNEL1") == 0) 
						{
						 tempString = strtok(NULL," \t\n");
						 (node->nextBranchesLoc[i])= atof(tempString) + CHANNEL_1;
						}
						else if(strcmp(tempString,"CHANNEL2") == 0) 
						{
						 tempString = strtok(NULL," \t\n");
						 (node->nextBranchesLoc[i])= atof(tempString) + CHANNEL_2;
						}
						else if(strcmp(tempString,"END") != 0)  // END: default value
						 (node->nextBranchesLoc[i])= atof(tempString);
					}
					else
						break ;
				}
			}
			else if (strcmp(commandString,"typeOfModule") == 0)
			{  // reading index of branches , not done 
				tempString = strtok(NULL," \t\n");
				if(tempString != NULL)
					if (strcmp(tempString,"TWOCHANNELS") == 0) node->typeOfModule = TWOCHANNELS;
			}
			else if (strcmp(commandString,"numOfSections") == 0)
				node->numOfSections = atoi(strtok(NULL," \t\n"));
			
			else if (strcmp(commandString,"secLen") == 0)
			{
				if (node->numOfSections == 0) 
				{
					printf("ERROR: Trying to define section lengths before defining the number of sections at line %hd\n",*lineNumber-1);
					#ifdef MEX
						mexErrMsgTxt("Error in .dll ")  ;  // exit(1);
					#else
						exit(1) ;
					#endif
				}
				else
				{
					node->secLen = (double *) malloc(node->numOfSections*sizeof(double));
					i = 0;
					while (i < node->numOfSections)
					{
						tempString = strtok(NULL," \t\n");
						if (tempString == NULL)
						{
							printf("ERROR: Insufficient input at line %hd\n",*lineNumber-1);
							#ifdef MEX
							mexErrMsgTxt("Error in .dll ")  ;  // exit(1);
							#else
								exit(1) ;
							#endif
						}
						else node->secLen[i] = atof(tempString);
						i++;
					}
				}
			}
			else if (strcmp(commandString,"secArea") == 0)
			{
				if (node->numOfSections == 0)
				{
					printf("ERROR: Trying to define section areas before defining the number of sections at line %hd\n",*lineNumber-1);
					#ifdef MEX
						mexErrMsgTxt("Error in .dll ")  ;  // exit(1);
					#else
						exit(1) ;
					#endif
				}
				else
				{
					node->secArea = (double *) malloc(node->numOfSections*sizeof(double));
					i = 0;
					while( i < node->numOfSections)
					{
						tempString = strtok(NULL," \t\n");
						if (tempString == NULL)
						{
							printf("ERROR: Insufficient input at line %hd\n",*lineNumber-1);
						#ifdef MEX
							mexErrMsgTxt("Error in .dll ")  ;  // exit(1);
						#else
							exit(1) ;
						#endif
						}
						else node->secArea[i] = atof(tempString);
						i++;
					}
				}
			}
			else
			{
				printf("ERROR: Illegal Command String at line %hd\n", *lineNumber-1);
				#ifdef MEX
					mexErrMsgTxt("Error in .dll ")  ;  // exit(1);
				#else
					exit(1) ;
				#endif
			}
        }
    }
    return(statusString);
}




int calcKZ1(double f, double* A, double* l, int nLength, Complex Zterm, property *p, Complex K[2][2], Complex *Z)
{
	Complex new_K[2][2];
	Complex j(0,1);
	double omega, S, La, Ra , La1, Ra1, Ca, Ga, Lw, Rw, Cw;
	int k;
	int obstructed = 0 ;

	//xinhui added
  // in case Area in some point is zero
  for(k=0; k<nLength; k++)
    if (A[k]==0) 
	  break ;
  if(k!=nLength)  // break out due to zero at some point
	 { nLength = k ;
      Zterm = -1 ;
	  obstructed = 1 ;
	 }



 	omega = 2*PI*f;  // PI definition in Complex.h
  	//N=max(size(A));  nLength is used here
   	S = 2 * sqrt(A[0]*PI) ;
    La = p->RHO * l[0]/2/A[0]*omega ;
	Ra = 0; // l[0] * S/2/pow(A[0],2) * sqrt(omega* p->RHO * p->MU/2) ;
	////////////////////////////////////////
	K[0][0] = 1;
	K[0][1] = Ra + j*La;
	K[1][0] = 0;
	K[1][1] = 1;

	for (k = 0; k < nLength; k++)
	{
		S = 2*sqrt(A[k]*PI);
	    if ( k < (nLength-1) )
	  	{
        	La1 = p->RHO*l[k+1]/2/A[k+1]*omega ;
         	// Ra1 = l[k+1]*S/2/pow(A[k+1],2)*sqrt(omega* p->RHO * p->MU/2) ;  //bug
			Ra1 = 0; //l[k+1]* 2*sqrt(A[k+1]*PI) /2/pow(A[k+1],2)*sqrt(omega* p->RHO * p->MU/2) ;  // corrected
			////////////////////////////////////////
	    }
	  	Ca = l[k]*A[k]/p->RHO/pow(p->C0,2)*omega ;
    	Ga = 0; //S * (p->ETA-1)/ p->RHO/pow(p->C0,2) * sqrt(p->LAMDA*omega/2/p->CP/p->RHO)*l[k] ;
		///////////////////////////////////////
		Lw = p->WALL_L/l[k]/S*omega ;
    	Rw = 99999999999999999999.0; //NAN; //0; //p->WALL_R/l[k]/S ;
  		//////////////////////////////////////
		Cw = l[k]*S/p->WALL_K*omega ;
  		if ( k < (nLength-1) )
		{
      		new_K[0][0] = 1;
      		new_K[0][1] = Ra + Ra1 + j*(La+La1);
      		new_K[1][0] = j*Ca + Ga + 1.0/(Rw+j*(Lw-1.0/Cw));
      		new_K[1][1] = 1.0 + ( j*Ca + Ga + 1.0/(Rw+j*(Lw-1.0/Cw)) ) * (Ra+Ra1+j*(La+La1));
  		}
  		else
  		{
      		new_K[0][0] =1;
      		new_K[0][1] = Ra + j*La;
      		new_K[1][0] = j*Ca + Ga + 1.0/(Rw+j*(Lw-1.0/Cw));
      		new_K[1][1] = 1.0 + (j*Ca + Ga + 1.0/(Rw+j*(Lw-1.0/Cw))) * (Ra+j*La);
  		}

		// K = K*new_K;
		multiply(K, K, new_K) ;

		La = La1;   // not problem with c code if nLength == 1, but it will cause some prob.s in Matlab,
		            // since there is no variable definition ahead in matlab code
		Ra = Ra1;
	}
 	
	if (Zterm == -1.0)
    	*Z = K[0][0]/K[1][0];
 	else
    	// *Z = (K[0][0]*Zterm + K[0][1]) / (K[1][0]*Zterm+K[1][1]) ;	
		/////////////////// modified -/////////////////
		*Z = (K[0][0]*Zterm.Imag() + K[0][1]) / (K[1][0]*Zterm.Imag()+K[1][1]) ;	

#ifdef TRACE
		cout << "K = \n" << K;
#endif
	return obstructed;
}




int calcKZ(double f, double* A, double* l, int nLength, Complex Zterm, property *p, Complex K[2][2], Complex *Z)
{
	Complex new_K[2][2];
	Complex j(0,1);
	double omega, S, La, Ra , La1, Ra1, Ca, Ga, Lw, Rw, Cw;
	int k;
	int obstructed = 0 ;

	//xinhui added
  // in case Area in some point is zero
  for(k=0; k<nLength; k++)
    if (A[k]==0) 
	  break ;
  if(k!=nLength)  // break out due to zero at some point
	 { nLength = k ;
      Zterm = -1 ;
	  obstructed = 1 ;
	 }



 	omega = 2*PI*f;  // PI definition in Complex.h
  	//N=max(size(A));  nLength is used here
   	S = 2 * sqrt(A[0]*PI) ;
    La = p->RHO * l[0]/2/A[0]*omega ;
	Ra = 0; // l[0] * S/2/pow(A[0],2) * sqrt(omega* p->RHO * p->MU/2) ;
	////////////////////////////////////////
	K[0][0] = 1;
	K[0][1] = Ra + j*La;
	K[1][0] = 0;
	K[1][1] = 1;

	for (k = 0; k < nLength; k++)
	{
		S = 2*sqrt(A[k]*PI);
	    if ( k < (nLength-1) )
	  	{
        	La1 = p->RHO*l[k+1]/2/A[k+1]*omega ;
         	// Ra1 = l[k+1]*S/2/pow(A[k+1],2)*sqrt(omega* p->RHO * p->MU/2) ;  //bug
			Ra1 = 0; //l[k+1]* 2*sqrt(A[k+1]*PI) /2/pow(A[k+1],2)*sqrt(omega* p->RHO * p->MU/2) ;  // corrected
			////////////////////////////////////////
	    }
	  	Ca = l[k]*A[k]/p->RHO/pow(p->C0,2)*omega ;
    	Ga = 0; //S * (p->ETA-1)/ p->RHO/pow(p->C0,2) * sqrt(p->LAMDA*omega/2/p->CP/p->RHO)*l[k] ;
		///////////////////////////////////////
		Lw = p->WALL_L/l[k]/S*omega ;
    	Rw = 99999999999999999999.0; //NAN; //0; //p->WALL_R/l[k]/S ;
  		//////////////////////////////////////
		Cw = l[k]*S/p->WALL_K*omega ;
  		if ( k < (nLength-1) )
		{
      		new_K[0][0] = 1;
      		new_K[0][1] = Ra + Ra1 + j*(La+La1);
      		new_K[1][0] = j*Ca + Ga ; //+ 1.0/(Rw+j*(Lw-1.0/Cw));
      		new_K[1][1] = 1.0 + (j*Ca+Ga) * (Ra+Ra1+j*(La+La1));
			// new_K[1][1] = 1.0 + ( j*Ca + Ga + 1.0/(Rw+j*(Lw-1.0/Cw)) ) * (Ra+Ra1+j*(La+La1));
  		}
  		else
  		{
      		new_K[0][0] =1;
      		new_K[0][1] = Ra + j*La;
      		new_K[1][0] = j*Ca + Ga ; //+ 1.0/(Rw+j*(Lw-1.0/Cw));
      		//new_K[1][1] = 1.0 + (j*Ca + Ga + 1.0/(Rw+j*(Lw-1.0/Cw))) * (Ra+j*La);
			new_K[1][1] = 1.0 + (j*Ca + Ga) * (Ra+j*La);
  		}

		// K = K*new_K;
		multiply(K, K, new_K) ;

		La = La1;   // not problem with c code if nLength == 1, but it will cause some prob.s in Matlab,
		            // since there is no variable definition ahead in matlab code
		Ra = Ra1;
	}
 	
	if (Zterm == -1.0)
    	*Z = K[0][0]/K[1][0];
 	else
    	// *Z = (K[0][0]*Zterm + K[0][1]) / (K[1][0]*Zterm+K[1][1]) ;	
		/////////////////// modified -/////////////////
		*Z = (K[0][0]*j*Zterm.Imag() + K[0][1]) / (K[1][0]*j*Zterm.Imag()+K[1][1]) ;	

#ifdef TRACE
		cout << "K = \n" << K;
#endif
	return obstructed;
}



// K1 = oral main tract
// K2 = nasal tract nostril 1/left nostril
// K3 = nasal tract nostril 2/right nostril

void calcTransFunc(treenode *node, Complex K1[2][2], Complex K2[2][2], Complex K3[2][2], Complex *Z, Complex *Zlip, Complex *Znoseleft, Complex *Znoseright, double f, property *p)
{
	Complex KBranchLeft[2][2], KBranchRight[2][2], KCurrent[2][2] ; //, tempMat[2][2];
	Complex KCurrent1[2][2], KCurrent2[2][2]; // xinhui added

	Complex Zterm(-1,0), j(0,1);
	double rad;
	int index, i;

    int sideBrach = 0 ;
	//Complex Ztemp[MAXNUMCHILDREN] ;
	Complex Ztemp[MAXNUMCHILDREN] ;
	Complex Ztermtemp;

//	double rad1, rad2 ;
	Complex Zterm1(-1,0), Zterm2(-1,0);
    
	int obstructed = 0 ;

//	printf("In calcTransFunc\n");

	// calculate for the side branches
    for(i=0; i<MAXNUMCHILDREN; i++)
	{
		// calculate each braches's Z
		if(node->child[i] != NULL)
		{
			calcTransFunc(node->child[i], K1, K2, K3, Z, Zlip, Znoseleft, Znoseright, f, p);
			Ztemp[i] = (*Z) ;
			sideBrach = 1 ;
		}
	}

    // calculate the resistance and also transfer matrix update, if side 
	// branches exist
	if (sideBrach == 1)  // side branches exist
	{   //total resistance
		Ztermtemp = 0 ;
	    for(i=0; i<MAXNUMCHILDREN; i++)
		{
			if(node->child[i] != NULL)
				Ztermtemp = Ztermtemp + 1.0/Ztemp[i] ;
		}
		Zterm = 1.0/Ztermtemp ;

		// update transfer matrix
		KBranchRight[0][0] = 1;
		KBranchRight[0][1] = 0;
		KBranchRight[1][0] = 0 ; //1.0/(*Z);
		KBranchRight[1][1] = 1;
	    for(i=0; i<MAXNUMCHILDREN; i++)
			if(node->child[i] != NULL)
			{
				KBranchRight[1][0] = Ztermtemp - 1.0/Ztemp[i];
				if((node->child[i]->K[0]) == 1)
				{ //node->K[0] = 1 ; 
				 // K1 = KBranchRight*K1;
				    multiply(K1, KBranchRight, K1) ;
				}

				if((node->child[i]->K[1]) == 1)
				{ //node->K[1] = 1 ;
					// K2 = KBranchRight*K2; 
				    multiply(K2, KBranchRight, K2) ;
				}
				
				if((node->child[i]->K[2]) == 1)
				{ //node->K[2] = 1 ;
					// K3 = KBranchRight*K3; 
				    multiply(K3, KBranchRight, K3) ;
				}

			}
	}



	// for those tubes that are side braches without children, Zterm = -1 ;
	// Zterm is not -1 when the tube is connected to nose or lips, or has children
	if ((node->typeOfEndofTube == OTB) || (node->typeOfEndofTube == NLTB) || (node->typeOfEndofTube == NRTB))
	{
/*		index = node->numOfSections;
		for (i = 0; i < node->numOfSections; i++)
		{
			if (node->secArea[i] == 0.0) {index = i; break;}
		}
		if (index < node->numOfSections)
		{
			// this is bug in original version, since after first freq. is calculated
			// the following freq.s will have different circumstance.
			//node->numOfSections = index;
			Zterm = -1;
			// cout<<"numOfSections = "<< node->numOfSections << "\n";
			// cout << "Zterm = " << Zterm <<"\n";
		}
		else 
		{
			rad = sqrt(node->secArea[node->numOfSections-1]/PI);
			Zterm = p->RHO*f/p->C0*2.0*PI*f+j*f*p->RHO*16.0/3.0/PI/rad;
		}
*/
			if (p->RADIATION_ON == 1)
			{

			   //  what if 2 channels module 
				 if(node->typeOfModule != TWOCHANNELS)  // JUST SINGLE
				 {
					rad = sqrt(node->secArea[node->numOfSections-1]/PI);
					// Zterm = p->RHO*f/p->C0*2.0*PI*f+j*f*p->RHO*16.0/3.0/PI/rad;
					Zterm =  j*f*p->RHO*16.0/3.0/PI/rad;
     ///////////////////////////////////////////////////////////////

					////////////////////
				//	if(*Zlip != -1)
				//		Zterm = *Zlip  ; //  in case there is user specified load at lips even there is no radiation.
				 }
				 else
				 { 
					 // for the case of 2-channel module at LIPS , NOSTRILs
					rad = sqrt(node->secArea[node->numOfSections-1]/PI);
//					Zterm1 = p->RHO*f/p->C0*2.0*PI*f+j*f*p->RHO*16.0/3.0/PI/rad;
					Zterm1 =   j*f*p->RHO*16.0/3.0/PI/rad;

					rad = sqrt(node->secArea1[node->numOfSections1-1]/PI);
//					Zterm2 = p->RHO*f/p->C0*2.0*PI*f+j*f*p->RHO*16.0/3.0/PI/rad;
					Zterm2 =  j*f*p->RHO*16.0/3.0/PI/rad;

					Zterm = Zterm1*Zterm2/(Zterm1+Zterm2) ;
				 }
			}
			else
				 Zterm = 0  ;
				////////////////////
			if(*Zlip != -1) // for both cases, 
						Zterm = *Zlip  ; //  in case there is user specified load at lips even there is no radiation.


		if (node->typeOfEndofTube == OTB) *Zlip = Zterm;
		else if (node->typeOfEndofTube == NLTB) *Znoseleft = Zterm;
		else if (node->typeOfEndofTube == NRTB) *Znoseright = Zterm;
	}

	// not useful any more, since markMultipletree () did this, xinhui
	if (node->typeOfEndofTube == OTB) 
		node->K[0] = 1 ; // oral
	else if (node->typeOfEndofTube == NLTB) 
		node->K[1] = 1 ; // left nose
	else if (node->typeOfEndofTube == NRTB)
		node->K[2] = 1 ;// right nose

	
	
	//	printf("Calculating for calcTransFunc\n");
    if(node->typeOfModule != TWOCHANNELS)  // JUST SINGLE
		obstructed = calcKZ(f, node->secArea, node->secLen, node->numOfSections, Zterm, p, KCurrent, Z);
    else
	{
		Complex Zlip1 ;
		Zlip1 = -1.0 ;


		if(node->left == NULL )
			calcKZ(f, node->secArea, node->secLen, node->numOfSections, Zterm, p, KCurrent1, Z);
		else
		{
			KCurrent1[0][0] = 1;
			KCurrent1[0][1] = 0;
			KCurrent1[1][0] = 0 ;
			KCurrent1[1][1] = 1;
			//in this case , Only lips is assumed and Zlip1 and Kcurrent for lips will be calculated
			calcTransFunc(node->left, KCurrent1,  KCurrent1,  KCurrent1, Z, &Zlip1, Znoseleft, Znoseright, f, p); //?????
		}

		if(node->right == NULL )
			calcKZ(f, node->secArea1, node->secLen1, node->numOfSections1, Zterm, p, KCurrent2, Z);
		else
		{
			KCurrent2[0][0] = 1;
			KCurrent2[0][1] = 0;
			KCurrent2[1][0] = 0 ; 
			KCurrent2[1][1] = 1;
			calcTransFunc(node->right, KCurrent2,  KCurrent2,  KCurrent2, Z, &Zlip1, Znoseleft, Znoseright, f, p); //?????
		}
	    
		// if node->right or ->left connect to lips or nostril1 or 2, there will be an error mesage showing up before calculation and then return to 
		// main program without calculation


		KCurrent[0][0] = (KCurrent1[0][0]*KCurrent2[0][1]+KCurrent1[0][1]*KCurrent2[0][0])/(KCurrent1[0][1]+KCurrent2[0][1]);
	    KCurrent[0][1] = KCurrent1[0][1]*KCurrent2[0][1]/(KCurrent1[0][1]+KCurrent2[0][1]);
	    KCurrent[1][0] = KCurrent1[1][0]+KCurrent2[1][0]-(KCurrent1[1][1]-KCurrent2[1][1])*(KCurrent1[0][0]-KCurrent2[0][0])/(KCurrent1[0][1]+KCurrent2[0][1]);
	    KCurrent[1][1] = (KCurrent1[1][1]*KCurrent2[0][1]+KCurrent1[0][1]*KCurrent2[1][1])/(KCurrent1[0][1]+KCurrent2[0][1]);
		if (Zterm == -1.0)
			*Z = KCurrent[0][0]/KCurrent[1][0];
 		else
			*Z = (KCurrent[0][0]*Zterm + KCurrent[0][1]) / (KCurrent[1][0]*Zterm+KCurrent[1][1]) ;			
		/*
		  Complex Ks1[2][2], Ks2[2][2] ;
  Complex Z ;
  singlechannel(f,A1,l1,Zterm, p, Ks1, &Z ) ;
  singlechannel(f,A2,l2,Zterm, p, Ks2, &Z ) ;

  K[0][0] = (Ks1[0][0]*Ks2[0][1]+Ks1[0][1]*Ks2[0][0])/(Ks1[0][1]+Ks2[0][1]);
  K[0][1] = Ks1[0][1]*Ks2[0][1]/(Ks1[0][1]+Ks2[0][1]);
  K[1][0] = Ks1[1][0]+Ks2[1][0]-(Ks1[1][1]-Ks2[1][1])*(Ks1[0][0]-Ks2[0][0])/(Ks1[0][1]+Ks2[0][1]);
  K[1][1] = (Ks1[1][1]*Ks2[0][1]+Ks1[0][1]*Ks2[1][1])/(Ks1[0][1]+Ks2[0][1]);
		*/

	}
	//xinhui
		if (node->K[0] == 1)
			multiply(K1, KCurrent, K1) ;
			//K1 = KCurrent*K1;
		if (node->K[1] == 1)
			multiply(K2, KCurrent, K2) ;
			//K2 = KCurrent*K2;
		if (node->K[2] == 1)
			multiply(K3, KCurrent, K3) ;
			//K3 = KCurrent*K3;

		// if tube is obstructed, so no output to all outports such as lips and nostrils
		if(obstructed == 1) 
		{
			if (node->K[0] == 1)
				*Zlip = -1 ;
			if (node->K[1] == 1)
				*Znoseleft = -1 ;
			if (node->K[2] == 1)
				*Znoseright = -1 ;
		}
/*
	if ((node->typeOfBranch == OTB) || (node->typeOfBranch == OCB))
		K1 = KCurrent*K1;
	else if ((node->typeOfBranch == NLCB) || (node->typeOfBranch == NLTB))
		K2 = KCurrent*K2;
	else if ((node->typeOfBranch == NRCB) || (node->typeOfBranch == NRTB))
		K3 = KCurrent*K3;
	else if (node->typeOfBranch == NCCB)
	{
		K2 = KCurrent*K2;
		K3 = KCurrent*K3;
	}
	else if (node->typeOfBranch == PCB)
	{
		K1 = KCurrent*K1;
		K2 = KCurrent*K2;
		K3 = KCurrent*K3;
	}
//	printf("Leaving calcTransFunc\n");		
*/

	return;
}




// create a new node with initial value
treenode *createNode(void)
{
	treenode *node ;
	int i ;

	node = (treenode *) malloc(sizeof(treenode));
	
	node->left = NULL ;
	node->right = NULL ;
	node->IndexOfBranch = NONVALID ;
	node->typeOfModule  = SINGLECHANNEL ;
	node->K[0] = 0 ;
	node->K[1] = 0 ;
	node->K[2] = 0 ;
	for (i=0; i<MAXNUMCHILDREN; i++)
	{
		node->nextBranches[i] = NONVALID ;
		node->nextBranchesLoc[i] = END ;
		node->child[i] = NULL ;
	}

	return node ;
}

//print out the information read from file
void parseOriginalTree(treenode *root)
{
	int i ;
	
	if (root != NULL)
	{
//		printf("typeOfBranch = 0x%0x\n",root->typeOfBranch);
//		printf("numOfBranches = %d\n",root->numOfBranches);
//		printf("numOfSections = %d\n",root->numOfSections);
		
		
		mexPrintf("--------------------------------------------\n") ;
		mexPrintf("IndexOfBranch = %d\n",root->IndexOfBranch);
		
		for(i=0; i<(MAXNUMCHILDREN); i++)  // last one is left to tree operation on purpose
			if(root->nextBranches[i] != NONVALID) 
				mexPrintf("Branches = %0.4f  Location = %0.4f \n",root->nextBranches[i], root->nextBranchesLoc[i]);

		mexPrintf("numOfSections =  %d \n", root->numOfSections);
		mexPrintf("secLen = ");
		for (i = 0; i < root->numOfSections; i++) mexPrintf("%0.4f ",root->secLen[i]);
		mexPrintf("\nsecArea = ");
		for (i = 0; i < root->numOfSections; i++) mexPrintf("%0.4f ",root->secArea[i]);
		mexPrintf("\n");

		if(root->typeOfModule == TWOCHANNELS) 
		{
			mexPrintf(" TWOCHANNELS \n");
			mexPrintf("numOfSections1 =  %d \n", root->numOfSections1);
			mexPrintf("secLen1 = ");
			for (i = 0; i < root->numOfSections1; i++) mexPrintf("%0.4f ",root->secLen1[i]);
			mexPrintf("\nsecArea1 = ");
			for (i = 0; i < root->numOfSections1; i++) mexPrintf("%0.4f ",root->secArea1[i]);
			mexPrintf("\n");
		}

	}

	// scan every child
	for(i=0; i<MAXNUMCHILDREN; i++)
		if (root->child[i] != NULL) parseOriginalTree(root->child[i]);

	return;
}


// tranform the original tree read from file to a tree
// so that the children tube will be located at end of branch
void createMultipleTree(treenode *root) 
{
	treenode *node ;
	treenode *node1, *node2 ;
	int p[MAXNUMCHILDREN] ;
	int i, j ;

	if(root == NULL) return ;

	for(i=0; i<MAXNUMCHILDREN; i++)
		p[i] = -1 ;  
	
	j = 0 ;
	// look for the  children
    for(i=0; i<MAXNUMCHILDREN; i++)
	{
		if(root->child[i] != NULL) // find one child
		{	p[j] = i ; j++ ; } 
	}
	
	// no child
	if(p[0]==-1) return ;

	// no child in the middle, all branches are at END
    if ( (root->nextBranchesLoc[p[0]]) == END) 
	{
		//nothing needed to do in this multiple_children tree
	}
	else // the first child in the middle 
	{
		if ((root->typeOfModule) != TWOCHANNELS)
		{
			// divide this node into 2 nodes
			// this only happen in the case of one branch in the middle of the channel
			// find first child who is in the middle of tube

			// Left - > this first child
			//root->left = root->child[p[0]] ;
			//root->child[p[0]] = NULL ; // for new node to do recursive operation

			//create a new node
			node = createNode() ;
			// Right -> new node 
			//root->right = node ;

			// copy data to new node
			copyNode(root, node) ;
		
			// update root 's information on area function
			// update new node's information on area function and child's location 
       
			// root->nextBranchesLoc[p[0]]  ----- branching location
			updateAreaFunction(root, node, root->nextBranchesLoc[p[0]]) ;

			// update location information in the new node
			for(i=0; i<MAXNUMCHILDREN; i++)
			{// root->nextBranchesLoc[p[0]]  ----- branching location
				if(node->nextBranchesLoc[i] != END)
					node->nextBranchesLoc[i] = node->nextBranchesLoc[i] - root->nextBranchesLoc[p[0]] ;  
			}
		
			// update children information in the new node and root
			node->child[p[0]] = NULL ;
			for(i=1; i<MAXNUMCHILDREN; i++)
			{   // root->nextBranchesLoc[p[0]]  ----- branching location
				// change children information since a node is created
				if(p[i] != -1)
				{
					if (fabs(root->nextBranchesLoc[p[0]] - root->nextBranchesLoc[p[i]]) <= EPS)
						node->child[p[i]] = NULL ;
					else
						root->child[p[i]] = NULL ;
				}
				// change location information
				if(node->nextBranchesLoc[i] != END)
					node->nextBranchesLoc[i] = node->nextBranchesLoc[i] - root->nextBranchesLoc[p[0]] ;  
			}
		
			// assuming the last element is for new node case.
			root->child[MAXNUMCHILDREN-1] = node ;

			// if the node to be cut off is GLOTTIS, LIPS, NOSTRIL1, NOSTRIL2
			// typeOfEndofTube will not be passed to new node, so it is considered here
			if(root->typeOfEndofTube == LIPS || root->typeOfEndofTube == NOSTRIL1 || root->typeOfEndofTube == NOSTRIL2)
				root->typeOfEndofTube = INTERMEDIATE; 
		}
		else  // two channels case
		{
		    for(i=0; i<MAXNUMCHILDREN; i++)
			{
				if (p[i]==-1) break ;
				if (root->nextBranchesLoc[p[i]] < CHANNEL_2 )  // SIDE BRANCH BELONGS TO CHANNLE1
				{
					//create a new node
					if(root->left==NULL) 
					{ node1 = createNode() ; 
              		  root->left = node1 ;
					  // copy data to new node
 					  copyNode(root, node1) ;
					  node1->numOfSections = root->numOfSections ;
					  node1->secLen = root->secLen ;
					  node1->secArea = root->secArea ;
					  node1->typeOfStartofTube = GLOTTIS ;
					  node1->typeOfEndofTube   = LIPS ;
					}
					node1->child[p[i]] = root->child[p[i]] ;
					node1->nextBranches[p[i]] = root->nextBranches[p[i]] ;
					node1->nextBranchesLoc[p[i]] = root->nextBranchesLoc[p[i]] - CHANNEL_1 ;
                    root->child[p[i]] = NULL ;
					// copy channel 1 data 
				}
				else if  (root->nextBranchesLoc[p[i]] < END )  // channel 2
				{
					//create a new node
					if(root->right==NULL)
					{ node2 = createNode() ; 
					  root->right = node2 ; 
					  // copy data to new node
 					  copyNode(root, node2) ;
					  node2->numOfSections = root->numOfSections1 ;
					  node2->secLen = root->secLen1 ;
					  node2->secArea = root->secArea1 ;
					  node2->typeOfStartofTube = GLOTTIS ;
					  node2->typeOfEndofTube   = LIPS ;
					}
					node2->child[p[i]] = root->child[p[i]] ;
					node2->nextBranches[p[i]] = root->nextBranches[p[i]] ;
					node2->nextBranchesLoc[p[i]] = root->nextBranchesLoc[p[i]] - CHANNEL_2 ;

					if(root->left!=NULL)
						root->left->child[p[i]] = NULL ;
                    
					root->child[p[i]] = NULL ;
				}
				else  // end ;
				{
					if(root->right!=NULL)
						root->right->child[p[i]] = NULL ;
					if(root->left!=NULL)
						root->left->child[p[i]] = NULL ;
				}
			}

		}
	} // done with the breaking down
    

    // recursive
	createMultipleTree(root->left) ;
	createMultipleTree(root->right) ;

    for(i=0; i<MAXNUMCHILDREN; i++)
	    createMultipleTree(root->child[i]) ;


	return ;
}

// get rid of tree node with area[0] == 0, to make the calculation K and Z easily
// making sure that each branch can get legitimate K and Z, Z will be not infinity at any case
// the first node is the tube from glottis  , which is already guranteed that the first area is not zero by matlab
//
void pruneMultipleTree(treenode *root) 
{
	int i ;
	// get rid of some children
    for(i=0; i<MAXNUMCHILDREN; i++)
	{
			if(root->child[i] != NULL)
			{
				if( (root->child[i])->secArea[0] <= 0)
					root->child[i] = NULL ;
			}
	}

	// recursive
    for(i=0; i<MAXNUMCHILDREN; i++)
	{
			if(root->child[i] != NULL)
				pruneMultipleTree(root->child[i]) ;
	}
}


void markMultipleTree(treenode *root, int *valid)   // determine which node should be marked to calculate transfer matrix
{
	int i ;


	if(root == NULL) return ;

		// just for convenience....
//	root->typeOfBranch = root->typeOfEndofTube ;

    // recursive, in case of 2-channels module
	markMultipleTree(root->left, valid) ;
	markMultipleTree(root->right, valid) ;

    for(i=0; i<MAXNUMCHILDREN; i++)
	    markMultipleTree(root->child[i], valid) ;

    for(i=0; i<MAXNUMCHILDREN; i++)
	{
			if(root->child[i] != NULL)
			{
				// only one calcualtion needed for each K , if the gemoery is defined correctly.
				if((root->child[i]->K[0]) == 1)
				 root->K[0] = root->K[0]+1 ; 

				if((root->child[i]->K[1]) == 1)
				 root->K[1] = root->K[1]+1 ; 				
				
				if((root->child[i]->K[2]) == 1)
				 root->K[2] = root->K[2]+1 ;
			}
	}

	// only check side braches of two channels case , since other cases alrady taken care of by Matlab
    if(root->typeOfModule == TWOCHANNELS)  // JUST SINGLE
	{
		if(root->left != NULL )
		{	if( (root->left->K[0])>=2  || (root->left->K[1])>=1 || (root->left->K[2])>=1  )
				 (*valid) = 0 ;
		}
		if(root->right != NULL )
		{	if((root->right->K[0])>=2  || (root->right->K[1])>=1 || (root->right->K[2])>=1 )
				 (*valid) = 0 ;
		}
	}

		// xinhui
	// tube itself
	if (root->typeOfEndofTube == OTB) 
			root->K[0] = 1 ; // oral
	else if (root->typeOfEndofTube == NLTB) 
			root->K[1] = 1 ; // left nose
	else if (root->typeOfEndofTube == NRTB)
			root->K[2] = 1 ;// right nose
	
	return ;
}

// tranform the original tree read from file to a binary tree
void createBinaryTree(treenode *root) 
{
	treenode *node ;
	int p[2] ;
	int i, j ;

	if(root == NULL) return ;

	p[0] = -1 ;  
	p[1] = -1 ;
	j = 0 ;

	// look for the first 2 children
    for(i=0; i<MAXNUMCHILDREN; i++)
	{
		if(root->child[i] != NULL) // find one child
		{	p[j] = i ; j++ ; } 
		if(j==2) break ;
	}
	
	// no child
	if(p[0]==-1) return ;

	// no child in the middle, at most 2 branches at END
    if ( (root->nextBranchesLoc[p[0]]) == END) 
	{
		root->left = root->child[p[0]] ;
		if(p[1]!=-1) // one more child
			root->right = root->child[p[1]] ;
	}
	else // the first child in the middle 
	{
		// divide this node into 2 nodes
		// this only happen in the case of singlechannel
		// find first child who is in the middle of tube

		// Left - > this first child
		root->left = root->child[p[0]] ;
		root->child[p[0]] = NULL ; // for new node to do recursive operation

		//create a new node
		node = createNode() ;
		// Right -> new node 
		root->right = node ;

		// copy data to new node
        copyNode(root, node) ;
		
		// update root 's information on area function
		// update new node's information on area function and child's location 
       
		// root->nextBranchesLoc[p[0]]  ----- branching location
        updateAreaFunction(root, node, root->nextBranchesLoc[p[0]]) ;

		// update location information in the new node
	    for(i=0; i<MAXNUMCHILDREN; i++)
		{// root->nextBranchesLoc[p[0]]  ----- branching location
			if(node->nextBranchesLoc[i] != END)
				node->nextBranchesLoc[i] = node->nextBranchesLoc[i] - root->nextBranchesLoc[p[0]] ;  
		}

		// if the node to be cut off is GLOTTIS, LIPS, NOSTRIL1, NOSTRIL2
		// typeOfEndofTube will not be passed to new node, so it is considered here
		if(root->typeOfEndofTube == LIPS || root->typeOfEndofTube == NOSTRIL1 || root->typeOfEndofTube == NOSTRIL2)
			root->typeOfEndofTube = INTERMEDIATE; 
	} // done with the breaking down
    

	    // recursive
    createBinaryTree(root->left) ;
	createBinaryTree(root->right) ;


	return ;
}

//void bubbleSort(double locations[], int branches[], int array_size)
void bubbleSort(double locations[], double branches[], int array_size)
{
  int i, j ;
  double temp2;
  double temp1 ;

  for (i = (array_size - 1); i >= 0; i--)
  {
    for (j = 1; j <= i; j++)
    {
      if (locations[j-1] > locations[j])
      {
        temp1 = locations[j-1];
        locations[j-1] = locations[j];
        locations[j] = temp1;

        temp2 = branches[j-1];
        branches[j-1] = branches[j];
        branches[j] = temp2;

      }
    }
  }
}


// update root 's information on area function
// update new node's information on area function and child's location 
void updateAreaFunction(treenode *root, treenode *node, double location) 
{
   double *backDL, *backArea, *frontDL, *frontArea  ;
   int i ;
   int ind ;
   double temp ;	

   // look for the array index to break the tube into 2...
   // now assume location is in the middle , no error processing
   temp = 0 ;
   for (i=0; i<root->numOfSections; i++)
   {
		temp = temp + root->secLen[i] ;
		if(fabs(temp-location) <= EPS || (temp>location)) // can not just use temp>=location due to double property
		{ ind = i ; break ;}
   }
   
    //if(temp == location)
	if	(fabs(temp-location) <= EPS)
   {
	    backDL   = copyData(root->secLen,   0, ind) ;
		backArea = copyData(root->secArea,  0, ind) ;
		frontDL =  copyData(root->secLen,   ind+1, root->numOfSections-1) ;
		frontArea = copyData(root->secArea, ind+1, root->numOfSections-1) ; 
		// location will not be at the end of last section of tube, 
		// it is prevented by matlab program? ? 
   }
   else
   {
	    backDL   = copyData(root->secLen,   0, ind) ;
		backArea = copyData(root->secArea,  0, ind) ;
		frontDL =  copyData(root->secLen,   ind, root->numOfSections-1) ;
		frontArea = copyData(root->secArea, ind, root->numOfSections-1) ;

		backDL[ind]  = (root->secLen[ind])-(temp-location) ;
		frontDL[0] = temp - location ;
   }


	node->secLen = frontDL ; 
	node->secArea = frontArea ;
//    if(temp == location)
	if	(fabs(temp-location) <= EPS)
		node->numOfSections = (root->numOfSections)-(ind+1) ;
	else
		node->numOfSections = (root->numOfSections)- ind ;

	root->secLen = backDL ;
	root->secArea = backArea ;
	root->numOfSections = ind+1 ;
}
/*
if( sum(tempDL(1:i))== Location ) 
    backDL = tempDL(1:i) ;
    backArea = tempArea(1:i) ;
    frontDL = tempDL(i+1:end) ;
    frontArea = tempArea(i+1:end) ;
else
    backDL = tempDL(1:i) ;
    backArea = tempArea(1:i) ;
    if i==1
        backDL(i) = Location ;
    else
        backDL(i) = Location - sum(tempDL(1:i-1))   ;
    end
    
    frontDL = tempDL(i:end) ;
    frontArea = tempArea(i:end) ;
    if i==1
        frontDL(1) = tempDL(1) -  Location ;
    else
        frontDL(1) = sum(tempDL(1:i)) - Location     ;
    end
end
*/


double *copyData(double *data,  int startPos, int endPos) 
{
	int i ;
	double *newData; 
	
	int lengthData = endPos-startPos+1 ;
	newData = (double *) malloc(lengthData*sizeof(double));

	for (i=0; i<lengthData; i++ )
		newData[i] = data[i+startPos] ;

	return newData ;
}

void copyNode(treenode *root, treenode *node) 
{
	int i ;

	node->IndexOfBranch = root->IndexOfBranch ;
	node->typeOfEndofTube = root->typeOfEndofTube ; 
	for (i=0; i<MAXNUMCHILDREN; i++)
	{
		node->nextBranches[i] = root->nextBranches[i] ;
		node->nextBranchesLoc[i] = root->nextBranchesLoc[i] ;
		node->child[i] = root->child[i] ;
	}
}


void multiply(Complex K[2][2], Complex K1[2][2], Complex K2[2][2]) 
{
	Complex  temp[2][2] ; // just in case K = K1 or K2 ...., avoid overlapping problem
	int i, j, k ;

	//temp = K1*K2 ;
	for (i=0; i<=1; i++)
		for (j=0; j<=1; j++)
		{
			temp[i][j] = 0 ;
			for (k=0; k<=1; k++)
				temp[i][j] = temp[i][j] + K1[i][k]*K2[k][j] ;
		}

	//temp = K ;
	for (i=0; i<=1; i++)
		for (j=0; j<=1; j++)
			K[i][j] = temp[i][j] ;

	return ;
}


