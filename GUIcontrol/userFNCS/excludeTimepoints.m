function [] = excludeTimepoints(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');
imStruc = get(handles.task3,'userdata');
if strcmp(tag,'function2')
    set(handles.subOption1,'value',1);
    set(handles.subOption2,'value',1);
    set(handles.subOption3,'value',1);
    set(handles.subOption4,'value',1);
    set(handles.table,'enable','on');
    tabdat = imStruc.tlistTable;
    set(handles.table,'data',tabdat);
    load(handles.tableProps);
    set(handles.table,'columnwidth',{tableProps.width{15},tableProps.width{16}});
    set(handles.table,'columnname',{'Time (min)','State'});
elseif strcmp(tag,'table')
    tabdat = get(handles.table,'data');
    ind = eventdata.Indices;
    if ind(2)==2
       if strcmp(tabdat{ind(1),ind(2)},'on')
           tabdat{ind(1),ind(2)}='OFF';
       else
           tabdat{ind(1),ind(2)}='on';
       end
    end
    set(handles.table,'data',tabdat);
else
    tabdat = get(handles.table,'data');
    s = size(tabdat);
    for i = 1:s(1)
       if strcmp(tabdat(i,2),'on')
          timepointList(i) = 1; 
       else
          timepointList(i) = 0; 
       end
    end
    imStruc.tlistTable = tabdat;
    imStruc.timepointList = timepointList;
    [timeArea,timeDiffs,picArea,picDiffs,diffList] = sortIncludedPoints(timepointList,imStruc);
    if isnan(diffList)
       set(handles.prompt,'string','Cannot update timepoints, since you have tried to exclude all intervals!'); 
    else
    imStruc.diffList = diffList;
    imStruc.timeArea = timeArea;
    imStruc.timeDiffs = timeDiffs;
    imStruc.picArea = picArea;
    imStruc.picDiffs = picDiffs;
    imStruc.currentTime = timeDiffs(1);
    imStruc.currentIndex = 1;
    dirpath = [imStruc.pathB4,handles.slash,'Results'];
    save([dirpath,handles.slash,'timepointList.mat'],'timepointList');    
    if exist([dirpath,handles.slash,'DilationA'],'dir')
        rmdir([dirpath,handles.slash,'DilationA'],'s');
    end
    if exist([dirpath,handles.slash,'DilationB'],'dir')
        rmdir([dirpath,handles.slash,'DilationB'],'s');
    end
    set(handles.function4,'enable','off');
    set(handles.task3,'userdata',imStruc);
    set(handles.prompt,'string',sprintf('Timepoint List saved in %s.  Previously defined analysis folders have been deleted.',dirpath));
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
so = odata(2);
tdata.button = tdata.button;
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);
