function areafunction_tuning
global VT ; 

iterNum = 300 ; % the maximum number of iteration

% only consider the case without side branch
VT.validGeometry = 1; 
VT.sideBranch = 0; 
vtar('Apply_Callback',gcbo,[],guidata(gcbo)); % calculate formants and check the format of geometry
if(VT.validGeometry==0)
     return ; 
end
% check if there is no side branch for geometry 
% If yes, return ; 
if(VT.sideBranch ==1)
    errordlg('No side branch allowed for sensitivity function !', 'Error', 'modal'); 
    return ; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot(VT.tempDL, VT.tempArea)

% calculate the sensitivity function again, 
% even though it might be redundant if they are already calculated , 
% 

% calculate sensitivity function 
refresh ; 
deltaL = VT.deltaL_sensitivity ; % 0.3 ; %cm

DL = VT.tempDL; Area = VT.tempArea;

Fn1 = VT.FormantExpect ; 
% The first call is to get DL and Area
[Fn, DL, Area, S] = sensitivity(VT, DL, Area, deltaL) ; 
old_Area = Area ; 
alpha = 20 ;  30 ; 20; 10 ; 
Tol = 30 ; 
for k = 1:iterNum 
    k,   
    delta = norm(Fn-Fn1) 
    if (delta<Tol) 
        break ; 
    end
    Zn = alpha*(Fn1-Fn)./Fn ; 
    temp1 = Area + Zn*S.Sensitivity_KE_PE ;  
    temp2 = exp(log(Area)+log(1+Zn*S.Sensitivity_KE_PE));
    tempArea = zeros(size(Area)) ; 
    tempArea(Area>1) = temp1(Area>1) ; 
    tempArea(Area<=1) = temp2(Area<=1) ; 
    tempArea(tempArea<0.1) = 0.1 ; 
    Area = tempArea ; 
    
    VT.Vowel.Geometry.Area = Area(1:length(DL)) ; %ones(1,17*1)*1 ;
    VT.Vowel.Geometry.DL =  DL(1:end) ; % ones(1,17*1)*1/1;
    get_acousticResponseJMorMT(2, 0)    
   [Fn, DL, Area, S] = sensitivity(VT, DL, Area, deltaL) ; 
end

save tempDLArea DL Area ; 
% figure ; 
switch lower(VT.Radiation_Load)
    case 'on'
        rad = 1 ; 
    case 'off'
        rad = 0 ; 
end
figure ; 
%vtar_all(VT, 17.5, 5, 0, 'r') ;

vtar_all(VT, DL, old_Area, rad, 'b') ;
vtar_all(VT, DL, Area, rad, 'r') ;
subplot(2,1,1); legend('Original', 'Modified');
subplot(2,1,2); legend('Original', 'Modified');
return ; 

% save Sensitivity_uniform.mat
S.Sensitivity_KE_PE = S.Sensitivity_KE_PE*deltaL ; % to normalize all the senesity in deltaL section length 
S.KE = S.KE*deltaL ; % to normalize all the senesity in deltaL section length 
S.PE = S.PE*deltaL ; % to normalize all the senesity in deltaL section length 
sensitivity_disp_Energy(Fn, DL, Area, S.KE, {'Kinetic Energy Distribution', '\bfKinetic Energy'}) ;
sensitivity_disp_Energy(Fn, DL, Area, S.PE, {'Potential Energy Distribution', '\bfPotential Energy'}) ;
sensitivity_disp(Fn, DL, Area,S.Sensitivity_KE_PE) ;


% display the sensitivity functions for the first five formants
% 

return ;