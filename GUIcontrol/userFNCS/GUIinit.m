function [] = GUIinit(hObject,handles,eventdata,extraData)


% do function
set(handles.prompt,'string','Choose a task to begin.');
set(handles.taskLock,'value',0);
set(handles.taskLock,'string','Tasks Unlocked');

set(handles.task1,'string','Define Cells');
set(handles.task2,'string','Process Images');
set(handles.task3,'string','Analysis');
set(handles.task4,'string','Results');


set(handles.task1,'enable','on');
set(handles.task2,'enable','on');
set(handles.task3,'enable','on');
set(handles.task4,'enable','on');

set(handles.function1,'string','--');
set(handles.function2,'string','--');
set(handles.function3,'string','--');
set(handles.function4,'string','--');
set(handles.function5,'string','--');
set(handles.function6,'string','--');
set(handles.function7,'string','--');

set(handles.function1,'enable','off');
set(handles.function2,'enable','off');
set(handles.function3,'enable','off');
set(handles.function4,'enable','off');
set(handles.function5,'enable','off');
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

set(handles.table,'enable','off');
set(handles.listbox,'enable','inactive');

loadListbox(hObject,handles,eventdata,handles.rootDirectory);
set(handles.task3,'userdata','');

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
