% function varargout = formant_tune(varargin)
% 
% Modify property of fluid and wall in this program.
%
%  - xinhui, July 2004 
%
function varargout = formant_tune(varargin)
% FORMANT_TUNE Application M-file for formant_tune.fig
%    FIG = FORMANT_TUNE launch formant_tune GUI.
%    FORMANT_TUNE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 16-May-2007 10:54:08

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
%| formant_tune in the inspector. By default, GUIDE sets the formant_tune to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% --------------------------------------------------------------------
function varargout = default_Callback(h, eventdata, handles, varargin)

global VT
% global Current_Fluid ; 
% 
% i = Current_Fluid  ;  %VT.Property.Fluid
% VT.FormantExpect

set(handles.F1, 'String',  VT.Formant(1));
set(handles.F2, 'String',  VT.Formant(2));
set(handles.F3, 'String',  VT.Formant(3));
set(handles.F4, 'String',  VT.Formant(4));
set(handles.F5, 'String',  VT.Formant(5));
% set(handles.F1Current, 'String',  VT.Formant(1));
% set(handles.F2Current, 'String',  VT.Formant(2));
% set(handles.F3Current, 'String',  VT.Formant(3));
% set(handles.F4Current, 'String',  VT.Formant(4));
% set(handles.F5Current, 'String',  VT.Formant(5));
% set(handles.wall_inductance, 'String', VT.PropertyDefault{i}.WALL_L);
% set(handles.wall_resistance, 'String', VT.PropertyDefault{i}.WALL_R);
% set(handles.wall_capacitance, 'String', VT.PropertyDefault{i}.WALL_K);



% --------------------------------------------------------------------
function varargout = ok_Callback(h, eventdata, handles, varargin)

global VT
%global Current_Fluid ;   % only global in this file , shared with other functions to remember
                         % which fluid is currently chosen
% check if the input is valid number
if isnan( str2double( get(handles.F1, 'String') ))  | 0 > ( str2double( get(handles.F1, 'String') ))
    errordlg('density must be a positive number','error', 'modal'); return ;
end
    
if isnan( str2double( get(handles.F2, 'String') )) | 0 > ( str2double( get(handles.F2, 'String') ))
    errordlg('viscosity must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.F3, 'String') )) | 0 > ( str2double( get(handles.F3, 'String') ))
    errordlg('air speed must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.F4, 'String') )) | 0 > ( str2double( get(handles.F4, 'String') ))
    errordlg('specific heat must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.F5, 'String') )) | 0 > ( str2double( get(handles.F5, 'String') ))
    errordlg('heat conductiton must be a positive number','error', 'modal');return ;
end
% if isnan( str2double( get(handles.wall_inductance, 'String') )) | 0 > ( str2double( get(handles.wall_inductance, 'String') ))
%     errordlg('wall inductance must be a positive number','error', 'modal');return ;
% end
% if isnan( str2double( get(handles.wall_resistance, 'String') )) | 0 > ( str2double( get(handles.wall_resistance, 'String') ))
%     errordlg('wall resistance must be a positive number','error', 'modal');return ;
% end
% if isnan( str2double( get(handles.wall_capacitance, 'String') )) | 0 > ( str2double( get(handles.wall_capacitance, 'String') ))
%     errordlg('wall stiffness must be a positive number','error', 'modal');return ;
% end

% 
% if 0 > ( str2double( get(handles.F1, 'String') ))
%     errordlg('F1 must be a positive number','error', 'modal'); return ;
% end
% if 0 > ( str2double( get(handles.F2, 'String') ))
%     errordlg('F2 must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.F3, 'String') ))
%     errordlg('air speed must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.F4, 'String') ))
%     errordlg('specific heat must be a positive number','error', 'modal');return ;
% end
% if 0 > ( str2double( get(handles.F5, 'String') ))
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
VT.FormantExpect(1)  = str2double( get(handles.F1, 'String') ) ;
VT.FormantExpect(2)  = str2double( get(handles.F2, 'String') );
VT.FormantExpect(3)  = str2double( get(handles.F3, 'String') );
VT.FormantExpect(4)  = str2double( get(handles.F4, 'String') );
VT.FormantExpect(5)  = str2double( get(handles.F5, 'String') ) ;
% VT.Property.WALL_L = str2double( get(handles.wall_inductance, 'String') );
% VT.Property.WALL_R = str2double( get(handles.wall_resistance, 'String') );
% VT.Property.WALL_K = str2double( get(handles.wall_capacitance, 'String') );
% 
% VT.Property.Fluid  =  Current_Fluid  ;  %;
% VT.Property.ETA    = VT.PropertyDefault{VT.Property.Fluid}.ETA ;    %= 1.4;

%delete(gcbf) ;
tempF = diff(VT.FormantExpect) ;
if ~all(tempF>0)
    errordlg('Check your formant value !!! ','error', 'modal');
    return ;
end
areafunction_tuning ; 

% --------------------------------------------------------------------
function varargout = cancel_Callback(h, eventdata, handles, varargin)
delete(gcbf) ;



function Initialize(handles)
% % Initialize the parameters
global VT
% global Current_Fluid ; 
set(handles.F1, 'String',  VT.Formant(1));
set(handles.F2, 'String',  VT.Formant(2));
set(handles.F3, 'String',  VT.Formant(3));
set(handles.F4, 'String',  VT.Formant(4));
set(handles.F5, 'String',  VT.Formant(5));

set(handles.F1C, 'String',  VT.Formant(1));
set(handles.F2C, 'String',  VT.Formant(2));
set(handles.F3C, 'String',  VT.Formant(3));
set(handles.F4C, 'String',  VT.Formant(4));
set(handles.F5C, 'String',  VT.Formant(5));

% set(handles.F1Current, 'String',  VT.Formant(1));
% set(handles.F2Current, 'String',  VT.Formant(2));
% set(handles.F3Current, 'String',  VT.Formant(3));
% set(handles.F4Current, 'String',  VT.Formant(4));
% set(handles.F5Current, 'String',  VT.Formant(5));

% set(handles.F1, 'String', VT.Property.RHO );
% set(handles.F2, 'String', VT.Property.MU );
% set(handles.F3, 'String', VT.Property.C0 );
% set(handles.F4, 'String', VT.Property.CP );
% set(handles.F5, 'String', VT.Property.LAMDA );
% set(handles.wall_inductance, 'String', VT.Property.WALL_L );
% set(handles.wall_resistance, 'String', VT.Property.WALL_R );
% set(handles.wall_capacitance, 'String', VT.Property.WALL_K );
% 
% 
% for i = 1: length(VT.PropertyDefault)
%     temp{i} = VT.PropertyDefault{i}.Fluid ;
% end
% set(handles.Fluid, 'Value', VT.Property.Fluid );
% set(handles.Fluid, 'String', temp );
% 
% Current_Fluid = VT.Property.Fluid  ; % VT.Property.Fluid
return ;


% --- Executes on selection change in Fluid.
function Fluid_Callback(hObject, eventdata, handles)
global VT ;
global Current_Fluid ; 

val = get(hObject, 'Value') ;
if (Current_Fluid == val  )
    return ;
end

Current_Fluid = val ; % VT.Property.Fluid = val  ;
% copy result to the edit area  !!!;
default_Callback(hObject, eventdata, handles) ;


% --- Executes on button press in default.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ok.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancel.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function F1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function F1_Callback(hObject, eventdata, handles)
% hObject    handle to F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F1 as text
%        str2double(get(hObject,'String')) returns contents of F1 as a double


% --- Executes during object creation, after setting all properties.
function F3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function F3_Callback(hObject, eventdata, handles)
% hObject    handle to F3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F3 as text
%        str2double(get(hObject,'String')) returns contents of F3 as a double


% --- Executes during object creation, after setting all properties.
function F4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function F4_Callback(hObject, eventdata, handles)
% hObject    handle to F4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F4 as text
%        str2double(get(hObject,'String')) returns contents of F4 as a double


% --- Executes during object creation, after setting all properties.
function F5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function F5_Callback(hObject, eventdata, handles)
% hObject    handle to F5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F5 as text
%        str2double(get(hObject,'String')) returns contents of F5 as a double


% --- Executes during object creation, after setting all properties.
function F2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function F2_Callback(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F2 as text
%        str2double(get(hObject,'String')) returns contents of F2 as a double



function F3Current_Callback(hObject, eventdata, handles)
% hObject    handle to F3Current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F3Current as text
%        str2double(get(hObject,'String')) returns contents of F3Current as a double


% --- Executes during object creation, after setting all properties.
function F3Current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F3Current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F4Current_Callback(hObject, eventdata, handles)
% hObject    handle to F4Current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F4Current as text
%        str2double(get(hObject,'String')) returns contents of F4Current as a double


% --- Executes during object creation, after setting all properties.
function F4Current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F4Current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F5Current_Callback(hObject, eventdata, handles)
% hObject    handle to F5Current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F5Current as text
%        str2double(get(hObject,'String')) returns contents of F5Current as a double


% --- Executes during object creation, after setting all properties.
function F5Current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F5Current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F2Currrent_Callback(hObject, eventdata, handles)
% hObject    handle to F2Currrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F2Currrent as text
%        str2double(get(hObject,'String')) returns contents of F2Currrent as a double


% --- Executes during object creation, after setting all properties.
function F2Currrent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F2Currrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


