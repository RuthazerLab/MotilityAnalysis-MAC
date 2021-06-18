function [] = initializeTask4(hObject,handles,eventdata,extraData)


% do function
    
set(handles.prompt,'string','Click Load Group Data to begin.');
set(handles.taskLock,'value',1);
set(handles.taskLock,'string','Tasks Locked');
set(handles.task1,'enable','off');
set(handles.task2,'enable','off');
set(handles.task3,'enable','off');
set(handles.task4,'enable','off');


set(handles.function1,'string','Load Group Data');
set(handles.function2,'string','Plot Results');
set(handles.function3,'string','Before/After Trend');
set(handles.function4,'string','New Text File');
set(handles.function5,'string','Open Text File');
set(handles.function6,'string','--');
set(handles.function7,'string','--');


set(handles.function1,'enable','on');
set(handles.function2,'enable','off');
set(handles.function3,'enable','off');
set(handles.function4,'enable','on');
set(handles.function5,'enable','on');
set(handles.function6,'enable','off');
set(handles.function7,'enable','off');


set(handles.option1,'enable','off');
set(handles.option2,'enable','off');
set(handles.option3,'enable','off');
set(handles.option4,'enable','off');
set(handles.subOption1,'enable','off');
set(handles.subOption2,'enable','off');
set(handles.subOption3,'enable','off');
set(handles.subOption4,'enable','off');

set(handles.option1,'string','--');
set(handles.option2,'string','--');
set(handles.option3,'string','--');
set(handles.option4,'string','--');
set(handles.subOption1,'string','--');
set(handles.subOption2,'string','--');
set(handles.subOption3,'string','--');
set(handles.subOption4,'string','--');

set(handles.option1,'value',0);
set(handles.option2,'value',0);
set(handles.option3,'value',0);
set(handles.option4,'value',0);
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);

set(handles.parameter1,'enable','off');
set(handles.parameter2,'enable','off');
set(handles.parameter3,'enable','off');
set(handles.parameter4,'enable','off');
set(handles.parameter5,'enable','off');

set(handles.plabel1,'string','--');
set(handles.plabel2,'string','--');
set(handles.plabel3,'string','--');
set(handles.plabel4,'string','--');
set(handles.plabel5,'string','--');

set(handles.parameter1,'string','--');
set(handles.parameter2,'string','--');
set(handles.parameter3,'string','--');
set(handles.parameter4,'string','--');
set(handles.parameter5,'string','--');

set(handles.slider,'enable','off');
set(handles.sliderClickL,'enable','off');
set(handles.sliderClickR,'enable','off');

handles = blankTheAxes(handles,1);
handles = blankTheAxes(handles,2);
handles = blankTheAxes(handles,3);

set(handles.enter,'enable','off');
set(handles.userInput,'enable','off');
set(handles.enter,'string','enter');
set(handles.userInput,'enable','off');

set(handles.table,'enable','off');
set(handles.table,'ColumnName',{'Table Data'});
set(handles.table,'data',{});


set(handles.listbox,'enable','inactive');

loadListbox(hObject,handles,eventdata,handles.rootDirectory);
set(handles.task4,'userdata',{'','',''});
set(handles.table,'userdata',{'',''});
set(handles.table,'data',{''});

% update project hierarchy 
set(handles.table,'enable','off');
excludeList = {'.','..','.DS_Store','ExportedResults','ExportedFigures','Processed_Images','Raw_Images'};
dirData = dir(handles.rootDirectory);
dirIndex = [dirData.isdir];
dirList = {dirData(dirIndex).name};
validIndex = ~ismember(dirList,excludeList);
projectNames = dirList(validIndex)';
for i = 1:length(projectNames)
    projectHierarchy(i).name = projectNames{i};
    dirData = dir([pwd,handles.slash,projectNames{i}]);
    dirIndex = [dirData.isdir];
    dirList = {dirData(dirIndex).name};
    validIndex = ~ismember(dirList,excludeList);
    names = dirList(validIndex)';
    for j = 1:length(names)
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
