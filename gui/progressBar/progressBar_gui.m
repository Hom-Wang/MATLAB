function varargout = progressBar_gui(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @progressBar_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @progressBar_gui_OutputFcn, ...
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


% --- Executes just before progressBar_gui is made visible.
function progressBar_gui_OpeningFcn(hObject, eventdata, handles, varargin)

global myProgressBar

myProgressBar.pBar = {
    handles.pBar01,    handles.pBar02,    handles.pBar03,    handles.pBar04,    handles.pBar05, ...
    handles.pBar06,    handles.pBar07,    handles.pBar08,    handles.pBar09,    handles.pBar10
};
myProgressBar.pText = handles.progressBar_text;

% Choose default command line output for progressBar_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes progressBar_gui wait for user response (see UIRESUME)
% uiwait(handles.mainWindow);


% --- Outputs from this function are returned to the command line.
function varargout = progressBar_gui_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

