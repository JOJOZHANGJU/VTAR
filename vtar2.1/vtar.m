% function varargout = vtar(varargin)
% 
% - This is an interface to calculate the acoustic response of vocal tract
% the model is named VTAR.
% It is developed by speech communication lab, university of maryland,
%
% - type 'vtar' to run this program, but add folder '/vtar' into matlab path before running it 
%
% - The details of documentation can be found at vtar/help  
% or http://www.isr.umd.edu/labs/scl/vtar, user can access help files
% througth interface.
%  
% - part of interface is designed through GUIDE, user can open vtar.fig to
% see its details
%
% 01/06/2004
% Last update    06/01/2004 by xinhui, zhou

function varargout = vtar(varargin)
% VTAR Application M-file for vtar.fig
%    FIG = VTAR launch vtar GUI.
%    VTAR('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 14-May-2007 23:53:02

global VT ;   % VT - Vocal Tract
if nargin == 0  % LAUNCH GUI
    % Try - catch -end is to detect any unexpected error in running VTAR and 
    % user has to restart VTAR if unexpected error happens 
    try 
        % To avoid the problem with restart the GUI while one instance is
        % already open
        if length(VT)~=0  % if(~isempty('VT'))
            figure(VT.handles.vtar)
            return ;
        end
        
        % VTAR does not work property in Matlab5
        verMatlab = version ;
        if (str2num(verMatlab(1))<=5)
           errordlg('sorry ! VTAR does not work on Matlab 5', 'error in VTAR', 'modal') ;
           return ;
        elseif (str2num(verMatlab(1)) == 7) % for Matlab 7.0 , some bug on global variable 
           feature('accel', 0) ;  % this is just an internal command obtained from mathworks to solve bug
        end
        
        fig = openfig(mfilename,'reuse');

        % Generate a structure of handles to pass to callbacks, and store it. 
        handles = guihandles(fig);
        guidata(fig, handles);
        
        % to adjust the size of figure window
        % assuming 1024*768 is the minimum size of screen size 
        fp = get(fig, 'position' ) ; 
        tempSize = get(0, 'screensize') ;
        if tempSize(3)*0.9 > 1024
            fp(3) = tempSize(3)*0.9 ;
        end    
        if tempSize(4)*0.9 > 768
            fp(4) = tempSize(4)*0.9 ;
        end
        set(fig, 'position', fp);
                
        movegui(fig, 'center') ;  % move the gui to the center of screen
                % in case some computers have smaller window
        ScreenSize = get(0, 'ScreenSize') ; % [1 1 1280 1024]
        % set(fig, 'position', ScreenSize) ;
        
        vtar_init1(handles) ;
        
    catch
        errordlg('Some problem in initialization , please use clear all and close all before starting VTAR ', 'error in VTAR', 'modal') ;
        if(exist('fig'))
            if(ishandle(fig))
                close(fig) ;
            end
        end
        % clear(VT.handles.vtar) ;  % this is to close the main window in case there are some strange and elusive errors
    end
    
    % Wait for callbacks to run and window to be dismissed:
    % uiwait(fig);
    if nargout > 0
        varargout{1} = fig;
    end
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
     try
        if (nargout)
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        else
            feval(varargin{:}); % FEVAL switchyard
        end
     catch
        disp(lasterr);
     end
end



%******************************************
%
%   CALLBACKS OF MENUS , BUTTONS ......
%
%******************************************

% Help munu iterms: 
% Manual:   vtar/help/vtar.html
% Online_help: http://www.isr.umd.edu/labs/scl/vtar or VT.Online_help  
% Email:  ?
% About_vtar: ...
% --------------------------------------------------------------------
function varargout = Help_Callback(h, eventdata, handles, varargin)

global VT ;
s = get(h,'tag') ;
switch s
    case 'Help'
        return ;
    case 'Manual'
        web(['file:' VT.vtarPath VT.Manual]) ; % VT.vtarPath and VT.Manual are specified in vtar_init1.m
    case 'Online_help'
        stat = web(VT.Online_help, '-browser') ;      
        if(stat==1)
            errordlg('Browser not found','Error', 'modal'); return ; 
        elseif(stat==2)
            errordlg('Browser not launched','Error', 'modal'); return ; 
        end
    case 'Email'
        eval(['web ' 'mailto:' VT.Email] ) ;
    case 'About_vtar'
        % h = helpdlg('VTAR is developed by speech communication lab in university of maryland, college park',     'About vtar', 'modal') ;
%         Msg = ['VTAR Version 1.0   -  July 2004                                                              ', ...
%                 'Developed by Speech Communication Lab in University of Maryland, College Park                                                                                  ', ...
%                 'Please send email to ' VT.Email  ' for further information or report bugs'] ;
        Msg = ['VTAR Version 2.0   -  June 2007                                                              ', ...
                'Speech Communication Lab at University of Maryland, College Park                                                                                  ', ...
                'Send feedback to ' VT.Email ] ;
         msgbox(Msg, 'About VTAR', 'help' , 'modal' ) ;
    otherwise
        errordlg('Unkown menu item chosen', 'Error', 'modal'); return ; 
end
return ;


% --------------------------------------------------------------------
function varargout = Air_property_Callback(h, eventdata, handles, varargin)
% property
property_fluid ;
return ;

% --------------------------------------------------------------------
function varargout = Wall_property_Callback(h, eventdata, handles, varargin)
% property
property_fluid ;
return ;


% --------------------------------------------------------------------
function varargout = Calculation_option_Callback(h, eventdata, handles, varargin)
% property
calculate_option ;
return ;

% --------------------------------------------------------------------
function varargout = Load_Callback(h, eventdata, handles, varargin)

global VT
try
    loadfile ;
catch
    errordlg('Error in file loading ', 'Error', 'modal') ;
end
return ;

% --------------------------------------------------------------------
function varargout = Save_Callback(h, eventdata, handles, varargin)
global VT
savefile ; 
return ;


% --------------------------------------------------------------------
function varargout = Exit_Callback(h, eventdata, handles, varargin)
% May not be very good statement to use close all

%pos_size = get(handles.vtar,'Position');

% user_response = modaldlg([pos_size(1)+pos_size(3)/5 pos_size(2)+pos_size(4)/5]);
user_response = questdlg('Do you want to exit ?',...
    'Exit','Yes','No','No');

switch lower(user_response)
    case {'no','cancel', []}
        return ;
        % take no action
    case 'yes'
        % Prepare to close GUI application window
        %                  .
        %                  .
        %                  .
        % 	delete(handles.figure1)
end
% close all  % exit 
close(handles.vtar) ;

% clear VT is just for convenience of restart vtar without any hidden
% trouble of handles, because MATLAB has this global variable even the
% figure is closed. One lesson is that it is better to use user data
% structre for figure handle instead of global varialbles. but it is too
% late to change the data structure

% clear global VT ;



% to calculate the acoustic response
% --------------------------------------------------------------------
function varargout = Apply_Callback(h, eventdata, handles, varargin)
global VT

if (VT.CurrentModeltype == 1) & (VT.CurrentGeneric ==1 )
    hTemp = errordlg('Area Function is not ready', 'Error', 'modal'); return ;
end

% need to get model type , it is not very useful right now. 06/02/2004
if(VT.CurrentGeneric == 1)
    Type = VT.handles_EditArea{VT.CurrentCategory, VT.CurrentModeltype}.RealType ;  
else
    Type = VT.handles_EditArea{VT.CurrentCategory, VT.CurrentGeneric+20}.RealType ;
end
%VT.RealType = Type ; 
get_acousticResponse(VT.CurrentCategory, Type);
return ;


% --------------------------------------------------------------------
function varargout = Radiation_Load_Callback(h, eventdata, handles, varargin)

global VT
ItemSelected = get(h, 'tag') ;
if isequal(ItemSelected, 'Radiation_Load_On')
    set(handles.Radiation_Load_On, 'Checked', 'on');
    set(handles.Radiation_Load_Off, 'Checked', 'off');
    VT.Radiation_Load = 'on' ; 
    VT.Property.Radiation = 1 ;

elseif(isequal(ItemSelected, 'Radiation_Load_Off'))
    set(handles.Radiation_Load_On, 'Checked', 'off');
    set(handles.Radiation_Load_Off, 'Checked', 'on');
    VT.Radiation_Load = 'off' ;     
    VT.Property.Radiation = 0 ;
end


% Callback for choice of category
% --------------------------------------------------------------------
function varargout = Category_Callback(h, eventdata, handles, varargin)
global VT

% which item you choose from popmenu
val = get(h,'Value');

% do not need to do anything, if the item chosen unchanged, but if val== 8,
% continue because it will read file whether or not it is selected at
% immediate last time.
% if (val == VT.CurrentCategory) &  (val~=8) , return ;  end  // outdated
if (val == VT.CurrentCategory)  return ;  end 


% set the val to current category
VT.CurrentCategory = val ;

% what kinds of plots we need to display, we have to use it 
% adapt to different sound, this one should be done without 
% connection to the area function input initially
% but the changeing area function will affect the value of plot , need to
% be updated *********

% if CurrentCategory is 1 (no category), 
% then the plots will be arbitray , which 
% depends on which category is the most recent one  ----- corrected now
% ---- using the plots as vowel as default plots when category is 1

% reset the acoustic response
if (nargin == 4)
    % nargin == 4, which means data are loaded directly from mat file. see loadfile.m
    % since data is loaded from file, do not clear f and AR as the
    % following
else
    VT.f  = 6000 ; 
    VT.AR =  0   ;  % zeros(1, 6000) ; 
end

% arbitrary type of sound will be input throught interface instead of just
% file ...

% if (val == 8)  % arbitray , need to get an input file with vocal tract configuration 
%     set(VT.handles.Apply, 'enable', 'off') ;
%     set(VT.toolbar.run  , 'enable', 'off') ;
%     if(nargin == 3)  % in case nargin == 4, which means data are loaded directly from mat file. see loadfile.m
%         get_acousticResponse ;
%     end
% else
%     set(VT.handles.Apply, 'enable', 'on') ;
%     set(VT.toolbar.run  , 'enable', 'on') ;
% end

% reset the menu for model type
set(handles.Model_type, 'String', VT.Model_types{val}) ; 
set(handles.Model_type, 'Value', 1) ; 
VT.CurrentModeltype = 1 ; % reset model type

% reset the menu for Generic_model
set(handles.Generic_model, 'String', VT.Generic_models{val}) ; 
set(handles.Generic_model, 'Value', 1) ; 
set(handles.Generic_model_text, 'String',VT.Generic_model_text{val} ) ;
VT.CurrentGeneric   = 1 ;

% ? how to clear all of them, edit area
% ????? how about plot areas ?????
% temporary answer: No, becuase it will adapt to the area function in 
% this category...
%----------------------------------------
%ClearEditArea(VT.Current_handle_EditArea) ;

% clear the edit area
VT.CurrentModeltype = 1 ; % reset model type
set(VT.Current_handle_EditArea, 'Visible', 'Off')
VT.Current_handle_EditArea = 0 ;   

% clear plots by put data to them..
% pending...

% assuming type 1 in model

% Update the plots' title......
updateplots(handles, 'category') ;  

% latest update
% 
%   vtar('Model_type_Callback',VT.handles.Model_type,[], VT.handles, [File(1:end-4) '.txt'])
%   VT.CurrentModeltype = 0 ; % reset model type

% after choosing one category, automatically using the first model
% if (val == 8)  % arbitray , need to get a input file with vocal tract configuration 
% else

% commented due to addition of fricative sound
% if (val == 3)
%     msgbox('No model for consonant right now', 'Message', 'modal') ;
% elseif(val~=1) % no category chosen
%     set(handles.Model_type,'Value', 2) ;
%     vtar('Model_type_Callback' ,1, [], VT.handles );  %, [File(1:end-4) '.txt'])
% end

if(val~=1) % no category chosen
    set(handles.Model_type,'Value', 2) ;
    vtar('Model_type_Callback' ,1, [], VT.handles );  %, [File(1:end-4) '.txt'])
end

return ;



% Callback for choice of Model_type
% --------------------------------------------------------------------
function varargout = Model_type_Callback(h, eventdata, handles, varargin)

global VT

% which item you choose
% if model type  is empty, 1, then Edit area not available
val = get(handles.Model_type,'Value');
if val == VT.CurrentModeltype  % do not need to do anything, since the item chosen unchanged
    % but not adapt to 'From File' option
    % ?????????????????????????????????????????
    % ????????
    % return ;
end
VT.CurrentModeltype = val ;

% clear current edit area
set(VT.Current_handle_EditArea, 'Visible', 'Off') ;
if val==1
    % For the case that model is 1, but generic is not 1, we can not 
    % make the edit area invisible...
    if(VT.CurrentGeneric ~= 1)
        set(VT.Current_handle_EditArea, 'Visible', 'On') ;
    end
    return ;  
end  % if type is 1, empty , return ;

% if a model is chosen , then no generic area function appears
if(val~=1)
    set(handles.Generic_model, 'Value', 1) ; VT.CurrentGeneric   = 1 ;
end

% Update titles of plots
% different type has different titles
updateplots(handles, 'category', VT.CurrentModeltype-1) ;  % for update the plots' title......


% setup a new edit area
if( isempty(VT.handles_EditArea{VT.CurrentCategory, VT.CurrentModeltype} ))
    sTemp =  get(handles.Model_type,'String') ;
    if(val == length(sTemp) )   % the last item in the list is 'From File' ;   if( isequal(sTemp{val}, 'From File')  )
        Create_handlesEditArea( VT.CurrentCategory, VT.CurrentModeltype, 'model', 1 ) ; % from file
    else
        Create_handlesEditArea( VT.CurrentCategory, VT.CurrentModeltype, 'model', VT.CurrentModeltype-1 ) ; 
        % VT.CurrentModeltype-1, different model type may have different geometry schematic
    end
end
VT.Current_handle_EditArea = VT.handles_EditArea{ VT.CurrentCategory, VT.CurrentModeltype }.handleList ;
set( VT.Current_handle_EditArea , 'Visible', 'On') ;



% if From File, read the data from file
sTemp =  get(handles.Model_type,'String') ;
if( isequal(sTemp{val}, 'From File')  & nargin == 3)
    Callback_EditArea( VT.CurrentCategory, VT.CurrentModeltype, 'readFile') ;
end ;

% 'From file' in case of nargin == 3 means the area function is from input
% file, 
% nargin == 4 means that not only the area function but also ohter setting
% information including the acoustic response are from file which is saved
% from previous runing. 
if(nargin == 4)  % from loading file, see Loadfile.m
    Callback_EditArea( VT.CurrentCategory, VT.CurrentModeltype, 'readFile', varargin{1}) ;  % varargin{1} ,name of the file where the data are from 
end

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% need to consider to copy data from corresponding area function to Edit
% area if there are some area function is already available
%
%%
% update the plot from previous data

% if there is some error in making the edit area....
% NOT USED .... SINCE IT WILL NEVER HAPPEN
if(isempty(VT.handles_EditArea{ VT.CurrentCategory, VT.CurrentModeltype }))
    return ;
end

% Update the edit area , particularly in case the user input some data
% before.
if(VT.CurrentCategory ~= 8)  % not for arbitrary
    Callback_EditArea( VT.CurrentCategory, VT.CurrentModeltype, 'General') ;
end
VT.Current_handle_EditArea = VT.handles_EditArea{ VT.CurrentCategory, VT.CurrentModeltype }.handleList ;
set( VT.Current_handle_EditArea , 'Visible', 'On') ;

% if arbitrary
if(VT.CurrentCategory == 8)  % not for arbitrary
    sTemp =  get(handles.Model_type,'String') ;
    if( ~isequal(sTemp{val}, 'From File')  & nargin == 3)
        VT.Arbitrary.Geometry.Mode = val ;  % oral mode, nasal mode, or oral nasal mode
    else
        set(handles.Model_type,'Value', VT.Arbitrary.Geometry.Mode) ;
    end ;
    
    % update the edit area ;
    VT.handles_EditArea{VT.CurrentCategory, VT.CurrentModeltype}.Index = -1 ;
    Callback_EditArea( VT.CurrentCategory, VT.CurrentModeltype, 'arbitrary', 0) ;
end


return ;



% Callback for generic area function . 
% This function is to offer user some examples of area fucntion for each
% sound.
% --------------------------------------------------------------------
function varargout = Generic_model_Callback(h, eventdata, handles, varargin)
global VT 

% Get the filename including the area function information for specefic vowel
val = get(h,'Value');
%disp(val)
if val==1  
    % just in case , popmenu of both model type and generic area function  are 1's
    if (VT.CurrentModeltype == 1)
        set(VT.Current_handle_EditArea, 'Visible', 'Off') ;
        VT.CurrentGeneric = 1 ;
        updateplots(handles, 'category') ; 
    end 
    return ;
end
VT.CurrentGeneric = val ;
VT.CurrentModeltype = 1 ;

set(handles.Model_type, 'Value', 1) ; 

% in order to refresh the window, remember the handles to be made invisible
set(VT.Current_handle_EditArea, 'Visible', 'Off') ;
VT.Current_handle_EditArea = 0 ;   

% different type has different titles
updateplots(handles, 'category', 1) ;  % for update the plots' title......

if( isempty(VT.handles_EditArea{VT.CurrentCategory, VT.CurrentGeneric+20} )) % 20 is added on purpose
    Create_handlesEditArea( VT.CurrentCategory, VT.CurrentGeneric, 'generic', 1 ) ;
end
VT.Current_handle_EditArea = VT.handles_EditArea{ VT.CurrentCategory, VT.CurrentGeneric+20 }.handleList ;
set( VT.Current_handle_EditArea , 'Visible', 'On') ;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% need to consider to copy file from corresponding area function to Edit
% area if there are some area function is already available
%
%%
% update the plot from previous data
% Callback_EditArea( VT.CurrentCategory, VT.CurrentGeneric+20, 'General') ;  % no use right here

% Reading data from file
if(nargin == 4) % considering Loading file
    File =  varargin{1} ; % loading file
else
    s = get(h,'String') ; % list of generic function file names
    if(~isequal(s{val}, 'From MRI images'))
        temp = get(handles.Category, 'Value') ; % which category of sound, vowel, consonant....
        File = [VT.vtarPath VT.generic_areafunctionFolder{temp} s{val}, '.ARE'] ; % file path and name 
    else  % get from pictures about which one should be used 
        CategoryTemp = get(handles.Category, 'Value')  ;
        temp = get_from_pictures( CategoryTemp ) ;
        return ; % temporary use   
    end
end

if exist(File) ~= 2
    errordlg('File does not exist','Error', 'modal'); return ;
    return ;
end

% read file
Callback_EditArea( VT.CurrentCategory, VT.CurrentGeneric+20, 'readFile', File) ; 

VT.Current_handle_EditArea = VT.handles_EditArea{ VT.CurrentCategory, VT.CurrentGeneric+20 }.handleList ;
set( VT.Current_handle_EditArea , 'Visible', 'On') ;

% if arbitrary
if(VT.CurrentCategory == 8)  % not for arbitrary
    VT.Arbitrary.Geometry.Mode = val ;  % oral mode, nasal mode, or oral nasal mode
    % update the edit area ;
    VT.handles_EditArea{VT.CurrentCategory,VT.CurrentGeneric+20}.Index = -1 ;
    Callback_EditArea( VT.CurrentCategory, VT.CurrentGeneric+20, 'arbitrary', 0) ;
end

return ;




%  Not being used now .....
%-------------------------------
% --- Executes when vtar window is resized.
function vtar_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to vtar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the figure size and position
Figure_Size = get(hObject,'Position') ;
% Set the figure's original size in normalized units
Original_Size = [ 0.0449    0.0586    0.9092    0.8307] ;  % just get it by reading the figure size 
% get(), uitoolbar changed the
% figure size
Original_Size = [47.0000   46.0000  931.0208  638.0000] ;  % pixels
% If the resized figure is smaller than the original figure size then compensate
% If the width is too small then reset to origianl width
% If the height is too small then reset to origianl width
if (Figure_Size(3) < Original_Size(3)) , Figure_Size(3) = Original_Size(3) ; end ;
if (Figure_Size(4) < Original_Size(4)) 
    Figure_Size(2) = Figure_Size(2)+Figure_Size(4)-Original_Size(4) ;     
    Figure_Size(4) = Original_Size(4) ; 
end ;
set(hObject,'Position',Figure_Size) ;
% movegui(hObject,'center')
return ;


% --- Executes when user attempts to close vtar.
function vtar_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to vtar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
vtarPath = which('vtar') ;
vtarPath = vtarPath(1:end-7) ;  % D:\My Documents\Speech\vtar\vtar.m
% delete the last 7 chars to get a path     
if ispc
    rmpath([vtarPath '\m']) ;  % remove this path in order to avoid the functions
    % in this folder recalled by other commands.
else
    rmpath([vtarPath '/m']) ;  % remove this path in order to avoid the functions
    % in this folder recalled by other commands.
end
clear global VT ;                           
% addpath(vtarPath)
% if ispc
%     addpath([vtarPath '\c'])
% else
%     addpath([vtarPath '\c\unix'])
% end
% addpath([vtarPath '\m'])


function output = get_from_pictures(Category)
global VT ;
output = 1 ;
if ispc
    imageFolder = '\image\' ;
else
    imageFolder = '/image/' ;
end

switch Category
    case 5  %/r/
        xdata = imread([VT.vtarPath imageFolder 'RR2.jpg']) ;
    case 6  %/l/
        xdata = imread([VT.vtarPath imageFolder 'LL2.jpg']) ;
    otherwise
        errordlg('error happend in get_from_pictures in vtar.m', 'error', 'modal') ;
        return ;
end

screenSize = get(0, 'screensize') ;
%             'closerequestfcn','',...

% hFig =  figure('createfcn','',...
%     'tag','picture',...
%     'numbertitle','off',...
%     'units','pixels',...
%     'position',[1/4*screenSize(3), 1/4*screenSize(4), 1/2*screenSize(3), 3/5*screenSize(4)], ...
%     'menubar','none',...
%     'inverthardcopy','off',...
%     'paperpositionmode','auto',...
%     'visible','on',...
%     'name','Choose area function from MRI images',...
%     'WindowStyle', 'modal') ;

hFig =  figure('createfcn','',...
    'tag','picture',...
    'numbertitle','off',...
    'units','pixels',...
    'position',round([1/4*screenSize(3), 1/4*screenSize(4), 1.15*1/2*screenSize(3), 1.15*3/5*screenSize(4)]), ...
    'menubar','none',...
    'inverthardcopy','off',...
    'paperpositionmode','auto',...
    'visible','on',...
    'name','Choose area function from MRI images') ;

hImg = image(xdata) ; %, 'parent', hFig) ;

%                    ud.lines(i).image = image(Xdata, 'parent', ud.ht.a(VT.numplots),...
%                                         'uicontextmenu',ud.contextMenu.u,...
%                                         'buttondownfcn', ['filtview(''mainaxes_down'',' num2str(VT.numplots) ')']) ;
% remove the tick label in case of image                                    
set(gca, 'XTickLabel',{' ', ' '})      ;
set(gca, 'YTickLabel',{' ', ' '})      ;

% no data for /l/ now
switch Category
    case 5  %/r/
    case 6  %/l/
%    h = msgbox('No MRI data available, please check later version of VTAR', 'Message', 'modal') ;
    h = msgbox('No area function data available for this speaker, please check later version of VTAR', 'Message', 'modal') ;
    uiwait (h) ;
    close (hFig) ;
    return ; 
    otherwise
        errordlg('error happend in get_from_pictures in vtar.m', 'error', 'modal') ;
        return ;
end

h = gca ; 
h1 = get(h, 'Children') ; % for the image in axes
% xlimValue = get(h, 'xlim')
% ylimValue = get(h, 'ylim')
%plot(gca, xlimValue, ylimValue, '.')
set(h1,'ButtonDownFcn',{@mouseClickMRI, h, Category});  % click the image to get area function, 

% commented by xinhui, 04/16/2007
%h = msgbox('No MRI data available, please check later version of VTAR', 'Message', 'modal') ;
%uiwait (h) ;
%close (hFig) ;
% 
% %%%%% added by xinhui 01/29/2004
%     fig = VT.handles.vtar ;
%     set(fig, 'userdata',ud,...
%             'units','pixels',...
%             'position',fp,...
%             'menubar','none',...
%             'inverthardcopy','off',...
%             'paperpositionmode','auto',...
%             'resizefcn','sbswitch(''resizedispatch'')%');
% 
%    
return ;

function mouseClickMRI(src,evt, axeH, Category)
global VT  ;
xy = get(axeH, 'currentpoint') ; 
xy = xy(2, 1:2) ; 
xlim = get(axeH, 'xlim') ;
ylim = get(axeH, 'ylim') ;
deltax = (xlim(2)-xlim(1))/5 ; 
deltay = (ylim(2)-ylim(1))/5 ; 
k = floor(xy(1)/deltax)+1 ;
m = floor(xy(2)/deltay)+1 ;
% subject = {'AM', 'AS', 'BG', 'DD', 'DJ', ...
%     'JC', 'JD', 'JM', 'JM2', 'LC', ...
%     'LH', 'LK', 'LP', 'LW', 'MD', ...
%     'MF', 'MH', 'MT', 'SH', 'SJ', ...
%     'SS1', 'SS2', 'TP' } ; 
subNo = 5*(m-1)+ k 
VT.subject{subNo}
filename = fullfile(VT.vtarPath, VT.generic_areafunctionFolder{Category},VT.generic_af_rFileName) ; 

load( filename) ; 
% find the subject area function
if(~exist([VT.subject{subNo}, '_distM1']))
    h = msgbox('No MRI data available, please check later version of VTAR', 'Message', 'modal') ;
    uiwait (h) ;
    return ; 
    %close (hFig) ;
end
% existing area function 
eval(['File = [' VT.subject{subNo}, '_distM1 ' VT.subject{subNo}, '_AreaM1];' ]) ; 
hfig = gcf ; 
figure(VT.handles.vtar) ; 
Callback_EditArea( VT.CurrentCategory, VT.CurrentGeneric+20, 'readFile', File) ; 
figure(hfig) ; 
return ; 

% pass area functin data into cell array and store it . 
% ------------------------------------------------
function put_areafunction(Category,Type,tempLength, tempArea, num) ; % put data into array
global VT ;
% remove old data
iLength = length(VT.handles_EditArea{Category,Type}.Length_data{num}) ; 
for i = 1 : iLength 
    VT.handles_EditArea{Category,Type}.Length_data{num}{i} = [] ;
    VT.handles_EditArea{Category,Type}.Area_data{num}{i} = [] ;
end
% put into new data
for iTemp = 1 : iLength
    if (iTemp<=length(tempLength))
        VT.handles_EditArea{Category,Type}.Length_data{num}{iTemp} = num2str(tempLength(iTemp)) ;
        VT.handles_EditArea{Category,Type}.Area_data{num}{iTemp} = num2str(tempArea(iTemp)) ;
    end ;
end
return ;

% --------------------------------------------------------------------
function Glottal_source_Callback(hObject, eventdata, handles)
% hObject    handle to Glottal_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
glottal_pulse;

% --------------------------------------------------------------------
function Tool_Callback(hObject, eventdata, handles)
% hObject    handle to Tool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Sound_synthesis_Callback(hObject, eventdata, handles)
% hObject    handle to Sound_synthesis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound_synthesis ; 

% --------------------------------------------------------------------
function Sensitivity_function_Callback(hObject, eventdata, handles)
% hObject    handle to Sensitivity_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sensitivity_function ; 

% --------------------------------------------------------------------
function Susceptance_plot_Callback(hObject, eventdata, handles)
% hObject    handle to Susceptance_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susceptance_gui ; %Susceptance_plot ; 


% --------------------------------------------------------------------
function areafunction_tuning_Callback(hObject, eventdata, handles)
% hObject    handle to areafunction_tuning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
formant_tune ; 

