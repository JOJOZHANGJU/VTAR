% a function should be able to take
function [f, AR, VT] = vtar_calc( Len1, Area1, Fupper, df, rad )

if( nargin<2 ), 
    Len1  = 17.5 ; % cm 
    Area1 = 4 ; % cm^2
end


if( nargin<3 ), 
    Fupper = 6000 ; 
end

if( nargin<4 ),
    df = 10 ; 
end

if( nargin<5 ),
    rad = 1 ; 
end

VT = vtar_init ;

VT.Fupper = Fupper ; 
VT.df     = df ; 
if(rad==1)
    VT.Radiation_Load = 'on' ;
else
    VT.Radiation_Load = 'off' ;
end

VT.Vowel.Geometry.Area = Area1(1:length(Len1)) ; %ones(1,17*1)*1 ;
VT.Vowel.Geometry.DL =  Len1(1:end) ; % ones(1,17*1)*1/1;

VT = get_acousticResponse1(VT, 2, 0) ; % 2, 0 are fixed in the fucntion

f  = VT.f ; 
AR = VT.AR ; 

VT.AR =  20*log10(abs(AR)) ;
VT = Calculate_formant( VT ) ;  
return ;
