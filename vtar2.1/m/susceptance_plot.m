function   susceptance_plot(TubeNo, Loc)
% Only consider two cases,
% nasal vowel case, and vowel case  , but not other cases to simplify
% it might be not useful to consider other cases,
%

global VT ;

% no arbitrary geometry 
if(VT.CurrentCategory == 8)
    h = msgbox('No susceptance plot for artibrary geometry', 'Message', 'modal') ;
    uiwait (h) ;    
    return ; 
end
if(VT.CurrentCategory== 5 & VT.sideBranch==1 ) % rhtoic sound, in this sound, only consider the case without side branch
                           % check at the susceptance plot program,
                           % suscepatance_disp.m
    h = msgbox('No susceptance plot for rohtic sound with sublingual cavity ', 'Message', 'modal') ;
    uiwait (h) ;    
    return ; 
end

% only consider the case that the geometry is valid
VT.validGeometry = 1;
VT.sideBranch = 0;
vtar('Apply_Callback',gcbo,[],guidata(gcbo)); % calculate formants and check the format of geometry
if(VT.validGeometry==0)
    return ;
end
% VT.model obtained from get_acousticResponse.m
% [Model1, Model2, validDiv] = divideModel(VT.model, TubeNo, Loc) ;
[Model1, Model2, Model3, validDiv] = divideModel(VT.model, TubeNo, Loc) ;

% if the dividing process is not valid , return ;
if (validDiv~=1 )
    return ;
end

% calculating the susceptance
% Model1 should be an artitrary geometry description
B1 = 0 ; B2 = 0 ; B3 = 0 ; 
if( ~isempty(Model1))
    [f,B1] = susceptance(Model1) ;
end
if( ~isempty(Model2))
    [f,B2] = susceptance(Model2) ;
end
if( ~isempty(Model3))
    [f,B3] = susceptance(Model3) ;
end
if(length(B1)==1), B1 = zeros(1,length(f)); end
if(length(B2)==1), B2 = zeros(1,length(f)); end
if(length(B3)==1), B3 = zeros(1,length(f)); end

% display the susceptance plots
if(VT.sideBranch == 0)
    susceptance_disp(f, B1, -B2, {'Bp', '-Bo'}) ;
else
    if( VT.CurrentCategory==4| VT.CurrentCategory==7 ) % nasal and nasalvowel   
        susceptance_disp(f, B1, -(B2+B3), {'Bn', '-(Bp+Bo)'}) ;
    else % lateral
       susceptance_disp(f, B1, -(B2+B3), {'Bs', '-(Bp+Bo)'}) ;
   end
    
%    susceptance_disp(f, B1, -B2, {'Bp', '-Bo'}) ;
%    susceptance_disp(f, B1, -B3, {'Bp', '-Bo'}) ;
end

return ;

function [Model1, Model2, Model3, validDiv] = divideModel(Model, TubeNo, Loc)
global VT ;
Model1 = [] ;
Model2 = [] ;
Model3 = [] ;
validDiv = 0 ;

END = 99900000  ;
SINGLECHANNEL = 1 ;
TWOCHANNELS   = 2 ;
GLOTTIS       = 2 ;
LIPS          = 2 ;

% find the root
maxnumTubes = length(Model) ;
root = 0 ;
for i = 1: maxnumTubes
    if(Model(i).typeOfStartofTube == GLOTTIS)
        root = i ;
    end
end
if (root ~= TubeNo)
    errordlg('Only tube starting from glottis can be selected', 'modal') ;
    return ;
end

% if there is no side branch

Tube_transformed(1).IndexOfBranch = 1 ;
Tube_transformed(1).typeOfModule  = SINGLECHANNEL ;
Tube_transformed(1).typeOfStartofTube = GLOTTIS ;
Tube_transformed(1).typeOfEndofTube   = LIPS ;
Tube_transformed(1).numOfSections = [] ; %length(Geometry.DL) ;
Tube_transformed(1).secLen = [] ; %Geometry.DL ;
Tube_transformed(1).secArea = [] ; %Geometry.Area ;
Tube_transformed(1).numOfSections1 = [ 0 ] ;  % for channel 2 in case that typeOfModule == TWOCHANNELS 
Tube_transformed(1).secLen1 = zeros(1, 200) ;
Tube_transformed(1).secArea1 = zeros(1, 200) ;

Tube_transformed(1).nextBranches = zeros(1, 10) ;
Tube_transformed(1).nextBranchesLoc =  zeros(1, 10) ;
Tube_transformed(1).nextBranchesLocEnd =  zeros(1, 10) ;
Tube_transformed(1).nextBranchesLocChannel =  ones(1, 10) ;
% case 1
if(VT.sideBranch ==0)
    
    DL = VT.tempDL; Area = VT.tempArea;
    DL = (DL(:))' ; Area = (Area(:))'
    if (Loc==END)
        Loc = sum(DL)
    elseif(Loc > sum(DL))
        Loc = sum(DL) ;
        errordlg('Only tube starting from glottis can be selected', 'modal') ;
    end
    if(abs(sum(DL)-Loc)<eps ) % at the end of this tube
        Tube_transformed(1).secLen = [DL(end:-1:1) 1] ;
        Tube_transformed(1).secArea = [Area(end:-1:1) 0] ;
        Tube_transformed(1).numOfSections = length(Tube_transformed(1).secLen) ;
        Model1 = Tube_transformed ;
    elseif(abs(Loc)<eps) % at the beginning of this tube
        Tube_transformed(1).secLen = [DL] ;
        Tube_transformed(1).secArea = [Area] ;
        Tube_transformed(1).numOfSections = length(Tube_transformed(1).secLen) ;
        Model2 = Tube_transformed ;
    else % in the middle of this tube
        [tempDL tempArea] = cutAreafunction(DL,  Area, Loc , sum(DL) );
        Tube_transformed(1).numOfSections = length(tempDL) ;
        Tube_transformed(1).secLen = tempDL ;
        Tube_transformed(1).secArea = tempArea ;
        Model2 = Tube_transformed ;
        
        [tempDL tempArea] = cutAreafunction(DL,  Area, 0 , Loc );
        Tube_transformed(1).numOfSections = length(tempDL)+1 ;
        Tube_transformed(1).secLen = [tempDL(end:-1:1) 1] ;
        Tube_transformed(1).secArea = [tempArea(end:-1:1) 0] ;
        Model1 = Tube_transformed ;
    end
    validDiv = 1 ;
    return ;
    
end % end of side branch,

% case2, only look at the first tube in this case
% Only consider the end of the first tube ...
% which might be useful to nasal , nasalvowel , and lateral which has side
% branch !
DL = Model(root).secLen; Area = Model(root).secArea;
DL = (DL(:))' ; Area = (Area(:))'

% at the end of the first tube
if (Loc==END)
    Loc = sum(DL) ;
elseif(Loc > sum(DL))
    Loc = sum(DL) ;
    errordlg('Only tube starting from glottis can be selected', 'modal') ;
end

if(abs(Loc)<eps) % at the beginning of the first tube
    Model2 = Model ; 
elseif(abs(sum(DL)-Loc)<eps) % at the end of the first tube
    % larynx as model 3
    Tube_transformed(1).secLen = [DL(end:-1:1) 1] ;
    Tube_transformed(1).secArea = [Area(end:-1:1) 0]
    Tube_transformed(1).numOfSections = length(Tube_transformed(1).secLen) ;
    Model3 = Tube_transformed ;

    % oral cavity as model 2
    tempModel = Model ;
    tempModel(root).numOfSections = 1  ;
    tempModel(root).secLen = eps ;   ;
    N = tempModel(root).nextBranches(1) ; % next tube
    tempModel(root).secArea = tempModel(N).secArea(1) ; %Area(end) ;
    tempModel(root).nextBranches(2) = 0 ;  % remove the side branch
    Model2 = tempModel ;

    % side branch as model 1
    tempModel = Model ;
    Nsidebranch = tempModel(root).nextBranches(2) ; % side branch
    tempModel(Nsidebranch).typeOfStartofTube = tempModel(root).typeOfStartofTube ; % the starting point of side branch
    tempModel(root).typeOfStartofTube = 0 ; % 
    Model1 = tempModel ;
    
    
else % in the middle of the first tube
    [tempDL tempArea] = cutAreafunction(DL,  Area, Loc , sum(DL) );
    Model(root).numOfSections = length(tempDL) ;
    Model(root).secLen = tempDL ;
    Model(root).secArea = tempArea ;
    Model2 = Model  ;
    
    [tempDL tempArea] = cutAreafunction(DL,  Area, 0 , Loc );
    Tube_transformed(1).numOfSections = length(tempDL)+1 ;
    Tube_transformed(1).secLen = [tempDL(end:-1:1) 1] ;
    Tube_transformed(1).secArea = [tempArea(end:-1:1) 0] ;
    Model1 = Tube_transformed ;
end


validDiv = 1;
return ;

function [DL1 ,Area1] = cutAreafunction(DL,  Area, x1 , x2 )
for k1 = 1:length(DL)
    if(sum(DL(1:k1))>=x1), break , end
end
for k2 = 1:length(DL)
    if(sum(DL(1:k2))>=x2), break , end
end

if(k1~=k2)
    tempArea = Area( k1:k2) ;
    tempDL = DL(k1:k2);
    %    tempDL(1) = DL(k1)- (sum(DL(1:k1))-x1) ;
    tempDL(1) =  (sum(DL(1:k1))-x1)+eps ;
    tempDL(end) = DL(k2)- (sum(DL(1:k2))-x2) ;
else
    tempArea = Area(k2) ;
    tempDL = x2-x1;
end

ind = find(tempDL~=0) ;
Area1(ind) = tempArea(ind) ; %sum(tempArea.*tempDL)/sum(tempDL) ;
DL1(ind) = tempDL(ind) ; %sum(tempDL) ;

% Area1 = sum(tempArea.*tempDL)/sum(tempDL) ;
% DL1 = sum(tempDL) ;
return ;

