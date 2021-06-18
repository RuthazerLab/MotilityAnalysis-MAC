function [] = writeTextFile(hObject,handles,eventdata,extraData)

% this function allows the user to creat a new text file under the rootDirectory
% and edit it with the text editor

% do function
tag = get(hObject,'tag');
if strcmp(tag,'function4')
    % initialize GUI to begin function
    set(handles.subOption1,'value',1);
    set(handles.subOption2,'value',1);
    set(handles.subOption3,'value',1);
    set(handles.subOption4,'value',1);
    spaceInds = strfind(handles.rootDirectory,' ');
    if ~isempty(spaceInds)
        set(handles.table,'enable','off');
        set(handles.enter,'enable','off');
        set(handles.prompt,'string','The root directory contains spaces which will cause problems when Matlab attempts to open text files for editing.  If you wish to use the text file functions, please remove all spaces in the folder names in the rootDirectory search path.');
    else
        set(handles.table,'enable','on');
        set(handles.enter,'enable','on');
        set(handles.prompt,'string','Navigate to the folder you''d like to create a text file in using the table, and click Make File when done');
        loadListbox([],handles,[],pwd);
        functionState.curPath = pwd;
        set(handles.function4,'userdata',functionState);
        handles = updateTable(handles,extraData);
    end
elseif strcmp(tag,'table')
    % interact with directories
    handles = updateTable(handles,extraData);
elseif strcmp(tag,'enter')
    % prompt user to enter filename of new textfile
    set(handles.table,'enable','off');
    set(handles.enter,'enable','off');
    set(handles.userInput,'enable','on');
    set(handles.prompt,'string','Please enter the filename (without extension) of the textfile you''d like to create and press enter when done.');
elseif strcmp(tag,'userInput')
    % makes sure that there are no spaces in the filename and then creates
    % and opens the text file
    str = get(handles.userInput,'string');
    functionState = get(handles.function4,'userdata');
    badvals = strfind(str,' ');
    str(badvals) = '_'; 
    path = [functionState.curPath,handles.slash,str,'.txt'];
    fid = fopen(path,'wt');
    fclose(fid);
    system(sprintf('open %s',path));
    set(handles.userInput,'enable','off');
    set(handles.userInput,'string','');
    set(handles.enter,'enable','on');
    set(handles.table,'enable','on');
    loadListbox([],handles,[],functionState.curPath);
    set(handles.function4,'userdata',functionState);
end


% define new control variables
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
tdata.task = tdata.task;
f = fdata(1);
p = fdata(2);
o = odata(1);
so = odata(2);
tdata.button = tdata.button;
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);

%_______________________________________________
function [handles] = updateTable(handles,extraData)
% updates the table with folders under selection

functionState = get(handles.function4,'userdata');
excludeList = {'.','..','.DS_Store'};
colname = {'Sub-Directories'};
if strcmp(extraData,'Move Back One Folder')
    cd('..');
    functionState.curPath = pwd;
    loadListbox([],handles,[],functionState.curPath);
    dirData = dir();
    dirIndex = [dirData.isdir];
    dirList = {dirData(dirIndex).name};
    validIndex = ~ismember(dirList,excludeList);
    keepDirs = dirList(validIndex)';
    if ~strcmp(pwd,handles.rootDirectory)
        finDirs = cell(length(keepDirs)+1,1);
        finDirs(1) = {'Move Back One Folder'};
        finDirs(2:length(keepDirs)+1,1)= keepDirs;
    else
        finDirs = keepDirs;
    end
    set(handles.table,'data',finDirs);
    set(handles.table,'columnname',colname);
else
    functionState.curPath = [functionState.curPath,handles.slash,extraData];
    loadListbox([],handles,[],functionState.curPath);
    dirData = dir(functionState.curPath);
    dirIndex = [dirData.isdir];
    dirList = {dirData(dirIndex).name};
    validIndex = ~ismember(dirList,excludeList);
    keepDirs = dirList(validIndex)';
    if ~strcmp(pwd,handles.rootDirectory)
        finDirs = cell(length(keepDirs)+1,1);
        finDirs(1) = {'Move Back One Folder'};
        finDirs(2:length(keepDirs)+1,1)= keepDirs;
    else
        finDirs = keepDirs;
    end
    set(handles.table,'data',finDirs);
    set(handles.table,'columnname',colname);
end
set(handles.function4,'userdata',functionState);


%_________________________________________________________
