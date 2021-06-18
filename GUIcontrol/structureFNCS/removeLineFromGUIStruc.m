% removeLineFromGUIStruc.m
% this script removes a line from the MotilityGUI structure file

clear all;
data.controlDirec = '/Users/Robert/Documents/GUI/GUIcontrol/';  % where the control structure file is  
data.filename = 'GUIcontrol.mat';  % name of the control structure file
data.filenameTXT1 = 'GUIfncs.txt';  % name of the control structure file in text form
data.filenameTXT2 = 'GUIbuttons.txt';  % name of the control structure file in text form

%%%% Control file numbers to be removed %%%%%

Tnum = 4;   % task control variable
Fnum = 1;   % function control variable
Pnum = 0;   % page number control variable
Onum = 0;   % option number control variable
SOnum =0;  % sub-option number control variable
Button = 'function1';   % button number control variable
callFuncName = 'loadCellData';  % function that is called when the control variables have the above vals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    error('Tnum=0 has a pre-determined function, cannot remove this line'); 
    tnumzero = 1;
end

if tnumzero==0&&didntExist==0
val = controlState.Tnum==Tnum&controlState.Fnum==Fnum&controlState.Pnum==Pnum...
    &controlState.Onum==Onum&controlState.SOnum==SOnum&strcmp(controlState.Button,Button);

if sum(val)==0
    error('The 6 control parameters you have defined are unique.. Cannot remove this line since it does not yet exist');
else
    controlState.Tnum = controlState.Tnum(not(val));
    controlState.Fnum = controlState.Fnum(not(val));
    controlState.Pnum = controlState.Pnum(not(val));
    controlState.Onum = controlState.Onum(not(val));
    controlState.SOnum = controlState.SOnum(not(val));
    controlState.Button = controlState.Button(not(val));    
    controlState.callFuncName = controlState.callFuncName(not(val)); 
    %taskdata
    controlState.task1name = controlState.task1name(not(val)); 
    controlState.task2name = controlState.task2name(not(val));
    controlState.task3name = controlState.task3name(not(val));
    controlState.task4name = controlState.task4name(not(val));
    controlState.task5name = controlState.task5name(not(val));
    controlState.whichtask = controlState.whichtask(not(val));
    %functiondata
    controlState.function1name = controlState.function1name(not(val));
    controlState.function2name = controlState.function2name(not(val));
    controlState.function3name = controlState.function3name(not(val));
    controlState.function4name = controlState.function4name(not(val));
    controlState.function5name = controlState.function5name(not(val));
    controlState.function6name = controlState.function6name(not(val));
    controlState.function7name = controlState.function7name(not(val));
    controlState.function1state = controlState.function1state(not(val)); 
    controlState.function2state = controlState.function2state(not(val));
    controlState.function3state = controlState.function3state(not(val));
    controlState.function4state = controlState.function4state(not(val));
    controlState.function5state = controlState.function5state(not(val));
    controlState.function6state = controlState.function6state(not(val));
    controlState.function7state = controlState.function7state(not(val));
    %optiondata
    controlState.option1name = controlState.option1name(not(val));
    controlState.option2name = controlState.option2name(not(val));
    controlState.option3name = controlState.option3name(not(val));
    controlState.option4name = controlState.option4name(not(val));
    controlState.option1state = controlState.option1state(not(val));
    controlState.option2state = controlState.option2state(not(val));
    controlState.option3state = controlState.option3state(not(val));
    controlState.option4state = controlState.option4state(not(val));
    %suboptiondata
    controlState.subOption1name = controlState.subOption1name(not(val));
    controlState.subOption2name = controlState.subOption2name(not(val));
    controlState.subOption3name = controlState.subOption3name(not(val));
    controlState.subOption4name = controlState.subOption4name(not(val));
    controlState.subOption1state = controlState.subOption1state(not(val));
    controlState.subOption2state = controlState.subOption2state(not(val));
    controlState.subOption3state = controlState.subOption3state(not(val));
    controlState.subOption4state = controlState.subOption4state(not(val));
    %plabeldata
    controlState.plabel1name= controlState.plabel1name(not(val));
    controlState.plabel2name= controlState.plabel2name(not(val));
    controlState.plabel3name= controlState.plabel3name(not(val));
    controlState.plabel4name= controlState.plabel4name(not(val));
    controlState.plabel5name= controlState.plabel5name(not(val));
    %parameter data
    controlState.parameter1name = controlState.parameter1name(not(val));
    controlState.parameter2name = controlState.parameter2name(not(val));
    controlState.parameter3name = controlState.parameter3name(not(val));
    controlState.parameter4name = controlState.parameter4name(not(val));
    controlState.parameter5name = controlState.parameter5name(not(val));
    controlState.parameter1state = controlState.parameter1state(not(val));
    controlState.parameter2state = controlState.parameter2state(not(val));
    controlState.parameter3state = controlState.parameter3state(not(val));
    controlState.parameter4state = controlState.parameter4state(not(val));
    controlState.parameter5state = controlState.parameter5state(not(val));
    %table data
    controlState.tablestate = controlState.tablestate(not(val));
    controlState.tabledata = controlState.tabledata(not(val));
    controlState.columnwidth = controlState.columnwidth(not(val));
	controlState.columnname = controlState.columnname(not(val));
    %enter/userinput data
    controlState.enterstate =controlState.enterstate(not(val));
    controlState.userinputstate = controlState.userinputstate(not(val));
    controlState.entername = controlState.entername(not(val));
    controlState.userinputname = controlState.userinputname(not(val));
    controlState.iteration = controlState.iteration(not(val));
    % slider data
    controlState.sliderstate = controlState.sliderstate(not(val));
    % prompt data
    controlState.promptstring = controlState.promptstring(not(val));
    % listbox data
    controlState.listboxstate = controlState.listboxstate(not(val));
    % axes data
    controlState.mainaxesstate = controlState.mainaxesstate(not(val));
    controlState.subaxes1state = controlState.subaxes1state(not(val));
    controlState.subaxes2state = controlState.subaxes2state(not(val));

end
    
tempdata = controlState;
controlState = sortStrucData(tempdata);
writeControlTextFiles(controlState,data);
save([data.controlDirec,data.filename],'controlState');
end