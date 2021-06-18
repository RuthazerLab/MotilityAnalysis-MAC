function [controlState] = loadStrucData(controlState,data,val)

% this function sets the val entry of controlState to the values found in
% data

controlState.Tnum(val) = data.Tnum;
controlState.Fnum(val) = data.Fnum;
controlState.Pnum(val) = data.Pnum;
controlState.Onum(val) = data.Onum;
controlState.SOnum(val) = data.SOnum;
controlState.Button{val} = data.Button;
controlState.callFuncName{val} = data.callFuncName; 
%taskdata
controlState.task1name{val} = data.task1name; 
controlState.task2name{val}=data.task2name;
controlState.task3name{val}=data.task3name;
controlState.task4name{val}=data.task4name;
controlState.whichtask(val)=data.whichtask;
%functiondata
controlState.function1name{val} = data.function1name;
controlState.function2name{val} = data.function2name;
controlState.function3name{val} = data.function3name;
controlState.function4name{val} = data.function4name;
controlState.function5name{val} = data.function5name;
controlState.function6name{val} = data.function6name;
controlState.function7name{val} = data.function7name;
controlState.function1state{val} = data.function1state; 
controlState.function2state{val} = data.function2state;
controlState.function3state{val} = data.function3state;
controlState.function4state{val} = data.function4state;
controlState.function5state{val} = data.function5state;
controlState.function6state{val} = data.function6state;
controlState.function7state{val} = data.function7state;
%optiondata
controlState.option1name{val} =data.option1name;
controlState.option2name{val} =data.option2name;
controlState.option3name{val} =data.option3name;
controlState.option4name{val} =data.option4name;
controlState.option1state{val} =data.option1state;
controlState.option2state{val} =data.option2state;
controlState.option3state{val} =data.option3state;
controlState.option4state{val} =data.option4state;
controlState.option1value{val} = data.option1value;
controlState.option2value{val} = data.option2value;
controlState.option3value{val} = data.option3value;
controlState.option4value{val} = data.option4value;
%suboptiondata
controlState.subOption1name{val} = data.subOption1name;
controlState.subOption2name{val} = data.subOption2name;
controlState.subOption3name{val} = data.subOption3name;
controlState.subOption4name{val} = data.subOption4name;
controlState.subOption1state{val} = data.subOption1state;
controlState.subOption2state{val} = data.subOption2state;
controlState.subOption3state{val} = data.subOption3state;
controlState.subOption4state{val} = data.subOption4state;
%plabeldata
controlState.plabel1name{val}=data.plabel1name;
controlState.plabel2name{val}=data.plabel2name;
controlState.plabel3name{val}=data.plabel3name;
controlState.plabel4name{val}=data.plabel4name;
controlState.plabel5name{val}=data.plabel5name;
%parameter data
controlState.parameter1name{val} = data.parameter1name;
controlState.parameter2name{val} = data.parameter2name;
controlState.parameter3name{val} = data.parameter3name;
controlState.parameter4name{val} = data.parameter4name;
controlState.parameter5name{val} = data.parameter5name;
controlState.parameter1state{val} = data.parameter1state;
controlState.parameter2state{val} = data.parameter2state;
controlState.parameter3state{val} = data.parameter3state;
controlState.parameter4state{val} = data.parameter4state;
controlState.parameter5state{val} = data.parameter5state;
%table data
controlState.tablestate{val} = data.tablestate;
controlState.tabledata{val} = data.tabledata;
controlState.columnname{val} = data.columnname;
controlState.columnwidth{val} = data.columnwidth;
%enter/userinput data
controlState.enterstate{val} =data.enterstate;
controlState.userinputstate{val} =data.userinputstate;
controlState.entername{val} = data.entername;
controlState.userinputname{val} = data.userinputname;
controlState.iteration{val} = data.iteration;
% slider data
controlState.sliderstate{val} = data.sliderstate;
% prompt data
controlState.promptstring{val} = data.promptstring;
% listbox data
controlState.listboxstate{val} = data.listboxstate;
% axes data
controlState.mainaxesstate{val} = data.mainaxesstate;
controlState.subaxes1state{val} = data.subaxes1state;
controlState.subaxes2state{val} = data.subaxes2state;
