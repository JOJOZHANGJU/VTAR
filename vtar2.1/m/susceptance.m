function [f, B] = susceptance(Model) 
global VT ; 
ORAL_MODE = 1 ; % it does not matter since AR is not used, only Z is used here
%        [f, AR, Z] = arbitray_model(VT.Fupper, VT.df, VT.deltaL, ORAL_MODE, Model, VT.Property) ;
        [f, AR, Z] = arbitray_model(VT.Fupper, 1, VT.deltaL, ORAL_MODE, Model, VT.Property) ;
        B = 1./Z ; 
return ;


%-----------------------------------------------------------------
function [f, AR, Z] = arbitray_model(Fupper, df, deltaL, mode, currentTube_Calc1, Property)
global VT ;

global currentTube_Calc

global loopTest_Calc  % for check loop exist staring from glottis
global endLips  endNostril1  endNostril2  % for check the duplicate tubes with lips, nostrils, used in plotNode() in this file

f = 6000 ;
AR = 0 ;
endLips = 0 ;  % for test if lips exist in tube configuration
endNostril1 = 0 ; % for test if Nostril1 exist in tube configuration
endNostril2 = 0 ;

% constants
ORAL_MODE = 2 ;
NASAL_MODE = 3 ;
ORALNASAL_MODE = 4 ;
FRICATIVE_MODE = 5 ;

TWOCHANNELS = 2 ;
GLOTTIS = 2 ;
LIPS = 2 ;
NOSTRIL1 = 3 ;
NOSTRIL2 = 4 ;
END = 99900000  ;
CHANNEL_1 =  20000000 ;
CHANNEL_2 =  40000000 ;

currentTube_Calc  = [] ;
currentTube_Calc  = currentTube_Calc1 ;
root = 0 ;

% find the first tube staring from glottis ;
% find the root of tree
maxnumTubes = length(currentTube_Calc) ;
loopTest_Calc = ones(1, maxnumTubes ) ;
for i = 1: maxnumTubes
    if(currentTube_Calc(i).typeOfStartofTube == GLOTTIS)
        if(root~=0)  % root ~=0 means that other tube also has starting point from glottis
            errordlg(['Just one tube can start from glottis: ' 'branch ' num2str(root) ' or   branch ' num2str(i) ], 'error', 'modal') ;
            return ;
        else
            root = i ;
            if(currentTube_Calc(i).secArea(1)<=0)
                errordlg(['The tube starting from glottis can not have zero area at the beginning : branch ' num2str(root) ], 'error', 'modal') ;
                return ;
            end
        end
    end
end

% check if any tube starts from GLOTTIS
if (root == 0)
    errordlg(['NO tube is defined to start from GLOTTIS '], 'error', 'modal') ;
    return ;
end

% adjust the location information
% subdivide the length of area function to get good accuracy of calculation
currentTube_Calc = modifyAreafunctionArbitrary(root, currentTube_Calc, deltaL) ;


% recall the mex function to calculate the acoustic response
%[f, AR, Z] = vtar_calc_mex_z1(Fupper, df, mode , root, currentTube_Calc, Property, VT.Z) ;

% for susceptance plot, we may have to get rid of resistance in the vocal
% tract transmission line 
%[f, AR, Z] = vtar_calc_mex_z1(Fupper, df, mode , root, currentTube_Calc, Property) ; % may have to neglect real part of everything . 
[f, AR, Z] = vtar_calc_mex_z2(Fupper, df, mode , root, currentTube_Calc, Property) ; % may have to neglect real part of everything . 
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


% to get smaller sections to ensure the accuracy of calculation
function Output = modifyAreafunctionArbitrary(root, Tube, dL)
global VT ;
TWOCHANNELS = 2 ;

% subdivide the tube to get better accurary in simulation result
[secLen secArea] = divide(Tube(root).secLen(( 1:Tube(root).numOfSections)) ,Tube(root).secArea(( 1:Tube(root).numOfSections)) , dL) ;
Tube(root).secLen  = secLen  ;
Tube(root).secArea = secArea ;
Tube(root).numOfSections = length(secLen) ;
if((Tube(root).typeOfModule==TWOCHANNELS))
    [secLen secArea] = divide(Tube(root).secLen1(( 1:Tube(root).numOfSections1)) ,Tube(root).secArea1(( 1:Tube(root).numOfSections1)) , dL ) ;
    Tube(root).secLen1  = secLen  ;
    Tube(root).secArea1 = secArea ;
    Tube(root).numOfSections1 = length(secLen) ;
end

for i = 1: length(Tube(root).nextBranches)
    if(Tube(root).nextBranches(i) ~= 0)  % one branch
        Tube = modifyAreafunctionArbitrary(Tube(root).nextBranches(i), Tube, dL) ;
    end
end

Output = Tube ;
return ;
