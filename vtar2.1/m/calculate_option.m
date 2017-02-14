% function varargout = calculate_option(varargin)
% 
%
function varargout = calculate_option(varargin)
% CALCULATE_OPTION Application M-file for calculate_option.fig
%    FIG = CALCULATE_OPTION launch calculate_option GUI.
%    CALCULATE_OPTION('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 22-Apr-2007 11:41:56

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




% --------------------------------------------------------------------
function varargout = default_Callback(h, eventdata, handles, varargin)

global VT
set(handles.Fupper, 'String', 6000);
set(handles.df, 'String', 1);
set(handles.deltaL, 'String', 0.3);
set(handles.deltaL_sensitivity, 'String', 0.3);


% --------------------------------------------------------------------
function varargout = ok_Callback(h, eventdata, handles, varargin)

global VT
% check if the input is valid number
if isnan( str2double( get(handles.Fupper, 'String') )) | 0 >= ( str2double( get(handles.Fupper, 'String') ))
    errordlg('Maximum frequency must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.df, 'String') )) | 0 >= ( str2double( get(handles.df, 'String') ))
    errordlg('Frequency step must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.deltaL, 'String') )) | 0 >= ( str2double( get(handles.deltaL, 'String') ))
    errordlg('Maximu length of tube subsection for calculation must be a positive number','error', 'modal');return ;
end
if isnan( str2double( get(handles.deltaL_sensitivity, 'String') )) | 0 >= ( str2double( get(handles.deltaL, 'String') ))
    errordlg('Maximu length of tube subsection for calculation must be a positive number','error', 'modal');return ;
end

%set(handles.deltaL_sensitivity, 'String', 0.3);

% return ;
% % put the input data in VT structure
VT.Fupper = str2double( get(handles.Fupper, 'String') );
VT.df = str2double( get(handles.df, 'String') );
VT.deltaL = str2double( get(handles.deltaL, 'String') );
VT.deltaL_sensitivity = str2double( get(handles.deltaL_sensitivity, 'String') );
delete(gcbf) ;



% --------------------------------------------------------------------
function varargout = cancel_Callback(h, eventdata, handles, varargin)
delete(gcbf) ;



function Initialize(handles)
% % Initialize the parameters
global VT
set(handles.Fupper, 'String', VT.Fupper );
set(handles.df, 'String', VT.df );
set(handles.deltaL, 'String', VT.deltaL );
set(handles.deltaL_sensitivity, 'String', VT.deltaL_sensitivity );
%VT.deltaL_sensitivity = str2double( get(handles.deltaL_sensitivity, 'String') );

return ;


% --- Executes during object creation, after setting all properties.
function deltaL_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaL_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function deltaL_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to deltaL_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaL_sensitivity as text
%        str2double(get(hObject,'String')) returns contents of deltaL_sensitivity as a double


