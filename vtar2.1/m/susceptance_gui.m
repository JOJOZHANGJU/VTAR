% function varargout = susceptance_gui(varargin)
% 
% Modify property of tube and wall in this program.
%
%  - xinhui, July 2004 
%
function varargout = susceptance_gui(varargin)
% SUSCEPTANCE_GUI Application M-file for susceptance_gui.fig
%    FIG = SUSCEPTANCE_GUI launch susceptance_gui GUI.
%    SUSCEPTANCE_GUI('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 07-Feb-2007 09:28:10

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    movegui(fig, 'center') ;
    Initialize(handles) ;  % copy value of property to edit area
    
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


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| susceptance_gui in the inspector. By default, GUIDE sets the susceptance_gui to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% --------------------------------------------------------------------
function varargout = default_Callback(h, eventdata, handles, varargin)

global VT
global Current_Fluid ; 

i = Current_Fluid  ;  %VT.Property.Fluid ;
set(handles.midLoc, 'String', VT.PropertyDefault{i}.RHO);
set(handles.viscosity, 'String', VT.PropertyDefault{i}.MU);
set(handles.air_speed, 'String', VT.PropertyDefault{i}.C0);
set(handles.spec_heat, 'String', VT.PropertyDefault{i}.CP);
set(handles.heat_conduct, 'String', VT.PropertyDefault{i}.LAMDA);
set(handles.wall_inductance, 'String', VT.PropertyDefault{i}.WALL_L);
set(handles.wall_resistance, 'String', VT.PropertyDefault{i}.WALL_R);
set(handles.wall_capacitance, 'String', VT.PropertyDefault{i}.WALL_K);



% --------------------------------------------------------------------
function varargout = plot_Callback(h, eventdata, handles, varargin)

global VT

END = 99900000  ;

tubeNo = get(handles.tube, 'Value' );
if( get(handles.endLoc, 'Value' )== 1)
    Loc = END ; 
else
    if isnan( str2double( get(handles.midLoc, 'String') ))  | 0 > ( str2double( get(handles.midLoc, 'String') ))
        errordlg('Location  must be a nonnegative number','error', 'modal'); return ;
    end
    Loc = str2double( get(handles.midLoc, 'String') ) ;
end
susceptance_plot(tubeNo, Loc) ; 
return ; 



global Current_Fluid ;   % only global in this file , shared with other functions to remember
                         % which tube is currently chosen
% check if the input is valid number
if isnan( str2double( get(handles.midLoc, 'String') ))  | 0 > ( str2double( get(handles.midLoc, 'String') ))
    errordlg('density must be a positive number','error', 'modal'); return ;
end
    
if isnan( str2double( get(handles.viscosity, 'String') )) | 0 > ( str2double( get(handles.viscosity, 'String') ))
    errordlg('viscosity must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.air_speed, 'String') )) | 0 > ( str2double( get(handles.air_speed, 'String') ))
    errordlg('air speed must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.spec_heat, 'String') )) | 0 > ( str2double( get(handles.spec_heat, 'String') ))
    errordlg('specific heat must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.heat_conduct, 'String') )) | 0 > ( str2double( get(handles.heat_conduct, 'String') ))
    errordlg('heat conductiton must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.wall_inductance, 'String') )) | 0 > ( str2double( get(handles.wall_inductance, 'String') ))
    errordlg('wall inductance must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.wall_resistance, 'String') )) | 0 > ( str2double( get(handles.wall_resistance, 'String') ))
    errordlg('wall resistance must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.wall_capacitance, 'String') )) | 0 > ( str2double( get(handles.wall_capacitance, 'String') ))
    errordlg('wall stiffness must be a positive number','error', 'modal');return ;
end

% 
% if 0 > ( str2double( get(handles.midLoc, 'String') ))
%     errordlg('midLoc must be a positive number','error', 'modal'); return ;
% end
% if 0 > ( str2double( get(handles.viscosity, 'String') ))
%     errordlg('viscosity must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.air_speed, 'String') ))
%     errordlg('air speed must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.spec_heat, 'String') ))
%     errordlg('specific heat must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.heat_conduct, 'String') ))
%     errordlg('heat conductiton must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.wall_inductance, 'String') ))
%     errordlg('wall inductance must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.wall_resistance, 'String') ))
%     errordlg('wall resistance must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.wall_capacitance, 'String') ))
%     errordlg('wall stiffness must be a positive number','error', 'modal');return ;
% end

% return ;
% % put the input data in VT structure
VT.Property.RHO = str2double( get(handles.midLoc, 'String') ) ;
VT.Property.MU  = str2double( get(handles.viscosity, 'String') );
VT.Property.C0  = str2double( get(handles.air_speed, 'String') );
VT.Property.CP     = str2double( get(handles.spec_heat, 'String') );
VT.Property.LAMDA  = str2double( get(handles.heat_conduct, 'String') ) ;
VT.Property.WALL_L = str2double( get(handles.wall_inductance, 'String') );
VT.Property.WALL_R = str2double( get(handles.wall_resistance, 'String') );
VT.Property.WALL_K = str2double( get(handles.wall_capacitance, 'String') );

VT.Property.Fluid  =  Current_Fluid  ;  %;
VT.Property.ETA    = VT.PropertyDefault{VT.Property.Fluid}.ETA ;    %= 1.4;

delete(gcbf) ;



% --------------------------------------------------------------------
function varargout = cancel_Callback(h, eventdata, handles, varargin)
delete(gcbf) ;



function Initialize(handles)
% % Initialize the parameters
global VT

tubeNames{1} = {'Whole vocal tract' };
tubeNames{2} = {'Whole vocal tract' };
%tubeNames{3} = {'Back', 'Oral', 'Velar tube', 'Nostril_1','Nostril_2' }
tubeNames{3} = {'Back cavity', 'Oral cavity', 'Velar tube', 'Nostril_1','Nostril_2' };
tubeNames{4} = {'Main vocal tract', 'Sublingual cavity' };
tubeNames{5} = {'Back cavity', 'Front cavity', 'Supralingual cavity', 'Channel_1','Channel_2' };
tubeNames{6} = {'Back cavity', 'Oral cavity', 'Velar tube', 'Nostril_1','Nostril_2' };
for k = 1: VT.maxnumTubes
    tubeNames{7}{k} = ['Tube' num2str(k)] ; 
end

set(handles.tube, 'Value', 1 );
if(VT.CurrentCategory==1)
set(handles.tube, 'String', '   ' );
else
set(handles.tube, 'String', tubeNames{VT.CurrentCategory-1} );
end

set(handles.endLoc,'Value', 1) ;
set(handles.midLoc, 'String', 0 );

if(VT.CurrentCategory== 4| VT.CurrentCategory==6 | VT.CurrentCategory==7 ) %  nasal, lateral, and nasalvowel   
set(handles.tube, 'Enable', 'off');
set(handles.endLoc, 'Enable', 'off') ;
set(handles.midLoc, 'Enable', 'off');
end

if(VT.CurrentCategory== 5) % rhtoic sound, in this sound, only consider the case without side branch
                           % check at the susceptance plot program,
                           % suscepatance_disp.m
   set(handles.tube, 'String', tubeNames{1});
end


return ; 
% 
% global Current_Fluid ; 
% set(handles.midLoc, 'String', VT.Property.RHO );
% set(handles.viscosity, 'String', VT.Property.MU );
% set(handles.air_speed, 'String', VT.Property.C0 );
% set(handles.spec_heat, 'String', VT.Property.CP );
% set(handles.heat_conduct, 'String', VT.Property.LAMDA );
% set(handles.wall_inductance, 'String', VT.Property.WALL_L );
% set(handles.wall_resistance, 'String', VT.Property.WALL_R );
% set(handles.wall_capacitance, 'String', VT.Property.WALL_K );
% 
% 
% for i = 1: length(VT.PropertyDefault)
%     temp{i} = VT.PropertyDefault{i}.Fluid ;
% end
% set(handles.tube, 'Value', VT.Property.Fluid );
% set(handles.tube, 'String', temp );
% 
% Current_Fluid = VT.Property.Fluid  ; % VT.Property.Fluid
return ;


% --- Executes on selection change in tube.
function tube_Callback(hObject, eventdata, handles)
global VT ;

return ; 

global Current_Fluid ; 

val = get(hObject, 'Value') ;
if (Current_Fluid == val  )
    return ;
end

Current_Fluid = val ; % VT.Property.Fluid = val  ;
% copy result to the edit area  !!!;
default_Callback(hObject, eventdata, handles) ;


% --- Executes on button press in endLoc.
function endLoc_Callback(hObject, eventdata, handles)
% hObject    handle to endLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of endLoc


