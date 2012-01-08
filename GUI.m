function varargout = GUI(varargin)
% GUI M-file for GUI.fig
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
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 10-May-2010 00:22:48

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

axes(handles.back);
backgroundImage = importdata('Background.jpg');
image(backgroundImage);

c = clock;

set(handles.multiplier,'String',['x' sprintf('%03i',1)]);

set(handles.axes1,'Color',[0 0 0]);

set(handles.date,'String',[sprintf('%02.f',c(2)) '.' sprintf('%02.f',c(3)) '.' ...
    num2str(c(1))]);
set(handles.date,'BackgroundColor',[154 153 255]./255);
set(handles.date,'ForegroundColor','Black');
set(handles.date,'FontSize',20);
set(handles.date,'FontWeight','bold');

set(handles.Qtext,'String',sprintf('%04.1f',0));
set(handles.Qtext,'BackgroundColor','Black');
set(handles.Qtext,'ForegroundColor','Yellow');
set(handles.Qtext,'FontSize',28);

% set(handles.text1,'FontName','Agency FB');
set(handles.text1,'ForegroundColor','Yellow');
set(handles.text1,'FontSize',36);
set(handles.text1,'BackgroundColor','black');
set(handles.text1,'FontWeight','bold');

set(handles.MisNo,'String',sprintf('%03i',0));
set(handles.MisNo,'BackgroundColor',[167 162 254]./255);
set(handles.MisNo,'FontSize',28);

set(handles.curtime,'BackgroundColor',[204 153 254]./255);
set(handles.curtime,'ForegroundColor','black');
set(handles.curtime,'String',[sprintf('%02.f',c(4)) ':' sprintf('%02.f',c(5)) ':' ...
    sprintf('%04.1f',c(6))]);
set(handles.curtime,'FontSize',20);
set(handles.curtime,'FontWeight','bold');

set(handles.xvel,'BackgroundColor',[209 103 103]./255);
set(handles.xvel,'ForegroundColor','black');
set(handles.xvel,'String','X Velocity: ');
set(handles.xvel,'FontSize',16);
set(handles.xvel,'FontName','Agency FB');
set(handles.xvel,'FontWeight','bold');

set(handles.yvel,'BackgroundColor',[209 103 103]./255);
set(handles.yvel,'ForegroundColor','black');
set(handles.yvel,'String','Y Velocity: ');
set(handles.yvel,'FontSize',16);
set(handles.yvel,'FontName','Agency FB');
set(handles.yvel,'FontWeight','bold');

set(handles.t_elapsed,'BackgroundColor',[255 102 52]./255);
set(handles.t_elapsed,'ForegroundColor','black');
set(handles.t_elapsed,'String','Elapsed Time: ');
set(handles.t_elapsed,'FontSize',16);
set(handles.t_elapsed,'FontName','Agency FB');
set(handles.t_elapsed,'FontWeight','bold');

set(handles.wl,'FontSize',36);
set(handles.wl,'String',[sprintf('%03i',0) '-' sprintf('%03i',0)]);
set(handles.wl,'FontName','OCR A Extended');
set(handles.wl,'FontWeight','bold');

set(handles.percent,'FontSize',18)
a = get(handles.wl,'String');
a1 = str2double(a(1:3));
a2 = str2double(a(5:7));

if a1 + a2 > 0
set(handles.percent,'String',sprintf('%01.4f',( a1/ (a1+a2))));
else set(handles.percent,'String',sprintf('%01.4f',0));
end

set(handles.percent,'FontName','OCR A Extended');
set(handles.percent,'FontWeight','bold');

set(handles.curdist,'BackgroundColor',[255 153 52]./255);
set(handles.curdist,'ForegroundColor','black');
set(handles.curdist,'String','Distance: ');
set(handles.curdist,'FontSize',16);
set(handles.curdist,'FontName','Agency FB');
set(handles.curdist,'FontWeight','bold');

set(handles.maxpts,'BackgroundColor',[154 153 255]./255);

set(handles.totalpts,'String',sprintf('%010.0f',0));
set(handles.avgpts,'String',sprintf('%06.0f',0));

current_choice = get(handles.popupmenu1,'Value');

handles.def_fig = [];

handles.instruct = struct(...
    'open',[...
    'Your mission is to move the magenta particle into the green radius '...
    'of the blue dot by controlling its charge in an n-body system.'...
    ' Should you choose to accept, hit the "Start" button.'],...
    'create',[...
    'Construct your field of fixed potentials. Right click and drag to'...
    ' create object, left click to move, shift click to resize.' ...
    ' Click on colorbar to redefine voltage.' ...
    ' Delete: left-click or right-click and drag.'],...
    'play',[...
    'Navigate the field by controlling the charge. Remember: a '...
    'negative charge goes against the field, a positive goes with it.']);

set(handles.instructions,'String',handles.instruct.open);

get(handles.popupmenu1,'String');

StaticList = {'Very Easy' 'Easy' 'Medium' 'Hard' 'Somerville'};
DynamicList = {'Very Easy' 'Easy' 'Medium'};

switch current_choice
    case 1
        set(handles.diff,'String',StaticList);    
        set(handles.diff,'Value',3);
    case 2
        set(handles.diff,'String',DynamicList);   
        set(handles.diff,'Value',2);
end

% Update handles structure
guidata(hObject, handles);



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


% --- Executes on slider movement.
function Qslider_Callback(hObject, eventdata, handles)
% hObject    handle to Qslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% set(handles.Qtext,'String',num2str(get(handles.Qslider,'Value')))

curQ = get(handles.Qslider,'Value');

    if curQ > 0
    setter = sprintf('%04.1f',curQ);
    elseif curQ < 0
    setter = sprintf('%05.1f',curQ);
    else setter = ' 00.0';
    end

if curQ > 0
    setter = ['+' setter];
end

set(handles.Qtext,'String',setter)

% --- Executes during object creation, after setting all properties.
function Qslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Qslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Qslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)
% hObject    handle to begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Qslider,'Value',0);
set(handles.Qtext,'String',sprintf('%04.1f',0));

set(handles.MisNo,'String',sprintf('%03i', ...
     str2double(get(handles.MisNo,'String')) + 1));

c = clock;
set(handles.curtime,'String',[sprintf('%02.f',c(4)) ':' sprintf('%02.f',c(5)) ':' ...
    sprintf('%04.1f',c(6))]);

set(handles.text1,'Visible','off');

set(handles.instructions,'String',handles.instruct.create);

set(hObject,'Visible','off');

game_state = Final_main(handles);

set(handles.instructions,'String',handles.instruct.open);

wl_res = get(handles.wl,'String');
w = str2double(wl_res(1:3));
l = str2double(wl_res(5:7));

if ~isempty(game_state)
    if game_state == 1

        curStreak = get(handles.multiplier,'String');
        curStreak(1) = [];
        curStreak = str2double(curStreak) + 1;
        set(handles.multiplier,'String',['x' sprintf('%03i',curStreak)]);

        w = w+1;
        set(handles.text1,'String','You Win!');
        set(handles.totalpts,'String',sprintf('%010.0f', ...
            str2double(get(handles.totalpts,'String')) + ...
            str2double(get(handles.Mtime,'String')) ));

    else
        set(handles.multiplier,'String',['x' sprintf('%03i',1)]);
        l = l+1;
        set(handles.text1,'String','You Lose!');
    end

    set(handles.wl,'String',[sprintf('%03i',w) '-' sprintf('%03i',l)]);
    
    a = get(handles.wl,'String');
    a = str2double(a(1:3)) + str2double(a(5:7));
    set(handles.avgpts,'String',sprintf('%06.0f', ...
        (1/a)*str2double(get(handles.totalpts,'String'))));

    a = get(handles.wl,'String');
    a1 = str2double(a(1:3));
    a2 = str2double(a(5:7));

    if a1 + a2 > 0
    set(handles.percent,'String',sprintf('%01.4f',( a1/ (a1+a2))));
    else set(handles.percent,'String',sprintf('%01.4f',0));
    end
    
    set(hObject,'Visible','on');
    
    for i=1:4
        set(handles.text1,'Visible','on');
        pause(1);
        set(handles.text1,'Visible','off');
        pause(1);
    end

end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

current_choice = get(handles.popupmenu1,'Value');

StaticList = {'Very Easy' 'Easy' 'Medium' 'Hard' 'Somerville'};
DynamicList = {'Very Easy' 'Easy' 'Medium'};

switch current_choice
    case 1
        set(handles.diff,'String',StaticList);
        set(handles.diff,'Value',3);
    case 2
        set(handles.diff,'String',DynamicList);
        set(handles.diff,'Value',2);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in diff.
function diff_Callback(hObject, eventdata, handles)
% hObject    handle to diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns diff contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        diff


% --- Executes during object creation, after setting all properties.
function diff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dynamic_speed.
function dynamic_speed_Callback(hObject, eventdata, handles)
% hObject    handle to dynamic_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dynamic_speed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dynamic_speed


% --- Executes during object creation, after setting all properties.
function dynamic_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dynamic_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function multiplier_Callback(hObject, eventdata, handles)
% hObject    handle to dynamic_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dynamic_speed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dynamic_speed


% --- Executes during object creation, after setting all properties.
function multiplier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dynamic_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Mtime_Callback(hObject, eventdata, handles)
% hObject    handle to dynamic_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dynamic_speed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dynamic_speed


% --- Executes during object creation, after setting all properties.
function Mtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dynamic_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
