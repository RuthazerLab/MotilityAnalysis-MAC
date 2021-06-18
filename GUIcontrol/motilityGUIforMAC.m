function varargout = motilityGUIforMAC(varargin)
% MOTILITYGUIFORMAC MATLAB code for motilityGUIforMAC.fig
%      MOTILITYGUIFORMAC, by itself, creates a new MOTILITYGUIFORMAC or raises the existing
%      singleton*.
%
%      H = MOTILITYGUIFORMAC returns the handle to a new MOTILITYGUIFORMAC or the handle to
%      the existing singleton*.
%
%      MOTILITYGUIFORMAC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTILITYGUIFORMAC.M with the given input arguments.
%
%      MOTILITYGUIFORMAC('Property','Value',...) creates a new MOTILITYGUIFORMAC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before motilityGUIforMAC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to motilityGUIforMAC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help motilityGUIforMAC
% Last Modified by GUIDE v2.5 24-Apr-2012 15:22:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motilityGUIforMAC_OpeningFcn, ...
                   'gui_OutputFcn',  @motilityGUIforMAC_OutputFcn, ...
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


% --- Executes just before motilityGUIforMAC is made visible.
function motilityGUIforMAC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motilityGUIforMAC (see VARARGIN)

% Choose default command line output for motilityGUIforMAC
handles.output = hObject;
handles.rootDirectory = '/Users/labuser/Documents/MATLAB/motility_GUIv2/GUIProjectFolders';  % define root directory for studies
handles.controlDirectory = '/Users/labuser/Documents/MATLAB/motility_GUIv2/GUIcontrol';
handles.controlFile = '/Users/labuser/Documents/MATLAB/motility_GUIv2/GUIcontrol/GUIcontrol.mat';  % define directory with functions and look up tables
handles.tableProps = '/Users/labuser/Documents/MATLAB/motility_GUIv2/GUIcontrol/tableProps.mat';
% colormaps
handles.cmap_blank = [1 1 1];
handles.cmap_colour = [0 0 0;hot(100);1 1 1];
handles.cmap_colour2 = [1 1 1;jet(50)];

% version
versionNum = 0;
if versionNum==0
    handles.slash = '/';   % MAC Version
else
    handles.slash = '\';   % PC Version
end
if ~isdir([handles.rootDirectory,handles.slash,'ExportedFigures'])
    mkdir([handles.rootDirectory,handles.slash,'ExportedFigures']);
end
if ~isdir([handles.rootDirectory,handles.slash,'ExportedResults'])
    mkdir([handles.rootDirectory,handles.slash,'ExportedResults']);
end
if not(exist(handles.rootDirectory,'dir'))
    set(handles.prompt,'string',...
    sprintf('Root directory path %s does not exist.  GUI cannot continue.  Please create path and restart.',handles.rootDirectory));
    turnOffButtons(handles);
elseif not(exist(handles.controlFile))
    set(handles.prompt,'string',...
    sprintf('Control file %s does not exist.  GUI cannot continue.  Please fix path and restart.',handles.controlFile));
    turnOffButtons(handles);
else
    tdata.task = 0;
    tdata.button = 'N/A';
    set(handles.taskPanel,'userdata',tdata);  % set the task to 1 and the button to zero
    set(handles.functionPanel,'userdata',[0 0]); % set the function to 0 and the page to 0
    set(handles.optionPanel,'userdata',[0 0]);  % set the option and sub option to 0
    guidata(handles.figure1, handles);
    executeAlgorithm(handles.figure1,handles,eventdata,handles.rootDirectory);  % execute the main algorithm    
    loadListbox([],handles,[],handles.rootDirectory);
    % update project hierarchy 
    set(handles.table,'enable','off');
    excludeList = {'.','..','.DS_Store','ExportedResults','ExportedFigures','Processed_Images','Raw_Images'};
    dirData = dir();
    dirIndex = [dirData.isdir];
    dirList = {dirData(dirIndex).name};
    validIndex = ~ismember(dirList,excludeList);
    projectNames = dirList(validIndex)';
    if length(projectNames)>0
        for i = 1:length(projectNames)
            projectHierarchy(i).name = projectNames{i};
            dirData = dir([pwd,handles.slash,projectNames{i}]);
            dirIndex = [dirData.isdir];
            dirList = {dirData(dirIndex).name};
            validIndex = ~ismember(dirList,excludeList);
            names = dirList(validIndex)';
            for j = 1:length(names);
                projectHierarchy(i).group(j).name = names{j};
                dirData = dir([pwd,handles.slash,projectNames{i},handles.slash,names{j}]);
                dirIndex = [dirData.isdir];
                dirList = {dirData(dirIndex).name};
                validIndex = ~ismember(dirList,excludeList);
                names2 = dirList(validIndex)';
                for k = 1:length(names2)
                   projectHierarchy(i).group(j).cell(k).name = names2{k}; 
                end
            end
        end
        save([handles.rootDirectory,handles.slash,'projectHierarchy.mat'],'projectHierarchy');
    end
end


% Update handles structure
guidata(hObject, handles);





% UIWAIT makes motilityGUIforMAC wait for user response (see UIRESUME)
 % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = motilityGUIforMAC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function userInput_Callback(hObject, eventdata, handles)
% hObject    handle to userInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of userInput as text
%        str2double(get(hObject,'String')) returns contents of userInput as a double
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes during object creation, after setting all properties.
function userInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to userInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enter.
function enter_Callback(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on button press in sliderClickR.
function sliderClickR_Callback(hObject, eventdata, handles)
% hObject    handle to sliderClickR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on button press in sliderClickL.
function sliderClickL_Callback(hObject, eventdata, handles)
% hObject    handle to sliderClickL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in option1.
function option1_Callback(hObject, eventdata, handles)
% hObject    handle to option1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option1
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on button press in option2.
function option2_Callback(hObject, eventdata, handles)
% hObject    handle to option2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option2
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on button press in option3.
function option3_Callback(hObject, eventdata, handles)
% hObject    handle to option3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option3
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on selection change in subOption1.
function subOption1_Callback(hObject, eventdata, handles)
% hObject    handle to subOption1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subOption1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subOption1
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes during object creation, after setting all properties.
function subOption1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subOption1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subOption2.
function subOption2_Callback(hObject, eventdata, handles)
% hObject    handle to subOption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subOption2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subOption2
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes during object creation, after setting all properties.
function subOption2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subOption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subOption3.
function subOption3_Callback(hObject, eventdata, handles)
% hObject    handle to subOption3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subOption3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subOption3
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes during object creation, after setting all properties.
function subOption3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subOption3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in task2.
function task2_Callback(hObject, eventdata, handles)
% hObject    handle to task2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of task2
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on button press in task3.
function task3_Callback(hObject, eventdata, handles)
% hObject    handle to task3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of task3
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on button press in task4.
function task4_Callback(hObject, eventdata, handles)
% hObject    handle to task4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of task4
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes on button press in task1.
function task1_Callback(hObject, eventdata, handles)
% hObject    handle to task1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of task1
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

function parameter1_Callback(hObject, eventdata, handles)
% hObject    handle to parameter1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter1 as text
%        str2double(get(hObject,'String')) returns contents of parameter1 as a double
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction

% --- Executes during object creation, after setting all properties.
function parameter1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in function1.
function function1_Callback(hObject, eventdata, handles)
% hObject    handle to function1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes on button press in function2.
function function2_Callback(hObject, eventdata, handles)
% hObject    handle to function2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes on button press in function4.
function function4_Callback(hObject, eventdata, handles)
% hObject    handle to function4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes on button press in function5.
function function5_Callback(hObject, eventdata, handles)
% hObject    handle to function5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes on button press in function6.
function function6_Callback(hObject, eventdata, handles)
% hObject    handle to function6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes on button press in function7.
function function7_Callback(hObject, eventdata, handles)
% hObject    handle to function7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes on button press in function3.
function function3_Callback(hObject, eventdata, handles)
% hObject    handle to function3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction



function parameter2_Callback(hObject, eventdata, handles)
% hObject    handle to parameter2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter2 as text
%        str2double(get(hObject,'String')) returns contents of parameter2 as a double
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes during object creation, after setting all properties.
function parameter2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameter3_Callback(hObject, eventdata, handles)
% hObject    handle to parameter3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter3 as text
%        str2double(get(hObject,'String')) returns contents of parameter3 as a double
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes during object creation, after setting all properties.
function parameter3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameter4_Callback(hObject, eventdata, handles)
% hObject    handle to parameter4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter4 as text
%        str2double(get(hObject,'String')) returns contents of parameter4 as a double
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes during object creation, after setting all properties.
function parameter4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameter5_Callback(hObject, eventdata, handles)
% hObject    handle to parameter5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter5 as text
%        str2double(get(hObject,'String')) returns contents of parameter5 as a double
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes during object creation, after setting all properties.
function parameter5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in option4.
function option4_Callback(hObject, eventdata, handles)
% hObject    handle to option4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option4

extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes on selection change in subOption4.
function subOption4_Callback(hObject, eventdata, handles)
% hObject    handle to subOption4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subOption4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subOption4
extraData = '';
executeAlgorithm(hObject,handles,eventdata,extraData);  % executes MAIN algorithm after any GUI object interaction


% --- Executes during object creation, after setting all properties.
function subOption4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subOption4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [t,f,p,o,so,button] = getControlValues(handles)
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
t = tdata.task;
f = fdata(1);
p = fdata(2);
o = odata(1);
so = odata(2);
button = tdata.button;

function [] = executeAlgorithm(hObject,handles,eventdata,extraData)
button = get(hObject,'tag');
handles = defineNewControlInfo(button,handles);
handles = define_Button_State(handles);
load(handles.controlFile);
[t,f,p,o,so,button] = getControlValues(handles);
val = find(controlState.Tnum==t&controlState.Fnum==f&controlState.Pnum==p&...
    controlState.Onum==o&controlState.SOnum==so&strcmp(controlState.Button,button));
iteration = controlState.iteration{val};
if not(strcmp(iteration,'DNC'));
   set(handles.enter,'userdata',str2double(iteration));
end
fh = str2func(controlState.callFuncName{val});
fh(hObject,handles,eventdata,extraData);
% [t,f,p,o,so,button] = getControlValues(handles)
% val = find(controlState.Tnum==t&controlState.Fnum==f&controlState.Pnum==p&...
%     controlState.Onum==o&controlState.SOnum==so&strcmp(controlState.Button,button))
define_Button_State(handles);


function [handles] = defineNewControlInfo(button,handles)
if not(strcmp(button,'figure1'))
    tdata = get(handles.taskPanel,'userdata');
    fdata = get(handles.functionPanel,'userdata');
    odata = get(handles.optionPanel,'userdata');
    tnew = tdata.task;
    fnew = fdata(1);
    pnew = fdata(2);
    onew = odata(1);
    sonew = odata(2);
    tdata.button = button;
    load(handles.controlFile);
 
    tchanged = 0;
    if strcmp(button,'task1');
        tnew = 1;
        tchanged = 1;
    end
    if strcmp(button,'task2');
        tnew = 2;
        tchanged = 1;
    end
    if strcmp(button,'task3');
        tnew = 3;
        tchanged = 1;
    end
    if strcmp(button,'task4');
        tnew = 4;
        tchanged = 1;
    end
    if tchanged==1
        fnew = 0;
        onew = 0;
        sonew = 0;
        pnew = 0;
    else
        fchanged = 0;
        if strcmp(button,'function1');
            fnew = 1;
            fchanged = 1;
        end
        if strcmp(button,'function2');
            fnew = 2;
            fchanged =1;
        end
        if strcmp(button,'function3');
            fnew = 3;
            fchanged = 1;
        end
        if strcmp(button,'function4');
            fnew = 4;
            fchanged = 1;
        end
        if strcmp(button,'function5');
            fnew = 5;
            fchanged = 1;
        end
        if strcmp(button,'function6');
            fnew = 6;
            fchanged = 1;
        end
        if strcmp(button,'function7');
            fnew = 7;
            fchanged = 1;
        end
        if strcmp(button,'option1');
            onew = 1;
        end
        if strcmp(button,'option2');
            onew = 2;
        end
        if strcmp(button,'option3');
            onew = 3;
        end
        if strcmp(button,'option4');
            onew = 4;
        end
        if strcmp(button,'subOption1');
            sonew = 1;
        end
        if strcmp(button,'subOption2');
            sonew = 2;
        end
        if strcmp(button,'subOption3');
            sonew = 3;
        end
        if strcmp(button,'subOption4');
            sonew = 4;
        end
        if fchanged==1
           sonew=0;
           onew =0;
        end
    end
    tdata.task = tnew;
    fdata(1) = fnew;
    fdata(2) = pnew;
    odata(1) = onew;
    odata(2) = sonew;
    set(handles.taskPanel,'userdata',tdata);
    set(handles.functionPanel,'userdata',fdata);
    set(handles.optionPanel,'userdata',odata);
    guidata(handles.figure1,handles);
end

function [handles] = define_Button_State(handles)
tpanel = get(handles.taskPanel,'userdata');
fpanel = get(handles.functionPanel,'userdata');
opanel = get(handles.optionPanel,'userdata');

t = tpanel.task;
f = fpanel(1);
p = fpanel(2);
o = opanel(1);
so = opanel(2);
button = tpanel.button;
load(handles.controlFile);

val = find(controlState.Tnum==t&controlState.Fnum==f&controlState.Pnum==p&...
      controlState.Onum==o&controlState.SOnum==so&strcmp(controlState.Button,button));
refreshButtons(handles,controlState,val);

function [handles] = turnOffButtons(handles)

set(handles.task1,'enable','off');
set(handles.task1,'string','--');
set(handles.task2,'enable','off');
set(handles.task2,'string','--');
set(handles.task3,'enable','off');
set(handles.task3,'string','--');
set(handles.task4,'enable','off');
set(handles.task4,'string','--');

set(handles.function1,'enable','off');
set(handles.function1,'string','--');
set(handles.function2,'enable','off');
set(handles.function2,'string','--');
set(handles.function3,'enable','off');
set(handles.function3,'string','--');
set(handles.function4,'enable','off');
set(handles.function4,'string','--');
set(handles.function5,'enable','off');
set(handles.function5,'string','--');
set(handles.function6,'enable','off');
set(handles.function6,'string','--');
set(handles.function7,'enable','off');
set(handles.function7,'string','--');

set(handles.option1,'enable','off');
set(handles.option1,'string','--');
set(handles.option2,'enable','off');
set(handles.option2,'string','--');
set(handles.option3,'enable','off');
set(handles.option3,'string','--');
set(handles.option4,'enable','off');
set(handles.option4,'string','--');

set(handles.subOption1,'enable','off');
set(handles.subOption1,'string','--');
set(handles.subOption2,'enable','off');
set(handles.subOption2,'string','--');
set(handles.subOption3,'enable','off');
set(handles.subOption3,'string','--');
set(handles.subOption4,'enable','off');
set(handles.subOption4,'string','--');

set(handles.plabel1,'string','--');
set(handles.plabel2,'string','--');
set(handles.plabel3,'string','--');
set(handles.plabel4,'string','--');
set(handles.plabel5,'string','--');

set(handles.parameter1,'enable','off');
set(handles.parameter1,'string','--');
set(handles.parameter2,'enable','off');
set(handles.parameter2,'string','--');
set(handles.parameter3,'enable','off');
set(handles.parameter3,'string','--');
set(handles.parameter4,'enable','off');
set(handles.parameter4,'string','--');
set(handles.parameter5,'enable','off');
set(handles.parameter5,'string','--');

set(handles.table,'enable','off');
set(handles.slider,'enable','off');
set(handles.sliderClickR,'enable','off');
set(handles.sliderClickL,'enable','off');
set(handles.enter,'enable','off');
set(handles.enter,'string','--');
set(handles.listbox,'enable','off');
set(handles.userInput,'enable','off');
set(handles.userInput,'string','--');

 
function [handles] = refreshButtons(handles,controlState,val)

set(handles.task1,'value',0);
set(handles.task2,'value',0);
set(handles.task3,'value',0);
set(handles.task4,'value',0);

if controlState.whichtask(val)==1
    set(handles.task1,'value',1);
elseif controlState.whichtask(val)==2
    set(handles.task2,'value',1);
elseif controlState.whichtask(val)==3
    set(handles.task3,'value',1);
elseif controlState.whichtask(val)==4
    set(handles.task4,'value',1);
end

if not(strcmp(controlState.task1name{val},'DNC'))
    set(handles.task1,'string',controlState.task1name{val});
end
if not(strcmp(controlState.task2name{val},'DNC'))
    set(handles.task2,'string',controlState.task2name{val});
end
if not(strcmp(controlState.task3name{val},'DNC'))
    set(handles.task3,'string',controlState.task3name{val});
end
if not(strcmp(controlState.task4name{val},'DNC'))
    set(handles.task4,'string',controlState.task4name{val});
end


% functions
if not(strcmp(controlState.function1state{val},'DNC'))
    set(handles.function1,'enable',controlState.function1state{val});
end
if not(strcmp(controlState.function1name{val},'DNC'))
    set(handles.function1,'string',controlState.function1name{val});
end
if not(strcmp(controlState.function2state{val},'DNC'))
    set(handles.function2,'enable',controlState.function2state{val});
end
if not(strcmp(controlState.function2name{val},'DNC'))
    set(handles.function2,'string',controlState.function2name{val});
end
if not(strcmp(controlState.function3state{val},'DNC'))
    set(handles.function3,'enable',controlState.function3state{val});
end
if not(strcmp(controlState.function3name{val},'DNC'))
    set(handles.function3,'string',controlState.function3name{val});
end
if not(strcmp(controlState.function4state{val},'DNC'))
    set(handles.function4,'enable',controlState.function4state{val});
end
if not(strcmp(controlState.function4name{val},'DNC'))
    set(handles.function4,'string',controlState.function4name{val});
end
if not(strcmp(controlState.function5state{val},'DNC'))
    set(handles.function5,'enable',controlState.function5state{val});
end
if not(strcmp(controlState.function5name{val},'DNC'))
    set(handles.function5,'string',controlState.function5name{val});
end
if not(strcmp(controlState.function6state{val},'DNC'))
    set(handles.function6,'enable',controlState.function6state{val});
end
if not(strcmp(controlState.function6name{val},'DNC'))
    set(handles.function6,'string',controlState.function6name{val});
end
if not(strcmp(controlState.function7state{val},'DNC'))
    set(handles.function7,'enable',controlState.function7state{val});
end
if not(strcmp(controlState.function7name{val},'DNC'))
    set(handles.function7,'string',controlState.function7name{val});
end

% options
if not(strcmp(controlState.option1state{val},'DNC'))
    set(handles.option1,'enable',controlState.option1state{val});
end
if not(strcmp(controlState.option1name{val},'DNC'))
    set(handles.option1,'string',controlState.option1name{val});
end
if not(strcmp(controlState.option1value{val},'DNC'))
    set(handles.option1,'value',str2double(controlState.option1value{val}));
end
if not(strcmp(controlState.option2state{val},'DNC'))
    set(handles.option2,'enable',controlState.option2state{val});
end
if not(strcmp(controlState.option2name{val},'DNC'))
    set(handles.option2,'string',controlState.option2name{val});
end
if not(strcmp(controlState.option2value{val},'DNC'))
    set(handles.option2,'value',str2double(controlState.option2value{val}));
end
if not(strcmp(controlState.option3state{val},'DNC'))
    set(handles.option3,'enable',controlState.option3state{val});
end
if not(strcmp(controlState.option3name{val},'DNC'))
    set(handles.option3,'string',controlState.option3name{val});
end
if not(strcmp(controlState.option3value{val},'DNC'))
    set(handles.option3,'value',str2double(controlState.option3value{val}));
end
if not(strcmp(controlState.option4state{val},'DNC'))
    set(handles.option4,'enable',controlState.option4state{val});
end
if not(strcmp(controlState.option4name{val},'DNC'))
    set(handles.option4,'string',controlState.option4name{val});
end
if not(strcmp(controlState.option4value{val},'DNC'))
    set(handles.option4,'value',str2double(controlState.option4value{val}));
end

% sub options

if not(strcmp(controlState.subOption1state{val},'DNC'))
    set(handles.subOption1,'enable',controlState.subOption1state{val});
end
if not(strcmp(controlState.subOption1name{val},'DNC'))
    set(handles.subOption1,'string',controlState.subOption1name{val});
end
if not(strcmp(controlState.subOption2state{val},'DNC'))
    set(handles.subOption2,'enable',controlState.subOption2state{val});
end
if not(strcmp(controlState.subOption2name{val},'DNC'))
    set(handles.subOption2,'string',controlState.subOption2name{val});
end
if not(strcmp(controlState.subOption3state{val},'DNC'))
    set(handles.subOption3,'enable',controlState.subOption3state{val});
end
if not(strcmp(controlState.subOption3name{val},'DNC'))
    set(handles.subOption3,'string',controlState.subOption3name{val});
end
if not(strcmp(controlState.subOption4state{val},'DNC'))
    set(handles.subOption4,'enable',controlState.subOption4state{val});
end
if not(strcmp(controlState.subOption4name{val},'DNC'))
    set(handles.subOption4,'string',controlState.subOption4name{val});
end

% plabels

if not(strcmp(controlState.plabel1name{val},'DNC'))
    set(handles.plabel1,'string',controlState.plabel1name{val});
end
if not(strcmp(controlState.plabel2name{val},'DNC'))
    set(handles.plabel2,'string',controlState.plabel2name{val});
end
if not(strcmp(controlState.plabel3name{val},'DNC'))
    set(handles.plabel3,'string',controlState.plabel3name{val});
end
if not(strcmp(controlState.plabel4name{val},'DNC'))
    set(handles.plabel4,'string',controlState.plabel4name{val});
end
if not(strcmp(controlState.plabel5name{val},'DNC'))
    set(handles.plabel5,'string',controlState.plabel5name{val});
end

% parameters
if not(strcmp(controlState.parameter1state{val},'DNC'))
    set(handles.parameter1,'enable',controlState.parameter1state{val});
end
if not(strcmp(controlState.parameter1name{val},'DNC'))
    set(handles.parameter1,'string',controlState.parameter1name{val});
end
if not(strcmp(controlState.parameter2state{val},'DNC'))
    set(handles.parameter2,'enable',controlState.parameter2state{val});
end
if not(strcmp(controlState.parameter2name{val},'DNC'))
    set(handles.parameter2,'string',controlState.parameter2name{val});
end
if not(strcmp(controlState.parameter3state{val},'DNC'))
    set(handles.parameter3,'enable',controlState.parameter3state{val});
end
if not(strcmp(controlState.parameter3name{val},'DNC'))
    set(handles.parameter3,'string',controlState.parameter3name{val});
end
if not(strcmp(controlState.parameter4state{val},'DNC'))
    set(handles.parameter4,'enable',controlState.parameter4state{val});
end
if not(strcmp(controlState.parameter4name{val},'DNC'))
    set(handles.parameter4,'string',controlState.parameter4name{val});
end
if not(strcmp(controlState.parameter5state{val},'DNC'))
    set(handles.parameter5,'enable',controlState.parameter5state{val});
end
if not(strcmp(controlState.parameter5name{val},'DNC'))
    set(handles.parameter5,'string',controlState.parameter5name{val});
end

% table
if not(strcmp(controlState.tablestate{val},'DNC'))
    set(handles.table,'enable',controlState.tablestate{val});
end
if not(strcmp(controlState.tabledata{val},'DNC'))
    set(handles.table,'data',controlState.tabledata{val});
end
if not(strcmp(controlState.columnname{val},'DNC'))
    set(handles.table,'columnname',{controlState.columnname{val}});
end
if not(strcmp(controlState.columnwidth{val},'DNC'))
    load(handles.tableProps);
    tabval = str2double(controlState.columnwidth{val});
    set(handles.table,'columnwidth',{tableProps.width{tabval}});
end

% other
if not(strcmp(controlState.sliderstate{val},'DNC'))
    set(handles.slider,'enable',controlState.sliderstate{val});
    set(handles.sliderClickR,'enable',controlState.sliderstate{val});
    set(handles.sliderClickL,'enable',controlState.sliderstate{val});
end
if not(strcmp(controlState.enterstate{val},'DNC'))
    set(handles.enter,'enable',controlState.enterstate{val});
end
if not(strcmp(controlState.entername{val},'DNC'))
    set(handles.enter,'string',controlState.entername{val});
end
if not(strcmp(controlState.listboxstate{val},'DNC'))
    set(handles.listbox,'enable',controlState.listboxstate{val});
end
if not(strcmp(controlState.userinputstate{val},'DNC'))
    set(handles.userInput,'enable',controlState.userinputstate{val});
end

if not(strcmp(controlState.userinputname{val},'DNC'))
    set(handles.userInput,'string',controlState.userinputname{val});
end
if not(strcmp(controlState.promptstring{val},'DNC'));
    set(handles.prompt,'string',controlState.promptstring{val});
end
mainaxesCond = controlState.mainaxesstate{val};
if strcmp(mainaxesCond,'BLANK')
    handles=blankTheAxes(handles,1);
end

subaxes1Cond = controlState.subaxes1state{val};
if strcmp(subaxes1Cond,'BLANK')
    handles=blankTheAxes(handles,2);
end

subaxes2Cond = controlState.subaxes2state{val};
if strcmp(subaxes2Cond,'BLANK')
    handles=blankTheAxes(handles,3);
end




% --- Executes when entered data in editable cell(s) in table.
function table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when selected cell(s) is changed in table.
function table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if numel(eventdata.Indices)~=0
    data = get(handles.table,'data');
    extraData = data{eventdata.Indices(1),eventdata.Indices(2)};
    executeAlgorithm(hObject,handles,eventdata,extraData);
end


% --- Executes on button press in taskLock.
function taskLock_Callback(hObject, eventdata, handles)
% hObject    handle to taskLock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of taskLock

val = get(handles.taskLock,'value');
if val==1
    set(handles.task1,'enable','off');
    set(handles.task2,'enable','off');
    set(handles.task3,'enable','off');
    set(handles.task4,'enable','off');
    set(handles.taskLock,'string','Tasks Locked');
else
    set(handles.task1,'enable','on');
    set(handles.task2,'enable','on');
    set(handles.task3,'enable','on');
    set(handles.task4,'enable','on');
    set(handles.taskLock,'string','Tasks Unlocked');
end
