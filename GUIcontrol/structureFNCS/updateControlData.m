function [controlState] = updateControlData(data)

% this function updates the controlState structure
% if there are no exisiting entries, ie. if the file doesn't exist, it
% creates the file
% otherwise, it adds 1 entry to the structure and then sorts the entries
% in a logical way
% the information in the structure is then printed to text files for
% readability


if exist([data.controlDirec,data.filename])
   load([data.controlDirec,data.filename]); 
   L = length(controlState.Tnum);
   didntExist = 0;
else
   warning('File was not existant.  A file has been created, but only contains the most recent update.');
   L = 1;
   didntExist = 1;
   controlState = defineGUIinit(data);
end

tnumzero = 0;
if data.Tnum==0
    warning('Tnum=0 has a pre-determined function, and so a unique entry could not be made');
    tnumzero = 1;
end



val = find(controlState.Tnum==data.Tnum&controlState.Fnum==data.Fnum...
    &controlState.Pnum==data.Pnum&controlState.Onum==data.Onum...
    &controlState.SOnum==data.SOnum&strcmp(controlState.Button,data.Button));

if tnumzero~=1
    
    if length(val)==1
        controlState = loadStrucData(controlState,data,val);
    else
        controlState = loadStrucData(controlState,data,L+1);
    end
end
tempdata = controlState;
controlState = sortStrucData(tempdata);
writeControlTextFiles(controlState,data);
save([data.controlDirec,data.filename],'controlState');