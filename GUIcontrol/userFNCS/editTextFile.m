function [] = editTextFile(hObject,handles,eventdata,extraData)

% this function allows the user to open a text file under the rootDirectory
% and edit it with the text editor

% do function
tag = get(hObject,'tag');
if strcmp(tag,'function5')
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
        set(handles.prompt,'string','Navigate to the folder you''d like to open a text file in using the table, click on the text file to open it.');
        loadListbox([],handles,[],pwd);
        functionState.curPath = pwd;
        set(handles.function5,'userdata',functionState);
        handles = updateTable(handles,extraData);
    end
elseif strcmp(tag,'table');
    handles = updateTable(handles,extraData);
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

%_________________________________________________

function handles = updateTable(handles,extraData)
% navigates through selected folders and updates table for each new
% selection, updates with allowed folders and files with extension .txt
% when the extension of the selection is .txt, matlab opens the file for
% editing

functionState = get(handles.function5,'userdata');
excludeList = {'.','..','.DS_Store'};
colname = {'Sub-Directories'};

strtest = length(strfind(extraData,'.txt'));
if strtest==0
    if strcmp(extraData,'Move Back One Folder')
        cd('..');
        functionState.curPath = pwd;
        loadListbox([],handles,[],functionState.curPath);
        dirData = dir();
        dirIndex = [dirData.isdir];
        dirTxt = strfind({dirData.name},'.txt');
        for i = 1:length(dirTxt)
           if length(dirTxt{i})>0
               dirTxtkeep(i) = 1;
           else
               dirTxtkeep(i) = 0;
           end
        end
        finIndex = dirTxtkeep|dirIndex;
        dirList = {dirData(finIndex).name};
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
        dirTxt = strfind({dirData.name},'.txt');
        for i = 1:length(dirTxt)
           if length(dirTxt{i})>0
               dirTxtkeep(i) = 1;
           else
               dirTxtkeep(i) = 0;
           end
        end
        finIndex = dirTxtkeep|dirIndex;
        dirList = {dirData(finIndex).name};
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
    
else
    path = [functionState.curPath,handles.slash,extraData];
    system(sprintf('open %s',path));
    set(handles.table,'data','');
    loadListbox([],handles,[],pwd);
    functionState.curPath = pwd;
    dirData = dir(functionState.curPath);
    dirIndex = [dirData.isdir];
    dirTxt = strfind({dirData.name},'.txt');
    for i = 1:length(dirTxt)
       if length(dirTxt{i})>0
           dirTxtkeep(i) = 1;
       else
           dirTxtkeep(i) = 0;
       end
    end
    finIndex = dirTxtkeep|dirIndex;
    dirList = {dirData(finIndex).name};
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
set(handles.function5,'userdata',functionState);