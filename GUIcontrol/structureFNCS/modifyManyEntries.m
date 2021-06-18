% modifyManyEntries.m
% this script modifies multiple parameters from the controlState structure
% CAREFUL with this script.  Backup the controlState file before use in
% case of a blunder.


clear all;
data.controlDirec = '/Users/Robert/Documents/GUI/GUIcontrol/';  % where the control structure file is  
data.filename = 'GUIcontrol.mat';  % name of the control structure file
data.filenameTXT1 = 'GUIfncs.txt';  % name of the control structure file in text form
data.filenameTXT2 = 'GUIbuttons.txt';  % name of the control structure file in text form

% check file
if exist([data.controlDirec,data.filename])
   load([data.controlDirec,data.filename]); 
   L = length(controlState.Tnum);
   didntExist = 0;
else
   error('File does not exist');
   didntExist = 1;
end


%%
if didntExist==0
    % you can check the values before running the full script by 
    % first running the cells above and then runnning this cell
    % if the values look correct, run the full script
    
    vals =find(strcmp(controlState.callFuncName,'loadRawImage'));   % change this to any condition you want
    %%
    
    for i = 1:length(vals)
        controlState.subOption1name{vals(i)} = 'DNC';   % new value for all values with above condition
    end
    
% save  new structure
writeControlTextFiles(controlState,data);
save([data.controlDirec,data.filename],'controlState');    
end


    