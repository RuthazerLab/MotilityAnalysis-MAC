function [] = modifyFolders(hObject,handles,eventdata,extraData)

% this function allows the user to modify the project folder names

% the data structure fileStruc is saved in the userdata of function3 and is
% accessed by the functions below..

% do function
tag = get(hObject,'tag');
if strcmp(tag,'function3')
    % initialize function
    loadListbox([],handles,[],handles.rootDirectory);
    functionState.navPage = 0;  %0 for root direc, 1 for proj fol, 2 for cell type, 3 for cell
    functionState.curPath = handles.rootDirectory;
    functionState.curMode = 1; % 1 for option1, 2 for option2
    set(handles.function3,'userdata',functionState);
    handles = updateTable(handles,extraData);
    functionState = get(handles.function3,'userdata');
    functionState.currentData = get(handles.table,'data');
    set(handles.function3,'userdata',functionState);
elseif strcmp(tag,'option1')
    % change to navigation mode
    set(handles.enter,'enable','off');
    set(handles.prompt,'string','');
    functionState = get(handles.function3,'userdata');
    set(handles.option1,'value',1);
    set(handles.option2,'value',0);
    set(handles.table,'data',functionState.currentData);
    functionState.curMode=1;
    set(handles.function3,'userdata',functionState);
    handles=refreshTable(handles);
elseif strcmp(tag,'option2')
    % change to edit mode
    set(handles.enter,'enable','on');
    set(handles.prompt,'string','');
    functionState = get(handles.function3,'userdata');
    set(handles.option1,'value',0);
    set(handles.option2,'value',1);
    functionState.curMode=2;
    set(handles.function3,'userdata',functionState);
    set(handles.prompt,'string','Edit the entries in the table, and click Update to save your changes.');
    handles=refreshTable(handles);
elseif strcmp(tag,'table')
    % call back for using table
    % in navigate mode cell selection changes directory
    % in edit mode cell selection allows for editing
    set(handles.prompt,'string','');
    functionState = get(handles.function3,'userdata');
    if functionState.curMode==1
        handles = updateTable(handles,extraData);
        set(handles.table,'ColumnEditable',false);
    else
        set(handles.table,'ColumnEditable',true);
    end
elseif strcmp(tag,'enter')
    % update folder names
    handles = redefineFolders(handles);
end

% define new control variables
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
tdata.task = tdata.task;
f = fdata(1);
p = fdata(2);
if strcmp(tag,'function3')
o=1;    
tdata.button = 'option1';
else
o = odata(1);
tdata.button = tdata.button;
end
so = odata(2);
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);


%___________________________________
function [handles] = updateTable(handles,extraData)
% updates the table based on user selection
functionState = get(handles.function3,'userdata');
set(handles.prompt,'string','');
excludeList = {'.','..','.DS_Store','ExportedFigures','ExportedResults'};  % don't show these folders
if functionState.navPage==0   % update table to root directory
    doBack = 0;
    goForward = 1;
    colname = {'Project Folders'};
elseif functionState.navPage==1  % update table to project folder
    doBack = 1;
    goForward = 1;
    colname = {'Cell Type Folders'};
elseif functionState.navPage==2  % update table to group folder
    if strcmp(extraData,'Move Back One Folder')
        doBack=0;
        colname = {'Project Folders'};
    else
        doBack=1;
        colname = {'Cell Folders'};
    end
    goForward = 1;
else
    doBack = 1;
    goForward = 0;
    if strcmp(extraData,'Move Back One Folder')
        colname = {'Group Folders'};
    else
        colname = {'Cell Folders'};
    end
end
% find new folders and update table
if strcmp(extraData,'Move Back One Folder')
    functionState.navPage = functionState.navPage-1;
    cd('..');
    functionState.curPath = pwd;
    dirData = dir();
    dirIndex = [dirData.isdir];
    dirList = {dirData(dirIndex).name};
    validIndex = ~ismember(dirList,excludeList);
    keepDirs = dirList(validIndex)';
    if functionState.curMode&&doBack
        finDirs = cell(length(keepDirs)+1,1);
        finDirs(1) = {'Move Back One Folder'};
        finDirs(2:length(keepDirs)+1,1)= keepDirs;
    else
        finDirs = keepDirs;
    end
    set(handles.table,'data',finDirs);
    set(handles.table,'columnname',colname);
else
    if goForward
        functionState.curPath = [functionState.curPath,handles.slash,extraData];
        dirData = dir(functionState.curPath);
        dirIndex = [dirData.isdir];
        dirList = {dirData(dirIndex).name};
        validIndex = ~ismember(dirList,excludeList);
        keepDirs = dirList(validIndex)';
        if functionState.curMode&&doBack
            finDirs = cell(length(keepDirs)+1,1);
            finDirs(1) = {'Move Back One Folder'};
            finDirs(2:length(keepDirs)+1,1)= keepDirs;
        else
            finDirs = keepDirs;
        end
        set(handles.table,'data',finDirs);
        set(handles.table,'columnname',colname);
        functionState.navPage=functionState.navPage+1;
    else
        set(handles.prompt,'string',sprintf('Error:  Cannot enter the %s folder, since the folders within cannot be renamed',extraData));
    end
end

if functionState.navPage>3
    functionState.navPage=3;
end
if functionState.navPage<0
    functionState.navPage=0;
end
functionState.currentData = get(handles.table,'data');
set(handles.function3,'userdata',functionState);
loadListbox([],handles,[],functionState.curPath);

%_________________________________________________________
function handles = refreshTable(handles)
% refreshes table (does not change directory)
functionState = get(handles.function3,'userdata');
excludeList = {'.','..','.DS_Store','ExportedResults','ExportedFigures'};
dirData = dir(functionState.curPath);
dirIndex = [dirData.isdir];
dirList = {dirData(dirIndex).name};
validIndex = ~ismember(dirList,excludeList);
keepDirs = dirList(validIndex)';
functionState.navPage
if functionState.curMode==1&&functionState.navPage>1
    finDirs = cell(length(keepDirs)+1,1);
    finDirs(1) = {'Move Back One Folder'};
    finDirs(2:length(keepDirs)+1,1)= keepDirs;
    
else
    finDirs = keepDirs;
end
set(handles.table,'data',finDirs);
loadListbox([],handles,[],pwd);
%_________________________________________________________
function handles = redefineFolders(handles)
% checks that no names are blank
% if not blank, checks that there are no spaces in the folders names
% if spaces, changes spaces to underscores
% makes a new directory and copies the contents of the old directory to the
% new one
% deletes the old folder 
tabdata = get(handles.table,'data');
flag = 0;
for i = 1:length(tabdata)
   len = length(tabdata{i}); 
   if len==0
       flag=1;
   end
end
if flag==1
    set(handles.prompt,'string','Error:  One or more Cell Type names are blank.. Please try again');
else
    set(handles.prompt,'string','Processing..');
    pause(0.1);
    functionState = get(handles.function3,'userdata');
    dirData = functionState.currentData;
    validIndex = ~ismember(dirData,{'Move Back One Folder'});
    keepDirs = dirData(validIndex)';
    if strcmp(functionState.currentData{1},'Move Back One Folder')
        functionState.currentData = functionState.currentData(2:end);
    end
    for i = 1:length(tabdata)
        if ~strcmp(tabdata{i},keepDirs{i})
            input = tabdata{i};
            badvals = strfind(input,' ');
            input(badvals) = '_';   
            copyfile(functionState.currentData{i},input);
            rmdir(functionState.currentData{i},'s');
        end
    end
    loadListbox([],handles,[],pwd);
    handles = refreshTable(handles);
    tabdata = get(handles.table,'data');
    functionState.currentData = tabdata;
    set(handles.function3,'userdata',functionState);
    set(handles.prompt,'string','Folders have been updated.  Click Navigate to change more folders or click any task/function to continue working.');
end