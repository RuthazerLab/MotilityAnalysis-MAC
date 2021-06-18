% updateMotGUIstruc.m
% this script updates a structure file that MotilityGUI will access every
% time a button is pressed
% the structure file contains 6 control variables along with:
% 1) the function that is called for each unique set of control variables
% 2) the button states for each unique set of control variables

clear all;
data.controlDirec = '/Users/Robert/Documents/GUI/GUIcontrol/';  % where the control structure file is  
data.filename = 'GUIcontrol.mat';  % name of the control structure file
data.filenameTXT1 = 'GUIfncs.txt';  % name of the control structure file in text form
data.filenameTXT2 = 'GUIbuttons.txt';  % name of the control structure file in text form

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control numbers/strings to be added/modified
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.Tnum = 2;   % task control variable
data.Fnum = 1;   % function control variable
data.Pnum = 0;   % page number control variable
data.Onum = 0;   % option number control variable
data.SOnum = 1;  % sub-option number control variable
data.Button = 'subOption1';   % button number control variable

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function that is called 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.callFuncName = 'loadRawImage';  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% task names/states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.task1name = 'DNC';
data.task2name = 'DNC';
data.task3name = 'DNC';
data.task4name = 'DNC';
data.whichtask = 2;  % 0 for no task, or integer for checked task

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function names/states 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.function1name = 'DNC';
data.function2name = 'DNC';
data.function3name = 'DNC';
data.function4name = 'DNC';
data.function5name = 'DNC';
data.function6name = 'DNC';
data.function7name = 'DNC';
data.function1state = 'DNC';
data.function2state = 'DNC';
data.function3state = 'DNC';
data.function4state = 'DNC';
data.function5state = 'DNC';
data.function6state = 'DNC';
data.function7state = 'DNC';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% option names/states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data.option1name = 'DNC';
data.option2name = 'DNC';
data.option3name = 'DNC';
data.option4name = 'DNC';
data.option1state = 'DNC';
data.option2state = 'DNC';
data.option3state = 'DNC';
data.option4state = 'DNC';
data.option1value = '0';
data.option2value = '0';
data.option3value = '0';
data.option4value = '0';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-option names/states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.subOption1name = 'DNC';
data.subOption2name = 'DNC';
data.subOption3name = 'DNC';
data.subOption4name = 'DNC';
data.subOption1state = 'DNC';
data.subOption2state = 'DNC';
data.subOption3state = 'DNC';
data.subOption4state = 'DNC';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plabel names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.plabel1name = '--';
data.plabel2name = '--';
data.plabel3name = '--';
data.plabel4name = '--';
data.plabel5name = '--';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameter names/states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.parameter1name = '--';
data.parameter2name = '--';
data.parameter3name = '--';
data.parameter4name = '--';
data.parameter5name = '--';
data.parameter1state = 'off';
data.parameter2state = 'off';
data.parameter3state = 'off';
data.parameter4state = 'off';
data.parameter5state = 'off';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.tablestate = 'DNC';
data.tabledata = 'DNC';
data.columnwidth = 'DNC';  % index of columnwidth definition in tableProps.mat.. set to DNC otherwise
data.columnname = 'DNC';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enter/user input state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.enterstate = 'DNC';
data.userinputstate = 'DNC';
data.entername = 'DNC';
data.userinputname = 'DNC';
data.iteration = 'DNC';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% slider state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.sliderstate = 'off';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prompt string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.promptstring = 'DNC';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% listbox state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.listboxstate = 'inactive';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% axes states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.mainaxesstate = 'DNC';
data.subaxes1state = 'BLANK';
data.subaxes2state = 'BLANK';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
controlState = updateControlData(data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
