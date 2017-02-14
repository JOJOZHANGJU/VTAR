function [Fn, S, DL, Area] = sensitivity_function(DL, Area, VT)
% global VT ; 

% % only consider the case without side branch
% VT.validGeometry = 1; 
% VT.sideBranch = 0; 
% vtar('Apply_Callback',gcbo,[],guidata(gcbo)); % calculate formants and check the format of geometry
% if(VT.validGeometry==0)
%      return ; 
% end
% % check if there is no side branch for geometry 
% % If yes, return ; 
% if(VT.sideBranch ==1)
%     errordlg('No side branch allowed for sensitivity function !', 'Error', 'modal'); 
%     return ; 
% end

%plot(VT.tempDL, VT.tempArea)

% calculate the sensitivity function again, 
% even though it might be redundant if they are already calculated , 
% 


% calculate sensitivity function 
% refresh ; 
deltaL = 0.2 ; %cm
% DL = VT.tempDL; Area = VT.tempArea;
% tic; 
[Fn, DL, Area, S] = sensitivity(VT,DL, Area, deltaL) ; 
% toc; Fn
% save Sensitivity_uniform.mat
S.Sensitivity_KE_PE = S.Sensitivity_KE_PE*deltaL ; % to normalize all the senesity in deltaL section length 
S.KE = S.KE*deltaL ; % to normalize all the senesity in deltaL section length 
S.PE = S.PE*deltaL ; % to normalize all the senesity in deltaL section length 
% sensitivity_disp_Energy(Fn, DL, Area,S.KE, {'Kinetic Energy Distribution', '\bfKinetic Energy'}) ;
% sensitivity_disp_Energy(Fn, DL, Area,S.PE, {'Potential Energy Distribution', '\bfPotential Energy'}) ;

sensitivity_disp_old(Fn, DL, Area,S.Sensitivity_KE_PE) ;
%sensitivity_disp(Fn, DL, Area,S.Sensitivity_KE_PE) ;


% display the sensitivity functions for the first five formants
% 

return ;