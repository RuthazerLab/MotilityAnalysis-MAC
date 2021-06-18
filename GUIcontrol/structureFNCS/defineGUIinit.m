function controlState = defineGUIinit(data)

% this function will define the state of the GUI upon initialization

if exist([data.controlDirec,data.filename])
   load([data.controlDirec,data.filename]); 
end


controlState.Tnum(1) = 0;
controlState.Fnum(1) = 0;
controlState.Pnum(1) = 0;
controlState.Onum(1) = 0;
controlState.SOnum(1) = 0;
controlState.Button{1} = 'N/A';
controlState.callFuncName{1} = 'GUIinit'; 
%taskdata
controlState.task1name{1} = 'Define Cells';
controlState.task2name{1} = 'Process Images';
controlState.task3name{1} = 'Analysis';
controlState.task4name{1} = 'Results';
controlState.whichtask(1) = 0;  % 0 for no task, or integer for checked task
%functiondata
controlState.function1name{1} = '--';
controlState.function2name{1} = '--';
controlState.function3name{1} = '--';
controlState.function4name{1} = '--';
controlState.function5name{1} = '--';
controlState.function6name{1} = '--';
controlState.function7name{1} = '--';
controlState.function1state{1} = 'off';
controlState.function2state{1} = 'off';
controlState.function3state{1} = 'off';
controlState.function4state{1} = 'off';
controlState.function5state{1} = 'off';
controlState.function6state{1} = 'off';
controlState.function7state{1} = 'off';
%optiondata
controlState.option1name{1} ='--';
controlState.option2name{1} ='--';
controlState.option3name{1} ='--';
controlState.option4name{1} ='--';
controlState.option1state{1} ='off';
controlState.option2state{1} ='off';
controlState.option3state{1} ='off';
controlState.option4state{1} ='off';
controlState.option1value{1} = '0';
controlState.option2value{1} = '0';
controlState.option3value{1} = '0';
controlState.option4value{1} = '0';
%suboptiondata
controlState.subOption1name{1} = '--';
controlState.subOption2name{1} = '--';
controlState.subOption3name{1} = '--';
controlState.subOption4name{1} = '--';
controlState.subOption1state{1} = 'off';
controlState.subOption2state{1} = 'off';
controlState.subOption3state{1} = 'off';
controlState.subOption4state{1} = 'off';
%plabeldata
controlState.plabel1name{1}='';
controlState.plabel2name{1}='';
controlState.plabel3name{1}='';
controlState.plabel4name{1}='';
controlState.plabel5name{1}='';
%parameter data
controlState.parameter1name{1} = '';
controlState.parameter2name{1} = '';
controlState.parameter3name{1} = '';
controlState.parameter4name{1} = '';
controlState.parameter5name{1} = '';
controlState.parameter1state{1} = 'off';
controlState.parameter2state{1} = 'off';
controlState.parameter3state{1} = 'off';
controlState.parameter4state{1} = 'off';
controlState.parameter5state{1} = 'off';
%table data
controlState.tablestate{1} = 'off';
controlState.tabledata{1} = '';
controlState.columnwidth{1} = '1';  % index of columnwidth definition in tableProps.mat.. set to DNC otherwise
controlState.columnname{1} = 'Table Data';
%enter/userinput data
controlState.enterstate{1} ='off';
controlState.userinputstate{1} ='off';
controlState.entername{1} = 'enter';
controlState.userinputname{1} = '--';
controlState.iteration{1} = '0';
% slider data
controlState.sliderstate{1} = 'off';
% prompt data
controlState.promptstring{1} = 'Choose a task to begin';
% listbox data
controlState.listboxstate{1} = 'inactive';
% axes data
controlState.mainaxesstate{1} = 'BLANK';
controlState.subaxes1state{1} = 'BLANK';
controlState.subaxes2state{1} = 'BLANK';


save([data.controlDirec,data.filename],'controlState');
