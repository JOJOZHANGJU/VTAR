function varargout = glottal_pulse1(varargin)
% GLOTTAL_PULSE1 M-file for glottal_pulse1.fig
%      GLOTTAL_PULSE1, by itself, creates a new GLOTTAL_PULSE1 or raises the existing
%      singleton*.
%
%      H = GLOTTAL_PULSE1 returns the handle to a new GLOTTAL_PULSE1 or the handle to
%      the existing singleton*.
%
%      GLOTTAL_PULSE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLOTTAL_PULSE1.M with the given input arguments.
%
%      GLOTTAL_PULSE1('Property','Value',...) creates a new GLOTTAL_PULSE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before glottal_pulse1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to glottal_pulse1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help glottal_pulse1

% Last Modified by GUIDE v2.5 21-May-2007 17:11:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @glottal_pulse1_OpeningFcn, ...
                   'gui_OutputFcn',  @glottal_pulse1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
else
    
    	fig = openfig(mfilename,'reuse');

    	handles = guihandles(fig);
	guidata(fig, handles);
    
    movegui(fig, 'center') ;
    Initialize(handles) ;  % copy value of property to edit area
    

end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



function Initialize(handles)
% % Initialize the parameters
global VT
set(handles.time_period, 'String', VT.glottalpulse.Tperiod);
set(handles.open_q, 'String', VT.glottalpulse.openP );
set(handles.close_q, 'String', VT.glottalpulse.openN);
set(handles.change_T, 'String', VT.glottalpulse.changeT );
set(handles.change_PN, 'String', VT.glottalpulse.changePN );
set(handles.delT, 'String', VT.glottalpulse.delT);
set(handles.shimmer_dB, 'String', VT.glottalpulse.shimmerdB);

% --- Executes just before glottal_pulse1 is made visible.
function glottal_pulse1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to glottal_pulse1 (see VARARGIN)

% Choose default command line output for glottal_pulse1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes glottal_pulse1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = glottal_pulse1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function time_period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function time_period_Callback(hObject, eventdata, handles)
% hObject    handle to time_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_period as text
%        str2double(get(hObject,'String')) returns contents of time_period as a double


% --- Executes during object creation, after setting all properties.
function open_q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to open_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function open_q_Callback(hObject, eventdata, handles)
% hObject    handle to open_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of open_q as text
%        str2double(get(hObject,'String')) returns contents of open_q as a double


% --- Executes during object creation, after setting all properties.
function close_q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to close_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function close_q_Callback(hObject, eventdata, handles)
% hObject    handle to close_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of close_q as text
%        str2double(get(hObject,'String')) returns contents of close_q as a double


% --- Executes during object creation, after setting all properties.
function change_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to change_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function change_T_Callback(hObject, eventdata, handles)
% hObject    handle to change_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of change_T as text
%        str2double(get(hObject,'String')) returns contents of change_T as a double


% --- Executes during object creation, after setting all properties.
function change_PN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to change_PN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function change_PN_Callback(hObject, eventdata, handles)
% hObject    handle to change_PN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of change_PN as text
%        str2double(get(hObject,'String')) returns contents of change_PN as a double


% --- Executes on button press in Default.
function Default_Callback(hObject, eventdata, handles)
global VT
set(handles.time_period, 'String', VT.glottalpulse.Tperiod);
set(handles.open_q, 'String', VT.glottalpulse.openP );
set(handles.close_q, 'String', VT.glottalpulse.openN);
set(handles.change_T, 'String', VT.glottalpulse.changeT );
set(handles.change_PN, 'String', VT.glottalpulse.changePN );
set(handles.delT, 'String', VT.glottalpulse.delT);
% hObject    handle to Default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VT
global Current_Fluid ;   % only global in this file , shared with other functions to remember
                         % which fluid is currently chosen
% check if the input is valid number
if isnan( str2double( get(handles.time_period, 'String') ))  | 0 > ( str2double( get(handles.time_period, 'String') )) 
    errordlg('time period must be a positive number','error', 'modal'); return ;
end
    
if isnan( str2double( get(handles.open_q, 'String') )) | 0 > ( str2double( get(handles.open_q, 'String') ))
    errordlg('open quotient must be greater than zero and less than one','error', 'modal');return ;
end
if isnan( str2double( get(handles.close_q, 'String') )) | 0 > ( str2double( get(handles.close_q, 'String') ))
    errordlg('close quotient must be greater than zero and less than one','error', 'modal');return ;
end
if ( str2double(get(handles.open_q, 'string')) + str2double(get(handles.close_q, 'string'))) >1
    errordlg('sum of open quotient and close quotient must be equal to or less than one', 'error', 'modal'); return;
end


VT.glottalpulse.Tperiod = str2double( get(handles.time_period, 'String') ) ;
VT.glottalpulse.openP  = str2double( get(handles.open_q, 'String') );
VT.glottalpulse.openN = str2double( get(handles.close_q, 'String') );
VT.glottalpulse.changeT = str2double( get(handles.change_T, 'String') );
VT.glottalpulse.changePN = str2double( get(handles.change_PN, 'String') );
VT.glottalpulse.delT = str2double( get(handles.delT, 'String'));
VT.glottalpulse.shimmerdB = str2double( get(handles.shimmer_dB, 'String'));

delete(gcbf) ;

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
delete(gcbf);
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function delT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function delT_Callback(hObject, eventdata, handles)
% hObject    handle to delT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delT as text
%        str2double(get(hObject,'String')) returns contents of delT as a double


% --- Executes during object creation, after setting all properties.
function shimmer_dB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shimmer_dB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function shimmer_dB_Callback(hObject, eventdata, handles)
% hObject    handle to shimmer_dB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shimmer_dB as text
%        str2double(get(hObject,'String')) returns contents of shimmer_dB as a double


% --- Executes during object creation, after setting all properties.
function glottal_source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to glottal_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in glottal_source.
function glottal_source_Callback(hObject, eventdata, handles)
% hObject    handle to glottal_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns glottal_source contents as cell array
%        contents{get(hObject,'Value')} returns selected item from glottal_source


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


