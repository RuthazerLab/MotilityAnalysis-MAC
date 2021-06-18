% modifySingleEntry.m
% this script modifies a single parameter from the controlState structure

clear all;
data.controlDirec = '/Users/Robert/Documents/GUI/GUIcontrol/';  % where the control structure file is  
data.filename = 'GUIcontrol.mat';  % name of the control structure file
data.filenameTXT1 = 'GUIfncs.txt';  % name of the control structure file in text form
data.filenameTXT2 = 'GUIbuttons.txt';  % name of the control structure file in text form

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control numbers/strings to be added/modified
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Tnum = 1;   % task control variable
Fnum = 5;   % function control variable
Pnum = 0;   % page number control variable
Onum = 0;   % option number control variable
SOnum = 0;  % sub-option number control variable
Button = 'function5';   % button number control variable
whichfield = 'tablestate';  % which field you would like to modify
newfield = 'DNC';

if exist([data.controlDirec,data.filename])
   load([data.controlDirec,data.filename]); 
   L = length(controlState.Tnum);
   didntExist = 0;
else
   error('File does not exist');
   didntExist = 1;
end

tnumzero = 0;
if Tnum==0
    error('Tnum=0 has a pre-determined function, cannot modify this field'); 
    tnumzero=1;
end

allowedfield = 1;
if strcmp(whichfield,'Tnum')||strcmp(whichfield,'Fnum')||strcmp(whichfield,'Pnum')||...
        strcmp(whichfield,'Onum')||strcmp(whichfield,'SOnum')||strcmp(whichfield,'Button')
    tempstruc = controlState;
    tempstruc = setfield(controlState,whichfield,newfield);
    val = controlState.Tnum==tempstruc.Tnum&controlState.Fnum==tempstruc.Fnum...
        &controlState.Pnum==tempstruc.Pnum&controlState.Onum==tempstruc.Onum...
        &controlState.SOnum==tempstruc.SOnum&strcmp(controlState.Button,tempstruc.Button)
    if sum(val)==1
        allowedfield = 0;
        error(sprintf('Cannot modify %s, since the new %s and the remaining control values map to an already existing entry.',whichfield,whichfield));
    end
end

if didntExist==0&&tnumzero==0&&allowedfield==1
   val = controlState.Tnum==Tnum&controlState.Fnum==Fnum&controlState.Pnum==Pnum...
    &controlState.Onum==Onum&controlState.SOnum==SOnum&strcmp(controlState.Button,Button);
   if sum(val)==0
       error('The 6 control parameters you have defined are unique.. Cannot modify this line since it does not yet exist');
   else
       checkfield = isfield(controlState,whichfield);
       if checkfield==0
           error(sprintf('There is no field in the controlStructure called %s',whichfield));
       else
           newentry = getfield(controlState,whichfield);
           fieldclass = class(newentry(1));
           if strcmp(fieldclass,'double')
               if strcmp(class(newfield),'double')
                newentry(val) = newfield;
               else
                error(sprintf('Cannnot change field, since the %s field must be a double precision number.',whichfield));
               end
           else
            newentry{val} = newfield;   
           end
           controlState = setfield(controlState,whichfield,newentry);
           writeControlTextFiles(controlState,data);
           save([data.controlDirec,data.filename],'controlState');
       end
   end
end