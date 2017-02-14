% function savefile
%   This function is to save all the information of vocal tract into 
% 2 files, one is .mat file and the other one is .txt 
% .mat file can be loaded into the program easily , .txt has area function
% information as area function file format but with more information on
% other settings such as fluid property. 
%
% These 2 saved file can be loaded into VTAR , see /m/loadfile.m
% 
%  Last updated: 06/02/2004, by xinhui, zhou
%----------------------------------

function savefile(varargin)
global VT ;

if(nargin==1)  % to save a plot
    saveplot(varargin{:}) ;
    return ;
end

VT.date = datestr(now, 0) ;

% remember the old folder
old_dir = pwd ;

% go to /users path
if ~(exist([VT.vtarPath '/users'], 'dir'))
     errordlg('folder /users/ missing ', 'Error', 'modal') ; 
else
     cd([VT.vtarPath '/users']) ;
end

% get file name 
[filename, pathname] = uiputfile( ...
    {'*.mat';'*.*'}, ...
    'Save');	
% If 'Cancel' was selected then return


% return to the old folder
cd(old_dir) ;


% .mat file saved
if isequal([filename,pathname],[0,0])
    return
else
    % avoid file name with '.'
    Ind = find(filename=='.') ;
    if(~isempty(Ind))
        filename = filename(1:Ind(1)-1) ;  % just get the characters before '.'
        if(isempty(filename))
            return ;
        end
    end ;
    
    % Construct the full path and save
    File = fullfile(pathname,filename);
    VTsaved = VT ;
    try 
        save(File,'VTsaved')
    catch
        errordlg('Save operation failed ! please check if you have write permission on the disk.', 'Error', 'modal') ;  
        return ;
    end
%    handles.LastFile = File;
%    guidata(h,handles)
end


% save figure , especially for the plots being held
% if some plots are being held , they should be saved so that when user
% load file .mat , they can be loaded also.
Ind = find(File=='.') ;

%if(isempty(Ind))
    File1 = [File(1:end) '.fig'] ;
%else
%    File = [File(1:Ind(end)-1) '.fig'] ;
%end


% ud = get(VT.handles.vtar,'userdata');
% hgsave(ud.ht.a(:), File)
 hgsave(VT.handles.vtar, File1)




% .txt file saved
% save other area function informaiton and also property .....
Ind = find(File=='.') ;
% if(isempty(Ind))
%     File2 = [File(1:end) '.txt'] ;
% else
%     File = [File(1:Ind(end)-1) '.txt'] ;
% end
     File2 = [File(1:end) '.txt'] ;

% open .txt file
[fid, message]  = fopen(File2, 'w') ;
if(fid == -1)
     errordlg(['File save error!' File ' ' message], 'Error', 'modal') ;  return ;
end

if(VT.CurrentCategory == 8) % arbitrary
    saveArbitrary(fid) ;
    fclose(fid) ;
    return ;
end

% comments in the file
fprintf(fid, '%s\n', '[') ;
fprintf(fid, '%s\n\n', VT.date) ;
fprintf(fid, '%s\n', ' comments are added here') ;
fprintf(fid, '%s\n', ' this is a saved file for area function and also other information on vocal tract modelling ') ;
fprintf(fid, '%s\n', ' The first parts are similiar to area function file, but this file also includes formants and property of fluid information') ;
fprintf(fid, '%s\n', ']') ;
fprintf(fid, '\n', ' ') ;

% save Category_Selection: and  Model_Selection:
Category = VT.CurrentCategory-1 ;
if(Category<1)
     fclose(fid) ;
     warndlg('No much information needed to be saved', 'warn ', 'modal') ;  return ;
     return ;  % 7 means arbitrary
end

Category_list = {'[1] Vowel', '[2] Consonant', '[3] Nasal', '[4] /r/', '[5] /l/', '[6] Nasalized_vowel', '[7]arbitrary'} ;

fprintf(fid, '%s \n', ['Category_Selection: ' num2str(Category)]) ;

switch Category
    case 1
        fprintf(fid, '%s \n', ['Model_Selection: ' num2str(VT.Vowel.Geometry.Type)]) ;        
        fprintf(fid, '\n%s \n\n', Category_list{Category}) ;   
        % data
        print2file(fid, VT.Vowel.Geometry.DL, VT.Vowel.Geometry.Area ) ;
    
    case 2
        fprintf(fid, '%s \n\n ', ['Model_Selection: ' num2str(VT.Consonant.Geometry.Type)]) ;        
        fprintf(fid, '%s\n\n', Category_list{Category}) ;   
        % data
        print2file(fid, VT.Consonant.Geometry.DL, VT.Consonant.Geometry.Area ) ;
        
        fprintf(fid, '\n%s\n', ['''Constriction_Location''  '  num2str(VT.Consonant.Geometry.ConstrictionLocation)]) ;      
    
        
    case 3
        fprintf(fid, '%s \n\n ', ['Model_Selection: ' num2str(VT.Nasal.Geometry.Type)]) ;      
        fprintf(fid, '%s \n\n', Category_list{Category}) ;   
        
        % data
        % if(num2str(VT.Nasal.Geometry.TwoNostril))
        if(VT.Nasal.Geometry.TwoNostril == 1)
            fprintf(fid, '%s\n\n', ['''number_of_Nostril''  ' num2str(2)]) ;      
        else
            fprintf(fid, '%s\n\n', ['''number_of_Nostril''  ' num2str(1)]) ;      
        end
        
        fprintf(fid, '%s\n\n', ['''CoupleArea''  '  num2str(VT.Nasal.Geometry.CoupleArea)]) ;      
 

        fprintf(fid, '%s\n', ['''Back''']) ; 
        print2file(fid, VT.Nasal.Geometry.PharynxDL, VT.Nasal.Geometry.PharynxArea ) ;
        fprintf(fid, '\n%s \n' ,['''Oral''']) ; 
        print2file(fid, VT.Nasal.Geometry.OralDL ,VT.Nasal.Geometry.OralArea) ;
        fprintf(fid, '\n%s \n' ,['''Velar_tube''']) ; 
        print2file(fid, VT.Nasal.Geometry.NasalBackDL, VT.Nasal.Geometry.NasalBackArea) ;
        fprintf(fid, '\n%s \n' ,['''Nostril_1''']) ; 
        print2file(fid, VT.Nasal.Geometry.NostrilDL1,VT.Nasal.Geometry.NostrilArea1) ;
        fprintf(fid, '\n%s \n' ,['''Nostril_2''']) ; 
        print2file(fid, VT.Nasal.Geometry.NostrilDL2,VT.Nasal.Geometry.NostrilArea2) ;

    case 4
        fprintf(fid, '%s\n\n ', ['Model_Selection: ' num2str(VT.Rhotic.Geometry.Type)]) ;    
        fprintf(fid, '\n%s \n', Category_list{Category}) ;   
        % data
        fprintf(fid, '%s\n', ['''Sublingual_on_or_off''  ' num2str(VT.Rhotic.Geometry.SublingualOn)]) ;      
 
        fprintf(fid, '\n%s \n',['''Back''']) ; 
        print2file(fid, VT.Rhotic.Geometry.BackDL, VT.Rhotic.Geometry.BackArea ) ;
        fprintf(fid, '\n%s \n',['''Front''']) ; 
        print2file(fid, VT.Rhotic.Geometry.FrontDL, VT.Rhotic.Geometry.FrontArea ) ;
        fprintf(fid, '\n%s \n',['''Main''']) ; 
        print2file(fid, VT.Rhotic.Geometry.MainDL, VT.Rhotic.Geometry.MainArea ) ;
        fprintf(fid, '\n%s \n',['''Sublingual''']) ; 
        print2file(fid, VT.Rhotic.Geometry.SublingualDL, VT.Rhotic.Geometry.SublingualArea) ;
        
        fprintf(fid, '\n%s\n', ['''SublingualLocation''  '  num2str(VT.Rhotic.Geometry.SublingualLocation)]) ;      
        
    case 5
        fprintf(fid, '%s\n\n ', ['Model_Selection: ' num2str(VT.Lateral.Geometry.Type)]) ;      
        fprintf(fid, '%s \n', Category_list{Category}) ;   
        
        % data
        fprintf(fid, '\n%s \n', ['''Number_of_Channels''  ' num2str(VT.Lateral.Geometry.LateralOn)]) ;      
        fprintf(fid, '%s \n', ['''Supralingual_on_or_off''  '  num2str(VT.Lateral.Geometry.SupralingualOn)]) ;      

        fprintf(fid, '\n%s \n',['''Supralingual''']) ; 
        print2file(fid, VT.Lateral.Geometry.SupralingualDL ,VT.Lateral.Geometry.SupralingualArea ) ;
        fprintf(fid, '\n%s \n',['''Back''']) ; 
        print2file(fid, VT.Lateral.Geometry.BackDL, VT.Lateral.Geometry.BackArea ) ;
        fprintf(fid, '\n%s \n',['''Front''']) ; 
        print2file(fid, VT.Lateral.Geometry.FrontDL, VT.Lateral.Geometry.FrontArea ) ;

        fprintf(fid, '\n%s \n',['''Channel1''']) ; 
        print2file(fid, VT.Lateral.Geometry.LateralDL1, VT.Lateral.Geometry.LateralArea1) ;
        fprintf(fid, '\n%s \n',['''Channel2''']) ; 
        print2file(fid, VT.Lateral.Geometry.LateralDL2, VT.Lateral.Geometry.LateralArea2) ;

 
    case 6
        fprintf(fid, '%s\n\n ', ['Model_Selection: ' num2str(VT.NasalVowel.Geometry.Type)]) ;      
        fprintf(fid, '%s \n', Category_list{Category}) ;   
%        fprintf(fid, '%s ', ['Model_Selection: ' num2str(VT.NasalVowel.Geometry.Type)]) ;      
        
        % data
        % fprintf(fid, '%s \n', ['''number_of_Nostril''  ' num2str(VT.NasalVowel.Geometry.TwoNostril)]) ;      
        if(VT.NasalVowel.Geometry.TwoNostril == 1)
            fprintf(fid, '%s\n', ['''number_of_Nostril''  ' num2str(2)]) ;      
        else
            fprintf(fid, '%s\n', ['''number_of_Nostril''  ' num2str(1)]) ;      
        end

        fprintf(fid, '%s \n', ['''CoupleArea''  '  num2str(VT.NasalVowel.Geometry.CoupleArea)]) ;      
 

        fprintf(fid, '\n%s \n',['''Back''']) ; 
        print2file(fid, VT.NasalVowel.Geometry.PharynxDL, VT.NasalVowel.Geometry.PharynxArea ) ;
        fprintf(fid, '\n%s \n',['''Oral''']) ; 
        print2file(fid, VT.NasalVowel.Geometry.OralDL ,VT.NasalVowel.Geometry.OralArea) ;
        fprintf(fid, '\n%s \n',['''Velar_tube''']) ; 
        print2file(fid, VT.NasalVowel.Geometry.NasalBackDL, VT.NasalVowel.Geometry.NasalBackArea) ;
        fprintf(fid, '\n%s \n',['''Nostril_1''']) ; 
        print2file(fid, VT.NasalVowel.Geometry.NostrilDL1,VT.NasalVowel.Geometry.NostrilArea1) ;
        fprintf(fid, '\n%s \n',['''Nostril_2''']) ; 
        print2file(fid, VT.NasalVowel.Geometry.NostrilDL2,VT.NasalVowel.Geometry.NostrilArea2) ;
    case 7
        
        
    otherwise
     errordlg('File save error, wrong category ', 'Error', 'modal') ;  
end

% printing property and formant
printProperty(fid);
printFormant(fid) ;
fclose(fid) ;


VT.date = [] ;   %datestr(now, 0) ;
return ;


% print data from one part of vocal tract
%-----------------------------------------
function  print2file(fid, DL, Area) 
        fprintf(fid, '%s \n', num2str(length(DL))) ;
        fprintf(fid, '%s \n', num2str((DL))) ;
        fprintf(fid, '%s \n', num2str((Area))) ;
return ;


% print data of wall and fluid property into file
%--------------------------------------------------
function printProperty(fid)
global VT ;
fprintf(fid, '\n%s ', 'Property of fluid:') ;        
        fprintf(fid, '\n%-20s ', ['RHO  ' num2str(VT.Property.RHO)]) ;  fprintf(fid, '%s ', '      % Air density (Unit: g/cm^3)') ;        
        fprintf(fid, '\n%-20s ', ['MU   ' num2str(VT.Property.MU)]) ;  fprintf(fid, '%s ', '      %  Air viscosity (Unit: dyne.s/cm^2 )') ;                
   
        fprintf(fid, '\n%-20s ', ['C0   ' num2str(VT.Property.C0)]) ;  fprintf(fid, '%s ', '      %  Sound speed in air (Unit: cm/s)') ;     
        fprintf(fid, '\n%-20s ', ['CP   ' num2str(VT.Property.CP)]) ;    fprintf(fid, '%s ', '      %  Specific heat of air (Unit: cal/g.k)') ;               
        fprintf(fid, '\n%-20s ', ['LAMDA' num2str(VT.Property.LAMDA)]) ;     fprintf(fid, '%s ', '      % Heat conduction of helium  (Unit: cal/s.cm.k)') ;        
        fprintf(fid, '\n%-20s ', ['ETA  ' num2str(VT.Property.ETA)]) ;          fprintf(fid, '%s ', '      % adiabatic constant') ;        

 fprintf(fid, '\n\n%s ', 'Property of wall:') ;        
       fprintf(fid, '\n%-20s ', ['WALL_L ' num2str(VT.Property.WALL_L)]) ;          fprintf(fid, '%s ', '     % Wall mass per unit length (Unit: g/cm)') ;        
       fprintf(fid, '\n%-20s ', ['WALL_R ' num2str(VT.Property.WALL_R)]) ;          fprintf(fid, '%s ', '      % Wall resistance (Unit: dyne.s/cm^2)') ;        
       fprintf(fid, '\n%-20s ', ['WALL_K ' num2str(VT.Property.WALL_K)]) ;          fprintf(fid, '%s ', '      % Wall stiffness (Unit: dyne/cm^2)') ;        

switch lower(VT.Radiation_Load)
    case 'on'
       fprintf(fid, '\n%-20s ', ['Radiation:  On']) ; 
    case 'off'
       fprintf(fid, '\n%-20s ', ['Radiation:  Off']) ; 
end

return ;



% print data of formants into file
%--------------------------------------------------
function printFormant(fid)
global VT 
% display on matlab also
fprintf(fid, '\n\n\n%s\n', 'Formant      frequency(Hz)     amplitude(dB)     bandwith(Hz)') ;
for i = 1: 5 
    if(VT.Formant(i)~=0)
        fprintf(fid, '%s\n', [ 'F' num2str(i) '            '  num2str(VT.Formant(i))   '            '  num2str(VT.Formant_amp(i)) '            '  num2str(VT.Formant_bw(i))]) ;
    end
end

return ;


% save arbitrary type of sound
function  saveArbitrary(fid)
global VT ;
Tube = VT.Arbitrary.Geometry.Tube ;

TWOCHANNELS = 2 ;

modeString = {'', 'Oral', 'Nasal', 'OralNasal'} ;
typeOfModuleString = {' ', 'TWOCHANNELS'} ;
typeOfStartofTubeString = {' ', 'GLOTTIS'} ;
typeOfEndofTubeString = {' ', 'LIPS', 'NOSTRIL1', 'NOSTRIL2'} ;


% write down some help informaiton from /areafunction/template3.are
if ispc
    helpFile = [VT.vtarPath '\areafunction\template3.are'] ;
else
    helpFile = [VT.vtarPath '/areafunction/template3.are'] ;
end
% copy the first several lines form /tmeppalte3.are
if exist(helpFile) == 2
    fidHelpFile = fopen(helpFile) ;
    if(fidHelpFile ~= -1) % file open successful
        for i = 1: 32
            tempString =  fgets(fidHelpFile);
            fprintf(fid, '%s\n', tempString ) ;
        end
        fclose(fidHelpFile) ;
    end
end

tempString = datestr(now, 0) ;
fprintf(fid, '%s\n\n\n', ['%  date : '  tempString ] ) ;


Mode = VT.Arbitrary.Geometry.Mode ;
fprintf(fid, '%s\n\n', ['<Mode> ', modeString{Mode}] ) ;

maxnumTubes = length(Tube) ;
for i = 1: maxnumTubes
    if(Tube(i).numOfSections <= 0) 
        continue ;
    end
%    fprintf(fid, '%s\n', ['     <indexOfBranch>  ', num2str(Tube(i).IndexOfBranch)] ) ;
    fprintf(fid, '%s\n', ['     <indexOfBranch>  ', num2str(i)] ) ;
    fprintf(fid, '%s\n', ['<typeOfStartofTube>  ', typeOfStartofTubeString{Tube(i).typeOfStartofTube}] ) ;
    fprintf(fid, '%s\n', ['<typeOfEndofTube>  ', typeOfEndofTubeString{Tube(i).typeOfEndofTube}] ) ;
    fprintf(fid, '%s\n', ['<typeOfModule>  ', typeOfModuleString{Tube(i).typeOfModule}] ) ;

    ind = find(Tube(i).nextBranches ~= 0) ;   
    fprintf(fid, '%s\n', ['<nextBranches> ',  num2str(Tube(i).nextBranches(ind(:)))] ) ;
    fprintf(fid, '%s  ', ['<nextBranchesLocation> '] ) ;
    for j = 1: length(ind)
        if (Tube(i).nextBranchesLocEnd(ind(j)) == 1)
            fprintf(fid, ' %s ', ['END'] ) ;
        elseif (Tube(i).typeOfModule == TWOCHANNELS)
            if (Tube(i).nextBranchesLocChannel(ind(j)) == 1)
                fprintf(fid, ' %s ', ['CHANNEL1 ' num2str(Tube(i).nextBranchesLoc(ind(j)))] ) ;
            else
                fprintf(fid, ' %s ', ['CHANNEL2 ' num2str(Tube(i).nextBranchesLoc(ind(j)))] ) ;
            end
        else
           fprintf(fid, ' %s ', num2str(Tube(i).nextBranchesLoc(ind(j))) ) ; 
        end
    end
    fprintf(fid, '%s\n', [' '] ) ;

    
    
    fprintf(fid, '%s\n', ['<numOfSections>  ', num2str(Tube(i).numOfSections)] ) ;
    fprintf(fid, '%s\n', ['<secLen>  ',  num2str(Tube(i).secLen(1:Tube(i).numOfSections))] ) ;
    fprintf(fid, '%s\n', ['<secArea> ',  num2str(Tube(i).secArea(1:Tube(i).numOfSections))] ) ;
    if(Tube(i).typeOfModule == TWOCHANNELS)
        fprintf(fid, '%s\n', ['<numOfSections>  ', num2str(Tube(i).numOfSections1)] ) ;
        fprintf(fid, '%s\n', ['<secLen>  ',  num2str(Tube(i).secLen1(1:Tube(i).numOfSections1))] ) ;
        fprintf(fid, '%s\n', ['<secArea> ',  num2str(Tube(i).secArea1(1:Tube(i).numOfSections1))] ) ;
    end
    
    fprintf(fid, '%s\n\n', [' '] ) ;
            
end

% printing property and formant
printProperty(fid);
printFormant(fid) ;

return ;






function    saveplot(varargin) ;
global VT ;
h = varargin{1} ;

% remember the old folder
old_dir = pwd ;

% go to /users path
if ~(exist([VT.vtarPath '/users'], 'dir'))
     errordlg('folder /users/ missing ', 'Error', 'modal') ; 
else
     cd([VT.vtarPath '/users']) ;
end

% get file name 
[filename, pathname] = uiputfile( ...
    {'*.fig';'*.*'}, ...
    'Save');	
% If 'Cancel' was selected then return


% return to the old folder
cd(old_dir) ;

% get full filename and path
if isequal([filename,pathname],[0,0])
    return
else
    % Construct the full path and save
    File = fullfile(pathname,filename);
end
Ind = find(File=='.') ;
if(isempty(Ind))
    File = [File(1:end) '.fig'] ;
end

ud = get(VT.handles.vtar,'userdata');
% ind = find(ud.ht.a==h) ;
% if (~isempty(ind))
%     hgsave(h, FILE) ;
% end
tempHandle = copyobj(ud.mainaxes, gcf) ;
set(tempHandle, 'units', 'normalized', 'position', [0.2 0.2 0.6 0.6]) ;
hgsave(tempHandle, File) ;  % the one with read color
delete (tempHandle) ;

% find which plot for saving 

% save plot as figure file


return ;



% ----------- end of file -------------------------

% 
% 
% 
% 
% 
% % nasal
% 
% % VT.Nasal.Geometry.NostrilDL = [ 0; 0 ] ;
% % VT.Nasal.Geometry.NostrilArea = [ 0; 0  ] ;
% % VT.AreaFunction.Settings.Nasal{1} =  {'', 'Pharynx', 'Oral', 'Back', 'Nostril_1', 'Nostril_2' } ; 
% % VT.AreaFunction.Settings.Nasal{2} =  {'', 'Pharynx', 'Oral', 'Back', 'Nostril'} ; 
% % VT.AreaFunction.Settings.PlotContextMenu.Nasal =  {'Acoustic Response' 'Pharynx', 'Oral', ...
% %                                                    'Back', 'Nostril_1', 'Nostril_2','Schematic' } ; 
% 
% % rhotic
% 
% % VT.AreaFunction.Settings.Rhotic{1} =  {'', 'Front', 'Back', 'Sublingual'} ; 
% % VT.AreaFunction.Settings.Rhotic{2} =  {'', 'Front', 'Back'} ;
% % VT.AreaFunction.Settings.PlotContextMenu.Rhotic = {'Acoustic Response', 'Front', 'Back', 'Sublingual', 'Schematic'} ; 
% % Lateral
% % VT.AreaFunction.Settings.Lateral{1} =  {'', 'Front', 'Back', 'Channel1', 'Channel2', 'Supralingual' } ;
% % VT.AreaFunction.Settings.Lateral{2} =  {'', 'Front', 'Back', 'Channel', 'Supralingual' } ;
% % VT.AreaFunction.Settings.Lateral{3} =  {'', 'Front', 'Back', 'Channel1', 'Channel2' } ;
% % VT.AreaFunction.Settings.Lateral{4} =  {'', 'Front', 'Back', 'Channel' } ;
% % VT.AreaFunction.Settings.PlotContextMenu.Lateral = {'Acoustic Response', 'Front', 'Back', 'Channel1',...
% %                                                     'Channel2', 'Supralingual', 'Schematic' } ;
% 
% % NasalVowel
% VT.NasalVowel.Geometry.Type = 1 ;
% VT.NasalVowel.Geometry.PharynxArea = [ 0 ] ;
% VT.NasalVowel.Geometry.PharynxDL = [ 0  ] ;
% VT.NasalVowel.Geometry.OralArea = [ 0  ] ;
% VT.NasalVowel.Geometry.OralDL = [ 0 ] ;
% VT.NasalVowel.Geometry.NasalBackArea = [ 0  ] ;
% VT.NasalVowel.Geometry.NasalBackDL = [ 0 ] ;
% VT.NasalVowel.Geometry.CoupleArea = [ 0 ] ;
% VT.NasalVowel.Geometry.TwoNostril = [ 0 ] ;
% 
% VT.NasalVowel.Geometry.NostrilArea = [ 0  ] ;
% VT.NasalVowel.Geometry.NostrilDL = [ 0 ] ;
% 
% VT.NasalVowel.Geometry.NostrilArea1 = [ 0  ] ;
% VT.NasalVowel.Geometry.NostrilDL1 = [ 0 ] ;
% 
% VT.NasalVowel.Geometry.NostrilArea2 = [ 0  ] ;
% VT.NasalVowel.Geometry.NostrilDL2 = [ 0 ] ;
% 
% return ;
% 
% % PropertyDefault {}
% function PropertyDefault = get_property_default() 
% File = 'property.txt' ;
% 
% % the following values are used in case File format is wrong
% PropertyDefault{1}.Fluid = 'Air' ;
% PropertyDefault{1}.RHO    = 1.14e-3;  % Air density (Unit: g/cm^3)
% PropertyDefault{1}.MU     = 1.86e-4;  % Air viscosity (Unit: dyne.s/cm^2 )
% PropertyDefault{1}.C0     = 3.5e4;    % Sound speed in air (Unit: cm/s)
% PropertyDefault{1}.CP     = 0.24;     % Specific heat of air (Unit: cal/g.k)
% PropertyDefault{1}.LAMDA  = 5.5e-5;   % Heat conduction of air (Unit: cal/s.cm.k)
% PropertyDefault{1}.ETA    = 1.4;      % 
% PropertyDefault{1}.WALL_L = 1.5;      % Wall mass per unit length (Unit: g/cm)
% PropertyDefault{1}.WALL_R = 1600;     % Wall resistance (Unit: dyne.s/cm^2)
% PropertyDefault{1}.WALL_K = 3e5;      % Wall stiffness (Unit: dyne/cm^2)
% 
% 
% Model = 
% 
% 
%     'number_of_Nostril'  2                   [2  or 1, if 1, then only Nostril_1 valid]
% 
%     'Pharynx' 
%         6 
%         0.34144     0.34046     0.35342     0.35071     0.40743     0.25022 
%         2.6719      2.9443      3.5288      3.8672      4.2583      4.2583 
%    
%     'Oral' 
%         24 
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
%         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
%         
%     'Back'
%         21
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
%         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
% 
%     'Nostril_1'
%         44 
%         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
%         2.132      1.9685      1.5495      1.3589      1.4344      1.6343       1.829      2.0331      2.1922      2.2865      2.4341      2.7089      2.8467      2.7493      2.7317      2.7377      2.7133      2.7037       2.704      2.8742      3.0156      3.0347      3.0105      2.8988       3.075      3.4037      3.6348      3.7974      3.5667       3.006      2.4878      2.0335      1.7394      1.5284      1.3417      1.2902      1.2656      1.1251     0.87207      0.6583     0.52972     0.51318     0.44172     0.32854 
% 
%      'Nostril_2'
%         44 
%         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
%         1.8722      2.0538      1.8646      1.4988      1.4006       1.527       1.806      2.0001       2.009      1.9206      1.7616      1.8316       2.018      2.0516      1.9706      1.7941      1.6028      1.5891      1.7334       1.843      1.8923      1.8543      1.7483      1.6042       1.638      1.8129      1.5961      1.2403      1.1546      1.1577        1.08      1.0639      1.0733      1.0311      1.0465      1.1466      1.2866      1.2451      1.1126     0.96486     0.91936     0.95043     0.75536     0.56478 
%    
%      'CoupleArea'  1.04 
% 
%      'Sublingual_on_or_off'   1        [1 - on , 0 - off]
% 
%      'Main'
%         45
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
%         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
%         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
%      
%      'Back'
%         21
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
%         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
%         
%      'Front'
%         24 
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
%         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
%         
%      'Sublingual'
%         6 
%         0.34144     0.34046     0.35342     0.35071     0.40743     0.25022 
%         2.6719      2.9443      3.5288      3.8672      4.2583      4.2583 
%  
%      'Number_of_Channels'          2    [ 2 or 1, if 1, then only Channel1 valid]
%      'Supralingual_on_or_off'      1    [1 - on , 0 - off]
%      'Back' 
%      'Front' 
%      'Channel1'
%      'Channel2'
%      'Supralingual'
%    
% 
% 
%     'number_of_Nostril'  2                   [2  or 1, if 1, then only Nostril_1 valid]
% 
%     'Pharynx' 
%         6 
%         0.34144     0.34046     0.35342     0.35071     0.40743     0.25022 
%         2.6719      2.9443      3.5288      3.8672      4.2583      4.2583 
%    
%     'Oral' 
%         24 
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
%         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
%         
%     'Back'
%         21
%         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
%         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
% 
%     'Nostril_1'
%         44 
%         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
%         2.132      1.9685      1.5495      1.3589      1.4344      1.6343       1.829      2.0331      2.1922      2.2865      2.4341      2.7089      2.8467      2.7493      2.7317      2.7377      2.7133      2.7037       2.704      2.8742      3.0156      3.0347      3.0105      2.8988       3.075      3.4037      3.6348      3.7974      3.5667       3.006      2.4878      2.0335      1.7394      1.5284      1.3417      1.2902      1.2656      1.1251     0.87207      0.6583     0.52972     0.51318     0.44172     0.32854 
% 
%      'Nostril_2'
%         44 
%         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
%         1.8722      2.0538      1.8646      1.4988      1.4006       1.527       1.806      2.0001       2.009      1.9206      1.7616      1.8316       2.018      2.0516      1.9706      1.7941      1.6028      1.5891      1.7334       1.843      1.8923      1.8543      1.7483      1.6042       1.638      1.8129      1.5961      1.2403      1.1546      1.1577        1.08      1.0639      1.0733      1.0311      1.0465      1.1466      1.2866      1.2451      1.1126     0.96486     0.91936     0.95043     0.75536     0.56478 
%    
%      'CoupleArea'  1.04 
% 
% 
% tempCategory = get_data(0, 'Category_Selection:', File) ;  % get data from file
%     if ((Category-1) ~= tempCategory)
%         if(Category ~= 1)   % I am trying to include one case that import area function wihtout specifiy the category from interface, just infer from file
%             errordlg('Category Error', 'Error', 'modal') ;  return ;
%         else
%             Category = tempCategory + 1 ; 
%             % other work to do , since category is NONE  right now
%         end
%     end
%     
%     tempModelType  = get_data(0, 'Model_Selection:', File) ;  % get data from file
%     tempModelType = round(tempModelType) ;
%     if(tempModelType ~= VT.handles_EditArea{Category,Type}.RealType)
%         
%              % check if tempModelType right 
%              if(tempModelType <= 0 | tempModelType>length(VT.Model_types{Category})-2 ) % if the model type array is 4, that means there are 2 types of model
%                 hTemp = errordlg('Model selection error in the input file', 'Error', 'modal') ;  return ;
%              end
%               
%              % if (tempModelType)
%              Ind = find (VT.handles_EditArea{ Category,Type }.handleList ~= 0) ;   % do not delete root
%              delete(VT.handles_EditArea{ Category,Type }.handleList(Ind) ) ;
%              VT.handles_EditArea{ Category,Type } = [] ;
%              % set(VT.handles_EditArea{ Category,Type }.handleList, 'visible', 'off') ;
%             if( ~Create_handlesEditArea( Category, Type, 'model', tempModelType ) )
%                 return ;  % invalid tempModelType 
%             end;
%     end
% 
%   % update the titles
%     updateplots(VT.handles, 'category',  tempModelType) ;
% 
%     % reset these value
%     VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;
%     VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
%     Temp = get(VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
%     set(VT.handles_EditArea{Category,Type}.Slider, 'Value', Temp) ;
%     
%         case 4  % 'Nasal'
%             %            Pharynx
%           case 5  % '/r/'
%             switch tempModelType
%                 case 1
%                     %      'Back'
%                     [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
%                     put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
%                     set_plotdata(Category, tempModelType, tempLength, tempArea, 2);  % 2 unused for vowel 
%                     
%                     %      'Front'
%                     [j, tempLength, tempArea] = get_data(Category-1, '''Front''', File) ;  % get data from file
%                     put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
%                     set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel 
%                     %      'Sublingual_on_or_off'             [1 - on , 0 - off]
%                     [tempLength] = get_data(Category-1, '''Sublingual_on_or_off''', File) ;  % get data from file
%                     if(tempLength == 1)
%                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(1))
%                     elseif(tempLength == 0)
%                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(2))
%                     else
%                         errordlg(['reading Sublingual_on_or_off !'], 'Error', 'modal') ; % return ;
%                     end
%                     %      'Sublingual'
%                     if(tempLength == 1)
%                         [j, tempLength, tempArea] = get_data(Category-1, '''Sublingual''', File) ;  % get data from file
%                         put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
%                         set_plotdata(Category, tempModelType, tempLength, tempArea, 4);  % 2 unused for vowel 
%                     end
%                     
%                 case 2
%                     %      'Main'
%                     [j, tempLength, tempArea] = get_data(Category-1, '''Main''', File) ;  % get data from file
%                     put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
%                     set_plotdata(Category, tempModelType, tempLength, tempArea, 2);  % 2 unused for vowel 
%                     %      'Sublingual_on_or_off'             [1 - on , 0 - off]
%                     [tempLength] = get_data(Category-1, '''Sublingual_on_or_off''', File) ;  % get data from file
%                     if(tempLength == 1)
%                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(1))
%                     elseif(tempLength == 0)
%                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(2))
%                     else
%                         errordlg(['reading Sublingual_on_or_off !'], 'Error', 'modal') ; % return ;
%                     end
%                     %      'Sublingual'
%                     if(tempLength == 1)
%                         [j, tempLength, tempArea] = get_data(Category-1, '''Sublingual''', File) ;  % get data from file
%                         put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
%                         set_plotdata(Category, tempModelType, tempLength, tempArea, 3);  % 2 unused for vowel 
%                     end
%                 otherwise
%                     errordlg('Error in /r/ model type', 'Error', 'modal') ;
%             end        
%             
%             
%             
%              % popmenu
%              Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;
% 
%             
%         case 6  % '/l/'
% 
% 
%             %      'Back'
%             [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel 
%             %      'Front'
%             [j, tempLength, tempArea] = get_data(Category-1, '''Front''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel 
%             %      'Channel1'
%             [j, tempLength, tempArea] = get_data(Category-1, '''Channel1''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 4) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 5);  % 2 unused for vowel 
% 
%              %      'Number_of_Channels'          2    [ 2 or 1, if 1, then only Channel1 valid]
%             [tempLength] = get_data(Category-1, '''Number_of_Channels''', File) ;  % get data from file
%             if(tempLength == 2)
%                Callback_EditArea(Category, Type, 'Lateral Channels', VT.handles_EditArea{Category, Type}.LateralChannel(2)) ;
%            elseif(tempLength == 1)
%                Callback_EditArea(Category, Type, 'Lateral Channels', VT.handles_EditArea{Category, Type}.LateralChannel(1)) ;
%            else
%                errordlg(['Number_of_Channels !'], 'Error', 'modal') ; % return ;
%            end
%             
%             %      'Channel2'
%             if(tempLength == 2)
%                 [j, tempLength, tempArea] = get_data(Category-1, '''Channel2''', File) ;  % get data from file
%                     put_areafunction(Category,Type,tempLength, tempArea, 5) ; % put data into array
%                     set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 6);  % 2 unused for vowel 
%             end
%             %      'Supralingual_on_or_off'      1    [1 - on , 0 - off]
%             [tempLength] = get_data(Category-1, '''Supralingual_on_or_off''', File) ;  % get data from file
%             
%             if(tempLength == 1)
%                 Callback_EditArea(Category, Type, 'Supralingual', VT.handles_EditArea{Category, Type}.Supralingual(1))
%             elseif(tempLength == 0)
%                 Callback_EditArea(Category, Type, 'Supralingual', VT.handles_EditArea{Category, Type}.Supralingual(2))
%             else
%                 errordlg(['Supralingual_on_or_off !'], 'Error', 'modal') ; % return ;
%             end
%             %      'Supralingual'
%             if(tempLength == 1)
%                 [j, tempLength, tempArea] = get_data(Category-1, '''Supralingual''', File) ;  % get data from file
%                     put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
%                     set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 4);  % 2 unused for vowel 
%             
%             end
% 
%             % popmenu
%              Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;
% 
%             
%             
%         case 7  % 'Nasalized_vowel'
% %      'number_of_Nostril' 2                  [ always 2 in current coding  or 1, if 1, then only Nostril_1 valid]
% %      'Pharynx' 
% %      'Oral' 
% %      'Back'
% %      'Nostril_1'
% %      'Nostril_2'
% %      'CoupleArea'  2.0
%             %            Pharynx
%             [j, tempLength, tempArea] = get_data(Category-1, '''Pharynx''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel 
% 
%             %            Oral
%             [j, tempLength, tempArea] = get_data(Category-1, '''Oral''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel 
%             %            Back
%             [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 4);  % 2 unused for vowel 
%             %            Nostril_1
%             [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_1''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 4) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 5);  % 2 unused for vowel 
% 
%            %        number of nostrils
%             [tempLength] = get_data(Category-1, '''number_of_Nostril''', File) ;  % get data from file
%             % copy this to edit area
%             if(tempLength == 2)
%                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(2))
%             else
%                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(1))
%             end
%             
%             %            Nostril_2
%             if(tempLength == 2)
%             [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_2''', File) ;  % get data from file
%                 put_areafunction(Category,Type,tempLength, tempArea, 5) ; % put data into array
%                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 6);  % 2 unused for vowel 
%             end
%             
%             % popmenu
%              Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;
%             
%             % do not need it since Popmenu callback will do this ....
%             % array_to_editarea(Category, Type) ;
% 
%             %           'CoupleArea'
%             [tempLength] = get_data(Category-1, '''CoupleArea''', File) ;  % get data from file
%                Callback_EditArea(Category, Type, 'Couple Area', VT.handles_EditArea{Category, Type}.CoupleArea, tempLength) ;
% 
% 
% 
%         otherwise
%     end
% end
% 
% 
% 
% 
% 
% fprintf(fid, '%s \n', 'leftDL') ;
% fprintf(fid, '%s \n', num2str(length(leftDL))) ;
% fprintf(fid, '%s \n', num2str((leftDL))) ;
% fprintf(fid, '%s \n', num2str((leftArea))) ;
% 
% 
% fprintf(fid, '%s \n', 'rightDL') ;
% fprintf(fid, '%s \n', num2str(length(rightDL))) ;
% fprintf(fid, '%s \n', num2str((rightDL))) ;
% fprintf(fid, '%s \n', num2str((rightArea))) ;
% 
% fprintf(fid, '%s \n', 'velarDL') ;
% fprintf(fid, '%s \n', num2str(length(velarDL))) ;
% fprintf(fid, '%s \n', num2str((velarDL))) ;
% fprintf(fid, '%s \n', num2str((velarArea))) ;
% 
% 
% fprintf(fid, '%s \n', 'NasalCouplingArea') ;
% fprintf(fid, '%s \n', num2str(NasalCouplingArea)) ;
%  
% 
% fprintf(fid, '%s \n', 'backDL') ;
% fprintf(fid, '%s \n', num2str(length(backDL))) ;
% fprintf(fid, '%s \n', num2str((backDL))) ;
% fprintf(fid, '%s \n', num2str((backArea))) ;
% 
% fprintf(fid, '%s \n', 'frontDL') ;
% fprintf(fid, '%s \n', num2str(length(frontDL))) ;
% fprintf(fid, '%s \n', num2str((frontDL))) ;
% fprintf(fid, '%s \n', num2str((frontArea))) ;
% 
% 
% 
% 
% warndlg('save operation completed',' done ', 'modal') ;
% return ;