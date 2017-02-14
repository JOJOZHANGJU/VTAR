% function loadfile
%  - Load area function and other information such as property of fluid and
%  air , acoustic response....., which are saved from previous running
%  -  

function loadfile
global VT ;

% remember the current folder
old_dir = pwd ;

% go to /users path
if ~(exist([VT.vtarPath '/users'], 'dir'))
    errordlg('folder /users/ missing ', 'Error', 'modal') ; 
else
    cd([VT.vtarPath '/users']) ;
end

% get file name from user input
[filename, pathname] = uigetfile( ...
    {'*.mat', 'All MAT-Files (*.mat)'; ...
        '*.*','All Files (*.*)'}, ...
    'load VT data');
% If "Cancel" is selected then return

% return to the old folder
cd(old_dir) ;
if isequal([filename,pathname],[0,0])
    return
end

% construct the fullfilename and Check and load the file.
File = fullfile(pathname,filename);
if isempty(File)
    errordlg('File open error', 'Error', 'modal') ; 
    return ;
end

if exist(File) == 2
    try  % in  case of wrong operation or file format
        load (File, '-mat', 'VTsaved');
    catch
        errordlg('File load error', 'Error', 'modal') ;   
        return ;
    end
end

if(~exist('VTsaved'))
    errordlg('File formant has some problem', 'Error', 'modal') ; 
    return ;
else
    if ( isempty(VTsaved.date))  % if date is empty, error happens
        errordlg('File formant is in .mat, but without the vocal tract information', 'Error', 'modal') ; 
        return ;
    end
    
    %copy data in edit area
    %       handles_EditArea: {8x40 cell}
    VT.Property = VTsaved.Property ;
    VT.Radiation_Load = VTsaved.Radiation_Load ;
    VT.CurrentCategory = VTsaved.CurrentCategory ;
    VT.CurrentModeltype = VTsaved.CurrentModeltype ;
    VT.CurrentGeneric = VTsaved.CurrentGeneric ;
    VT.f =  VTsaved.f ;
    VT.AR = VTsaved.AR ;
    VT.Vowel = VTsaved.Vowel ; 
    VT.Consonant = VTsaved.Consonant ;
    VT.Nasal = VTsaved.Nasal ;
    VT.Rhotic = VTsaved.Rhotic ;
    VT.Lateral = VTsaved.Lateral ;
    VT.NasalVowel = VTsaved.NasalVowel ;
    VT.Formant = VTsaved.Formant ;
    VT.Formant_amp = VTsaved.Formant_amp ;
    VT.Formant_bw = VTsaved.Formant_bw ;
    VT.Arbitrary  = VTsaved.Arbitrary ;
    clear VTsaved ;
end


% already have property information
% no further information should be taken on property

%  radition should be checked
%-----------------------------------
if(VT.Property.Radiation == 1)
    VT.Radiation_Load = 'on' ;
    set(VT.handles.Radiation_Load_On, 'Checked', 'on');
    set(VT.handles.Radiation_Load_Off, 'Checked', 'off');
elseif (VT.Property.Radiation == 0)
    VT.Radiation_Load = 'off'
    VT.Property.Radiation = 0 ;
    set(VT.handles.Radiation_Load_On, 'Checked', 'off');
    set(VT.handles.Radiation_Load_Off, 'Checked', 'on');
else
    errordlg('Radiation property in loaded file is out of range', 'Error', 'modal') ; 
end

% check category, and modeltype
%-----------------------------------
% category
Category  = VT.CurrentCategory ;
Modeltype = VT.CurrentModeltype ;
Generic   = VT.CurrentGeneric   ;

% the purpose is to make the callback work, since the callback will not
% work if VT.CurrentCategory == Category, so I need to set it to 1
% initially
VT.CurrentCategory  = 1 ;
VT.CurrentModeltype = 1 ;
VT.CurrentGeneric   = 1 ;
set(VT.handles.Category, 'Value', Category) ;
% vtar('Category_Callback',gcbo,[],guidata(gcbo))
vtar('Category_Callback',VT.handles.Category, [], VT.handles, 1) ; % 1 here is just not to delete VT.f and VT.AR ;



% load some plots which are held
Ind = find(File=='.') ;
if(isempty(Ind))
    File = [File(1:end) '.fig'] ;
else
    File = [File(1:Ind(end)-1) '.fig'] ;
end
% the following for fig saved
if exist(File) ~= 0
    try 
        ud = get(VT.handles.vtar,'userdata') ;

        tempHandleFig = hgload( File) ;
        udtemp = get(tempHandleFig,'userdata') ;
        tempHandleAxe = udtemp.ht.a ;
        
        % remove current plots which are held
        holdPlots('holdOff') ;
        for i = 1: length(tempHandleAxe) 
            tempChild = findobj(tempHandleAxe(i), 'type', 'line', 'tag', 'hold') ;
            if( ~isempty(tempChild))
                Child = copyobj(tempChild(:), ud.ht.a(i)) ;
                VT.handleHoldPlots{1, i} = Child ;
            else
                VT.handleHoldPlots{1, i} = [] ;
            end
        end
%        delete(tempHandleAxe(:)) ;
        delete(tempHandleFig) ;
    catch
        
    end
end



% the following just for axes saved
% if exist(File) ~= 0
%     try 
%         ud = get(VT.handles.vtar,'userdata') ;
%         tempHandleAxe = hgload( File) ;
%         
%         % remove current plots which are held
%         holdPlots('holdoff') ;
%         for i = 1: length(tempHandleAxe) 
%             tempChild = findobj(tempHandleAxe(i), 'type', 'line', 'tag', 'hold') ;
%             if( ~isempty(tempChild))
%                 Child = copyobj(tempChild(:), ud.ht.a(i)) ;
%                 VT.handleHoldPlots{1, i} = Child ;
%             end
%         end
%         delete(tempHandleAxe(:)) ;
%     catch
%         
%     end
% end

% see if .txt file exist 
File = [File(1:end-4) '.txt'] ; 
if exist(File) == 0
        errordlg([File ' does not exist '], 'Error', 'modal') ;   
        return ;
end

% model type or generic type
% if(Category ~= 8) % 8 means arbitrary
    if(Modeltype ~= 1)
        %           vtar('Model_type_Callback',gcbo,[],guidata(gcbo))
        set(VT.handles.Model_type, 'Value', Modeltype) ;
        vtar('Model_type_Callback',VT.handles.Model_type,[], VT.handles, [File(1:end-4) '.txt'])
        
    elseif (Generic ~= 1)
        set(VT.handles.Generic_model, 'Value', Generic) ;
        %          vtar('Generic_model_Callback',gcbo,[],guidata(gcbo))  
        
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        % the following has to be changed since the user may modify the
        % data from example area function.  -- DONE
        vtar('Generic_model_Callback', VT.handles.Generic_model, [], VT.handles, [File(1:end-4) '.txt'])  ;
    end
    %        VT.handles.Category
%end

% update the formant information
RePlot(VT.handles) ;



return ; 




% display formant infomration on interface
%-----------------------------------
function RePlot(handles)
global VT 

Display_formant(handles.F1, VT.Formant(1) );
Display_formant(handles.F2, VT.Formant(2) );
Display_formant(handles.F3, VT.Formant(3) );
Display_formant(handles.F4, VT.Formant(4) );
Display_formant(handles.F5, VT.Formant(5) );

Display_formant(handles.F1_amp, VT.Formant_amp(1), '%10.2f' );
Display_formant(handles.F2_amp, VT.Formant_amp(2), '%10.2f'  );
Display_formant(handles.F3_amp, VT.Formant_amp(3), '%10.2f'  );
Display_formant(handles.F4_amp, VT.Formant_amp(4), '%10.2f'  );
Display_formant(handles.F5_amp, VT.Formant_amp(5), '%10.2f'  );

Display_formant(handles.F1_bw, VT.Formant_bw(1) );
Display_formant(handles.F2_bw, VT.Formant_bw(2) );
Display_formant(handles.F3_bw, VT.Formant_bw(3) );
Display_formant(handles.F4_bw, VT.Formant_bw(4) );
Display_formant(handles.F5_bw, VT.Formant_bw(5) );


% display on matlab also
display('Formant      frequency(Hz)     amplitude(dB)     bandwith(Hz)') ;
for i = 1: 5 
    if(VT.Formant(i)~=0)
        disp([ 'F' num2str(i) '            '  num2str(VT.Formant(i))   '            '  num2str(VT.Formant_amp(i)) '            '  num2str(VT.Formant_bw(i))]) ;
    end
end


%-----------------------------------------------------------------------
%  display information of formant
%
function Display_formant(h, data, varargin)

if( ~isnumeric(data))
    errordlg('Error for formant information','Error', 'modal'); return ;
end
if data == 0
    set(h, 'String',  ' ');
elseif (isnan(data))
    set(h, 'String',  ' *** ');
else
    %set(h, 'String', data );
    if nargin == 3
        set(h, 'String', num2str(data, varargin{1}) );
    else
        set(h, 'String', num2str(data) );
    end
end
return ;


% end of this file
% -------------------------------




% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% VT.date = datestr(now, 0) ;
% 
% [filename, pathname] = uiputfile( ...
%     {'*.mat';'*.*'}, ...
%     'Save');	
% % If 'Cancel' was selected then return
% if isequal([filename,pathname],[0,0])
%     return
% else
%     % Construct the full path and save
%     File = fullfile(pathname,filename);
%     save(File,'VT')
% %    handles.LastFile = File;
% %    guidata(h,handles)
% end
% 
% % save other area function informaiton and also property .....
% Ind = find(File=='.') ;
% if(isempty(Ind))
%     File = [File(1:end) '.txt'] ;
% else
%     File = [File(1:Ind(1)-1) '.txt'] ;
% end
% 
% 
% fid = fopen(File, 'w') ;
% if(fid == -1)
%      errordlg('File open error', 'Error', 'modal') ;  return ;
% end
% 
% 
% % comments in the file
% fprintf(fid, '%s\n', '[') ;
% fprintf(fid, '%s\n\n', VT.date) ;
% 
% fprintf(fid, '%s\n', ' comments are added here') ;
% fprintf(fid, '%s\n', ' this is a save file for area function and also other information on vocal tract modelling ') ;
% fprintf(fid, '%s\n', ' The first parts are similiar to area function file, but this file also has include formants and property of fluid information') ;
% fprintf(fid, '%s\n', ']') ;
% fprintf(fid, '\n', ' ') ;
% 
% 
% 
% % Category_Selection: 4   Model_Selection: 1
% 
% Category = VT.CurrentCategory-1 ;
% if(Category<1)
%      fclose(fid) ;
%      warndlg('No much information needed to be saved', 'warn ', 'modal') ;  return ;
%      return ;  % 7 means arbitrary
% end
% 
% Category_list = {'[1] Vowel', '[2] Consonant', '[3] Nasal', '[4] /r/', '[5] /l/', '[6] Nasalized_vowel', '[7]arbitrary'} ;
% 
% fprintf(fid, '%s \n', ['Category_Selection: ' num2str(Category)]) ;
% 
% switch Category
%     case 1
%         fprintf(fid, '%s \n', ['Model_Selection: ' num2str(VT.Vowel.Geometry.Type)]) ;        
%         fprintf(fid, '%s \n', Category_list{Category}) ;   
%         % data
%         print2file(fid, VT.Vowel.Geometry.DL, VT.Vowel.Geometry.Area ) ;
%     
%     case 2
%         fprintf(fid, '%s\n ', ['Model_Selection: ' num2str(VT.Consonant.Geometry.Type)]) ;        
%         fprintf(fid, '%s\n', Category_list{Category}) ;   
%         % data
%         print2file(fid, VT.Consonant.Geometry.DL, VT.Consonant.Geometry.Area ) ;
%         
%     case 3
%         fprintf(fid, '%s\n ', ['Model_Selection: ' num2str(VT.Nasal.Geometry.Type)]) ;      
%         fprintf(fid, '%s\n', Category_list{Category}) ;   
%         
%         % data
%         fprintf(fid, '%s\n', ['''number_of_Nostril''  ' num2str(VT.Nasal.Geometry.TwoNostril)]) ;      
%         fprintf(fid, '%s\n', ['''CoupleArea''  '  num2str(VT.Nasal.Geometry.CoupleArea)]) ;      
%  
% 
%         fprintf(fid, '%s\n', ['''Pharynx''']) ; 
%         print2file(fid, VT.Nasal.Geometry.PharynxDL, VT.Nasal.Geometry.PharynxArea ) ;
%         fprintf(fid, '%s \n' ,['''Oral''']) ; 
%         print2file(fid, VT.Nasal.Geometry.OralDL ,VT.Nasal.Geometry.OralArea) ;
%         fprintf(fid, '%s \n' ,['''Back''']) ; 
%         print2file(fid, VT.Nasal.Geometry.NasalBackDL, VT.Nasal.Geometry.NasalBackArea) ;
%         fprintf(fid, '%s \n' ,['''Nostril_1''']) ; 
%         print2file(fid, VT.Nasal.Geometry.NostrilDL1,VT.Nasal.Geometry.NostrilArea1) ;
%         fprintf(fid, '%s \n' ,['''Nostril_2''']) ; 
%         print2file(fid, VT.Nasal.Geometry.NostrilDL2,VT.Nasal.Geometry.NostrilArea2) ;
% 
%     case 4
%         fprintf(fid, '%s\n ', ['Model_Selection: ' num2str(VT.Rhotic.Geometry.Type)]) ;    
%         fprintf(fid, '%s \n', Category_list{Category}) ;   
%         % data
%         fprintf(fid, '%s \n', ['''Sublingual_on_or_off''  ' num2str(VT.Rhotic.Geometry.SublingualOn)]) ;      
%  
%         fprintf(fid, '%s \n',['''Back''']) ; 
%         print2file(fid, VT.Rhotic.Geometry.BackDL, VT.Rhotic.Geometry.BackArea ) ;
%         fprintf(fid, '%s \n',['''Front''']) ; 
%         print2file(fid, VT.Rhotic.Geometry.FrontDL, VT.Rhotic.Geometry.FrontArea ) ;
%         fprintf(fid, '%s \n',['''Main''']) ; 
%         print2file(fid, VT.Rhotic.Geometry.MainDL, VT.Rhotic.Geometry.MainArea ) ;
%         fprintf(fid, '%s \n',['''Sublingual''']) ; 
%         print2file(fid, VT.Rhotic.Geometry.SublingualDL, VT.Rhotic.Geometry.SublingualArea) ;
%         
%     case 5
%         fprintf(fid, '%s\n ', ['Model_Selection: ' num2str(VT.Lateral.Geometry.Type)]) ;      
%         fprintf(fid, '%s \n', Category_list{Category}) ;   
%         
%         % data
%         fprintf(fid, '%s \n', ['''Number_of_Channels''  ' num2str(VT.Lateral.Geometry.LateralOn)]) ;      
%         fprintf(fid, '%s \n', ['''Supralingual_on_or_off''  '  num2str(VT.Lateral.Geometry.SupralingualOn)]) ;      
% 
%         fprintf(fid, '%s \n',['''Supralingual''']) ; 
%         print2file(fid, VT.Lateral.Geometry.SupralingualDL ,VT.Lateral.Geometry.SupralingualArea ) ;
%         fprintf(fid, '%s \n',['''Back''']) ; 
%         print2file(fid, VT.Lateral.Geometry.BackDL, VT.Lateral.Geometry.BackArea ) ;
%         fprintf(fid, '%s \n',['''Front''']) ; 
%         print2file(fid, VT.Lateral.Geometry.FrontDL, VT.Lateral.Geometry.FrontArea ) ;
% 
%         fprintf(fid, '%s \n',['''Channel1''']) ; 
%         print2file(fid, VT.Lateral.Geometry.LateralDL1, VT.Lateral.Geometry.LateralArea1) ;
%         fprintf(fid, '%s \n',['''Channel2''']) ; 
%         print2file(fid, VT.Lateral.Geometry.LateralDL2, VT.Lateral.Geometry.LateralArea2) ;
% 
%  
%     case 6
%         fprintf(fid, '%s\n ', ['Model_Selection: ' num2str(VT.NasalVowel.Geometry.Type)]) ;      
%         fprintf(fid, '%s \n', Category_list{Category}) ;   
% %        fprintf(fid, '%s ', ['Model_Selection: ' num2str(VT.NasalVowel.Geometry.Type)]) ;      
%         
%         % data
%         fprintf(fid, '%s \n', ['''number_of_Nostril''  ' num2str(VT.NasalVowel.Geometry.TwoNostril)]) ;      
%         fprintf(fid, '%s \n', ['''CoupleArea''  '  num2str(VT.NasalVowel.Geometry.CoupleArea)]) ;      
%  
% 
%         fprintf(fid, '%s \n',['''Pharynx''']) ; 
%         print2file(fid, VT.NasalVowel.Geometry.PharynxDL, VT.NasalVowel.Geometry.PharynxArea ) ;
%         fprintf(fid, '%s \n',['''Oral''']) ; 
%         print2file(fid, VT.NasalVowel.Geometry.OralDL ,VT.NasalVowel.Geometry.OralArea) ;
%         fprintf(fid, '%s \n',['''Back''']) ; 
%         print2file(fid, VT.NasalVowel.Geometry.NasalBackDL, VT.NasalVowel.Geometry.NasalBackArea) ;
%         fprintf(fid, '%s \n',['''Nostril_1''']) ; 
%         print2file(fid, VT.NasalVowel.Geometry.NostrilDL1,VT.NasalVowel.Geometry.NostrilArea1) ;
%         fprintf(fid, '%s \n',['''Nostril_2''']) ; 
%         print2file(fid, VT.NasalVowel.Geometry.NostrilDL2,VT.NasalVowel.Geometry.NostrilArea2) ;
%     case 7
%         
%         
%     otherwise
%      errordlg('File save error, wrong category ', 'Error', 'modal') ;  
% end
% % printing property
% printProperty(fid);
% printFormant(fid) ;
% fclose(fid) ;
% return ;
% 
% 
% % print data from one part of vocal tract
% function  print2file(fid, DL, Area) 
%         fprintf(fid, '%s \n', num2str(length(DL))) ;
%         fprintf(fid, '%s \n', num2str((DL))) ;
%         fprintf(fid, '%s \n', num2str((Area))) ;
% return ;
% 
% 
% function printProperty(fid)
% global VT ;
% fprintf(fid, '\n%s ', 'property of fluid:') ;        
%         fprintf(fid, '\n%-20s ', ['RHO  ' num2str(VT.Property.RHO)]) ;  fprintf(fid, '%s ', '      % Air density (Unit: g/cm^3)') ;        
%         fprintf(fid, '\n%-20s ', ['MU   ' num2str(VT.Property.MU)]) ;  fprintf(fid, '%s ', '      %  Air viscosity (Unit: dyne.s/cm^2 )') ;                
%    
%         fprintf(fid, '\n%-20s ', ['C0   ' num2str(VT.Property.C0)]) ;  fprintf(fid, '%s ', '      %  Sound speed in air (Unit: cm/s)') ;     
%         fprintf(fid, '\n%-20s ', ['CP   ' num2str(VT.Property.CP)]) ;    fprintf(fid, '%s ', '      %  Specific heat of air (Unit: cal/g.k)') ;               
%         fprintf(fid, '\n%-20s ', ['LAMDA' num2str(VT.Property.LAMDA)]) ;     fprintf(fid, '%s ', '      % Heat conduction of helium  (Unit: cal/s.cm.k)') ;        
%         fprintf(fid, '\n%-20s ', ['ETA  ' num2str(VT.Property.ETA)]) ;          fprintf(fid, '%s ', '      % adiabatic constant') ;        
% 
%  fprintf(fid, '\n\n%s ', 'property of wall:') ;        
%        fprintf(fid, '\n%-20s ', ['WALL_L ' num2str(VT.Property.WALL_L)]) ;          fprintf(fid, '%s ', '     % Wall mass per unit length (Unit: g/cm)') ;        
%        fprintf(fid, '\n%-20s ', ['WALL_R ' num2str(VT.Property.WALL_R)]) ;          fprintf(fid, '%s ', '      % Wall resistance (Unit: dyne.s/cm^2)') ;        
%        fprintf(fid, '\n%-20s ', ['WALL_K ' num2str(VT.Property.WALL_K)]) ;          fprintf(fid, '%s ', '      % Wall stiffness (Unit: dyne/cm^2)') ;        
% 
% return ;
% 
% 
% 
% function printFormant(fid)
% global VT 
% 
% % display on matlab also
% fprintf(fid, '\n\n\n%s\n', 'Formant      frequency(Hz)     amplitude(dB)     bandwith(Hz)') ;
% for i = 1: 5 
%     if(VT.Formant(i)~=0)
%         fprintf(fid, '%s\n', [ 'F' num2str(i) '            '  num2str(VT.Formant(i))   '            '  num2str(VT.Formant_amp(i)) '            '  num2str(VT.Formant_bw(i))]) ;
%     end
% end
% 
% return ;
% 
% 
% 
% 
% % 
% % 
% % 
% % 
% % 
% % % nasal
% % 
% % % VT.Nasal.Geometry.NostrilDL = [ 0; 0 ] ;
% % % VT.Nasal.Geometry.NostrilArea = [ 0; 0  ] ;
% % % VT.AreaFunction.Settings.Nasal{1} =  {'', 'Pharynx', 'Oral', 'Back', 'Nostril_1', 'Nostril_2' } ; 
% % % VT.AreaFunction.Settings.Nasal{2} =  {'', 'Pharynx', 'Oral', 'Back', 'Nostril'} ; 
% % % VT.AreaFunction.Settings.PlotContextMenu.Nasal =  {'Acoustic Response' 'Pharynx', 'Oral', ...
% % %                                                    'Back', 'Nostril_1', 'Nostril_2','Schematic' } ; 
% % 
% % % rhotic
% % 
% % % VT.AreaFunction.Settings.Rhotic{1} =  {'', 'Front', 'Back', 'Sublingual'} ; 
% % % VT.AreaFunction.Settings.Rhotic{2} =  {'', 'Front', 'Back'} ;
% % % VT.AreaFunction.Settings.PlotContextMenu.Rhotic = {'Acoustic Response', 'Front', 'Back', 'Sublingual', 'Schematic'} ; 
% % % Lateral
% % % VT.AreaFunction.Settings.Lateral{1} =  {'', 'Front', 'Back', 'Channel1', 'Channel2', 'Supralingual' } ;
% % % VT.AreaFunction.Settings.Lateral{2} =  {'', 'Front', 'Back', 'Channel', 'Supralingual' } ;
% % % VT.AreaFunction.Settings.Lateral{3} =  {'', 'Front', 'Back', 'Channel1', 'Channel2' } ;
% % % VT.AreaFunction.Settings.Lateral{4} =  {'', 'Front', 'Back', 'Channel' } ;
% % % VT.AreaFunction.Settings.PlotContextMenu.Lateral = {'Acoustic Response', 'Front', 'Back', 'Channel1',...
% % %                                                     'Channel2', 'Supralingual', 'Schematic' } ;
% % 
% % % NasalVowel
% % VT.NasalVowel.Geometry.Type = 1 ;
% % VT.NasalVowel.Geometry.PharynxArea = [ 0 ] ;
% % VT.NasalVowel.Geometry.PharynxDL = [ 0  ] ;
% % VT.NasalVowel.Geometry.OralArea = [ 0  ] ;
% % VT.NasalVowel.Geometry.OralDL = [ 0 ] ;
% % VT.NasalVowel.Geometry.NasalBackArea = [ 0  ] ;
% % VT.NasalVowel.Geometry.NasalBackDL = [ 0 ] ;
% % VT.NasalVowel.Geometry.CoupleArea = [ 0 ] ;
% % VT.NasalVowel.Geometry.TwoNostril = [ 0 ] ;
% % 
% % VT.NasalVowel.Geometry.NostrilArea = [ 0  ] ;
% % VT.NasalVowel.Geometry.NostrilDL = [ 0 ] ;
% % 
% % VT.NasalVowel.Geometry.NostrilArea1 = [ 0  ] ;
% % VT.NasalVowel.Geometry.NostrilDL1 = [ 0 ] ;
% % 
% % VT.NasalVowel.Geometry.NostrilArea2 = [ 0  ] ;
% % VT.NasalVowel.Geometry.NostrilDL2 = [ 0 ] ;
% % 
% % return ;
% % 
% % % PropertyDefault {}
% % function PropertyDefault = get_property_default() 
% % File = 'property.txt' ;
% % 
% % % the following values are used in case File format is wrong
% % PropertyDefault{1}.Fluid = 'Air' ;
% % PropertyDefault{1}.RHO    = 1.14e-3;  % Air density (Unit: g/cm^3)
% % PropertyDefault{1}.MU     = 1.86e-4;  % Air viscosity (Unit: dyne.s/cm^2 )
% % PropertyDefault{1}.C0     = 3.5e4;    % Sound speed in air (Unit: cm/s)
% % PropertyDefault{1}.CP     = 0.24;     % Specific heat of air (Unit: cal/g.k)
% % PropertyDefault{1}.LAMDA  = 5.5e-5;   % Heat conduction of air (Unit: cal/s.cm.k)
% % PropertyDefault{1}.ETA    = 1.4;      % 
% % PropertyDefault{1}.WALL_L = 1.5;      % Wall mass per unit length (Unit: g/cm)
% % PropertyDefault{1}.WALL_R = 1600;     % Wall resistance (Unit: dyne.s/cm^2)
% % PropertyDefault{1}.WALL_K = 3e5;      % Wall stiffness (Unit: dyne/cm^2)
% % 
% % 
% % Model = 
% % 
% % 
% %     'number_of_Nostril'  2                   [2  or 1, if 1, then only Nostril_1 valid]
% % 
% %     'Pharynx' 
% %         6 
% %         0.34144     0.34046     0.35342     0.35071     0.40743     0.25022 
% %         2.6719      2.9443      3.5288      3.8672      4.2583      4.2583 
% %    
% %     'Oral' 
% %         24 
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
% %         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
% %         
% %     'Back'
% %         21
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
% %         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
% % 
% %     'Nostril_1'
% %         44 
% %         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
% %         2.132      1.9685      1.5495      1.3589      1.4344      1.6343       1.829      2.0331      2.1922      2.2865      2.4341      2.7089      2.8467      2.7493      2.7317      2.7377      2.7133      2.7037       2.704      2.8742      3.0156      3.0347      3.0105      2.8988       3.075      3.4037      3.6348      3.7974      3.5667       3.006      2.4878      2.0335      1.7394      1.5284      1.3417      1.2902      1.2656      1.1251     0.87207      0.6583     0.52972     0.51318     0.44172     0.32854 
% % 
% %      'Nostril_2'
% %         44 
% %         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
% %         1.8722      2.0538      1.8646      1.4988      1.4006       1.527       1.806      2.0001       2.009      1.9206      1.7616      1.8316       2.018      2.0516      1.9706      1.7941      1.6028      1.5891      1.7334       1.843      1.8923      1.8543      1.7483      1.6042       1.638      1.8129      1.5961      1.2403      1.1546      1.1577        1.08      1.0639      1.0733      1.0311      1.0465      1.1466      1.2866      1.2451      1.1126     0.96486     0.91936     0.95043     0.75536     0.56478 
% %    
% %      'CoupleArea'  1.04 
% % 
% %      'Sublingual_on_or_off'   1        [1 - on , 0 - off]
% % 
% %      'Main'
% %         45
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
% %         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
% %         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
% %      
% %      'Back'
% %         21
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
% %         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
% %         
% %      'Front'
% %         24 
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
% %         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
% %         
% %      'Sublingual'
% %         6 
% %         0.34144     0.34046     0.35342     0.35071     0.40743     0.25022 
% %         2.6719      2.9443      3.5288      3.8672      4.2583      4.2583 
% %  
% %      'Number_of_Channels'          2    [ 2 or 1, if 1, then only Channel1 valid]
% %      'Supralingual_on_or_off'      1    [1 - on , 0 - off]
% %      'Back' 
% %      'Front' 
% %      'Channel1'
% %      'Channel2'
% %      'Supralingual'
% %    
% % 
% % 
% %     'number_of_Nostril'  2                   [2  or 1, if 1, then only Nostril_1 valid]
% % 
% %     'Pharynx' 
% %         6 
% %         0.34144     0.34046     0.35342     0.35071     0.40743     0.25022 
% %         2.6719      2.9443      3.5288      3.8672      4.2583      4.2583 
% %    
% %     'Oral' 
% %         24 
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.33332     0.39682     0.39682     0.39682 
% %         3.33        2.27        2.57        2.17        1.84        1.98        1.73        1.43        1.73        2.08        2.32        2.84        3.51        4.25        4.79        4.61        4.07        3.64        2.84        1.42        0.29           0           0           0 
% %         
% %     'Back'
% %         21
% %         0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682     0.39682      0.0635 
% %         0.57        0.57        0.21        0.58        2.18        3.15        2.96        2.89         3.7        4.21        3.57        3.59        2.97        3.17        3.25        2.58        2.74        2.77        2.49        2.93        3.33 
% % 
% %     'Nostril_1'
% %         44 
% %         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
% %         2.132      1.9685      1.5495      1.3589      1.4344      1.6343       1.829      2.0331      2.1922      2.2865      2.4341      2.7089      2.8467      2.7493      2.7317      2.7377      2.7133      2.7037       2.704      2.8742      3.0156      3.0347      3.0105      2.8988       3.075      3.4037      3.6348      3.7974      3.5667       3.006      2.4878      2.0335      1.7394      1.5284      1.3417      1.2902      1.2656      1.1251     0.87207      0.6583     0.52972     0.51318     0.44172     0.32854 
% % 
% %      'Nostril_2'
% %         44 
% %         0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875      0.1875 
% %         1.8722      2.0538      1.8646      1.4988      1.4006       1.527       1.806      2.0001       2.009      1.9206      1.7616      1.8316       2.018      2.0516      1.9706      1.7941      1.6028      1.5891      1.7334       1.843      1.8923      1.8543      1.7483      1.6042       1.638      1.8129      1.5961      1.2403      1.1546      1.1577        1.08      1.0639      1.0733      1.0311      1.0465      1.1466      1.2866      1.2451      1.1126     0.96486     0.91936     0.95043     0.75536     0.56478 
% %    
% %      'CoupleArea'  1.04 
% % 
% % 
% % tempCategory = get_data(0, 'Category_Selection:', File) ;  % get data from file
% %     if ((Category-1) ~= tempCategory)
% %         if(Category ~= 1)   % I am trying to include one case that import area function wihtout specifiy the category from interface, just infer from file
% %             errordlg('Category Error', 'Error', 'modal') ;  return ;
% %         else
% %             Category = tempCategory + 1 ; 
% %             % other work to do , since category is NONE  right now
% %         end
% %     end
% %     
% %     tempModelType  = get_data(0, 'Model_Selection:', File) ;  % get data from file
% %     tempModelType = round(tempModelType) ;
% %     if(tempModelType ~= VT.handles_EditArea{Category,Type}.RealType)
% %         
% %              % check if tempModelType right 
% %              if(tempModelType <= 0 | tempModelType>length(VT.Model_types{Category})-2 ) % if the model type array is 4, that means there are 2 types of model
% %                 hTemp = errordlg('Model selection error in the input file', 'Error', 'modal') ;  return ;
% %              end
% %               
% %              % if (tempModelType)
% %              Ind = find (VT.handles_EditArea{ Category,Type }.handleList ~= 0) ;   % do not delete root
% %              delete(VT.handles_EditArea{ Category,Type }.handleList(Ind) ) ;
% %              VT.handles_EditArea{ Category,Type } = [] ;
% %              % set(VT.handles_EditArea{ Category,Type }.handleList, 'visible', 'off') ;
% %             if( ~Create_handlesEditArea( Category, Type, 'model', tempModelType ) )
% %                 return ;  % invalid tempModelType 
% %             end;
% %     end
% % 
% %   % update the titles
% %     updateplots(VT.handles, 'category',  tempModelType) ;
% % 
% %     % reset these value
% %     VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;
% %     VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
% %     Temp = get(VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
% %     set(VT.handles_EditArea{Category,Type}.Slider, 'Value', Temp) ;
% %     
% %         case 4  % 'Nasal'
% %             %            Pharynx
% %           case 5  % '/r/'
% %             switch tempModelType
% %                 case 1
% %                     %      'Back'
% %                     [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
% %                     put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
% %                     set_plotdata(Category, tempModelType, tempLength, tempArea, 2);  % 2 unused for vowel 
% %                     
% %                     %      'Front'
% %                     [j, tempLength, tempArea] = get_data(Category-1, '''Front''', File) ;  % get data from file
% %                     put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
% %                     set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel 
% %                     %      'Sublingual_on_or_off'             [1 - on , 0 - off]
% %                     [tempLength] = get_data(Category-1, '''Sublingual_on_or_off''', File) ;  % get data from file
% %                     if(tempLength == 1)
% %                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(1))
% %                     elseif(tempLength == 0)
% %                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(2))
% %                     else
% %                         errordlg(['reading Sublingual_on_or_off !'], 'Error', 'modal') ; % return ;
% %                     end
% %                     %      'Sublingual'
% %                     if(tempLength == 1)
% %                         [j, tempLength, tempArea] = get_data(Category-1, '''Sublingual''', File) ;  % get data from file
% %                         put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
% %                         set_plotdata(Category, tempModelType, tempLength, tempArea, 4);  % 2 unused for vowel 
% %                     end
% %                     
% %                 case 2
% %                     %      'Main'
% %                     [j, tempLength, tempArea] = get_data(Category-1, '''Main''', File) ;  % get data from file
% %                     put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
% %                     set_plotdata(Category, tempModelType, tempLength, tempArea, 2);  % 2 unused for vowel 
% %                     %      'Sublingual_on_or_off'             [1 - on , 0 - off]
% %                     [tempLength] = get_data(Category-1, '''Sublingual_on_or_off''', File) ;  % get data from file
% %                     if(tempLength == 1)
% %                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(1))
% %                     elseif(tempLength == 0)
% %                         Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(2))
% %                     else
% %                         errordlg(['reading Sublingual_on_or_off !'], 'Error', 'modal') ; % return ;
% %                     end
% %                     %      'Sublingual'
% %                     if(tempLength == 1)
% %                         [j, tempLength, tempArea] = get_data(Category-1, '''Sublingual''', File) ;  % get data from file
% %                         put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
% %                         set_plotdata(Category, tempModelType, tempLength, tempArea, 3);  % 2 unused for vowel 
% %                     end
% %                 otherwise
% %                     errordlg('Error in /r/ model type', 'Error', 'modal') ;
% %             end        
% %             
% %             
% %             
% %              % popmenu
% %              Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;
% % 
% %             
% %         case 6  % '/l/'
% % 
% % 
% %             %      'Back'
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel 
% %             %      'Front'
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Front''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel 
% %             %      'Channel1'
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Channel1''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 4) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 5);  % 2 unused for vowel 
% % 
% %              %      'Number_of_Channels'          2    [ 2 or 1, if 1, then only Channel1 valid]
% %             [tempLength] = get_data(Category-1, '''Number_of_Channels''', File) ;  % get data from file
% %             if(tempLength == 2)
% %                Callback_EditArea(Category, Type, 'Lateral Channels', VT.handles_EditArea{Category, Type}.LateralChannel(2)) ;
% %            elseif(tempLength == 1)
% %                Callback_EditArea(Category, Type, 'Lateral Channels', VT.handles_EditArea{Category, Type}.LateralChannel(1)) ;
% %            else
% %                errordlg(['Number_of_Channels !'], 'Error', 'modal') ; % return ;
% %            end
% %             
% %             %      'Channel2'
% %             if(tempLength == 2)
% %                 [j, tempLength, tempArea] = get_data(Category-1, '''Channel2''', File) ;  % get data from file
% %                     put_areafunction(Category,Type,tempLength, tempArea, 5) ; % put data into array
% %                     set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 6);  % 2 unused for vowel 
% %             end
% %             %      'Supralingual_on_or_off'      1    [1 - on , 0 - off]
% %             [tempLength] = get_data(Category-1, '''Supralingual_on_or_off''', File) ;  % get data from file
% %             
% %             if(tempLength == 1)
% %                 Callback_EditArea(Category, Type, 'Supralingual', VT.handles_EditArea{Category, Type}.Supralingual(1))
% %             elseif(tempLength == 0)
% %                 Callback_EditArea(Category, Type, 'Supralingual', VT.handles_EditArea{Category, Type}.Supralingual(2))
% %             else
% %                 errordlg(['Supralingual_on_or_off !'], 'Error', 'modal') ; % return ;
% %             end
% %             %      'Supralingual'
% %             if(tempLength == 1)
% %                 [j, tempLength, tempArea] = get_data(Category-1, '''Supralingual''', File) ;  % get data from file
% %                     put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
% %                     set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 4);  % 2 unused for vowel 
% %             
% %             end
% % 
% %             % popmenu
% %              Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;
% % 
% %             
% %             
% %         case 7  % 'Nasalized_vowel'
% % %      'number_of_Nostril' 2                  [ always 2 in current coding  or 1, if 1, then only Nostril_1 valid]
% % %      'Pharynx' 
% % %      'Oral' 
% % %      'Back'
% % %      'Nostril_1'
% % %      'Nostril_2'
% % %      'CoupleArea'  2.0
% %             %            Pharynx
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Pharynx''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel 
% % 
% %             %            Oral
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Oral''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel 
% %             %            Back
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 4);  % 2 unused for vowel 
% %             %            Nostril_1
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_1''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 4) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 5);  % 2 unused for vowel 
% % 
% %            %        number of nostrils
% %             [tempLength] = get_data(Category-1, '''number_of_Nostril''', File) ;  % get data from file
% %             % copy this to edit area
% %             if(tempLength == 2)
% %                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(2))
% %             else
% %                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(1))
% %             end
% %             
% %             %            Nostril_2
% %             if(tempLength == 2)
% %             [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_2''', File) ;  % get data from file
% %                 put_areafunction(Category,Type,tempLength, tempArea, 5) ; % put data into array
% %                 set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 6);  % 2 unused for vowel 
% %             end
% %             
% %             % popmenu
% %              Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;
% %             
% %             % do not need it since Popmenu callback will do this ....
% %             % array_to_editarea(Category, Type) ;
% % 
% %             %           'CoupleArea'
% %             [tempLength] = get_data(Category-1, '''CoupleArea''', File) ;  % get data from file
% %                Callback_EditArea(Category, Type, 'Couple Area', VT.handles_EditArea{Category, Type}.CoupleArea, tempLength) ;
% % 
% % 
% % 
% %         otherwise
% %     end
% % end
% % 
% % 
% % 
% % 
% % 
% % fprintf(fid, '%s \n', 'leftDL') ;
% % fprintf(fid, '%s \n', num2str(length(leftDL))) ;
% % fprintf(fid, '%s \n', num2str((leftDL))) ;
% % fprintf(fid, '%s \n', num2str((leftArea))) ;
% % 
% % 
% % fprintf(fid, '%s \n', 'rightDL') ;
% % fprintf(fid, '%s \n', num2str(length(rightDL))) ;
% % fprintf(fid, '%s \n', num2str((rightDL))) ;
% % fprintf(fid, '%s \n', num2str((rightArea))) ;
% % 
% % fprintf(fid, '%s \n', 'velarDL') ;
% % fprintf(fid, '%s \n', num2str(length(velarDL))) ;
% % fprintf(fid, '%s \n', num2str((velarDL))) ;
% % fprintf(fid, '%s \n', num2str((velarArea))) ;
% % 
% % 
% % fprintf(fid, '%s \n', 'NasalCouplingArea') ;
% % fprintf(fid, '%s \n', num2str(NasalCouplingArea)) ;
% %  
% % 
% % fprintf(fid, '%s \n', 'backDL') ;
% % fprintf(fid, '%s \n', num2str(length(backDL))) ;
% % fprintf(fid, '%s \n', num2str((backDL))) ;
% % fprintf(fid, '%s \n', num2str((backArea))) ;
% % 
% % fprintf(fid, '%s \n', 'frontDL') ;
% % fprintf(fid, '%s \n', num2str(length(frontDL))) ;
% % fprintf(fid, '%s \n', num2str((frontDL))) ;
% % fprintf(fid, '%s \n', num2str((frontArea))) ;
% % 
% % 
% % 
% % 
% % warndlg('save operation completed',' done ', 'modal') ;
% % return ;