function varargout = MotionControl(varargin)
% MOTIONCONTROL MATLAB code for MotionControl.fig
%      MOTIONCONTROL, by itself, creates a new MOTIONCONTROL or raises the existing singleton*.
% 
%      H = MOTIONCONTROL returns the handle to a new MOTIONCONTROL or the handle to
%      the existing singleton*.
% 
%      MOTIONCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTIONCONTROL.M with the given input arguments.
% 
%      MOTIONCONTROL('Property','Value',...) creates a new MOTIONCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotionControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotionControl_OpeningFcn via varargin.
% 
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% 
% See also: GUIDE, GUIDATA, GUIHANDLES
% 
% Edit the above text to modify the response to help MotionControl
% 
% Last Modified by GUIDE v2.5 04-Aug-2016 16:05:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;  
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotionControl_OpeningFcn, ...
                   'gui_OutputFcn',  @MotionControl_OutputFcn, ...
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
%End initialization code - DO NOT EDIT`


function MotionControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotionControl (see VARARGIN)
% Choose default command line output for MotionControl

handles.output = hObject;

duration = 60; % time (in seconds) the program will run
fs = 8192; % do not change
frequency = 30; % frequency
t = 0:1/fs:duration; % time from 0 to duration in increments of 1/fs
maskSin = sin(2*pi*frequency*t); % create sine function
maskCos = cos(2*pi*frequency*t); % create cosine function

% First soundcard (Use 4 channels)
s1 = daq.createSession('directsound');
noutchan = 4;
addAudioOutputChannel(s1, 'Audio9', 1:noutchan);
s1.Rate = fs;
s1.IsContinuous = true;

% Second soundcard (Use 2 channels)
s2 = daq.createSession('directsound');
noutchan1 = 2;
addAudioOutputChannel(s2,'Audio8',1:noutchan1);
s2.Rate = fs;
s2.IsContinuous = true;

% Create input sound vectors for s1
up_sound(:,1)=maskSin;
up_sound(:,2)=0;
up_sound(:,3)=0;
up_sound(:,4)=0;

right_sound(:,2)=maskCos;
right_sound(:,3)=0;
right_sound(:,4)=0;

left_sound(:,3)=maskCos;
left_sound(:,4)=0;

down_sound(:,4)=maskCos;

% Create input sound vectors for s2
vert_sound(:,1)=maskSin;
vert_sound(:,2)=0;

vert2_sound(:,2)=maskCos;

% Redefine sounds for later use in function varargout
handles.sound1 = s1;
handles.sound2 = s2;
handles.up_sound=up_sound;
handles.right_sound=right_sound;
handles.left_sound=left_sound;
handles.down_sound=down_sound;

handles.vert_sound=vert_sound;
handles.vert2_sound = vert2_sound;

handles.keyhold=0;

%Update handles structure
guidata(hObject, handles);



% UIWAIT makes MotionControl wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = MotionControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.output; % Might not be needed

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
% 	Key: name of the key that was pressed, in lower case
% 	Character: character interpretation of the key(s) that was pressed
% 	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if (handles.keyhold==0)
    handles.keyhold=1;
    guidata(hObject, handles);
    switch eventdata.Key
      case 'w'
           set(handles.text2, 'String', 'Up');
           queueOutputData(handles.sound1, handles.up_sound);
           startBackground(handles.sound1);
      case 'd'
           set(handles.text2, 'String', 'Right');
           queueOutputData(handles.sound1, handles.right_sound);
           startBackground(handles.sound1);
      case 'a'
           set(handles.text2, 'String', 'Left');
           queueOutputData(handles.sound1, handles.left_sound);
           startBackground(handles.sound1);
      case 's'
           set(handles.text2, 'String', 'Down');
           queueOutputData(handles.sound1, handles.down_sound);
           startBackground(handles.sound1);
      case 'z'
           set(handles.text2, 'String', 'Vertical');
           queueOutputData(handles.sound2, handles.vert_sound);
           startBackground(handles.sound2);
      case 'x'
           set(handles.text2, 'String', 'Vertical2');
           queueOutputData(handles.sound2, handles.vert2_sound);
           startBackground(handles.sound2);

%       case 'r' 
%            for i=1:120 % Number of loop iterations is equal to time run in minutes
%            set(handles.text2, 'String', 'Rotate');
%            queueOutputData(handles.sound, handles.up_sound+handles.down_sound+handles.right_sound+handles.left_sound+handles.vert_sound);
%            startBackground(handles.sound1);
%            end
    end
end
% % 
% {
% % --- Executes on key release with focus on figure1 or any of its controls.
% function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
% 	Key: name of the key that was released, in lower case
% 	Character: character intersadadwpretation of the key(s) that was released
% 	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
% set(handles.text2, 'String', 'Stop');
% handles.keyhold=0;
% guidata(hObject, handles);
% stop(handles.sound);
% }