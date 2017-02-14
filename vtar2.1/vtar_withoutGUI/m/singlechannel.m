function [K,Z]=singlechannel(f,A,l,Zterm)
%SingleChannel Calculate transfer matrix between the pressure and volume 
%		velocity of the source and load ends of the front cavity, and the
%		input acoustic impedance.

% Define as global variables the air properties
%	RHO: air density;
%	MU: air viscosity;
%	C0: sound of speed in air;
%	CP: specific heat of air;
%	LAMDA: air heat conduction.
global RHO MU C0 CP LAMDA ETA WALL_L WALL_R WALL_K;
global VT ;
RHO = VT.Property.RHO ;
MU = VT.Property.MU ;
C0 = VT.Property.C0 ;
CP = VT.Property.CP ;
LAMDA = VT.Property.LAMDA ;
ETA = VT.Property.ETA ;
WALL_L = VT.Property.WALL_L ;
WALL_R = VT.Property.WALL_R ;
WALL_K = VT.Property.WALL_K ;

vtar_inittemp
La1 = 0; % just to avoid the case that just one small section is used in tube 
Ra1 = 0;


omega=2*pi*f;
%f   % xinhui
N=max(size(A));
S=2*sqrt(A(1)*pi);
La=RHO*l(1)/2/A(1)*omega;
Ra=l(1)*S/2/A(1)^2*sqrt(omega*RHO*MU/2);
K=[1 Ra+sqrt(-1)*La;0 1];


for k=1:N
% for k=2:N % xinhui
   S=2*sqrt(A(k)*pi);
   if k<N
      La1=RHO*l(k+1)/2/A(k+1)*omega;
      % Ra1=l(k+1)*S/2/A(k+1)^2*sqrt(omega*RHO*MU/2); % bug
      Ra1=l(k+1)*2*sqrt(A(k+1)*pi)/2/A(k+1)^2*sqrt(omega*RHO*MU/2);
      %Ra1=Ra1+0.05*RHO*200/2/A(k+1)^2*abs(1-(A(k)/A(k+1))^2); %%%%%%%%%%%%%%%%%%%%      
   end
   Ca=l(k)*A(k)/RHO/C0^2*omega;
   Ga=S*(ETA-1)/RHO/C0^2*sqrt(LAMDA*omega/2/CP/RHO)*l(k);
   Lw=WALL_L/l(k)/S^1*omega;
   Rw=WALL_R/l(k)/S^1;
   Cw=l(k)*S^1/WALL_K*omega;
   %Lw=4*sqrt(pi)*WALL_L/l(k)/S^2*omega;
   %Rw=4*sqrt(pi)*WALL_R/l(k)/S^2;
   %Cw=l(k)*S^2/WALL_K/(4*sqrt(pi))*omega;
  
  	j=sqrt(-1);
   if k<N
      k11=1;
      k12=Ra+Ra1+j*(La+La1);
      k21=j*Ca+Ga+1/(Rw+j*(Lw-1/Cw));
      k22=1+(j*Ca+Ga+1/(Rw+j*(Lw-1/Cw)))*(Ra+Ra1+j*(La+La1));
   else
      k11=1;
      k12=Ra+j*La;
      k21=j*Ca+Ga+1/(Rw+j*(Lw-1/Cw));
      k22=1+(j*Ca+Ga+1/(Rw+j*(Lw-1/Cw)))*(Ra+j*La);
   end
   
   K=K*[k11 k12;k21 k22];
  
  	La=La1;
  	Ra=Ra1;
end

if isinf(Zterm)
   Z=K(1,1)/K(2,1);
else
   Z=(K(1,1)*Zterm+K(1,2))/(K(2,1)*Zterm+K(2,2));
end
