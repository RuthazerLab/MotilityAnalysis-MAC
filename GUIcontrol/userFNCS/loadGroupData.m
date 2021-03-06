function [] = loadGroupData(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');

if strcmp(tag,'function1')
    
    load([handles.rootDirectory,handles.slash,'projectHierarchy.mat']);
    set(handles.subOption1,'value',1);
    set(handles.subOption2,'value',1);
    set(handles.subOption3,'value',1);
    set(handles.subOption4,'value',1);
    loadListbox([],handles,[],handles.rootDirectory);
    set(handles.table,'enable','on');
    set(handles.prompt,'string','Navigate to the Group Folder you''d like to load using the table.');
    for i = 1:length(projectHierarchy)
       tabdata{i,1} = projectHierarchy(i).name; 
    end
    load(handles.tableProps);
    set(handles.table,'columnname',{'Project Name'});
    set(handles.table,'data',tabdata);
    set(handles.table,'columnwidth',{tableProps.width{1}});
    set(handles.table,'data',tabdata);
   
    set(handles.function1,'userdata','');
    set(handles.enter,'userdata',0);

elseif strcmp(tag,'table')
        doLoad = 0;
        load([handles.rootDirectory,handles.slash,'projectHierarchy.mat']);
        set(handles.prompt,'string','');
    	iteration=get(handles.enter,'userdata');
        groupInds = get(handles.function1,'userdata');
        if iteration==0
            ind = eventdata.Indices(1);
            groupInds.projInd = ind;
            groupInds.projName = extraData;
            set(handles.enter,'userdata',iteration+1);
            for i = 1:length(projectHierarchy(ind).group)
               tabdata{i,1} = projectHierarchy(ind).group(i).name; 
            end
            set(handles.table,'columnname','Group Name');
            set(handles.table,'data',tabdata);
        elseif iteration==1
            ind = eventdata.Indices(1);
            groupInds.groupInd = ind;
            groupInds.groupName = extraData;
            projName = [projectHierarchy(groupInds.projInd).name,handles.slash];
            groupName = [projectHierarchy(groupInds.projInd).group(groupInds.groupInd).name,handles.slash];
            Ncells = length(projectHierarchy(groupInds.projInd).group(groupInds.groupInd).cell);
            for i = 1:Ncells
                cellName = projectHierarchy(groupInds.projInd).group(groupInds.groupInd).cell(i).name;
                dirpath = [handles.rootDirectory,handles.slash,projName,groupName,cellName];
                testA(i) = exist([dirpath,handles.slash,'Results',handles.slash,'DilationA',handles.slash,'globalAnalysis.mat'],'file');    
                testB(i) = exist([dirpath,handles.slash,'Results',handles.slash,'DilationB',handles.slash,'globalAnalysis.mat'],'file');
            end
            testAsum = sum(testA);
            testBsum = sum(testB);
            if and(testAsum,testBsum)
                tabdata{1,1} = 'DilationA';
                tabdata{2,1} = 'DilationB';
                set(handles.table,'data',tabdata);
                set(handles.table,'columnname','Choose Dilation');
                set(handles.enter,'userdata', iteration+1);
            elseif testAsum
                tabdata{1,1} = 'DilationA';
                set(handles.table,'data',tabdata);
                set(handles.table,'columnname','Choose Dilation');
                set(handles.enter,'userdata', iteration+1);
            elseif testBsum
                tabdata{1,1} = 'DilationB';
                set(handles.table,'data',tabdata);
                set(handles.table,'columnname','Choose Dilation');
                set(handles.enter,'userdata', iteration+1);
            else
                set(handles.prompt,'string','Global analysis files missing!  Please first perform the analysis on this group and try again.');
                loadListbox([],handles,[],handles.rootDirectory);
                set(handles.table,'data','');
                set(handles.table,'columnname','Table Data');
            end
        else
            groupInds.dilation = extraData(end);
            doLoad=1;
        end
        set(handles.function1,'userdata',groupInds);
        if doLoad ==1
            dataCell = get(handles.task4,'userdata');
            groupStruc = dataCell{2};
            if strcmp(groupStruc,'')
               L=1;
            else
               L = length(groupStruc)+1; 
            end
            groupStruc(L).projName = groupInds.projName;
            groupStruc(L).groupName = groupInds.groupName;
            groupStruc(L).dilation = groupInds.dilation;
            dataCell{2} = groupStruc;
            set(handles.task4,'userdata',dataCell);
            handles = loadData(handles);
        end
    
end


% define new control variables
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
tdata.task = tdata.task;
f = fdata(1);
p = fdata(2);
o = 0;
so = 0;
tdata.button = tdata.button;
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);


%_________________________________________

function [handles] = loadData(handles)
    
handles = turnOFFbuttons(handles);
dataCell = get(handles.task4,'userdata');
cellStruc = dataCell{1};
groupStruc = dataCell{2};
tabledataCell = get(handles.table,'userdata');
table1 = tabledataCell{1};
table2 = tabledataCell{2};
groupInds = get(handles.function1,'userdata');
L = length(groupStruc);

if strcmp(cellStruc,'')
    L2=1;
else
    L2 = length(cellStruc)+1; 
end
groupStruc(L).cellStartInd = L2;
load([handles.rootDirectory,handles.slash,'projectHierarchy.mat']);
projName = [projectHierarchy(groupInds.projInd).name,handles.slash];
groupName = [projectHierarchy(groupInds.projInd).group(groupInds.groupInd).name,handles.slash];

Area = 0;
AreaF = 0;
SumRedist = 0;
SumRedistF = 0;
NSumRedist = 0;
NSumRedistF = 0;
BoxCar = 0;
BoxCarF = 0;

mArea = 0;
sArea = 0;
mAreaF = 0;
sAreaF = 0;
mSumRedist = 0;
sSumRedist = 0;
mSumRedistF = 0;
sSumRedistF = 0;
mNSumRedist = 0;
sNSumRedist = 0;
mNSumRedistF = 0;
sNSumRedistF = 0;
mBoxCar = 0;
sBoxCar = 0;
mBoxCarF = 0;
sBoxCarF = 0;
mConReg = 0;
sConReg = 0;
mConRegF = 0;
sConRegF = 0;
Ncells = 0;
firstDone = 0;
dirpath = [handles.rootDirectory,handles.slash,projName,groupName];
excludeList = {'.','..','.DS_Store'};
dirData = dir(dirpath);
dirIndex = [dirData.isdir];
dirList = {dirData(dirIndex).name};
validIndex = ~ismember(dirList,excludeList);
keepDirs = dirList(validIndex)';

for i = 1:length(keepDirs)    
    if strcmp(groupInds.dilation,'A')
        fp = [dirpath,handles.slash,keepDirs{i},handles.slash,'Results',handles.slash,'DilationA',handles.slash,'globalAnalysis.mat'];    
        if exist(fp,'file')
            load(fp);
            addEntry = 1;
        else
            addEntry = 0;
        end
    elseif strcmp(groupInds.dilation,'B')
        fp = [dirpath,handles.slash,keepDirs{i},handles.slash,'Results',handles.slash,'DilationB',handles.slash,'globalAnalysis.mat'];    
        if exist(fp,'file')
            load(fp);
            addEntry = 1;
        else
            addEntry = 0;
        end
    end
    if addEntry ==1
        cellStruc(L2).analysis = globalAnalysis;
        cellStruc(L2).projName = groupStruc(L).projName;
        cellStruc(L2).groupName = groupStruc(L).groupName;
        cellStruc(L2).cellName = keepDirs{i};
        cellStruc(L2).dilation = groupStruc(L).dilation;
        if L2==1
            table1{L2,1} = 'on';
        else
            table1{L2,1} = 'off';
        end
        table1{L2,2} = groupInds.dilation;
        table1{L2,3} = keepDirs{i};
        table1{L2,4} = groupName(1:end-1);
        table1{L2,5} = projName(1:end-1);
        L2 = L2+1;
        Ncells = Ncells+1;
        groupList{Ncells} = keepDirs{i};

        mArea(Ncells) = globalAnalysis.meanArea;
        mAreaF(Ncells) = globalAnalysis.meanAreaFiltered;
        mSumRedist(Ncells) = globalAnalysis.meanSumRedist;
        mSumRedistF(Ncells) = globalAnalysis.meanSumRedistFiltered;
        mNSumRedist(Ncells) = globalAnalysis.meanSumRedistNorm;
        mNSumRedistF(Ncells) = globalAnalysis.meanSumRedistNormFiltered;
        mBoxCar(Ncells) = globalAnalysis.meanBoxCar;
        mBoxCarF(Ncells) = globalAnalysis.meanBoxCarFiltered;
        mConReg(Ncells) = globalAnalysis.meanConnectedArea;
        mConRegF(Ncells) = globalAnalysis.meanConnectedAreaFiltered;
    end
end
tabledataCell{1} = table1;
groupStruc(L).groupList = groupList;
groupStruc(L).Ncells = Ncells;
groupStruc(L).mArea = mean(mArea);
groupStruc(L).sArea = std(mArea);
groupStruc(L).mAreaF = mean(mAreaF);
groupStruc(L).sAreaF = std(mAreaF);
groupStruc(L).mSumRedist = mean(mSumRedist);
groupStruc(L).sSumRedist = std(mSumRedist);
groupStruc(L).mSumRedistF = mean(mSumRedistF);
groupStruc(L).sSumRedistF = std(mSumRedistF);
groupStruc(L).mNSumRedist = mean(mNSumRedist);
groupStruc(L).sNSumRedist = std(mNSumRedist);
groupStruc(L).mNSumRedistF = mean(mNSumRedistF);
groupStruc(L).sNSumRedistF = std(mNSumRedistF);
groupStruc(L).mBoxCar = mean(mBoxCar);
groupStruc(L).sBoxCar = std(mBoxCar);
groupStruc(L).mBoxCarF = mean(mBoxCarF);
groupStruc(L).sBoxCarF = std(mBoxCarF);
groupStruc(L).mConReg = mean(mConReg);
groupStruc(L).sConReg = std(mConReg);
groupStruc(L).mConRegF = mean(mConRegF);
groupStruc(L).sConRegF = std(mConRegF);

loadListbox([],handles,[],dirpath);
dataCell{1} = cellStruc;
dataCell{2} = groupStruc;
set(handles.task4,'userdata',dataCell);   

set(handles.table,'enable','inactive');
set(handles.table,'columnname',{'Plot','Dil','Group','Project'});
load(handles.tableProps);
col1 = tableProps.width{11};
col2 = tableProps.width{12};
col3 = tableProps.width{13};
col4 = tableProps.width{14};
set(handles.table,'columnwidth',{col1,col2,col3,col4});

table2{L,1} = 'on';
table2{L,2} = groupInds.dilation;
table2{L,3} = groupName(1:end-1);
table2{L,4} = projName(1:end-1);
tabledataCell{2} = table2;
set(handles.table,'data',table2);
set(handles.table,'userdata',tabledataCell);
handles = turnONbuttons(handles);

function handles = turnOFFbuttons(handles)
set(handles.prompt,'string','Loading Data..');
pause(0.1);
set(handles.function1,'enable','off');
set(handles.function2,'enable','off');
set(handles.function3,'enable','off');
set(handles.function4,'enable','off');
set(handles.function5,'enable','off');
set(handles.function6,'enable','off');
set(handles.function7,'enable','off');

function handles = turnONbuttons(handles)
set(handles.prompt,'string','Data loaded, you may begin/resume using the plot functions.');
set(handles.function1,'enable','on');
set(handles.function2,'enable','on');
set(handles.function3,'enable','on');
set(handles.function4,'enable','on');
set(handles.function5,'enable','on');
set(handles.function6,'enable','off');
set(handles.function7,'enable','off');