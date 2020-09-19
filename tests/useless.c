#include <stdio.h> 

/* MiniScrip Library */
double readNumber() { double ret; scanf("%lf", &ret); return ret; } 
void writeNumber(double n) { printf("%0.3lf",n); } 

const double N = -100;

float a, b; 

double cube(double i) { 
   return i*i*i; 
} 

double add(double n, double k) { 
   double j;         
        
   j = (N-n) + cube(k); 
   writeNumber(j); 
   return j;
} 
 
void main() { 
  
   a = readNumber(); 
   b = readNumber(); 
   
   add(a, b);
} 