% ///////////////////////////////////////////
% //                18/03/2019             //
% ///////////////////////////////////////////
%   ---> Use COM3 for WindowsXP Lab Computer.
%   ---> Use COM9 for Luke's Laptop.
%   ---> Use COM6 for Luke's Arduino.
%
% ///////////////////////////////////////////
% //                12/03/2019             //
% ///////////////////////////////////////////
%   ---> Changes to calculations:
%           mass(g) = 1000*{[(pressure)*133.32*(circumference/(2*pi*1000))*(length/1000)]/9.806}
%   ---> Added Length of vessel (mm) (Text entry)
%   ---> Added Diastolic BP (mmHg) (Text entry)
%   ---> Added DBP static text
%   ---> Added Diastolic tension (g) (Static Text)
%   ---> MsgBoxes added when entries are NaN
%   ---> To add: If a limit is exceeded after value is entered,
%             restore the current value in text box so that
%             the user knows the current value still.
%
% ///////////////////////////////////////////
% //                8/03/2019              //
% ///////////////////////////////////////////
%   ---> Changes yet to be made to calculations:
%           mass(g) = 1000*{[(pressure)*133.32*(circumference/(2*pi*1000))*(length/1000)]/9.806}
%   ---> To Add, Length of vessel (mm) (Text entry)
%   ---> To Add, Diastolic BP (mmHg) (Text entry)
%   ---> To Add, DBP static text
%   ---> To Add, Diastolic tension (g) (Static Text)
%
% ///////////////////////////////////////////
% //                27/02/2019,            //
% ///////////////////////////////////////////
%   ---> Changes to Avinash's calculations.
%   ---> Incremental changes in values no longer included.
%   ---> BPS should now be displayed in BPM.
%   ---> Set a 6 RPM maximum value.
%
% /////////////////////////////////////////////////
% //                                             //
% //        SERIAL COMMS MESSAGE FORMAT          //
% //                                             //
% /////////////////////////////////////////////////
%
%   Bits sent from MATLAB via serial are read into
%   'Receieved_String' in the following order:
%   order:
% --> initialDistent (1 Char) [0]
% --> dist           (5 Char) [1 - 5]
% --> motorSpeed     (4 Char) [6 - 9]
% --> motorStatus    (1 Char) [  10 ]
% --> motorMode      (1 Char) [  11 ]
% --> analogDelay    (3 Char) [12 - 14]
% --> motorNumber    (1 Char) [  15 ]
% ----------------------------------------------
%                                   == (16 Char)
% '\0', NULL for string termination   (+1 Char)
% -----------------------------------------------
%
%   Copy & Paste below code for ease of use in Arduino Serial Monitor
%   M1 start 0000010002110001
%   M1 Stop  0000010002010001
%

function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose 'GUI allows only one
%      instance to run (singleton)'.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 29-Apr-2019 12:42:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

instrreset;

handles.const = Constant;

handles.M1 = Motor;
handles.M1.motorNumber = '1';

handles.M2 = Motor;
handles.M2.motorNumber = '2';

handles.M3 = Motor;
handles.M3.motorNumber = '3';

handles.M4 = Motor;
handles.M4.motorNumber = '4';

guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

handles.s = serial('COM9', 'BaudRate', 115200);
fopen(handles.s);

% Update handles structure
guidata(handles.figure1, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Hints: get(hObject,'String') returns contents of terminalwrite as text
%        str2double(get(hObject,'String')) returns contents of terminalwrite as a double

% --- Executes during object creation, after setting all properties.
function terminalwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to terminalwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in m4speedminus.
function m4speedminus_Callback(hObject, eventdata, handles)
% hObject    handle to m4speedminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4speedtemp = str2double(get(handles.m4speed,'String'));

if (m4speedtemp > 0) 
    m4speedtemp = m4speedtemp - 1;
    handles.M4.motorSpeed = strcat('00000',int2str(m4speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m4data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m4speed, 'String', num2str(m4speedtemp));


% --- Executes on button press in m4speedplus.
function m4speedplus_Callback(hObject, eventdata, handles)
% hObject    handle to m4speedplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4speedtemp = str2double(get(handles.m4speed,'String'));

if (m4speedtemp < 5) 
    m4speedtemp = m4speedtemp + 1;
    handles.M4.motorSpeed = strcat('00000',int2str(m4speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m4data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
else
    msgbox('Maximum speed reached');
end
    
set(handles.m4speed, 'String', num2str(m4speedtemp));


% --- Executes on button press in m4distminus.
function m4distminus_Callback(hObject, eventdata, handles)
% hObject    handle to m4distminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4disttemp = str2double(get(handles.m4dist,'String'));

if (m4disttemp > 0) 
    m4disttemp = m4disttemp - 1;
    handles.M4.dist = strcat('0',int2str(m4disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m4data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m4dist, 'String', num2str(m4disttemp));

% --- Executes on button press in m4distplus.
function m4distplus_Callback(hObject, eventdata, handles)
% hObject    handle to m4distplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4disttemp = str2double(get(handles.m4dist,'String'));

if (m4disttemp < 5) 
    m4disttemp = m4disttemp + 1;
    handles.M4.dist = strcat('0',int2str(m4disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m4data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);

else
    msgbox('Maximum distension reached');
end

set(handles.m4dist, 'String', int2str(m4disttemp));

guidata(handles.figure1, handles);



% --- Executes on button press in m4onoff.
function m4onoff_Callback(hObject, eventdata, handles)
% hObject    handle to m4onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stattemp = get(handles.m4stat,'String');

if (strcmp(stattemp,'OFF')) % compare strings
    set(handles.m4stat, 'String', 'ON');
    handles.M4.motorStatus = '1';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber)
    % Print Motor 1 data to COM port
    fprintf(handles.s, m4data);
    
    guidata(handles.figure1, handles);
end

if (strcmp(stattemp,'ON'))
    set(handles.m4stat, 'String', 'OFF');
    handles.M4.motorStatus = '0';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);

    fprintf(handles.s, m4data);
    
end
guidata(handles.figure1, handles);

guidata(handles.figure1, handles);


% --- Executes on button press in m3speedminus.
function m3speedminus_Callback(hObject, eventdata, handles)
% hObject    handle to m3speedminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3speedtemp = str2double(get(handles.m3speed,'String'));

if (m3speedtemp > 0) 
    m3speedtemp = m3speedtemp - 1;
    handles.M3.motorSpeed = strcat('00000',int2str(m3speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m3data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m3speed, 'String', num2str(m3speedtemp));


% --- Executes on button press in m3speedplus.
function m3speedplus_Callback(hObject, eventdata, handles)
% hObject    handle to m3speedplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3speedtemp = str2double(get(handles.m3speed,'String'));

if (m3speedtemp < 5) 
    m3speedtemp = m3speedtemp + 1;
    handles.M3.motorSpeed = strcat('00000',int2str(m3speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m3data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
    
else
    msgbox('Maximum speed reached');
end
    
set(handles.m3speed, 'String', num2str(m3speedtemp));


% --- Executes on button press in m3distminus.
function m3distminus_Callback(hObject, eventdata, handles)
% hObject    handle to m3distminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3disttemp = str2double(get(handles.m3dist,'String'));

if (m3disttemp > 0) 
    m3disttemp = m3disttemp - 1;
    handles.M3.dist = strcat('0',int2str(m3disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m3data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m3dist, 'String', num2str(m3disttemp));


% --- Executes on button press in m3distplus.
function m3distplus_Callback(hObject, eventdata, handles)
% hObject    handle to m3distplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3disttemp = str2double(get(handles.m3dist,'String'));

if (m3disttemp < 5) 
    m3disttemp = m3disttemp + 1;
    handles.M3.dist = strcat('0',int2str(m3disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m3data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
    
else
    msgbox('Maximum distension reached');
end
    
set(handles.m3dist, 'String', int2str(m3disttemp));



% --- Executes on button press in m3onoff.
function m3onoff_Callback(hObject, eventdata, handles)
% hObject    handle to m3onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stattemp = get(handles.m3stat,'String');

if (strcmp(stattemp,'OFF')) % compare strings
    set(handles.m3stat, 'String', 'ON');
    handles.M3.motorStatus = '1';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m3data);
    
    guidata(handles.figure1, handles);
end

if (strcmp(stattemp,'ON'))
    set(handles.m3stat, 'String', 'OFF');
    handles.M3.motorStatus = '0';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m3data);
    
    guidata(handles.figure1, handles);
end
guidata(handles.figure1, handles);


guidata(handles.figure1, handles);


% --- Executes on button press in m2distplus.
function m2distplus_Callback(hObject, eventdata, handles)
% hObject    handle to m2distplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2disttemp = str2double(get(handles.m2dist,'String'));

if (m2disttemp < 5) 
    m2disttemp = m2disttemp + 1;
    handles.M2.dist = strcat('0',int2str(m2disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m2data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
else
    msgbox('Maximum distension reached');
end
    
set(handles.m2dist, 'String', num2str(m2disttemp));



% --- Executes on button press in m2distminus.
function m2distminus_Callback(hObject, eventdata, handles)
% hObject    handle to m2distminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2disttemp = str2double(get(handles.m2dist,'String'));

if (m2disttemp > 0) 
    m2disttemp = m2disttemp - 1;
    handles.M2.dist = strcat('0',int2str(m2disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m2data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m2dist, 'String', num2str(m2disttemp));


% --- Executes on button press in m2speedplus.
function m2speedplus_Callback(hObject, eventdata, handles)
% hObject    handle to m2speedplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2speedtemp = str2double(get(handles.m2speed,'String'));

if (m2speedtemp < 5) 
    m2speedtemp = m2speedtemp + 1;
    handles.M2.motorSpeed = strcat('00000',int2str(m2speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m2data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
    
else
    msgbox('Maximum speed reached');
end
    
set(handles.m2speed, 'String', num2str(m2speedtemp));


% --- Executes on button press in m2speedminus.
function m2speedminus_Callback(hObject, eventdata, handles)
% hObject    handle to m2speedminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2speedtemp = str2double(get(handles.m2speed,'String'));

if (m2speedtemp > 0) 
    m2speedtemp = m2speedtemp - 1;
    handles.M2.motorSpeed = strcat('00000',int2str(m2speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m2data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m2speed, 'String', num2str(m2speedtemp));


% --- Executes on button press in m2onoff.
function m2onoff_Callback(hObject, eventdata, handles)
% hObject    handle to m2onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stattemp = get(handles.m2stat,'String');

if (strcmp(stattemp,'OFF')) % compare strings, turn motor ON
    set(handles.m2stat, 'String', 'ON');
    handles.M2.motorStatus = '1';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m2data);
    
    guidata(handles.figure1, handles);
    % turn motor on here
    
end

if (strcmp(stattemp,'ON'))
    set(handles.m2stat, 'String', 'OFF');
    handles.M2.motorStatus = '0';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);

    fprintf(handles.s, m2data);
    
    guidata(handles.figure1, handles);

end

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);


% --- Executes on button press in m1speedminus.
function m1speedminus_Callback(hObject, eventdata, handles)
% hObject    handle to m1speedminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1speedtemp = str2double(get(handles.m1speed,'String'));

if (m1speedtemp > 0) 
    m1speedtemp = m1speedtemp - 1;
    handles.M1.motorSpeed = strcat('00000',int2str(m1speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m1data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m1speed, 'String', num2str(m1speedtemp));


% --- Executes on button press in m1speedplus.
function m1speedplus_Callback(hObject, eventdata, handles)
% hObject    handle to m1speedplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1speedtemp = str2double(get(handles.m1speed,'String'));

if (m1speedtemp < 5) 
    m1speedtemp = m1speedtemp + 1;
    handles.M1.motorSpeed = strcat('00000',int2str(m1speedtemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m1data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
    
else
    msgbox('Maximum speed reached');
end
    
set(handles.m1speed, 'String', num2str(m1speedtemp));






% --- Executes on button press in m1distminus.
function m1distminus_Callback(hObject, eventdata, handles)
% hObject    handle to m1distminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1disttemp = str2double(get(handles.m1dist,'String'));

if (m1disttemp > 0) 
    m1disttemp = m1disttemp - 1;
    handles.M1.dist = strcat('0',int2str(m1disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m1data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
end
    
set(handles.m1dist, 'String', num2str(m1disttemp));



% Motor 1, Distension + button
function m1distplus_Callback(hObject, eventdata, handles)
% hObject    handle to m1distplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

m1disttemp = str2double(get(handles.m1dist,'String'));

if (m1disttemp < 5) 
    m1disttemp = m1disttemp + 1;
    handles.M1.dist = strcat('0',int2str(m1disttemp));
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m1data);
    
    
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);
else
    msgbox('Maximum distension reached');
end
    
set(handles.m1dist, 'String', num2str(m1disttemp));




% --- Executes on button press in m1onoff.
function m1onoff_Callback(hObject, eventdata, handles)
% hObject    handle to m1onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

stattemp = get(handles.m1stat,'String');

if (strcmp(stattemp,'OFF')) % compare strings
    set(handles.m1stat, 'String', 'ON');
    handles.M1.motorStatus = '1';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber)
    % Print Motor 1 data to COM port
    fprintf(handles.s, m1data);
    
    guidata(handles.figure1, handles);

end

if (strcmp(stattemp,'ON'))
    set(handles.m1stat, 'String', 'OFF');
    handles.M1.motorStatus = '0';
    
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    % Print Motor 1 data to COM port
    fprintf(handles.s, m1data);
    
    
    guidata(handles.figure1, handles);
    
end

guidata(handles.figure1, handles);
guidata(handles.figure1, handles);


% --- Executes on button press in m4const.
function m4const_Callback(hObject, eventdata, handles)
% hObject    handle to m4const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

set(handles.m4modetext, 'String', 'Pulsatile');
handles.M4.motorMode = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);

% Print Motor 1 data to COM port
fprintf(handles.s, m4data);

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);


% --- Executes on button press in m3const.
function m3const_Callback(hObject, eventdata, handles)
% hObject    handle to m3const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

set(handles.m3modetext, 'String', 'Pulsatile');
handles.M3.motorMode = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);

% Print Motor 1 data to COM port
fprintf(handles.s, m3data);

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);


% --- Executes on button press in m2const.
function m2const_Callback(hObject, eventdata, handles)
% hObject    handle to m2const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

set(handles.m2modetext, 'String', 'Pulsatile');
handles.M2.motorMode = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
% Print Motor 1 data to COM port
fprintf(handles.s, m2data);

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);

% --- Executes on button press in m1const.
function m1const_Callback(hObject, eventdata, handles)
% hObject    handle to m1const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

set(handles.m1modetext, 'String', 'Pulsatile');
handles.M1.motorMode = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
% Print Motor 1 data to COM port
fprintf(handles.s, m1data);

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);


% --- Executes during object deletion, before destroying properties.
function m1statusstatictext_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to m1statusstatictext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function m1dist_Callback(hObject, eventdata, handles)
% hObject    handle to m1dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1string = strlength(get(handles.m1speed,'String'));

% Get entered speed, distension and circumference
m1speedtemp = str2double(get(handles.m1speed,'String')); % (BPS)
 m1disttemp = str2double(get(handles.m1dist, 'String'));  % (%)Distension
 m1circtemp = str2double(get(handles.m1circ, 'String'));  % (mm)Circumference
   m1length = str2double(get(handles.m1length, 'String'));      
      m1DBP = str2double(get(handles.m1DBP, 'String'));  
      
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m1disttemp, m1circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m1speedtemp, calculateddist); % BPM to RPS
m1mass = handles.const.calculateMass(m1DBP, m1circtemp, m1length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m1mass = round(m1mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m1mass = num2str(m1mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
       % m1mass = pad(calculatedspeed,4,'left',' ');  

if ((strlength(calculateddist) == 5) && (speedcheck <= handles.const.MaxSpeedRPS) && (m1disttemp < handles.const.MaxDist) && (m1disttemp > handles.const.MinDist))
    
    % Update Diastolic tension value on GUI
    set(handles.m1tension, 'String', m1mass);
    
    % Update values of motor class for motor 1.
    handles.M1.lastDist = num2str(m1disttemp);
    handles.M1.motorSpeed = calculatedspeed;
    handles.M1.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    fprintf(handles.s, m1data);
    
    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);    
  
% elseif ( (m1disttemp > 20) || (m1disttemp <-20) )
%     guidata(handles.figure1, handles);
%     set(handles.terminalread, 'String', 'Maximum Distension is 20%');
%     guidata(handles.figure1, handles);
%     
elseif ( (m1speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m1dist, 'String', handles.M1.lastDist);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid distension entered.', 'User Assistance','help');
    set(handles.m1dist, 'String', handles.M1.lastDist);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m1dist as text
%        str2double(get(hObject,'String')) returns contents of m1dist as a double

% --- Executes during object creation, after setting all properties.
function m1dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function m1dist_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to m1dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on m1dist and none of its controls.
function m1dist_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to m1dist (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function m1speed_Callback(hObject, eventdata, handles)
% hObject    handle to m1speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1string = strlength(get(handles.m1speed,'String'));

% Get entered speed, distension and circumference
m1speedtemp = str2double(get(handles.m1speed,'String')); % (BPS)
 m1disttemp = str2double(get(handles.m1dist, 'String'));  % (%)Distension
 m1circtemp = str2double(get(handles.m1circ, 'String'));  % (mm)Circumference
   m1length = str2double(get(handles.m1length, 'String'));      
      m1DBP = str2double(get(handles.m1DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m1disttemp, m1circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m1speedtemp, calculateddist); % BPM to RPS
m1mass = handles.const.calculateMass(m1DBP, m1circtemp, m1length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
           m1mass = round(m1mass*100)/100;          % (g) 

% speedcheck is a numeric version of calculated speed for use in
% range checking the speed in RPS
 speedcheck = calculatedspeed; 
 
% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m1mass = num2str(m1mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' '); 

if ((m1speedtemp >= 0) && (m1speedtemp <= handles.const.MaxSpeedBPM) && (strlength(calculatedspeed) == 5) && (speedcheck <= handles.const.MaxSpeedRPS))
        
    % Update Diastolic tension value on GUI
    set(handles.m1tension, 'String', m1mass);
    
    % Update values of motor class for motor 1.
    handles.M1.lastSpeed = num2str(m1speedtemp);
    handles.M1.motorSpeed = calculatedspeed;
    handles.M1.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    fprintf(handles.s, m1data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif ( (m1speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m1speed, 'String', handles.M1.lastSpeed);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid speed entered.', 'User Assistance','help');
    set(handles.m1speed, 'String', handles.M1.lastSpeed);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m1speed as text
%        str2double(get(hObject,'String')) returns contents of m1speed as a double


% --- Executes during object creation, after setting all properties.
function m1speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function m1const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in m1ramp.
function m1ramp_Callback(hObject, eventdata, handles)
% hObject    handle to m1ramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update mode GUI text
set(handles.m1modetext, 'String', 'Ramp');

% Change mode value in motor class
handles.M1.motorMode = '2'; 
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

% Print Motor 1 data to COM port
m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
fprintf(handles.s, m1data);

guidata(handles.figure1, handles);

guidata(handles.figure1, handles);


% --- Executes on button press in m4ramp.
function m4ramp_Callback(hObject, eventdata, handles)
% hObject    handle to m4ramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

set(handles.m4modetext, 'String', 'Ramp');
handles.M4.motorMode = '2';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);

% Print Motor 1 data to COM port
fprintf(handles.s, m4data);

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);

% --- Executes on button press in m3ramp.
function m3ramp_Callback(hObject, eventdata, handles)
% hObject    handle to m3ramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

set(handles.m3modetext, 'String', 'Ramp');
handles.M3.motorMode = '2';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);

% Print Motor 1 data to COM port
fprintf(handles.s, m3data);

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);

% --- Executes on button press in m2ramp.
function m2ramp_Callback(hObject, eventdata, handles)
% hObject    handle to m2ramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

set(handles.m2modetext, 'String', 'Ramp');
handles.M2.motorMode = '2';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
% Print Motor 1 data to COM port
fprintf(handles.s, m2data)

guidata(handles.figure1, handles);



guidata(handles.figure1, handles);


function m2dist_Callback(hObject, eventdata, handles)
% hObject    handle to m2dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2string = strlength(get(handles.m2speed,'String'));

% Get entered speed, distension and circumference
m2speedtemp = str2double(get(handles.m2speed,'String')); % (BPS)
 m2disttemp = str2double(get(handles.m2dist, 'String'));  % (%)Distension
 m2circtemp = str2double(get(handles.m2circ, 'String'));  % (mm)Circumference
   m2length = str2double(get(handles.m2length, 'String'));      
      m2DBP = str2double(get(handles.m2DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m2disttemp, m2circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m2speedtemp, calculateddist); % BPM to RPS
m2mass = handles.const.calculateMass(m2DBP, m2circtemp, m2length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m2mass = round(m2mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m2mass = num2str(m2mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
       % m1mass = pad(calculatedspeed,4,'left',' ');  

if ((strlength(calculateddist) == 5) && (speedcheck <= handles.const.MaxSpeedRPS) && (m2disttemp < handles.const.MaxDist) && (m2disttemp > handles.const.MinDist))
    
    % Update Diastolic tension value on GUI
    set(handles.m2tension, 'String', m2mass);
    
    % Update values of motor class for motor 1.
    handles.M2.lastDist = num2str(m2disttemp);
    handles.M2.motorSpeed = calculatedspeed;
    handles.M2.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    fprintf(handles.s, m2data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);    
  
% elseif ( (m1disttemp > 20) || (m1disttemp <-20) )
%     guidata(handles.figure1, handles);
%     set(handles.terminalread, 'String', 'Maximum Distension is 20%');
%     guidata(handles.figure1, handles);
%     
elseif ( (m2speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m2dist, 'String', handles.M2.lastDist);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid distension entered.', 'User Assistance','help');
    set(handles.m2dist, 'String', handles.M2.lastDist);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m2dist as text
%        str2double(get(hObject,'String')) returns contents of m2dist as a double


% --- Executes during object creation, after setting all properties.
function m2dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2speed_Callback(hObject, eventdata, handles)
% hObject    handle to m2speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2string = strlength(get(handles.m2speed,'String'));

% Get entered speed, distension and circumference
m2speedtemp = str2double(get(handles.m2speed,'String')); % (BPS)
 m2disttemp = str2double(get(handles.m2dist, 'String'));  % (%)Distension
 m2circtemp = str2double(get(handles.m2circ, 'String'));  % (mm)Circumference
   m2length = str2double(get(handles.m2length, 'String'));      
      m2DBP = str2double(get(handles.m2DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m2disttemp, m2circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m2speedtemp, calculateddist); % BPM to RPS
m2mass = handles.const.calculateMass(m2DBP, m2circtemp, m2length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m2mass = round(m2mass*100)/100;          % (g) 

         
% speedcheck is a numeric version of calculated speed for use in
% range checking the speed in RPS
 speedcheck = calculatedspeed; 
 
% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m2mass = num2str(m2mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if ((m2speedtemp >= 0) && (m2speedtemp <= handles.const.MaxSpeedBPM) && (strlength(calculatedspeed) == 5) && (speedcheck <= handles.const.MaxSpeedRPS))
        
    % Update Diastolic tension value on GUI
    set(handles.m2tension, 'String', m2mass);
    
    % Update values of motor class for motor 1.
    handles.M2.lastSpeed = num2str(m2speedtemp);
    handles.M2.motorSpeed = calculatedspeed;
    handles.M2.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    fprintf(handles.s, m2data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif ( (m2speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m2speed, 'String', handles.M2.lastSpeed);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid speed entered.', 'User Assistance','help');
    set(handles.m2speed, 'String', handles.M2.lastSpeed);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m2speed as text
%        str2double(get(hObject,'String')) returns contents of m2speed as a double


% --- Executes during object creation, after setting all properties.
function m2speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m4dist_Callback(hObject, eventdata, handles)
% hObject    handle to m4dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4string = strlength(get(handles.m4speed,'String'));

% Get entered speed, distension and circumference
m4speedtemp = str2double(get(handles.m4speed,'String')); % (BPS)
 m4disttemp = str2double(get(handles.m4dist, 'String'));  % (%)Distension
 m4circtemp = str2double(get(handles.m4circ, 'String'));  % (mm)Circumference
   m4length = str2double(get(handles.m4length, 'String'));      
      m4DBP = str2double(get(handles.m4DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m4disttemp, m4circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m4speedtemp, calculateddist); % BPM to RPS
m4mass = handles.const.calculateMass(m4DBP, m4circtemp, m4length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m4mass = round(m4mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m4mass = num2str(m4mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
       % m1mass = pad(calculatedspeed,4,'left',' ');  

if ((strlength(calculateddist) == 5) && (speedcheck <= handles.const.MaxSpeedRPS) && (m4disttemp < handles.const.MaxDist) && (m4disttemp > handles.const.MinDist))
    
    % Update Diastolic tension value on GUI
    set(handles.m4tension, 'String', m4mass);
    
    % Update values of motor class for motor 1.
    handles.M4.lastDist = num2str(m4disttemp);
    handles.M4.motorSpeed = calculatedspeed;
    handles.M4.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    fprintf(handles.s, m4data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);    
  
% elseif ( (m1disttemp > 20) || (m1disttemp <-20) )
%     guidata(handles.figure1, handles);
%     set(handles.terminalread, 'String', 'Maximum Distension is 20%');
%     guidata(handles.figure1, handles);
%     
elseif ( (m4speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m4dist, 'String', handles.M4.lastDist);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid distension entered.', 'User Assistance','help');
    set(handles.m4dist, 'String', handles.M4.lastDist);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m4dist as text
%        str2double(get(hObject,'String')) returns contents of m4dist as a double


% --- Executes during object creation, after setting all properties.
function m4dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m4speed_Callback(hObject, eventdata, handles)
% hObject    handle to m4speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4string = strlength(get(handles.m4speed,'String'));

% Get entered speed, distension and circumference
m4speedtemp = str2double(get(handles.m4speed,'String')); % (BPS)
 m4disttemp = str2double(get(handles.m4dist, 'String'));  % (%)Distension
 m4circtemp = str2double(get(handles.m4circ, 'String'));  % (mm)Circumference
   m4length = str2double(get(handles.m4length, 'String'));      
      m4DBP = str2double(get(handles.m4DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m4disttemp, m4circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m4speedtemp, calculateddist); % BPM to RPS
m4mass = handles.const.calculateMass(m4DBP, m4circtemp, m4length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m4mass = round(m4mass*100)/100;          % (g) 

         
% speedcheck is a numeric version of calculated speed for use in
% range checking the speed in RPS
 speedcheck = calculatedspeed; 
 
% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m4mass = num2str(m4mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if ((m4speedtemp >= 0) && (m4speedtemp <= handles.const.MaxSpeedBPM) && (strlength(calculatedspeed) == 5) && (speedcheck <= handles.const.MaxSpeedRPS))
        
    % Update Diastolic tension value on GUI
    set(handles.m4tension, 'String', m4mass);
    
    % Update values of motor class for motor 1.
    handles.M4.lastSpeed = num2str(m4speedtemp);
    handles.M4.motorSpeed = calculatedspeed;
    handles.M4.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    fprintf(handles.s, m4data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif ( (m4speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m4speed, 'String', handles.M4.lastSpeed);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid speed entered.', 'User Assistance','help');
    set(handles.m4speed, 'String', handles.M4.lastSpeed);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m4speed as text
%        str2double(get(hObject,'String')) returns contents of m4speed as a double


% --- Executes during object creation, after setting all properties.
function m4speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3dist_Callback(hObject, eventdata, handles)
% hObject    handle to m3dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3string = strlength(get(handles.m3speed,'String'));

% Get entered speed, distension and circumference
m3speedtemp = str2double(get(handles.m3speed,'String')); % (BPS)
 m3disttemp = str2double(get(handles.m3dist, 'String'));  % (%)Distension
 m3circtemp = str2double(get(handles.m3circ, 'String'));  % (mm)Circumference
   m3length = str2double(get(handles.m3length, 'String'));      
      m3DBP = str2double(get(handles.m3DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m3disttemp, m3circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m3speedtemp, calculateddist); % BPM to RPS
m3mass = handles.const.calculateMass(m3DBP, m3circtemp, m3length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m3mass = round(m3mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m3mass = num2str(m3mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
       % m1mass = pad(calculatedspeed,4,'left',' ');  

if ((strlength(calculateddist) == 5) && (speedcheck <= handles.const.MaxSpeedRPS) && (m3disttemp < handles.const.MaxDist) && (m3disttemp > handles.const.MinDist))
    
    % Update Diastolic tension value on GUI
    set(handles.m3tension, 'String', m3mass);
    
    % Update values of motor class for motor 1.
    handles.M3.lastDist = num2str(m3disttemp);
    handles.M3.motorSpeed = calculatedspeed;
    handles.M3.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    fprintf(handles.s, m3data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);    
  
% elseif ( (m1disttemp > 20) || (m1disttemp <-20) )
%     guidata(handles.figure1, handles);
%     set(handles.terminalread, 'String', 'Maximum Distension is 20%');
%     guidata(handles.figure1, handles);
%     
elseif ( (m3speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m3dist, 'String', handles.M3.lastDist);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid distension entered.', 'User Assistance','help');
    set(handles.m3dist, 'String', handles.M3.lastDist);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m3dist as text
%        str2double(get(hObject,'String')) returns contents of m3dist as a double


% --- Executes during object creation, after setting all properties.
function m3dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3speed_Callback(hObject, eventdata, handles)
% hObject    handle to m3speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3string = strlength(get(handles.m3speed,'String'));

% Get entered speed, distension and circumference
m3speedtemp = str2double(get(handles.m3speed,'String')); % (BPS)
 m3disttemp = str2double(get(handles.m3dist, 'String'));  % (%)Distension
 m3circtemp = str2double(get(handles.m3circ, 'String'));  % (mm)Circumference
   m3length = str2double(get(handles.m3length, 'String'));      
      m3DBP = str2double(get(handles.m3DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m3disttemp, m3circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m3speedtemp, calculateddist); % BPM to RPS
m3mass = handles.const.calculateMass(m3DBP, m3circtemp, m3length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m3mass = round(m3mass*100)/100;          % (g) 

         
% speedcheck is a numeric version of calculated speed for use in
% range checking the speed in RPS
 speedcheck = calculatedspeed; 
 
% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m3mass = num2str(m3mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if ((m3speedtemp >= 0) && (m3speedtemp <= handles.const.MaxSpeedBPM) && (strlength(calculatedspeed) == 5) && (speedcheck <= handles.const.MaxSpeedRPS))
        
    % Update Diastolic tension value on GUI
    set(handles.m3tension, 'String', m3mass);
    
    % Update values of motor class for motor 1.
    handles.M3.lastSpeed = num2str(m3speedtemp);
    handles.M3.motorSpeed = calculatedspeed;
    handles.M3.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    fprintf(handles.s, m3data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif ( (m3speedtemp > handles.const.MaxSpeedBPM) || (speedcheck > handles.const.MaxSpeedRPS) )
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m3speed, 'String', handles.M3.lastSpeed);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid speed entered.', 'User Assistance','help');
    set(handles.m3speed, 'String', handles.M3.lastSpeed);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m3speed as text
%        str2double(get(hObject,'String')) returns contents of m3speed as a double


% --- Executes during object creation, after setting all properties.
function m3speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function m4circ_Callback(hObject, eventdata, handles)
% hObject    handle to m4circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4string = strlength(get(handles.m4speed,'String'));

% Get entered speed, distension and circumference
m4speedtemp = str2double(get(handles.m4speed,'String')); % (BPS)
 m4disttemp = str2double(get(handles.m4dist, 'String'));  % (%)Distension
 m4circtemp = str2double(get(handles.m4circ, 'String'));  % (mm)Circumference
   m4length = str2double(get(handles.m4length, 'String'));      
      m4DBP = str2double(get(handles.m4DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m4disttemp, m4circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m4speedtemp, calculateddist); % BPM to RPS
m4mass = handles.const.calculateMass(m4DBP, m4circtemp, m4length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m4mass = round(m4mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m4mass = num2str(m4mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

% Current range is 0 to 500 mm
if ( (m4circtemp > 0) && (m4circtemp < handles.const.MaxCirc) && (speedcheck <= handles.const.MaxSpeedRPS))
    
    % Update Diastolic tension value on GUI
    set(handles.m4tension, 'String', m4mass);
    
    % Update values of motor class for motor 1.
    handles.M4.lastCirc = num2str(m4circtemp);
    handles.M4.motorSpeed = calculatedspeed;
    handles.M4.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    fprintf(handles.s, m4data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif (m4speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m4circ, 'String', handles.M4.lastCirc);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid circumference entered.', 'User Assistance','help');
    set(handles.m4circ, 'String', handles.M4.lastCirc);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m4circ as text
%        str2double(get(hObject,'String')) returns contents of m4circ as a double


% --- Executes during object creation, after setting all properties.
function m4circ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function m3circ_Callback(hObject, eventdata, handles)
% hObject    handle to m3circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3string = strlength(get(handles.m3speed,'String'));

% Get entered speed, distension and circumference
m3speedtemp = str2double(get(handles.m3speed,'String')); % (BPS)
 m3disttemp = str2double(get(handles.m3dist, 'String'));  % (%)Distension
 m3circtemp = str2double(get(handles.m3circ, 'String'));  % (mm)Circumference
   m3length = str2double(get(handles.m3length, 'String'));      
      m3DBP = str2double(get(handles.m3DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m3disttemp, m3circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m3speedtemp, calculateddist); % BPM to RPS
m3mass = handles.const.calculateMass(m3DBP, m3circtemp, m3length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m3mass = round(m3mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m3mass = num2str(m3mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

% Current range is 0 to 500 mm
if ( (m3circtemp > 0) && (m3circtemp < handles.const.MaxCirc) && (speedcheck <= handles.const.MaxSpeedRPS))
    
    % Update Diastolic tension value on GUI
    set(handles.m3tension, 'String', m3mass);
    
    % Update values of motor class for motor 1.
    handles.M3.lastCirc = num2str(m3circtemp);
    handles.M3.motorSpeed = calculatedspeed;
    handles.M3.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    fprintf(handles.s, m3data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif (m3speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m3circ, 'String', handles.M3.lastCirc);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid circumference entered.', 'User Assistance','help');
    set(handles.m3circ, 'String', handles.M3.lastCirc);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m3circ as text
%        str2double(get(hObject,'String')) returns contents of m3circ as a double


% --- Executes during object creation, after setting all properties.
function m3circ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2circ_Callback(hObject, eventdata, handles)
% hObject    handle to m2circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2string = strlength(get(handles.m2speed,'String'));

% Get entered speed, distension and circumference
m2speedtemp = str2double(get(handles.m2speed,'String')); % (BPS)
 m2disttemp = str2double(get(handles.m2dist, 'String'));  % (%)Distension
 m2circtemp = str2double(get(handles.m2circ, 'String'));  % (mm)Circumference
   m2length = str2double(get(handles.m2length, 'String'));      
      m2DBP = str2double(get(handles.m2DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m2disttemp, m2circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m2speedtemp, calculateddist); % BPM to RPS
m2mass = handles.const.calculateMass(m2DBP, m2circtemp, m2length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m2mass = round(m2mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m2mass = num2str(m2mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

% Current range is 0 to 500 mm
if ( (m2circtemp > 0) && (m2circtemp < handles.const.MaxCirc) && (speedcheck <= handles.const.MaxSpeedRPS))
    
    % Update Diastolic tension value on GUI
    set(handles.m2tension, 'String', m2mass);
    
    % Update values of motor class for motor 1.
    handles.M2.lastCirc = num2str(m2circtemp);
    handles.M2.motorSpeed = calculatedspeed;
    handles.M2.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber)
    fprintf(handles.s, m2data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif (m2speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m2circ, 'String', handles.M2.lastCirc);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid circumference entered.', 'User Assistance','help');
    set(handles.m2circ, 'String', handles.M2.lastCirc);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m2circ as text
%        str2double(get(hObject,'String')) returns contents of m2circ as a double


% --- Executes during object creation, after setting all properties.
function m2circ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m1circ_Callback(hObject, eventdata, handles)
% hObject    handle to m1circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1string = strlength(get(handles.m1speed,'String'));

% Get entered speed, distension and circumference
m1speedtemp = str2double(get(handles.m1speed,'String')); % (BPS)
 m1disttemp = str2double(get(handles.m1dist, 'String'));  % (%)Distension
 m1circtemp = str2double(get(handles.m1circ, 'String'));  % (mm)Circumference
   m1length = str2double(get(handles.m1length, 'String'));      
      m1DBP = str2double(get(handles.m1DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m1disttemp, m1circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m1speedtemp, calculateddist); % BPM to RPS
m1mass = handles.const.calculateMass(m1DBP, m1circtemp, m1length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m1mass = round(m1mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m1mass = num2str(m1mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

% Current range is 0 to 500 mm
if ( (m1circtemp > 0) && (m1circtemp < handles.const.MaxCirc) && (speedcheck <= handles.const.MaxSpeedRPS))
    
    % Update Diastolic tension value on GUI
    set(handles.m1tension, 'String', m1mass);
    
    % Update values of motor class for motor 1.
      handles.M1.lastCirc = num2str(m1circtemp);
    handles.M1.motorSpeed = calculatedspeed;
          handles.M1.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    fprintf(handles.s, m1data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
  
elseif (m1speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m1circ, 'String', handles.M1.lastCirc);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid circumference entered.', 'User Assistance','help');
    set(handles.m1circ, 'String', handles.M1.lastCirc);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m1circ as text
%        str2double(get(hObject,'String')) returns contents of m1circ as a double


% --- Executes during object creation, after setting all properties.
function m1circ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function m4length_Callback(hObject, eventdata, handles)
% hObject    handle to m4length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4string = strlength(get(handles.m4speed,'String'));

% Get entered speed, distension and circumference
m4speedtemp = str2double(get(handles.m4speed,'String')); % (BPS)
 m4disttemp = str2double(get(handles.m4dist, 'String'));  % (%)Distension
 m4circtemp = str2double(get(handles.m4circ, 'String'));  % (mm)Circumference
   m4length = str2double(get(handles.m4length, 'String'));      
      m4DBP = str2double(get(handles.m4DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m4disttemp, m4circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m4speedtemp, calculateddist); % BPM to RPS
m4mass = handles.const.calculateMass(m4DBP, m4circtemp, m4length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m4mass = round(m4mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
% 
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m4mass = num2str(m4mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m4length) && (speedcheck <= handles.const.MaxSpeedRPS) && (m4length > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m4tension, 'String', m4mass);
    
    % Update values of motor class for motor 1.
    handles.M4.lastLength = num2str(m4length);
    handles.M4.motorSpeed = calculatedspeed;
    handles.M4.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    fprintf(handles.s, m4data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m4speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m4length, 'String', handles.M4.lastLength);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid length entered.', 'User Assistance','help');
    set(handles.m4length, 'String', handles.M4.lastLength);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m4length as text
%        str2double(get(hObject,'String')) returns contents of m4length as a double


% --- Executes during object creation, after setting all properties.
function m4length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m4DBP_Callback(hObject, eventdata, handles)
% hObject    handle to m4DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m4string = strlength(get(handles.m4speed,'String'));

% Get entered speed, distension and circumference
 m4speedtemp = str2double(get(handles.m4speed,'String')); % (BPS)
  m4disttemp = str2double(get(handles.m4dist, 'String'));  % (%)Distension
  m4circtemp = str2double(get(handles.m4circ, 'String'));  % (mm)Circumference
    m4length = str2double(get(handles.m4length, 'String'));      
       m4DBP = str2double(get(handles.m4DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m4disttemp, m4circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m4speedtemp, calculateddist); % BPM to RPS
m4mass = handles.const.calculateMass(m4DBP, m4circtemp, m4length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m4mass = round(m4mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m4mass = num2str(m4mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m4DBP) && (speedcheck <= handles.const.MaxSpeedRPS) && (m4DBP > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m4tension, 'String', m4mass);
    
    % Update values of motor class for motor 1.
    handles.M4.lastDBP = num2str(m4DBP);
    handles.M4.motorSpeed = calculatedspeed;
    handles.M4.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber);
    fprintf(handles.s, m4data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m4speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m4DBP, 'String', handles.M4.lastDBP);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid diastolic BP entered.', 'User Assistance','help');
    set(handles.m4DBP, 'String', handles.M4.lastDBP);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m4DBP as text
%        str2double(get(hObject,'String')) returns contents of m4DBP as a double


% --- Executes during object creation, after setting all properties.
function m4DBP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3length_Callback(hObject, eventdata, handles)
% hObject    handle to m3length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3string = strlength(get(handles.m3speed,'String'));

% Get entered speed, distension and circumference
m3speedtemp = str2double(get(handles.m3speed,'String')); % (BPS)
 m3disttemp = str2double(get(handles.m3dist, 'String'));  % (%)Distension
 m3circtemp = str2double(get(handles.m3circ, 'String'));  % (mm)Circumference
   m3length = str2double(get(handles.m3length, 'String'));      
      m3DBP = str2double(get(handles.m3DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m3disttemp, m3circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m3speedtemp, calculateddist); % BPM to RPS
m3mass = handles.const.calculateMass(m3DBP, m3circtemp, m3length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m3mass = round(m3mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
% 
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m3mass = num2str(m3mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m3length) && (speedcheck <= handles.const.MaxSpeedRPS) && (m3length > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m3tension, 'String', m3mass);
    
    % Update values of motor class for motor 1.
    handles.M3.lastLength = num2str(m3length);
    handles.M3.motorSpeed = calculatedspeed;
    handles.M3.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    fprintf(handles.s, m3data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m3speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m3length, 'String', handles.M3.lastLength);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid length entered.', 'User Assistance','help');
    set(handles.m3length, 'String', handles.M3.lastLength);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m3length as text
%        str2double(get(hObject,'String')) returns contents of m3length as a double


% --- Executes during object creation, after setting all properties.
function m3length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3DBP_Callback(hObject, eventdata, handles)
% hObject    handle to m3DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m3string = strlength(get(handles.m3speed,'String'));

% Get entered speed, distension and circumference
 m3speedtemp = str2double(get(handles.m3speed,'String')); % (BPS)
  m3disttemp = str2double(get(handles.m3dist, 'String'));  % (%)Distension
  m3circtemp = str2double(get(handles.m3circ, 'String'));  % (mm)Circumference
    m3length = str2double(get(handles.m3length, 'String'));      
       m3DBP = str2double(get(handles.m3DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m3disttemp, m3circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m3speedtemp, calculateddist); % BPM to RPS
m3mass = handles.const.calculateMass(m3DBP, m3circtemp, m3length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m3mass = round(m3mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m3mass = num2str(m3mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m3DBP) && (speedcheck <= handles.const.MaxSpeedRPS) && (m3DBP > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m3tension, 'String', m3mass);
    
    % Update values of motor class for motor 1.
    handles.M3.lastDBP = num2str(m3DBP);
    handles.M3.motorSpeed = calculatedspeed;
    handles.M3.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
    fprintf(handles.s, m3data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m3speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m3DBP, 'String', handles.M3.lastDBP);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid diastolic BP entered.', 'User Assistance','help');
    set(handles.m3DBP, 'String', handles.M3.lastDBP);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m3DBP as text
%        str2double(get(hObject,'String')) returns contents of m3DBP as a double


% --- Executes during object creation, after setting all properties.
function m3DBP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2length_Callback(hObject, eventdata, handles)
% hObject    handle to m2length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2string = strlength(get(handles.m2speed,'String'));

% Get entered speed, distension and circumference
m2speedtemp = str2double(get(handles.m2speed,'String')); % (BPS)
 m2disttemp = str2double(get(handles.m2dist, 'String'));  % (%)Distension
 m2circtemp = str2double(get(handles.m2circ, 'String'));  % (mm)Circumference
   m2length = str2double(get(handles.m2length, 'String'));      
      m2DBP = str2double(get(handles.m2DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m2disttemp, m2circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m2speedtemp, calculateddist); % BPM to RPS
m2mass = handles.const.calculateMass(m2DBP, m2circtemp, m2length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m2mass = round(m2mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
% 
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m2mass = num2str(m2mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m2length) && (speedcheck <= handles.const.MaxSpeedRPS) && (m2length > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m2tension, 'String', m2mass);
    
    % Update values of motor class for motor 1.
    handles.M2.lastLength = num2str(m2length);
    handles.M2.motorSpeed = calculatedspeed;
    handles.M2.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    fprintf(handles.s, m2data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m2speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m2length, 'String', handles.M2.lastLength);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid length entered.', 'User Assistance','help');
    set(handles.m2length, 'String', handles.M2.lastLength);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m2length as text
%        str2double(get(hObject,'String')) returns contents of m2length as a double


% --- Executes during object creation, after setting all properties.
function m2length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2DBP_Callback(hObject, eventdata, handles)
% hObject    handle to m2DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m2string = strlength(get(handles.m2speed,'String'));

% Get entered speed, distension and circumference
 m2speedtemp = str2double(get(handles.m2speed,'String')); % (BPS)
  m2disttemp = str2double(get(handles.m2dist, 'String'));  % (%)Distension
  m2circtemp = str2double(get(handles.m2circ, 'String'));  % (mm)Circumference
    m2length = str2double(get(handles.m2length, 'String'));      
       m2DBP = str2double(get(handles.m2DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m2disttemp, m2circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m2speedtemp, calculateddist); % BPM to RPS
m2mass = handles.const.calculateMass(m2DBP, m2circtemp, m2length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m2mass = round(m2mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m2mass = num2str(m2mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m2DBP) && (speedcheck <= handles.const.MaxSpeedRPS) && (m2DBP > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m2tension, 'String', m2mass);
    
    % Update values of motor class for motor 1.
    handles.M2.lastDBP = num2str(m2DBP);
    handles.M2.motorSpeed = calculatedspeed;
    handles.M2.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
    fprintf(handles.s, m2data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m2speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m2DBP, 'String', handles.M2.lastDBP);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid diastolic BP entered.', 'User Assistance','help');
    set(handles.m2DBP, 'String', handles.M2.lastDBP);
    guidata(handles.figure1, handles);
end 

% Hints: get(hObject,'String') returns contents of m2DBP as text
%        str2double(get(hObject,'String')) returns contents of m2DBP as a double


% --- Executes during object creation, after setting all properties.
function m2DBP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m1length_Callback(hObject, eventdata, handles)
% hObject    handle to m1length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1string = strlength(get(handles.m1speed,'String'));

% Get entered speed, distension and circumference
m1speedtemp = str2double(get(handles.m1speed,'String')); % (BPS)
 m1disttemp = str2double(get(handles.m1dist, 'String'));  % (%)Distension
 m1circtemp = str2double(get(handles.m1circ, 'String'));  % (mm)Circumference
   m1length = str2double(get(handles.m1length, 'String'));      
      m1DBP = str2double(get(handles.m1DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m1disttemp, m1circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m1speedtemp, calculateddist); % BPM to RPS
m1mass = handles.const.calculateMass(m1DBP, m1circtemp, m1length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m1mass = round(m1mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
% 
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m1mass = num2str(m1mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m1length) && (speedcheck <= handles.const.MaxSpeedRPS) && (m1length > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m1tension, 'String', m1mass);
    
    % Update values of motor class for motor 1.
    handles.M1.lastLength = num2str(m1length);
    handles.M1.motorSpeed = calculatedspeed;
    handles.M1.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    fprintf(handles.s, m1data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m1speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m1length, 'String', handles.M1.lastLength);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid length entered.', 'User Assistance','help');
    set(handles.m1length, 'String', handles.M1.lastLength);
    guidata(handles.figure1, handles);
end 
% Hints: get(hObject,'String') returns contents of m1length as text
%        str2double(get(hObject,'String')) returns contents of m1length as a double

% --- Executes during object creation, after setting all properties.
function m1length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m1DBP_Callback(hObject, eventdata, handles)
% hObject    handle to m1DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m1string = strlength(get(handles.m1speed,'String'));

% Get entered speed, distension and circumference
 m1speedtemp = str2double(get(handles.m1speed,'String')); % (BPS)
  m1disttemp = str2double(get(handles.m1dist, 'String'));  % (%)Distension
  m1circtemp = str2double(get(handles.m1circ, 'String'));  % (mm)Circumference
m1length = str2double(get(handles.m1length, 'String'));      
   m1DBP = str2double(get(handles.m1DBP, 'String'));    
      
% Calculate distension, speed and mass. 
% Functions defined in 'Pulsatile' class.
calculateddist = handles.const.calculateDistension(m1disttemp, m1circtemp); % circ to dist(mm)
calculatedspeed = handles.const.calculateSpeed(m1speedtemp, calculateddist); % BPM to RPS
m1mass = handles.const.calculateMass(m1DBP, m1circtemp, m1length);

% Round to 2 decimal places
 calculateddist = round(calculateddist*100)/100;  % (mm)
calculatedspeed = round(calculatedspeed*1000)/1000; % (RPS)
         m1mass = round(m1mass*100)/100;          % (g) 

% Arduino expects 5 characters for distension and 4 for speed.
% 'pad' adds zeros to fill where necessary so that 5 and 4 
% characters are sent, as expected...
%
% E.g, '2.5' after padding to 5 chars = '02.50'
%
% pad() accepts strings only
     speedcheck = calculatedspeed;
 calculateddist = num2str(calculateddist);
calculatedspeed = num2str(calculatedspeed);
         m1mass = num2str(m1mass);
 calculateddist = pad(calculateddist,5);
calculatedspeed = pad(calculatedspeed,5);
         % m1mass = pad(calculatedspeed,4,'left',' ');  

if (isnumeric(m1DBP) && (speedcheck <= handles.const.MaxSpeedRPS) && (m1DBP > 0))
     
    % Update Diastolic tension value on GUI
    set(handles.m1tension, 'String', m1mass);
    
    % Update values of motor class for motor 1.
    handles.M1.lastDBP = num2str(m1DBP);
    handles.M1.motorSpeed = calculatedspeed;
    handles.M1.dist = calculateddist;
    
    % Update handles structure.
    guidata(handles.figure1, handles);
    handles = guidata(handles.figure1);
    
    % Concatenate handles structure into single string, send, and wait for reply. 
    m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber);
    fprintf(handles.s, m1data);
    

    % Update Terminal text with reply from Arduino
    guidata(handles.figure1, handles);
    
    guidata(handles.figure1, handles);   
    
elseif (m1speedtemp > handles.const.MaxSpeedBPM || (speedcheck > handles.const.MaxSpeedRPS))
    guidata(handles.figure1, handles);
    msgbox('Maximum speed exceeded.', 'User Assistance','help');
    set(handles.m1DBP, 'String', handles.M1.lastDBP);
    guidata(handles.figure1, handles);
else
    guidata(handles.figure1, handles);
    msgbox('Invalid diastolic BP entered.', 'User Assistance','help');
    set(handles.m1DBP, 'String', handles.M1.lastDBP);
    guidata(handles.figure1, handles);
end 

% Hints: get(hObject,'String') returns contents of m1DBP as text
%        str2double(get(hObject,'String')) returns contents of m1DBP as a double


% --- Executes during object creation, after setting all properties.
function m1DBP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1DBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton67.
function pushbutton67_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

handles.M4.initialDistent = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m4data = strcat(handles.M4.initialDistent, handles.M4.dist, handles.M4.motorSpeed, handles.M4.motorStatus, handles.M4.motorMode, handles.M4.analogDelay, handles.M4.motorNumber)
% Print Motor 1 data to COM port
fprintf(handles.s, m4data);
guidata(handles.figure1, handles);
handles.M4.initialDistent = '0';
guidata(handles.figure1, handles);

% --- Executes on button press in pushbutton66.
function pushbutton66_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

handles.M3.initialDistent = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
    m3data = strcat(handles.M3.initialDistent, handles.M3.dist, handles.M3.motorSpeed, handles.M3.motorStatus, handles.M3.motorMode, handles.M3.analogDelay, handles.M3.motorNumber);
% Print Motor 1 data to COM port
fprintf(handles.s, m3data);
guidata(handles.figure1, handles);
handles.M3.initialDistent = '0';
guidata(handles.figure1, handles);

% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

handles.M2.initialDistent = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m2data = strcat(handles.M2.initialDistent, handles.M2.dist, handles.M2.motorSpeed, handles.M2.motorStatus, handles.M2.motorMode, handles.M2.analogDelay, handles.M2.motorNumber);
% Print Motor 1 data to COM port
fprintf(handles.s, m2data);
guidata(handles.figure1, handles);
handles.M2.initialDistent = '0';
guidata(handles.figure1, handles);

% --- Executes on button press in pushbutton65.
function pushbutton65_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);

handles.M1.initialDistent = '1';
    
guidata(handles.figure1, handles);
handles = guidata(handles.figure1);
    
m1data = strcat(handles.M1.initialDistent, handles.M1.dist, handles.M1.motorSpeed, handles.M1.motorStatus, handles.M1.motorMode, handles.M1.analogDelay, handles.M1.motorNumber)
% Print Motor 1 data to COM port
fprintf(handles.s, m1data);
guidata(handles.figure1, handles);
handles.M1.initialDistent = '0';
handles.M1.initialDistent
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function m4onoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
