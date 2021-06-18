% functionTemplate.m
% this script writes a template function file for easy integration into the
% GUI architechture

dirFuncs = '/Users/Robert/Documents/GUI/GUIcontrol/userFNCS/';

%%%%%%%%%%%%%%%%%
% function name
fname = 'BAtrend';  % study name, DON'T add extension, will be done automatically
%%%%%%%%%%%%%%%%%

if exist([dirFuncs,fname,'.m'])
    error('Function already exists!  Cannot create template');
else
fid = fopen([dirFuncs,fname,'.m'],'w');
fprintf(fid,'function [] = %s(hObject,handles,eventdata,extraData)\n',fname);
fprintf(fid,'\n\n');
fprintf(fid,'%% do function\n\n');
fprintf(fid,'%% define new control variables\n'); 
fprintf(fid,'tdata = get(handles.taskPanel,''userdata'');\n');
fprintf(fid,'fdata = get(handles.functionPanel,''userdata'');\n');
fprintf(fid,'odata = get(handles.optionPanel,''userdata'');\n');
fprintf(fid,'tdata.task = tdata.task;\n');  % default values
fprintf(fid,'f = fdata(1);\n');
fprintf(fid,'p = fdata(2);\n');
fprintf(fid,'o = odata(1);\n');
fprintf(fid,'so = odata(2);\n');
fprintf(fid,'tdata.button = tdata.button;\n');
fprintf(fid,'set(handles.taskPanel,''userdata'',tdata);\n');
fprintf(fid,'set(handles.functionPanel,''userdata'',[f,p]);\n');
fprintf(fid,'set(handles.optionPanel,''userdata'',[o,so]);\n');
fprintf(fid,'\n');
fprintf(fid,'%% update GUI\n');
fprintf(fid,'guidata(handles.figure1,handles);\n');
fclose(fid);
end