function [] = loadListbox(hObject,handles,eventdata,extraData)

% this function loads the contents of the directory defined in extraData
% into the GUI listbox

% do function
dir_path = extraData;
cd (dir_path)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
is_dir = [dir_struct.isdir];
counter = 1;
for i = 1:length(sorted_names)
    if strcmp(sorted_names{i},'..')==1
        sorted_names_new{counter} = 'FOLDER CONTENTS:';
    elseif strcmp(sorted_names{i},'.')==1|strcmp(sorted_names{i},'.DS_Store')
        counter=counter-1;
    else
        sorted_names_new{counter} = sorted_names{i};
    end
    counter = counter+1;
end
sorted_index_new = sorted_index;
isdir_new = is_dir;
liststruct.file_names = sorted_names_new;
liststruct.is_dir = isdir_new;
liststruct.sorted_index = sorted_index_new;
set(handles.listbox,'userdata',liststruct);
set(handles.listbox,'String',liststruct.file_names,...
	'Value',1)
currentdir = sprintf('Current Directory: %s',pwd);
set(handles.figure1,'name',currentdir);

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
