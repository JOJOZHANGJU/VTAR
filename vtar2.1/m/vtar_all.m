% a function should be able to take
function vtar_all(VT1, dist1, Area1, rad, color1, linestyle1, linewidth1, sensefunc, Nop, combTube)

global VT ;


fontsize = 12 ; 
%VT = VT1 ; 
if(nargin<3)
    errordlg('Not enough arguments !!!', 'Error!!! ', 'modal') ; return ;
end
if(nargin<5)
    color1 = 'r' ;
    sensefunc = 0 ;
    linestyle1 = '-' ;
    linewidth1 = 0.25 ;
elseif(nargin<8)
    sensefunc = 0
    linestyle1 = '-' ;
    linewidth1 = 0.25 ;
end
if(rad==1)
    VT.Radiation_Load = 'on' ;
else
    VT.Radiation_Load = 'off' ;
end

addpath('./m') ;

VT.Vowel.Geometry.Area = Area1(1:length(dist1)) ; %ones(1,17*1)*1 ;
VT.Vowel.Geometry.DL =  dist1(1:end) ; % ones(1,17*1)*1/1;

if(nargin>8)
    numTotal = length(Nop)-1 ;
    %         save   NopMT  Nop;
    for kk = 1:numTotal
        if(kk==numTotal)
            %                 tempArea(kk) = mean(Area1(Nop(kk):Nop(kk+1)))
            %                 tempL(kk) = sum(dist1(Nop(kk):Nop(kk+1)))
            tempL(kk) = sum(dist1(Nop(kk):Nop(kk+1))) ;
            tempArea(kk) = sum(Area1(Nop(kk):Nop(kk+1)).*dist1(Nop(kk):Nop(kk+1)))/tempL(kk) ;
        else
            %                 tempArea(kk) = mean(Area1(Nop(kk):Nop(kk+1)-1))
            %                 tempL(kk) = sum(dist1(Nop(kk):Nop(kk+1)-1))
            tempL(kk) = sum(dist1(Nop(kk):Nop(kk+1)-1));
            tempArea(kk) = sum(Area1(Nop(kk):Nop(kk+1)-1).*dist1(Nop(kk):Nop(kk+1)-1))/tempL(kk) ;
        end
    end

    if(nargin>9) % in case averaging on the simple tube needed
        for kk = 1:length(combTube)
            tempNum = combTube{kk} ;
            tempArea(tempNum) = sum(tempArea(tempNum).*tempL(tempNum))/sum(tempL(tempNum)) ;
        end
    end
    VT.Vowel.Geometry.Area = tempArea  ; %ones(1,17*1)*1 ;
    VT.Vowel.Geometry.DL =  tempL ; % ones(1,17*1)*1/1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the formants
[Distance, Area] = lengh_to_distance(VT.Vowel.Geometry.DL, VT.Vowel.Geometry.Area)  ;
%    figure;
subplot(2,1,1);
%     plot(Distance, Area,'color', colororder(caseNo)) ; hold on ; grid on ;
%    plot(Distance, Area,'color', colororder(k1), 'linewidth',2) ; hold on ; grid on ;title('\bfArea Function')
plot(Distance, Area,'color', color1, 'linestyle', linestyle1, 'linewidth',linewidth1) ; hold on ; grid on ;title('\bfArea Function', 'fontsize', fontsize)
xlabel('\bf Distance from glottis (cm)', 'fontsize', fontsize)
ylabel('\bf Area (cm^2)', 'fontsize', fontsize)
ylim1 = get(gca, 'ylim') ; set(gca, 'ylim', [0 ylim1(2)]) ; 

subplot(2,1,2);
get_acousticResponseJMorMT(2, 0) ; % 2, 0 are fixed in the fucntion
plot(VT.f, VT.AR,'color', color1, 'linestyle', linestyle1, 'linewidth',linewidth1) ; grid on ; hold on ; title('\bfAcoustic Response', 'fontsize', fontsize)
xlabel('\bf Frequency (Hz)', 'fontsize', fontsize)
ylabel('\bf Acoustic response (dB)', 'fontsize', fontsize)

% plot sensitivity function,
if(sensefunc==1)
    h = gcf;
    [Fn, S, DL, Area] = sensitivity_function(VT.Vowel.Geometry.DL, VT.Vowel.Geometry.Area) ;
    figure(h)
end

return ;
