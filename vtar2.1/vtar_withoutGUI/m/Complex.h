/******************************************
*
*  The original complex.zip from some website is downloaded.
*  But some operators missing in original Complex.h are added 
*  in this file . 
*
*   xinhui  01/06/2004
*
*******************************************/



/* Complex.h */


/*
 initial programmer:
 * Av: Elias Johansson
   http://www.paron.nu/?lang=english
 
 missing the * and / operators!
 
 programmer #2:
 Robert M. Delaney
 Emeritus Professor of Physics
 Saint Louis University
 10/8/2003
 
*/

// #define NAN 123454321  //xinhui added

// NAN should be INF , but we just used it without being consistent



#define NAN (mxGetInf())  //xinhui added



#define PI  3.1415926535897932  //xinhui added


#ifndef _COMPLEX_H_
#define _COMPLEX_H_


 

// xinhui added


#include <math.h>
#include <stdio.h>
#include <alloc.h>
#include <string>
#include <utility>
//using namespace std::rel_ops;


class Complex {
public:
	// Constructor
	Complex();
	Complex(const Complex& c);
	Complex(double a, double b) : real(a), imag(b) {}
	void SetTo(double a, double b);
	
	//standard funktioner...
	double Real() {return real;} //returnera realdelen
	double Imag() {return imag;} //returnera imaginärdelen
	double Norm(); //returnera komplexa talets norm
	double Abs(); //returnera absolutbeloppet
	Complex Conj(); //returnera konjugatet i ett nytt komplext tal
	double Arg();
	
	//funktioner för utskrift
	const char *abi(); //återge en sträng med talet på a+bi form
	const char *pol(); //återge en sträng med talet på polär form
	
	//användbara extrafunktioner!!!
	bool IsPrime(); //är talet ett gaussiskt primtal?
	Complex GetNeztPrime(); //ta fram nästa gaussiska primtal, räknat från vårt komplexa tal och uppåt
	Complex GetPrevPrime(); //ta fram föregående gaussiska primtal, räknat från vårt komplexa tal och neråt
		
	//operatorer för normal räkning med de komplexa talen...
	const Complex& operator+= (const Complex& c);
	const Complex& operator+= (const double c); //vi vill kunna addera reella tal oxå!
	Complex operator+ (const Complex& c) const;
	Complex operator+ (const double c) const; //realla tal
	
	friend Complex operator+= (double x, const Complex& c);
	friend Complex operator+ (double x, const Complex& c);
	
	const Complex& operator-= (const Complex& c);
	const Complex& operator-= (const double c); //vi vill kunna subtrahera reella tal oxå!	
	Complex operator- (const Complex& c) const;
	Complex operator- (const double c) const; //realla tal
	
	friend Complex operator-= (double x, const Complex& c);
	friend Complex operator- (double x, const Complex& c);
	
	const Complex& operator*= (const Complex& c);
	const Complex& operator*= (const double c);
	Complex operator* (const Complex& c) const;
	Complex operator* (const double c) const;
	
	friend Complex operator*= (double x, const Complex& c);
	friend Complex operator* (double x, const Complex& c);
	
	const Complex& operator/= (const Complex& c);
	const Complex& operator/= (const double c);
	Complex operator/ (const Complex& c) const;
	Complex operator/ (const double c) const;
	
	friend Complex operator/= (double x, const Complex& c);
	friend Complex operator/ (double x, const Complex& c);
	
	//unära operatorer, för att addera/subtrahera enklare.
	//vi vill även kunna negera vårt komplexa tal!
	Complex operator- () const; //negerar. En positiv variant verkar onödigt, eller?
	Complex operator++ (int); //ökar hela vårt komplexa tal med 1 (både realdel och imaginärdel)
	const Complex& operator++ ();
	Complex operator-- (int); //ökar hela vårt komplexa tal med 1 (både realdel och imaginärdel)
	const Complex& operator-- ();
	
	//en extra tilldelningsoperator för realla tal
	const Complex& operator= (const double c);


	//xinhui
	const Complex& operator= (const Complex& c);




	//jämförelseoperatorer 
	//(ska bara behöva definiera två av dem eftersom vi inkluderat utility.h)
	bool operator== (const Complex& c) const;
	

	//xinhui added
	bool operator== (const double c) const ;
	bool operator!= (const double c) const ;

	bool operator< (const Complex& c) const;
		
private:
	double real; //(a) i a + bi
	double imag; //(b) i a + bi
	char abitemp[100];
	char poltemp[100];
};
#endif






// Constructor

Complex::Complex() {

	real = 0;
	imag = 0;
}



Complex::Complex(const Complex& c) {

	real = c.real;
	imag = c.imag;
}



void Complex::SetTo(double a, double b) {

	real = a;
	imag = b;
}





//FUNKTIONER

double Complex::Norm() {

	return double(pow(real,2) + pow(imag,2)); //pow(x,y) ger x^y
}



double Complex::Abs() {

	return (double)sqrt(pow(real,2) + pow(imag,2)); //sgrt(x) ger roten ur x
}



Complex Complex::Conj() {

	Complex cong(real, -imag);
	return cong;
}



double Complex::Arg() {

	//double arg = atan(imag/real); wrong!

	double arg = atan2(imag, real);
	return arg;
}



const char* Complex::abi() {

	const char *t2 = "+";
	if(imag < 0)
		t2 = "-";

	if((real != 0) && (imag != 0))
		if(real < 0)
			sprintf(abitemp, "-%g %s %gi",fabs(real),t2,fabs(imag));
		else
			sprintf(abitemp, "%g %s %gi",fabs(real),t2,fabs(imag));
	else
		if(imag != 0 && real == 0)
			sprintf(abitemp, "%s%ei",t2,fabs(imag));
		else
			if(real < 0)
				sprintf(abitemp, "-%e",fabs(real));
			else
				sprintf(abitemp, "%e",fabs(real));
	return &(*abitemp);
}

const char* Complex::pol() {
	double abs = Abs();
	double arg = Arg();
	sprintf(poltemp,"%g(cos(%g) + isin(%g))",abs,arg,arg);
	return &(*poltemp);
}


// Overloaded Operators
const Complex& Complex::operator+= (const Complex& c) {
	real += c.real;
	imag += c.imag;
	return *this;
}

const Complex& Complex::operator+= (const double c) {
	real += c;
	return *this;
}

Complex Complex::operator+ (const Complex& c) const {
	Complex e(*this);
	e += c;
	return e;
}

Complex Complex::operator+ (const double c) const {
	Complex e(real+c,imag);
	return e;
}


Complex operator+= (double x, const Complex& c)
{
	Complex e(x + c.real, c.imag);
	return e;
}

Complex operator+ (double x, const Complex& c)
{
	Complex e(x + c.real, c.imag);
	return e;
}

const Complex& Complex::operator-= (const Complex& c) {
	real -= c.real;
	imag -= c.imag;
	return *this;
}

const Complex& Complex::operator-= (const double c) {
	real -= c;
	return *this;
}

Complex Complex::operator- (const Complex& c) const {
	Complex e(*this);
	e -= c;
	return e;
}

Complex Complex::operator- (const double c) const {
	Complex e(real-c,imag);
	return e;
}


Complex operator-= (double x, const Complex& c)
{
	Complex e(x - c.real, -c.imag);
	return e;
}

Complex operator- (double x, const Complex& c)
{
	Complex e(x - c.real, -c.imag);
	return e;
}


const Complex& Complex::operator*= (const Complex& c)
{
	double		ac, bd;
	
	if(real!=0 && imag!=0)
	{
		ac = real*c.real;
		bd = imag*c.imag;
		
		// the order here is important since z might be the same as x or y
		imag = (real + imag)*(c.real + c.imag) - ac - bd;
		real = ac - bd;
		return *this;
	}
	
	if(real==0)
	{
		ac = -imag*c.imag;
		imag = imag*c.real;
		real = ac;
		return *this;
	}
	
	if(imag==0)
	{
		ac = real*c.real;
		imag = real*c.imag;
		real = ac;
		return *this;
	}
	
	return *this;
}


const Complex& Complex::operator*= (const double c)
{
	real *= c;
	imag *= c;
	
	return *this;
}


Complex Complex::operator* (const Complex& c) const
{
	Complex e(*this);
	e *= c;
	return e;
}


Complex Complex::operator* (const double c) const
{
	Complex e(real*c,imag*c);
	return e;
}


Complex operator*= (double x, const Complex& c)
{
	Complex e(x*c.real, x*c.imag);
	return e;
}

Complex operator* (double x, const Complex& c)
{

    Complex e(x*c.real, x*c.imag);
	return e;
}


const Complex& Complex::operator/= (const Complex& c)
{
	double		ac, bd, den;
	
	if(c.real==0 && c.imag==0)
	{
		real = NAN;
		imag = NAN;
		return *this;
	}
	
	if(real==0 && imag==0)
		return *this;
	
	if(c.real!=0 && c.imag!=0)
	{
		den = c.real*c.real + c.imag*c.imag;
	
		ac = real*c.real;
		bd = imag*c.imag;
		
		// the order here is important since z might be the same as x or y
		imag = ((real + imag)*(c.real - c.imag) - ac + bd)/den;
		real = (ac + bd)/den;
		
		return *this;
	}
	
	if(c.imag==0)
	{
		real = real/c.real;
		imag = imag/c.real;
	}
	
	if(c.real==0)
	{
		ac = real;
		real = imag/c.imag;
		imag = -ac/c.imag;
	}
	
	return *this;
}


const Complex& Complex::operator/= (const double c)
{
	if(c==0)
	{
		real = NAN;
		imag = NAN;
		return *this;
	}
	
	real /= c;
	imag /= c;
	
	return *this;
}


Complex Complex::operator/ (const Complex& c) const
{
	Complex e(*this);
	e /= c;
	return e;
}


Complex Complex::operator/ (const double c) const
{
	if(c==0)
	{
		Complex e(NAN, NAN);
		return e;
	}
	
	Complex e(real/c,imag/c);

	return e;
}


Complex operator/= (double x, const Complex& c)
{
	double	den;
	
	if(c.real==0 && c.imag==0)
	{
		Complex e(NAN, NAN);
		return e;
	}
	
	den = c.real*c.real + c.imag*c.imag;
	
	Complex e(x*c.real/den, -x*c.imag/den);
	return e;
}

Complex operator/ (double x, const Complex& c)
{
	double	den;
	
	if(c.real==0 && c.imag==0)
	{
		Complex e(NAN, NAN);
		return e;
	}
	
	den = c.real*c.real + c.imag*c.imag;
	
	Complex e(x*c.real/den, -x*c.imag/den);
	return e;
}



Complex Complex::operator- () const {
	Complex e(*this);
	e.real = -real;
	e.imag = -imag;
	return e;
}

const Complex& Complex::operator++ () {
	Complex e(1,1);
	return (*this) += e;
}

Complex Complex::operator++ (int) {
	Complex e(1,1);
	(*this) += e;
	return e;
}

const Complex& Complex::operator-- () {
	Complex e(1,1);
	return (*this) -= e;
}

Complex Complex::operator-- (int) {
	Complex e(1,1);
	(*this) -= e;
	return e;
}

const Complex& Complex::operator= (const double c) {
	
	real = c;
	imag = 0;
	return *this;
}

//xinhui added
const Complex& Complex::operator= (const Complex& c) {
	
	real = c.real;
	imag = c.imag;
	return *this;
}


bool Complex::operator== (const Complex& c) const {
	if(c.real == real && c.imag == imag)
		return true;
	else
		return false;
}

//xinhui added
bool Complex::operator== (const double c) const {
	if(c == real)
		return true;
	else
		return false;
}

//xinhui added
bool Complex::operator!= (const double c) const {
	if(c != real)
		return true;
	else
		return false;
}


bool Complex::operator< (const Complex& c) const {
	if(real < c.real && imag < c.imag)
		return true;
	else
		return false;
}




