function [] = addToStudy(hObject,handles,eventdata,extraData)

% this function adds to the exisiting project folder hierarchy for a new set of
% cells or groups.. the user is prompted with the number of groups and cells to
% be added

% the data structure fileStruc is saved in the userdata of function2 and is
% accessed by the functions below..

% do function
tag = get(hObject,'tag');
load(handles.tableProps);
colwid = tableProps.width{1};
iteration = get(handles.enter,'userdata'); % which iteration of the function 
if iteration==0
    set(handles.function2,'userdata','');
    [handles,iteration] = zerothIteration(handles);
elseif iteration==1
    [handles,iteration] = firstIteration(handles,extraData);     
elseif iteration==2
    [handles,iteration] = secondIteration(hObject,handles);     
elseif iteration==3
    [handles,iteration] = thirdIteration(handles,colwid,extraData);    
elseif iteration==4
    [handles,iteration] = fourthIteration(hObject,handles,colwid);      
elseif iteration==5
    [handles,iteration] = fifthIteration(hObject,handles,colwid); 
end
set(handles.enter,'userdata',iteration);
% define new control variables
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
tdata.task = tdata.task;
f = fdata(1);
p = fdata(2);
so = odata(2);
if strcmp(tag,'option1')||strcmp(tag,'option2')
    tdata.button = 'enter';    
    o = 0;
else
    tdata.button = tdata.button;
    o = odata(1);
end
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);

%____________________________________________
function [handles,iteration] = zerothIteration(handles)
% first finds all exisiting projects and filters out folders matlab finds
% that aren't real project folders
% checks that there is at least one existing project
% if a project exists, updates the table with projects and prompts user to
% choose
files = dir(handles.rootDirectory);
counter = 1;
for i = 1:length(files)
    if files(i).isdir&&not(strcmp(files(i).name,'.'))&&not(strcmp(files(i).name,'..'))&&not(strcmp(files(i).name,'.DS_Store'))&&not(strcmp(files(i).name,'ExportedResults'))&&not(strcmp(files(i).name,'ExportedFigures'))
        projectname{counter,1} = files(i).name;  
        counter = counter+1;
    end
end
if counter==1
    iteration = 0;
    set(handles.prompt,'string','You haven''t yet defined any project folders, please start with Create Study.');
else
    iteration=1;
    set(handles.table,'data',projectname);
    set(handles.table,'enable','on');
    set(handles.enter,'enable','on');
    set(handles.userInput,'string','');
    set(handles.prompt,'string','Please click on the project folder name you''d like to add to in the table above');
end
set(handles.enter,'userdata',iteration);
loadListbox([],handles,[],handles.rootDirectory);

%____________________________________________
function [handles,iteration] = firstIteration(handles,str)
% prompts user to choose between adding a new group or adding new cell
fileStruc = get(handles.function2,'userdata');
set(handles.prompt,'string','Please choose whether you''d like to add a new group, or whether you''d like to add cells to an existing Group, by clicking on the appropriate option above.'); 
loadListbox([],handles,[],[handles.rootDirectory,handles.slash,str]);
set(handles.option1,'string','Add Group Folders');
set(handles.option2,'string','Add Cell Folders');
set(handles.option1,'enable','on');
set(handles.option2,'enable','on');
set(handles.table,'data','');
set(handles.table,'ColumnName','Cell Names');
set(handles.table,'enable','off');
iteration = 2; 
fileStruc.projectName = str;
set(handles.function2,'userdata',fileStruc);

%____________________________________________
function [handles,iteration] = secondIteration(hObject,handles)
% checks what choice the user made
% if choice Group, prompt user for number of new groups
% if choice Cell, check to make sure group folders exist
% if groups exist, update table with groups and prompt user to choose group
tag = get(hObject,'tag');
flag0 = 0;
fileStruc = get(handles.function2,'userdata');
if strcmp(tag,'option1') 
   fileStruc.optionState = 1;
   set(handles.function2,'userdata',fileStruc);
   set(handles.userInput,'enable','on');
   set(handles.enter,'enable','on');
   set(handles.prompt,'string','Please enter the number of extra Group folders to add and press enter when done');
else
   fileStruc.optionState = 2;
   set(handles.function2,'userdata',fileStruc);
   files = dir();
   counter = 1;
   for i = 1:length(files)
       isdirtest = files(i).isdir;
       prjdatatest = not(strcmp(files(i).name,'ExportedResults'));
       prjfigtest = not(strcmp(files(i).name,'ExportedFigures'));
       DStest = not(strcmp(files(i).name,'.DS_Store'));
       dottest = not(strcmp(files(i).name,'.'));
       dottest2 = not(strcmp(files(i).name,'..'));
       if isdirtest&&prjdatatest&&prjfigtest&&DStest&&dottest&&dottest2
           groupData{counter,1} = files(i).name;
           counter = counter+1;
       end
   end
   if counter==1
       set(handles.prompt,'string','Group folders missing!');
       iteration = 2;
       flag0 = 1;
   else
       set(handles.table,'data',groupData);
       set(handles.table,'enable','on');
       set(handles.table','columnname','Group Name');
       set(handles.prompt,'string','Please click on the Group folder you''d like to add to');
   end
end
if not(flag0)
    iteration = 3;
end
set(handles.function2,'userdata',fileStruc);

%____________________________________________
function [handles,iteration] = thirdIteration(handles,colwid,str)
% checks what choice was initially made (group or cell)
% if choice group, checks that input was an integer number
%   if int, updates table with default group names
%   if int, prompts user to edit names
% if choice cell, prompts user for number of new cells to add to the
% selected group
fileStruc = get(handles.function2,'userdata');
fileStruc.projectFolder = pwd;
if fileStruc.optionState==1
    input = get(handles.userInput,'string');
    pause(0.01);
    num = str2double(input);
    if isnan(num)
        set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
        iteration = 3;  
    elseif round(num)<=0
        set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
        iteration = 3;
    else
        L = round(num);
        excludeList = {'.','..','.DS_Store','ExportedFigures','ExportedResults'};
        dirData = dir();
        dirIndex = [dirData.isdir];
        dirList = {dirData(dirIndex).name};
        validIndex = ~ismember(dirList,excludeList);
        keepDirs = dirList(validIndex)';
        startInd = length(keepDirs)+1;
        for i = 1:L
           tabdata{i,1} = sprintf('Group %02.0f',startInd+i-1); 
        end       
        colnam = {'Group Name'};
        set(handles.table,'data',tabdata);
        set(handles.table,'ColumnName',colnam);
        set(handles.table,'ColumnWidth',{colwid});
        set(handles.table,'ColumnEditable',true);
        set(handles.table,'enable','on');
        set(handles.prompt,'string','Please edit the Group names in the table and click enter when done');
        set(handles.userInput,'enable','off');
        set(handles.userInput,'string','');
        iteration =4;    
    end
    
else
   loadListbox([],handles,[],[fileStruc.projectFolder,handles.slash,str]); 
   fileStruc.GroupFolder = [fileStruc.projectFolder,handles.slash,str];
   fileStruc.GroupName = str;
   set(handles.prompt,'string',sprintf('Please enter the number of new cells you''d like to add to the %s folder',[fileStruc.projectName,handles.slash,str]));
   set(handles.table,'enable','off');
   set(handles.table','data','');
   set(handles.table,'columnname','Cell Name');
   set(handles.enter,'enable','on');
   set(handles.userInput,'enable','on');
   set(handles.userInput,'string','');
   iteration =4;
end
set(handles.function2,'userdata',fileStruc);
%____________________________________________
function [handles,iteration] = fourthIteration(hObject,handles,colwid)
% checks initial user choice (group or cell)
% if choice group, checks that no group names are blank
%   if not blank, make new group folders 
%   if not blank, prompt user for # cells first new group
% if choice cell, check that input is an int number
%   if int, update table with default new cell names and prompt user to
%   edit

fileStruc = get(handles.function2,'userdata');
if fileStruc.optionState==1
    button = get(hObject,'tag');
    if strcmp(button,'table')
        iteration = 4;
    else
        tabdata = get(handles.table,'data');
        flag = 0;
        for i = 1:length(tabdata)
            len = length(tabdata{i}); 
            if len==0
               flag=1;
            end
        end
        if flag==1
            set(handles.prompt,'string','Error:  One or more Group names are blank.. Please try again');
            iteration = 4;
        else
        for i = 1:length(tabdata)
            input = tabdata{i};
            badvals = strfind(input,' ');
            input(badvals) = '_';       
            mkdir([fileStruc.projectFolder,handles.slash,input]); 
            fileStruc.GroupFolders{i} = [fileStruc.projectFolder,handles.slash,input]; 
            fileStruc.Groups{i} = input;
        end
        loadListbox([],handles,[],fileStruc.projectFolder);
        fileStruc.NGroups = length(tabdata);
        fileStruc.curGroup = 1;
        fileStruc.doPrompt = 1;
        set(handles.prompt,'string',sprintf('Please Enter the number of Cells for Group: %s',tabdata{1}));
        set(handles.table,'data','');
        set(handles.table,'columnname','Cell Names');
        set(handles.userInput,'enable','on');
        set(handles.userInput,'string','');
        iteration = 5;
        end
    end
else
    input = get(handles.userInput,'string');
    pause(0.01);
    if not(strcmp(input,''))
        num = str2double(input);
        if isnan(num)
            set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
            iteration = 4;  
        elseif round(num)<=0
            set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
            iteration = 4;
        else
            L = round(num);
            excludeList = {'.','..','.DS_Store','ExportedFigures','ExportedResults'};
            dirData = dir();
            dirIndex = [dirData.isdir];
            dirList = {dirData(dirIndex).name};
            validIndex = ~ismember(dirList,excludeList);
            keepDirs = dirList(validIndex)';
            startInd = length(keepDirs)+1;
            for i = 1:L
               tabdata{i,1} = sprintf('Cell %02.0f',startInd+i-1); 
            end
            set(handles.table,'columnname',sprintf('%s Cells',fileStruc.GroupName));
            set(handles.table,'data',tabdata);
            set(handles.table,'ColumnWidth',{colwid});
            set(handles.table,'ColumnEditable',true);
            set(handles.table,'enable','on');
            set(handles.prompt,'string','Please edit the Cell names in the table and click enter when done');
            set(handles.userInput,'enable','off');
            set(handles.userInput,'string','');
            fileStruc.doPrompt = 1;
            set(handles.function2,'userdata',fileStruc);
            iteration =5;    
        end
    else
        iteration = 4;
    end
end
set(handles.function2,'userdata',fileStruc);



%____________________________________________
function [handles,iteration] = fifthIteration(hObject,handles,colwid)
% checks initial user choice (group or cell)
% if choice group, checks that input is an int number
%   if int, updates table with default new cell names
%   if int, prompt user to edit names
%   if names edited, makes new folders and prompts user for num cells next
%   group
%   if last group, make folders
% if choice cell, check that no names are blank
%   if not blank, create new folders
fileStruc =get(handles.function2,'userdata');
if fileStruc.optionState==1
    NGroups = fileStruc.NGroups;
    curGroup = fileStruc.curGroup;
    doPrompt = fileStruc.doPrompt;
    if doPrompt==1
        input = get(handles.userInput,'string');
        pause(0.01);
        if not(strcmp(input,''))
            num = str2double(input);
            if isnan(num)
                set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
                iteration = 5;  
            elseif round(num)<=0
                set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
                iteration = 5;
            else
                L = round(num);
                for i = 1:L
                   tabdata{i,1} = sprintf('Cell %02.0f',i); 
                end
                set(handles.table,'columnname',sprintf('%s Cells',fileStruc.Groups{curGroup}));
                set(handles.table,'data',tabdata);
                set(handles.table,'ColumnWidth',{colwid});
                set(handles.table,'ColumnEditable',true);
                set(handles.table,'enable','on');
                set(handles.prompt,'string','Please edit the Cell names in the table and click enter when done');
                set(handles.userInput,'enable','off');
                set(handles.userInput,'string','');
                fileStruc.doPrompt = 0;
                set(handles.function2,'userdata',fileStruc);
                iteration =5;    
            end
        else
            iteration = 5;
        end
    else
        button = get(hObject,'tag');
        if strcmp(button,'table')
            iteration = 5;
        else
            tabdata = get(handles.table,'data');
            flag = 0;
            for i = 1:length(tabdata)
               len = length(tabdata{i}); 
               if len==0
                   flag=1;
               end
            end
            if flag==1
                set(handles.prompt,'string','Error:  One or more Group names are blank.. Please try again');
                iteration = 5;
            else
                for i = 1:length(tabdata)
                    if isfield(fileStruc,'cellFolders')
                        L = length(fileStruc.cellFolders);
                    else
                        L=0;    
                    end
                    input = tabdata{i};
                    badvals = strfind(input,' ');
                    input(badvals) = '_';   
                    mkdir([fileStruc.GroupFolders{curGroup},handles.slash,input]); 
                    fileStruc.cellFolders{L+1} = [fileStruc.GroupFolders{curGroup},handles.slash,input]; 
                end
                loadListbox([],handles,[],fileStruc.GroupFolders{curGroup});
                if curGroup==NGroups
                    iteration=6;
                    set(handles.prompt,'string','Folders Have been created.  Please copy raw image files into the appropriate Raw Image Folders. Click any function/task to continue');
                    set(handles.enter,'enable','off');
                    set(handles.table','enable','off');
                    set(handles.userInput,'enable','off');
                    createGUIfolders(handles,fileStruc);
                else
                   fileStruc.curGroup=curGroup+1;
                   fileStruc.doPrompt=1;
                   iteration=5;
                   set(handles.userInput,'enable','on');
                   set(handles.userInput,'string','');
                   set(handles.prompt,'string',sprintf('Please Enter the number of Cells for Group: %s',fileStruc.Groups{fileStruc.curGroup}));
                   set(handles.table,'columnname','Cell Names');
                   set(handles.table,'data','');
                end
                set(handles.function2,'userdata',fileStruc);
            end
        end
    end
else
    button = get(hObject,'tag');
    if strcmp(button,'table')
        iteration = 5;
    else
        tabdata = get(handles.table,'data');
        flag = 0;
        for i = 1:length(tabdata)
           len = length(tabdata{i}); 
           if len==0
               flag=1;
           end
        end
        if flag==1
            set(handles.prompt,'string','Error:  One or more Cell names are blank.. Please try again');
            iteration = 5;
        else
            for i = 1:length(tabdata)
                input = tabdata{i};
                badvals = strfind(input,' ');
                input(badvals) = '_';   
                mkdir([fileStruc.GroupFolder,handles.slash,input]); 
                fileStruc.cellFolders{i} = [fileStruc.GroupFolder,handles.slash,input]; 
            end
            loadListbox([],handles,[],fileStruc.GroupFolder);
            createGUIfolders(handles,fileStruc);
            set(handles.function2,'userdata',fileStruc);
            set(handles.table,'enable','off');
            set(handles.table,'data','');
            set(handles.prompt,'string','Folders Have been created.  Please copy raw image files into the appropriate Raw Image Folders. Click any function/task to continue');
            set(handles.enter,'enable','off');
            set(handles.userInput,'enable','off');
            iteration = 6;
        end
    end
end

%______________________________
% makes folders under each cell Folder for future use
function createGUIfolders(handles,fileStruc)

L = length(fileStruc.cellFolders);
for i = 1:L
    mkdir([fileStruc.cellFolders{i},handles.slash,'Raw_Images']);
    mkdir([fileStruc.cellFolders{i},handles.slash,'Processed_Images']);
    mkdir([fileStruc.cellFolders{i},handles.slash,'Results']);
end