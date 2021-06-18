function [] = createStudy(hObject,handles,eventdata,extraData)

% this function creates the project folder hierarchy for a new set of
% experiments.. the user is prompted with the number of groups and cells to
% be added

% the data structure fileStruc is saved in the userdata of function1 and is
% accessed by the functions below..

% do function
load(handles.tableProps);
colwid = tableProps.width{1};
button = get(hObject,'tag');
if not(strcmp(button,'table'))
    iteration = get(handles.enter,'userdata'); % which iteration of the function 
    if iteration==0
        iteration = iteration+1;
        set(handles.enter,'userdata',iteration);
        set(handles.function1,'userdata','');
        set(handles.enter,'enable','on');
        loadListbox([],handles,[],handles.rootDirectory);
    elseif iteration==1
        [handles,iteration] = firstIteration(handles);               %defined below
        set(handles.enter,'userdata',iteration);
    elseif iteration==2
        [handles,iteration] = secondIteration(handles,colwid);              %defined below
        set(handles.enter,'userdata',iteration);
    elseif iteration==3
        [handles,iteration] = thirdIteration(handles);               %defined below
        set(handles.enter,'userdata',iteration);
    elseif iteration==4
        [handles,iteration] = fourthIteration(handles,colwid);              %defined below
        set(handles.enter,'userdata',iteration);
    end
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

%_____________________________________
function [handles,iteration] = firstIteration(handles)
% check that the new project name is not blank
% if not blank, prompt user for the number of groups
input = get(handles.userInput,'string');
if strcmp(input,'')||isempty(input)
    set(handles.prompt,'string','Error: Input cannot be blank, please try again');
    iteration = 1;
elseif isdir([handles.rootDirectory,handles.slash,input])
    set(handles.prompt,'string','Error: Directory already exists, please try again');
    iteration=1;  
else
    set(handles.prompt,'string','Please Enter the Number of Groups for this Project');
    badvals = strfind(input,' ');
    input(badvals) = '_';
    mkdir([handles.rootDirectory,handles.slash,input]);
    fileStruc.projectFolder = [handles.rootDirectory,handles.slash,input];
    loadListbox([],handles,[],fileStruc.projectFolder);
    set(handles.userInput,'string','');
    set(handles.function1,'userdata',fileStruc);
    iteration =2;
end

%___________________________________
function [handles,iteration] = secondIteration(handles,colwid)
% check that input is an integer number
% if an int, then update table with default group names
% prompt user to change names
input = get(handles.userInput,'string');
if not(strcmp(input,''))
    pause(0.01);
    num = str2double(input);
    if isnan(num)
        set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
        iteration = 2;  
    elseif round(num)<=0
        set(handles.prompt,'string','Error: Input must be a positive integer number, please try again');
        iteration = 2;
    else
        L = round(num);
        for i = 1:L
           tabdata{i,1} = sprintf('Group %02.0f',i); 
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
        iteration =3;   
    end
else
    iteration = 2;
end

%__________________________
function [handles,iteration] = thirdIteration(handles)
% checks that groups names aren't blank
% if not blank, reads in group names and makes directories
% if not blank, prompts user for number of cells for 1st group
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
    iteration = 3;
else
    fileStruc = get(handles.function1,'userdata');
    for i = 1:length(tabdata)
        input = tabdata{i};
        badvals = strfind(input,' ');
        input(badvals) = '_';    
        mkdir([fileStruc.projectFolder,handles.slash,input]); 
        fileStruc.groupFolders{i} = [fileStruc.projectFolder,handles.slash,input]; 
        fileStruc.groups{i} = input;
    end
    loadListbox([],handles,[],fileStruc.projectFolder);
    fileStruc.Ngroups = length(tabdata);
    fileStruc.curGroup = 1;
    fileStruc.doPrompt = 1;
    set(handles.function1,'userdata',fileStruc);
    set(handles.prompt,'string',sprintf('Please Enter the number of Cells for Group: %s',tabdata{1}));
    set(handles.table,'data','');
    set(handles.table,'columnname','Cell Names');
    set(handles.userInput,'enable','on');
    set(handles.userInput,'string','');
    iteration = 4;
end


%___________________________________
function [handles,iteration] = fourthIteration(handles,colwid)
% checks that the number of cells is an integer number
% if int, updates table with default cell names
% prompts user to edit names
% when user is done editing names, prompts user for number of cells for
% next group
% repeats this until all groups have cells defined
% when the last group has been defined, GUI folders are created and the
% function is terminates

fileStruc =get(handles.function1,'userdata');
Ngroups = fileStruc.Ngroups;
curGroup = fileStruc.curGroup;
doPrompt = fileStruc.doPrompt;

if doPrompt==1
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
            for i = 1:L
               tabdata{i,1} = sprintf('Cell %02.0f',i); 
            end
            set(handles.table,'columnname',sprintf('%s Cells',fileStruc.groups{curGroup}));
            set(handles.table,'data',tabdata);
            set(handles.table,'ColumnWidth',{colwid});
            set(handles.table,'ColumnEditable',true);
            set(handles.table,'enable','on');
            set(handles.prompt,'string','Please edit the Cell names in the table and click enter when done');
            set(handles.userInput,'enable','off');
            set(handles.userInput,'string','');
            fileStruc.doPrompt = 0;
            set(handles.function1,'userdata',fileStruc);
            iteration =4;    
        end
    else
        iteration = 4;
    end
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
        iteration = 4;
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
            mkdir([fileStruc.groupFolders{curGroup},handles.slash,input]); 
            fileStruc.cellFolders{L+1} = [fileStruc.groupFolders{curGroup},handles.slash,input]; 
        end
        loadListbox([],handles,[],fileStruc.groupFolders{curGroup});
        if curGroup==Ngroups
            iteration=5;
            set(handles.prompt,'string','Folders Have been created.  Please copy raw image files into the appropriate Raw Image Folders. Click any function/task to continue');
            set(handles.enter,'enable','off');
            set(handles.table','enable','off');
            set(handles.userInput,'enable','off');
            createGUIfolders(handles,fileStruc);
        else
           fileStruc.curGroup=curGroup+1;
           fileStruc.doPrompt=1;
           iteration=4;
           set(handles.userInput,'enable','on');
           set(handles.userInput,'string','');
           set(handles.prompt,'string',sprintf('Please Enter the number of Cells for Cell Type: %s',fileStruc.groups{fileStruc.curGroup}));
           set(handles.table,'columnname','Cell Names');
           set(handles.table,'data','');
        end
        set(handles.function1,'userdata',fileStruc);
    end
end

%____________________________________________
function createGUIfolders(handles,fileStruc)
% makes folders under each cell Folder for future use
L = length(fileStruc.cellFolders);
for i = 1:L
    mkdir([fileStruc.cellFolders{i},handles.slash,'Raw_Images']);
    mkdir([fileStruc.cellFolders{i},handles.slash,'Processed_Images']);
    mkdir([fileStruc.cellFolders{i},handles.slash,'Results']);
end