function Sensitivity_disp(Fn, DL, Area,S) 

figure; set(gcf, 'name', 'Formant Sensitivity Function') ; 
% to plot sensitivity function for MT and JM
k1 = 1 ;
mindata = 0 ;
maxdata = 0 ;
lineWidth = 2 ; 
fontSize = 10 ;
    colororder = 'bbr' ;

% Sensitivity_KE_PE = S.Sensitivity_KE_PE ;
%  data = Sensitivity_KE_PE ;
  data = S ; %S.KE;
    if( mindata>min(min(data)) )
        mindata = min(min(data)) ;
    end
    if( maxdata< max(max(data)) )
        maxdata =  max(max(data)) ;
    end
    
[Distance, Area] = lengh_to_distance(DL, Area)  ;


%    data = Total_KE_PE ;
    n = 8
subplot(n/2,2,1) ;
    plot(Distance, Area, 'color', colororder(k1), 'linewidth', lineWidth) ; hold on ; grid on ; set(gca, 'xlim', [0 max(Distance)])
    set(gca, 'XTick', [0:2:20]), set(gca, 'ylim', [0 13])
    ylabel('\bfArea(cm^2)') ;
    xlabel('\bfDistance from the glottis(cm)') ;
    title('\bfArea function');

    subplot(n/2,2,2) ;
    plot(Distance, Area, 'color', colororder(k1), 'linewidth', lineWidth) ; hold on ; grid on ; set(gca, 'xlim', [0 max(Distance)])
    set(gca, 'XTick', [0:2:20]), set(gca, 'ylim', [0 13])
    ylabel('\bfArea(cm^2)') ;
    xlabel('\bfDistance from the glottis(cm)') ;
    title('\bfArea function');
    
    
    if(1)
        for k = 1:5
            data(k,:)=data(k,:)./DL ;
        end
        if( mindata>min(min(data)) )
            mindata = min(min(data)) ;
        end
        if( maxdata< max(max(data)) )
            maxdata =  max(max(data)) ;
        end
    end
    
    % in the case that 
    if(mindata==maxdata) 
       mindata = maxdata-1 ; 
    end
    
    for k = 1:5
        %        subplot(n/2,2,k+1) ;hold on ;
        subplot(n/2,2,k+2) ;hold on ;

        %        plot(data(k,:), 'color', colororder(subject) ) ;   grid on ;  set(gca, 'xlim', [0 length(Total_KE_PE(k,:))])

        [Distance1, Area1] = lengh_to_distance(DL, data(k,:))  ;
        % [Distance1, Area1] = lengh_to_distance(VT.Vowel.Geometry.DL, data(k,:)./VT.Vowel.Geometry.DL)  ;

        %       plot(Distance1, Area1, 'color', colororder(subject) ) ;   grid on ;  % set(gca, 'xlim', [0 length(Total_KE_PE(k,:))])
        plot(Distance1, Area1, 'color', colororder(k1), 'linewidth', lineWidth  ) ;   grid on ;  % set(gca, 'xlim', [0 length(Total_KE_PE(k,:))])
        set(gca, 'xlim', [0 max(Distance)]) ;

        %         xlabel('Section number from glottis') ;
        ylabel('\bfSensitivity') ;
        %        title(['Formant ' num2str(k) ' :' num2str(Formant(k))  ' Hz'])
        title(['\bfF' num2str(k)])
        %         set(gca, 'ylim', [-0.1 0.1])
        %        set(gca, 'ylim', [min(min(data)) max(max(data))])
        set(gca, 'ylim', [mindata maxdata])
        set(gca, 'XTick', [0:2:20])
    end
    
%     if (subject==9)
%         saveas(gcf, 'MTsensitivity', 'jpg');
%     else
%         saveas(gcf, 'JMsensitivity', 'jpg');
%     end
%     
%     saveas(gcf, 'MTsensitivity', 'jpg');
%     saveas(gcf, 'JMsensitivity', 'jpg');


return ;
