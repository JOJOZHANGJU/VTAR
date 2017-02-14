Len1  = [ 7.5 10 ];% cm , lengths of the tubes
 Area1 = [ 4 2] ; % cm ^2, areas of the tubes
 
 
 Fupper = 4000 ; % Hz
 df     = 10 ; % freq interval
 rad     = 0 ;  % lip radiation considered

 figure;
 [f, ar]  =  vtar_calc( 17, 3, Fupper, df, rad) ;  
subplot(211)
  plot(f, 20*log10(abs(ar)), 'color', 'r', 'linewidth', 1.5) ; grid on ; set(gca, 'xlim', [0 4000])
  
  hold on ; 
   [f, ar]  =  vtar_calc( 16, 3, Fupper, df, rad) ;  

  plot(f, 20*log10(abs(ar)), 'color', 'b', 'linestyle', '--',  'linewidth', 1.5) ; grid on ; set(gca, 'xlim', [0 4000])
  set(gca, 'ylim', [0 45])
  set(gca, 'fontsize', 16) ; 
  saveas(gcf, 'acousticResponse', 'png')
  xlabel('Frequency (Hz)')
  ylabel('(dB)')
  saveas(gcf, 'acousticResponse', 'png')
  