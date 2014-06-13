function varargout = playergui(varargin)
% PLAYERGUI MATLAB code for playergui.fig
%      PLAYERGUI, by itself, creates a new PLAYERGUI or raises the existing
%      singleton*.
%
%      H = PLAYERGUI returns the handle to a new PLAYERGUI or the handle to
%      the existing singleton*.
%
%      PLAYERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYERGUI.M with the given input arguments.
%
%      PLAYERGUI('Property','Value',...) creates a new PLAYERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before playergui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to playergui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help playergui

% Last Modified by GUIDE v2.5 11-Jun-2014 13:17:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @playergui_OpeningFcn, ...
                   'gui_OutputFcn',  @playergui_OutputFcn, ...
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

% --- Executes just before playergui is made visible.
function playergui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to playergui (see VARARGIN)

% Choose default command line output for playergui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isempty(varargin)
    error('No arguments specified. You need to specify a function that should be called')
else
    if ~isa(varargin{1}, 'function_handle')
        error('Invalid argument type. You need to specify a function that should be called')
    else
        % Initialise variables
        setappdata(hObject, 'currentFrame', 0);
        setappdata(hObject, 'StepSize', 1);
        setappdata(hObject, 'FPS', 0.5);
        setappdata(hObject, 'callingFunction', varargin{1});
        % Timer object is not created on function start as the handles have
        % likely not been initialised yet.
        setappdata(hObject, 'timerObj', []);
    end
end
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes playergui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = playergui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PlayButton.
function PlayButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timerObj = getappdata(handles.output, 'timerObj');
if isempty(timerObj)
    FPS = getappdata(handles.output, 'FPS');
    % Declare timer object
    timerObj = timer('TimerFcn', {@MoveFrame, [], handles.output, handles.DestAxes}, 'Period', 1 / FPS, 'ExecutionMode', 'fixedRate');
end
setappdata(handles.output, 'timerObj', timerObj);
start(timerObj);
setappdata(handles.output, 'timerObj', timerObj);
guidata(hObject,handles)

% --- Executes on button press in ForwardButton.
function ForwardButton_Callback(hObject, eventdata, handles)
% hObject    handle to ForwardButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timerObj = getappdata(handles.output, 'timerObj');
if ~isempty(timerObj)
    stop(timerObj);
end
MoveFrame([], [], 1, handles.output, handles.DestAxes);
if ~isempty(timerObj)
    setappdata(handles.output, 'timerObj', timerObj);
end
guidata(hObject,handles)


% --- Executes on button press in StopButton.
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timerObj = getappdata(handles.output, 'timerObj');
if ~isempty(timerObj)
    stop(timerObj);
end
setappdata(handles.output, 'timerObj', timerObj);

% --- Executes on button press in BackButton.
function BackButton_Callback(hObject, eventdata, handles)
% hObject    handle to BackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timerObj = getappdata(handles.output, 'timerObj');
if ~isempty(timerObj)
    stop(timerObj);
end
MoveFrame([], [], -1, handles.output, handles.DestAxes);
if ~isempty(timerObj)
    setappdata(handles.output, 'timerObj', timerObj);
end
guidata(hObject,handles)


function FPSvar_Callback(hObject, eventdata, handles)
% hObject    handle to FPSvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FPSvar as text
%        str2double(get(hObject,'String')) returns contents of FPSvar as a double


% --- Executes during object creation, after setting all properties.
function FPSvar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FPSvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ChangeButton.
function ChangeButton_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stpval = str2num(get(handles.StepVar, 'String'));
StepSize = getappdata(handles.output, 'StepSize');
if isempty(stpval)
    set(handles.StepVar, 'String', num2str(StepSize));
else
    setappdata(handles.output, 'StepSize', stpval);
end
fpsval = str2num(get(handles.FPSvar, 'String'));
FPS = getappdata(handles.output, 'FPS');
if isempty(fpsval) || fpsval < 0
    set(handles.FPSvar, 'String', num2str(FPS));
else
    setappdata(handles.output, 'FPS', fpsval);
end

timerObj = getappdata(handles.output, 'timerObj');
if ~isempty(timerObj)
    % Is the timer currently running?
    if strcmp(get(timerObj, 'Running'), 'on')
        isRunning = true;
    else
        isRunning = false;
    end
    % Stop it if it is as you can't change the rate whilst it's running.
    if isRunning
        stop(timerObj);
    end
    % Set the period
    set(timerObj, 'Period', 1 / FPS);
    % Resume if it was running before.
    if isRunning
        start(timerObj);
    end
    setappdata(handles.output, 'timerObj', timerObj);
end
guidata(hObject,handles)

function StepVar_Callback(hObject, eventdata, handles)
% hObject    handle to StepVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepVar as text
%        str2double(get(hObject,'String')) returns contents of StepVar as a double


% --- Executes during object creation, after setting all properties.
function StepVar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StepVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function MoveFrame(obj, event, stepSize, handle, axesHandle)
    % Check to see if the axes handle is still alive. If not, kill the
    % timer
    if ~ishghandle(axesHandle)
        % The handle to the timer is dead, so find it and then delete it.
        timerObj = timerfindall;
        stop(timerObj);
        delete(timerObj);
    end
    % Step size has not been specified, so we're looking at a timer call
    if isempty(stepSize)
        stepSize = getappdata(handle, 'StepSize');
    end
    currentFrame = getappdata(handle, 'currentFrame');
    currentFrame = currentFrame + stepSize;
    % Get the calling function
    callingFunction = getappdata(handle, 'callingFunction');
    % Run the calling function
    callingFunction(currentFrame, axesHandle);
    % Save the current frame number to memory.
    setappdata(handle, 'currentFrame', currentFrame);
    


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
timerObj = getappdata(handles.output, 'timerObj');
stop(timerObj);
delete(timerObj);
catch
    % timer likely finished before we could delete it. It shouldn't happen.
end
delete(hObject);


% --- Executes during object creation, after setting all properties.
function DestAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DestAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
