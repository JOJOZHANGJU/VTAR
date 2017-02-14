
Test code: 

 clear all ; close all ;
 addpath(genpath('.')) ; 
 Len1  = [ 7.5 10 ];% cm , lengths of the tubes
 Area1 = [ 4 4] ; % cm ^2, areas of the tubes
 Fupper = 6000 ; % Hz
 df     = 10 ; % freq interval
 rad     = 0 ;  % lip radiation considered

 [f, ar, VT]  =  vtar_calc( Len1, Area1, Fupper, df, rad) ;  

 figure; plot(f, 20*log10(abs(ar))) ; grid on ; set(gca, 'xlim', [0 6000])


[Fn, S, DL, Area] = sensitivity_function(Len1, Area1, VT)