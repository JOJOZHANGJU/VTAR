% function init_vtar(handles) 
%
%*************************************************************************
%  This function is to initialize the data used throughout the program , including:
%   1. addpath
%   2. initialize VT , a data structure to include information of vocal tract
%   3. initialize the arrays for menus
%   4. create toolbars and ruler  (most of ruler and toolbar's callback are from sptool's function in 
%      DSP toolbox and those files are included in .../vtar/m/) 
%
%   xinhui, July 2004
%-------------------------------------------------------------------------
% 
function VT = vtar_init


%---------------------------------
% Add paths for mex and m functions 
%
vtarPath = which( 'vtar_init.m' ) ;
vtarPath = vtarPath( 1 : end-length('vtar_init.m') ) ;  % D:\My Documents\Speech\vtar\vtar.m
                              % delete the last 7 chars to get a path     
addpath(vtarPath) ;
if ispc
%    addpath([vtarPath '\c']) ;  % windows system
    addpath([vtarPath '\m'], 0) ;  % 0 means the path will be in the front of search path
else
%    addpath([vtarPath '/c/unix']) ;   % unix system
%    addpath([vtarPath '/c']) ;   % unix system
    addpath([vtarPath '/m'], 0) ;  % 0 means the path will be in the front of search path
end

VT.vtarPath = vtarPath ;  % remember path for other functions to access file, such as files for
                          % help and generic area function 


%------------------------------------------
% Default value for property of air and wall 
%
VT.PropertyDefault = get_property_default ;  % to get default property
% Property of air and wall
VT.Property.RHO = VT.PropertyDefault{1}.RHO ;  % = 1.14e-3;
VT.Property.MU  = VT.PropertyDefault{1}.MU ;    % = 1.86e-4;
VT.Property.C0  = VT.PropertyDefault{1}.C0 ;    %  = 3.5e4;
VT.Property.CP  = VT.PropertyDefault{1}.CP ;     %= 0.24;
VT.Property.LAMDA  = VT.PropertyDefault{1}.LAMDA ;  %= 5.5e-5;
VT.Property.ETA    = VT.PropertyDefault{1}.ETA ;    %= 1.4;
VT.Property.WALL_L = VT.PropertyDefault{1}.WALL_L ; %= 1.5;
VT.Property.WALL_R = VT.PropertyDefault{1}.WALL_R ; %= 1600;
VT.Property.WALL_K = VT.PropertyDefault{1}.WALL_K ; %= 3e5;
VT.Property.Radiation = 0 ;
VT.Property.Fluid = 1 ;   % Fluid category 1 

VT.Radiation_Load = 'On' ;   % Radiation load is considered


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Glottal waveform parameters  - Default values
%Avinash , August 2005


%-------------------------------------------------------
% The following is for popupmenus in the interface.
%
% setup categories and corresponding model types for each sound 
% so that we can give area function to each model 
VT.Categories  =  {'', 'Vowel', 'Consonant', 'Nasal', '/r/', '/l/', 'Nasalized vowel', 'Arbitrary' } ; % , 'Nasals with sinus'} ;
VT.Model_types =  { {' '};
                  {' ', '1-tube', '2-tube', '3-tube', '4-tube', 'Arbitrary', 'From File'} ; ...
                  {' ', 'Fricative', 'From File'} ; ...
                  {' ', 'Nasal Model', 'From File'} ; ...
                  {' ', '/r/ Model 1',  '/r/ Model 2','From File'} ; ...
                  {' ', '/l/ Model', 'From File'} ; ...
                  {' ', 'NasalizedVowel Model', 'From File'} ; ...
                  {' ', 'Oral Mode', 'Nasal Mode', 'Oral_Nasal Mode', 'From File'} ; ...
                  } ;

% For examples of area function of different sound       
% each item corresponds to a file including the informaton of area function
%VT.Vowel_generic = {'', 'AA', 'AH', 'AO', 'EH', 'EW', 'EY', 'IW', 'IY', 'OE','OH', 'IY_Fant', 'U_Fant' } ;
%VT.Vowel_generic = {'', 'AA', 'AH', 'AO', 'EH', 'EW', 'EY', 'IW', 'IY', 'OE','OH', 'IY_Fant', 'U_Fant','A_Fant', 'I_Fant', 'E_Fant'  } ;
VT.Vowel_generic = {'', 'AA', 'AH', 'AO', 'EH', 'EW', 'EY', 'IW', 'IY', 'OE','OH', 'IY_Fant', 'U_Fant','E_Fant'  } ;

VT.Consonant_generic = {' '} ;
VT.Nasal_generic = {'', 'M', 'N', 'NG' } ; %,  'NASAL1' } ;
VT.r_generic = {'','r_retroflex', 'r_bunched', 'From MRI images'  } ;
VT.l_generic = {'', 'Example_1', 'From MRI images' } ; 
VT.NasalVowel_generic = {' '} ; 
VT.Arbitrary_generic = {' ',  'Oral Example', 'Nasal Example'} ; 

VT.Generic_models =  { {' '};VT.Vowel_generic; VT.Consonant_generic; VT.Nasal_generic; ...
                             VT.r_generic; VT.l_generic; VT.NasalVowel_generic; VT.Arbitrary_generic } ;             

                         VT.Generic_model_text = {'Generic','Generic vowel','Generic Con.','Generic Nasal', ...
                         'Generic /r/','Generic /l/', 'Examples', 'Examples'}  ;            
                     
% location of generic area function for each catogory
if ispc
    VT.generic_areafunctionFolder =  {'', '\areafunction\vowel\', '\areafunction\consonant\',...
                                  '\areafunction\nasal\', '\areafunction\_r\', ...
                                  '\areafunction\_l\', '\areafunction\nasalvowel\' , '\areafunction\arbitrary\'} ;
else
    VT.generic_areafunctionFolder =  {'', '/areafunction/vowel/', '/areafunction/consonant/',...
                                  '/areafunction/nasal/', '/areafunction/_r/', ...
                                  '/areafunction/_l/', '/areafunction/nasalvowel/' , '/areafunction/arbitrary/'} ;
end
VT.generic_af_rFileName = 'areafunction_r.mat' ;

VT.subject = {'MT', 'LH', 'DD', 'SS2', 'BG', ...
    'MF', 'SS1', 'JD', 'JM', 'JC', ...
    'JM2', 'SH', 'MH', 'LC', 'SJ', ...
    'LW', 'AM', 'LK', 'AS', 'TP', ...
    'LP', 'DJ', 'MD' } ; 

% the 7 parameters for articulation model of vowel                 
% UNUSED , INITIALLY intended to include 7-parameters model
VT.Articu_model_7pos = {'Jaw position','Tongue dorsum position','Tongue dorsum shape','Tongue apex position', ...
                         'Lip height (aperture)','Lip protrusion','Larynx height'}  ;          

%-----------------------------------------------------
% For help munu iterms
% get help by reading manual, webpage or sending email
%


VT.Manual      = '\help\vtar1.htm' ;
VT.Online_help = 'http://www.isr.umd.edu/Labs/SCL/vtar/help/' ;
VT.Email       = 'vtar@isr.umd.edu'  ;



%-----------------------------------------------------
%  Initialize the category and model type
% 
VT.CurrentCategory  = 1 ;  % which item is chosen in the menu
VT.CurrentModeltype = 1 ;
VT.CurrentGeneric   = 1 ;

% Initiallization.    this 2 statements just for test of ruler and initialization of plots;
VT.f  = 6000 ;  % 1:6000 ;
VT.AR =  0   ;  % zeros(1, 6000) ; 
VT.AR_sync = 0 ; % speech synthesis 

% Maximum frequency, frequency step, 
% and maximum length of tube subsection in simulation
VT.Fupper =4000 ; % Hz
VT.df = 5 ; % Hz
VT.deltaL = 0.1 ; % 3 ; % cm 
VT.deltaL_sensitivity = 0.3 ; 

VT.maxnumTubes = 30 ; % maximum number of tubes in arbitrary models
VT.maxnumSidebranch = 10 ; % maximum number of side branches in arbitrary models

%----------------------------------------
% Area function setting for each sound 
%
VT = Init_AreaFunction( VT ) ;

% Formant information initilization
for i = 1: 5 
    VT.Formant(i) = 0 ;
    VT.Formant_amp(i) = 0 ;
    VT.Formant_bw(i) = 0 ;
    VT.FormantExpect(i) = 0 ; % used for area function tuning
end

VT.date = [] ;  %  to set the date, this variable is used in Loadfile.m and Savefile.m
return ;





%----------------------------------------
% Area function setting for each sound 
%----------------------------------------
function  VT  = Init_AreaFunction( VT )
% global VT ;

% vowel
VT.Vowel.Geometry.Area = [ 0 ] ;
VT.Vowel.Geometry.DL = [ 0  ] ;
VT.Vowel.Geometry.Type = 1 ;

% consonant
% just for fricative right now
VT.Consonant.Geometry.Area = [ 0 ] ;
VT.Consonant.Geometry.DL = [ 0  ] ;
VT.Consonant.Geometry.ConstrictionLocation = [ 0  ] ;
VT.Consonant.Geometry.Type = 1 ;

% nasal
VT.Nasal.Geometry.Type = 1 ;
VT.Nasal.Geometry.PharynxArea = [ 0 ] ;
VT.Nasal.Geometry.PharynxDL = [ 0  ] ;
VT.Nasal.Geometry.OralArea = [ 0  ] ;
VT.Nasal.Geometry.OralDL = [ 0 ] ;
VT.Nasal.Geometry.NasalBackArea = [ 0  ] ;
VT.Nasal.Geometry.NasalBackDL = [ 0 ] ;
VT.Nasal.Geometry.TwoNostril = [ 1 ] ;
VT.Nasal.Geometry.CoupleArea = [ 0 ] ;

VT.Nasal.Geometry.NostrilArea = [ 0  ] ;
VT.Nasal.Geometry.NostrilDL = [ 0 ] ;

VT.Nasal.Geometry.NostrilArea1 = [ 0  ] ;
VT.Nasal.Geometry.NostrilDL1 = [ 0 ] ;

VT.Nasal.Geometry.NostrilArea2 = [ 0  ] ;
VT.Nasal.Geometry.NostrilDL2 = [ 0 ] ;

% rhotic
VT.Rhotic.Geometry.Type = 1 ;
VT.Rhotic.Geometry.BackArea = [ 0 ] ;
VT.Rhotic.Geometry.BackDL = [ 0 ] ;
VT.Rhotic.Geometry.FrontArea = [ 0  ] ;
VT.Rhotic.Geometry.FrontDL = [ 0 ] ;

VT.Rhotic.Geometry.SublingualArea = [ 0 ] ;
VT.Rhotic.Geometry.SublingualDL = [ 1  ] ;
%VT.Rhotic.Geometry.SublingualOn = [ 0  ] ;
VT.Rhotic.Geometry.SublingualOn = [ 1  ] ;  % corrected , it is consistent with default value in interface, xinhui 03/28/2005

% combine back and front
VT.Rhotic.Geometry.MainArea = [ 0  ] ;
VT.Rhotic.Geometry.MainDL = [ 0 ] ;
VT.Rhotic.Geometry.SublingualLocation = [ 0 ] ;

% Lateral
VT.Lateral.Geometry.Type = 1 ;
VT.Lateral.Geometry.BackArea = [ 0  ] ;
VT.Lateral.Geometry.BackDL = [ 0 ] ;
VT.Lateral.Geometry.LateralArea1 = [ 0 ] ;
VT.Lateral.Geometry.LateralDL1 = [ 0 ] ;
VT.Lateral.Geometry.LateralArea2 = [ 0 ] ;
VT.Lateral.Geometry.LateralDL2 = [ 0 ] ;
VT.Lateral.Geometry.LateralDL = [ 0 ] ;
VT.Lateral.Geometry.LateralArea = [ 0 ] ;
VT.Lateral.Geometry.SupralingualArea = [ 0 ] ;
VT.Lateral.Geometry.SupralingualDL = [ 0 ] ;
VT.Lateral.Geometry.FrontArea = [ 0 ] ;
VT.Lateral.Geometry.FrontDL = [ 0 ] ;
VT.Lateral.Geometry.LateralOn = [ 1  ] ;
VT.Lateral.Geometry.SupralingualOn = [ 1 ] ;

% NasalVowel
VT.NasalVowel.Geometry.Type = 1 ;
VT.NasalVowel.Geometry.PharynxArea = [ 0 ] ;
VT.NasalVowel.Geometry.PharynxDL = [ 0  ] ;
VT.NasalVowel.Geometry.OralArea = [ 0  ] ;
VT.NasalVowel.Geometry.OralDL = [ 0 ] ;
VT.NasalVowel.Geometry.NasalBackArea = [ 0  ] ;
VT.NasalVowel.Geometry.NasalBackDL = [ 0 ] ;
VT.NasalVowel.Geometry.CoupleArea = [ 0 ] ;
VT.NasalVowel.Geometry.TwoNostril = [ 1] ;

VT.NasalVowel.Geometry.NostrilArea = [ 0  ] ;
VT.NasalVowel.Geometry.NostrilDL = [ 0 ] ;

VT.NasalVowel.Geometry.NostrilArea1 = [ 0  ] ;
VT.NasalVowel.Geometry.NostrilDL1 = [ 0 ] ;

VT.NasalVowel.Geometry.NostrilArea2 = [ 0  ] ;
VT.NasalVowel.Geometry.NostrilDL2 = [ 0 ] ;

% Arbitrary type 
VT.Arbitrary.Geometry.Mode = 0 ;
for i = 1: VT.maxnumTubes
    VT.Arbitrary.Geometry.Tube(i).IndexOfBranch = [ -1 ] ;
    VT.Arbitrary.Geometry.Tube(i).typeOfModule  = [ 1 ] ;
    VT.Arbitrary.Geometry.Tube(i).typeOfStartofTube = [ 1 ] ;
    VT.Arbitrary.Geometry.Tube(i).typeOfEndofTube   = [ 1 ] ;
    VT.Arbitrary.Geometry.Tube(i).numOfSections = [ 0 ] ;
    VT.Arbitrary.Geometry.Tube(i).secLen = zeros(1, 200) ;
    VT.Arbitrary.Geometry.Tube(i).secArea = zeros(1, 200) ;
    VT.Arbitrary.Geometry.Tube(i).numOfSections1 = [ 0 ] ;
    VT.Arbitrary.Geometry.Tube(i).secLen1 = zeros(1, 200) ;
    VT.Arbitrary.Geometry.Tube(i).secArea1 = zeros(1, 200) ;
    VT.Arbitrary.Geometry.Tube(i).nextBranches = zeros(1, 10) ;
    VT.Arbitrary.Geometry.Tube(i).nextBranchesLoc =  ones(1, 10) ;
    % VT.Arbitrary.Geometry.Tube(i).nextBranchesLoc =  zeros(1, 10) ;
    VT.Arbitrary.Geometry.Tube(i).nextBranchesLocEnd =  zeros(1, 10) ;
    VT.Arbitrary.Geometry.Tube(i).nextBranchesLocChannel =  ones(1, 10) ;
    
end

return ;



%------------------------------------------------------
%  read default property of wall and air from a file 
%
function PropertyDefault = get_property_default() 
File = 'property.txt' ;

% the following default values are used in case File format is wrong
PropertyDefault{1}.Fluid = 'Air' ;
PropertyDefault{1}.RHO    = 1.14e-3;  % Air density (Unit: g/cm^3)
PropertyDefault{1}.MU     = 1.86e-4;  % Air viscosity (Unit: dyne.s/cm^2 )
PropertyDefault{1}.C0     = 3.5e4;    % Sound speed in air (Unit: cm/s)
PropertyDefault{1}.CP     = 0.24;     % Specific heat of air (Unit: cal/g.k)
PropertyDefault{1}.LAMDA  = 5.5e-5;   % Heat conduction of air (Unit: cal/s.cm.k)
PropertyDefault{1}.ETA    = 1.4;      % 
PropertyDefault{1}.WALL_L = 1.5;      % Wall mass per unit length (Unit: g/cm)
PropertyDefault{1}.WALL_R = 1600;     % Wall resistance (Unit: dyne.s/cm^2)
PropertyDefault{1}.WALL_K = 3e5;      % Wall stiffness (Unit: dyne/cm^2)

fid = fopen(File);
if(fid == -1) % file can not be found 
      errordlg('File for fluid property can not be found ', 'Error') ;  return ;
end

% start reading data from file
%---------------------------------
% skip the comments area in file
a = fscanf(fid,'%c', 1) ;  
while a ~= ']'
    a = fscanf(fid,'%c',1) ;
    if(feof(fid))
        errordlg('File format error', 'Error') ;  return ;
    end
end

i = 1 ;
while 1
    String = 'Fluid:'  ;
    % look for String in file , and then read from there
    a = fscanf(fid,'%s', 1) ;  % 
    while ~isequal(a, String)  % find 'Fluid:'
        a = fscanf(fid,'%s',1) ;
        if(feof(fid)) % reach the end of file
            if (i==1), errordlg('File format error', 'Error') ;  return ;  % if i==1 means no record is found
            else 
                % after this, wall property is read from file
                for temp = 1: i-1 
                    frewind(fid) ;
                    PropertyDefault{temp}.WALL_L  =   get_data('WALL_L', fid) ;      % Wall mass per unit length (Unit: g/cm)
                    PropertyDefault{temp}.WALL_R  =   get_data('WALL_R', fid) ;    % Wall resistance (Unit: dyne.s/cm^2)
                    PropertyDefault{temp}.WALL_K  =   get_data('WALL_K', fid) ;      % Wall stiffness (Unit: dyne/cm^2)
                end ;
                    return ;
            end
        end
    end
    
    PropertyDefault{i}.Fluid = fscanf(fid,'%s', 1) ;  
    PropertyDefault{i}.RHO   =   get_data('RHO', fid) ;  % 1.14e-3;  % Air density (Unit: g/cm^3)
    PropertyDefault{i}.MU    =   get_data('MU', fid) ;  % Air viscosity (Unit: dyne.s/cm^2 )
    PropertyDefault{i}.C0    =   get_data('C0', fid) ;  % Sound speed in air (Unit: cm/s)
    PropertyDefault{i}.CP    =   get_data('CP', fid) ;  % Specific heat of air (Unit: cal/g.k)
    PropertyDefault{i}.LAMDA =   get_data('LAMDA', fid) ;  % Heat conduction of air (Unit: cal/s.cm.k)
    PropertyDefault{i}.ETA   =   get_data('ETA', fid) ;    
    i = i+1 ;  % next type of fluid 
end

return ;



%function [j, tempLength, tempArea] = get_data(Category, String, File, Datatype) ;  % get data from file
%---------------------------------------------
% read data following the 'String' in file 'fid'
% remember that the pointer in fid is not reset and will not start
% searching from the beginning of the file, that is how several types of
% fluid's properties can be obtained without confusion
%
function [varargout] = get_data(String, fid)  % get data from file varargout

    % set a default value in case there is an error in file format
    varargout{1} = 1 ;
    
    % look for String, then read from there
    a = fscanf(fid,'%s', 1) ;  % skip 4 chars just for the format in madea's area function file
    while ~isequal(a, String)
        a = fscanf(fid,'%s',1) ;
        if(feof(fid))
            errordlg(['File format error:' String  'NOT FOUND'], 'Error') ;  return ;
        end
    end
    
    % look for value of 'String'
    temp = fscanf(fid,'%f', 1) ;
    if (isempty(temp))
        errordlg(['File format error:' String  ' ''s VALUE NOT FOUND'], 'Error') ;  
        return ;
    else
        varargout{1} = temp ;   
    end
return ;

