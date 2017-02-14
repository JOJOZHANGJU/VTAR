function [Fn, DL, Area1, S] = sensitivity(VT1, originalDL, originalArea, deltaL) 
global VT ;
%VT = VTsaved ;
%length (VT.Vowel.Geometry.Area)
colororder = 'bmrkcgybmcrgkybmcrgky' ;

% VT.Vowel.Geometry.Area = ones(1,17*1)*1 ;
% VT.Vowel.Geometry.DL = ones(1,17*1)*1/1;
% VT.Vowel.Geometry.Area = ones(1,35*2) ;
% VT.Vowel.Geometry.DL = ones(1,35*2)*0.25/1;

% originalArea = VT.Vowel.Geometry.Area ;
% originalDL   = VT.Vowel.Geometry.DL ;
% for each formant , calcualte the energy for potential and kinetic energy 
rho = VT.Property.RHO ;
c0 = VT.Property.C0 ;
RHO = rho ;       
C0  = c0  ;

% rho = VTsaved.Property.RHO ;
% c0 = VTsaved.Property.C0 ;

% to divide a tube into smaller tube for sensitivity analysis
originalArea1 = VT.Vowel.Geometry.Area ; % 
originalDL1   = VT.Vowel.Geometry.DL ;
originalFupper = VT.Fupper  ; 
originaldf = VT.df   ; 
old_VT_f = VT.f ;  old_VT_AR = VT.AR ;

[DL, Area1] = divide( originalDL, originalArea, deltaL);
VT.Vowel.Geometry.Area = Area1 ;
VT.Vowel.Geometry.DL = DL ;
originalArea = VT.Vowel.Geometry.Area ; % 
originalDL   = VT.Vowel.Geometry.DL ;
N = length(originalDL) ;

% calculate the formants 
% [Distance, Area] = lengh_to_distance(VT.Vowel.Geometry.DL, VT.Vowel.Geometry.Area)  ;
% figure;
% subplot(2,1,1); 
% plot(Distance, Area) ; hold on ; grid on ;
% VT.Fupper = 6000 ; 
% VT.df  = 1 ;
% 
% get_acousticResponseJMorMT(2, 0) ; % 2, 0 are fixed in the fucntion
% subplot(2,1,2); hold on ; %    figure(2) ; hold on ; 
% plot(VT.f, VT.AR) ; grid on ;



% energy distribution and sensitivity
Formant = VT.Formant ;
Fn = VT.Formant ; 

% for temporary use to test how to define the transfer funcitons
if(0)
            VT.Vowel.Geometry.Area = originalArea(1:N) ;
            VT.Vowel.Geometry.DL   = originalDL(1:N)   ;
            Z = -1;
            VT.Z = complex(Z) ; 
            %       get_acousticResponseJMorMT_Z(2, 0) ;
            get_acousticResponse_Z(2, 0) ;
%           figure;  plot(VT.f, 20*log10(abs(VT.ARcomplex.*VT.Z))) ; 
            r_lip=sqrt(originalArea(end)/pi);
            Zrad_lip = RHO*VT.f./C0*2*pi.*VT.f+sqrt(-1).*VT.f*RHO*16/3/pi/r_lip;

            figure;  plot(VT.f, 20*log10(abs(VT.ARcomplex.*Zrad_lip))) ; 
            figure;  plot(VT.f, 20*log10(abs(Zrad_lip))) ; 
            figure;  plot(VT.f, 20*log10(abs(VT.ARcomplex))) ; 
%            figure;  plot(VT.f, (abs(VT.Z))) ; 
end

% % 
% % temporary use
% Formant = 1000 ;
% k =1 ;
% VT.Fupper = 6000 ; Formant(k);
% VT.df  = 50 ; Formant(k)-1; % the second frequency is formant 
% VT.Fupper = Formant(k);
% VT.df  = Formant(k)-1; % the second frequency is formant 
% 
% VTsaved.Property.MU = 0
% m = 0 ;
% VT.Vowel.Geometry.Area = originalArea(m+1:N) ;
% VT.Vowel.Geometry.DL   = originalDL(m+1:N)   ;
% Z = 0+0*j ;
% VT.Z = complex(Z) ; 
% get_acousticResponseJMorMT_Z(2, 0) ;
%  return ;
% % 
Sensitivity_KE_PE = zeros(5, N) ; 
KE = zeros(5, N) ;
PE = zeros(5, N) ;
Total_KE_PE = KE + PE ;

for k = 1:5
    for m = 1:N 
        if (Formant(k)==0)
            break ; 
        end
        VT.Fupper = Formant(k);
        VT.df  = Formant(k)-1; % the second frequency is formant 
        % calcuate impedance after each tube 
        if (m ==N)
            switch lower(VT.Radiation_Load)
                case 'on'
                    r_lip=sqrt(originalArea(end)/pi);
                    Zrad_lip = RHO*Formant(k)/C0*2*pi*Formant(k)+sqrt(-1)*Formant(k)*RHO*16/3/pi/r_lip;
                case 'off'
                    Zrad_lip = 0;
            end
            Z = Zrad_lip ;  % radiation impedance
            VT.Z = complex(real(Z), imag(Z)) ; 
        else
            VT.Vowel.Geometry.Area = originalArea(m+1:N) ;
            VT.Vowel.Geometry.DL   = originalDL(m+1:N)   ;
            Z = -1;
            VT.Z = complex(Z) ; 
            %       get_acousticResponseJMorMT_Z(2, 0) ;
            get_acousticResponse_Z(2, 0) ;
            % calculate Z
        end
        
        % get U volume velocity and Z impedance so that 
        VT.Vowel.Geometry.Area = originalArea(1:m) ;
        VT.Vowel.Geometry.DL   = originalDL(1:m)   ;
        %calculate Z
        %    VT.Z = complex(VT.Z) ; 
        VT.Z = complex(real(VT.Z(end)), imag(VT.Z(end))) ;
        Z = VT.Z(end); %(2) ;  % for impedance load
        %get_acousticResponseJMorMT_Z(2, 0) ;
        get_acousticResponse_Z(2, 0) ;
        % U = VT.AR(2) ;
        U = VT.ARcomplex(2) ;
        P = U*Z ;
        KE(k,m) = 1/2*rho*VT.Vowel.Geometry.DL(end)/VT.Vowel.Geometry.Area(end)*(abs(U).^2) ;
        PE(k,m) = 1/2*VT.Vowel.Geometry.DL(end)*VT.Vowel.Geometry.Area(end)*(abs(P).^2)/(rho*c0^2);
        Total_KE_PE(k,m) = KE(k,m)+PE(k,m) ;
        Sensitivity_KE_PE(k,m) = KE(k,m)-PE(k,m) ;   
    end
end

% sensitivity 
for k = 1:5
    temp = sum(Total_KE_PE(k,:)) ; 
    if(temp~=0)
        Sensitivity_KE_PE(k,:) = Sensitivity_KE_PE(k,:)/temp ;  
    end
end
S.Sensitivity_KE_PE = Sensitivity_KE_PE ; 
S.KE = KE ; 
S.PE = PE ; 

VT.Vowel.Geometry.Area = originalArea1 ; % 
VT.Vowel.Geometry.DL = originalDL1 ;
VT.Fupper = originalFupper ; 
VT.df  = originaldf ; 
VT.f = old_VT_f  ;  VT.AR = old_VT_AR ;


return ; 


% latest version of divide with the maximum number of tube subsections
function [DL1, Area1] = divide( DL, Area, Delta_L)
EPS = 1E-16 ;
Area1  = [] ;
DL1 = [] ;  
max_sections = 400 ; % new variable added 
for i = 1: length(DL) 
    if(DL(i) <= Delta_L)
        DL1 = [DL1 DL(i) ] ;
        Area1  = [Area1  Area(i)] ;
    else
        %       if(ceil(DL(i)/Delta_L) < 100)
        if(ceil(DL(i)/Delta_L) < max_sections)  % updated by xinhui , 03/27/2005
            
            Temp_Length = Delta_L*ones(1,round(DL(i)/Delta_L)) ;  %round
            Temp_Area   = Area(i)*ones(1,round(DL(i)/Delta_L)) ; %round
            
            if(abs(sum(Temp_Length)-DL(i))>EPS)
                if(sum(Temp_Length)>DL(i))
                    Temp_Length(end) = Delta_L -(sum(Temp_Length)-DL(i))  ;    
                else
                    Temp_Length(end+1) = DL(i) - sum(Temp_Length) ;
                    Temp_Area(end+1)   = Area(i) ;         
                end
            end
            
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
        else  % if length is too large, the maximum number of section is 100 ;
            %             Temp_Length = DL(i)/100*ones(1,100) ;
            %             Temp_Area   = Area(i)*ones(1,100) ; 
            Temp_Length = DL(i)/max_sections*ones(1,max_sections) ;
            Temp_Area   = Area(i)*ones(1,max_sections) ; 
            
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
            h = warndlg('Please be aware that large length of section will reduce the accuracy of modelling', 'warning', 'modal') ;
        end
    end
end 
