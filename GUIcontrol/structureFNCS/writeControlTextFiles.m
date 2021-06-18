function [] = writeControlTextFiles(controlState,data)

% this function outputs the controlState structre in a readable text file
% two files are written, one that contains which function is called for
% each unique set of control values
% the second files contains all the button state information for the the
% unique set

fid = fopen([data.controlDirec,data.filenameTXT1],'wt');
fprintf(fid,'%s| %s| %s| %s| %s| %15s| %20s|\n','t','f','p','o','so','Button Press','Call this function');
fprintf(fid,'------------------------------------------------------\n');

L = length(controlState.Tnum);
for i = 1:L
   t = controlState.Tnum(i);
   f = controlState.Fnum(i);
   p = controlState.Pnum(i);
   o = controlState.Onum(i);
   so = controlState.SOnum(i);
   button = controlState.Button{i};
   fnc = controlState.callFuncName{i};
   fprintf(fid,'%1d| %1d| %1d| %1d| %2d| %15s| %20s|\n',t,f,p,o,so,button,fnc);  
end

fclose(fid);

fid = fopen([data.controlDirec,data.filenameTXT2],'wt');
for i = 1:length(controlState.Tnum)
t=controlState.Tnum(i);
f=controlState.Fnum(i);
p=controlState.Pnum(i);
o=controlState.Onum(i);
so=controlState.SOnum(i);
button=controlState.Button{i};
fprintf(fid,'-----------------------------------\n');
fprintf(fid,'ControlID %1d%1d%1d%1d%1d\t%s\n-----------------------------------\n\n',t,f,p,o,so,button);
fprintf(fid,'Task info\n');
fprintf(fid,'Task1 Name: %s\n',controlState.task1name{i}); 
fprintf(fid,'Task2 Name: %s\n',controlState.task2name{i});
fprintf(fid,'Task3 Name: %s\n',controlState.task3name{i});
fprintf(fid,'Task4 Name: %s\n',controlState.task4name{i});
fprintf(fid,'Task5 Name: %s\n',controlState.task5name{i});
fprintf(fid,'Which Task: %d\n\n',controlState.whichtask(i));
fprintf(fid,'Function info\n');
fprintf(fid,'Function1 Name: %s\n',controlState.function1name{i});
fprintf(fid,'Function2 Name: %s\n',controlState.function2name{i});
fprintf(fid,'Function3 Name: %s\n',controlState.function3name{i});
fprintf(fid,'Function4 Name: %s\n',controlState.function4name{i});
fprintf(fid,'Function5 Name: %s\n',controlState.function5name{i});
fprintf(fid,'Function6 Name: %s\n',controlState.function6name{i});
fprintf(fid,'Function7 Name: %s\n',controlState.function7name{i});
fprintf(fid,'Function1 State: %s\n',controlState.function1state{i}); 
fprintf(fid,'Function2 State: %s\n',controlState.function2state{i});
fprintf(fid,'Function3 State: %s\n',controlState.function3state{i});
fprintf(fid,'Function4 State: %s\n',controlState.function4state{i});
fprintf(fid,'Function5 State: %s\n',controlState.function5state{i});
fprintf(fid,'Function6 State: %s\n',controlState.function6state{i});
fprintf(fid,'Function7 State: %s\n\n',controlState.function7state{i});
fprintf(fid,'Option info\n');
fprintf(fid,'Option1 Name: %s\n',controlState.option1name{i});
fprintf(fid,'Option2 Name: %s\n',controlState.option2name{i});
fprintf(fid,'Option3 Name: %s\n',controlState.option3name{i});
fprintf(fid,'Option4 Name: %s\n',controlState.option4name{i});
fprintf(fid,'Option1 State: %s\n',controlState.option1state{i});
fprintf(fid,'Option2 State: %s\n',controlState.option2state{i});
fprintf(fid,'Option3 State: %s\n',controlState.option3state{i});
fprintf(fid,'Option4 State: %s\n',controlState.option4state{i});
fprintf(fid,'Option1 Value: %s\n',controlState.option1value{i});
fprintf(fid,'Option2 Value: %s\n',controlState.option2value{i});
fprintf(fid,'Option3 Value: %s\n',controlState.option3value{i});
fprintf(fid,'Option4 Value: %s\n\n',controlState.option4value{i});
fprintf(fid,'Sub-Option info\n');
fprintf(fid,'subOption1 Name: %s\n',controlState.subOption1name{i});
fprintf(fid,'subOption2 Name: %s\n',controlState.subOption2name{i});
fprintf(fid,'subOption3 Name: %s\n',controlState.subOption3name{i});
fprintf(fid,'subOption4 Name: %s\n',controlState.subOption4name{i});
fprintf(fid,'subOption1 State: %s\n',controlState.subOption1state{i});
fprintf(fid,'subOption2 State: %s\n',controlState.subOption2state{i});
fprintf(fid,'subOption3 State: %s\n',controlState.subOption3state{i});
fprintf(fid,'subOption4 State: %s\n\n',controlState.subOption4state{i});
fprintf(fid,'Plabel info\n');
fprintf(fid,'plabel1 Name: %s\n',controlState.plabel1name{i});
fprintf(fid,'plabel2 Name: %s\n',controlState.plabel2name{i});
fprintf(fid,'plabel3 Name: %s\n',controlState.plabel3name{i});
fprintf(fid,'plabel4 Name: %s\n',controlState.plabel4name{i});
fprintf(fid,'plabel5 Name: %s\n\n',controlState.plabel5name{i});
fprintf(fid,'Parameter info\n');
fprintf(fid,'parameter1 Name: %s\n',controlState.parameter1name{i});
fprintf(fid,'parameter2 Name: %s\n',controlState.parameter2name{i});
fprintf(fid,'parameter3 Name: %s\n',controlState.parameter3name{i});
fprintf(fid,'parameter4 Name: %s\n',controlState.parameter4name{i});
fprintf(fid,'parameter5 Name: %s\n',controlState.parameter5name{i});
fprintf(fid,'parameter1 State: %s\n',controlState.parameter1state{i});
fprintf(fid,'parameter2 State: %s\n',controlState.parameter2state{i});
fprintf(fid,'parameter3 State: %s\n',controlState.parameter3state{i});
fprintf(fid,'parameter4 State: %s\n',controlState.parameter4state{i});
fprintf(fid,'parameter5 State: %s\n\n',controlState.parameter5state{i});
fprintf(fid,'Table info\n');
fprintf(fid,'table State: %s\n',controlState.tablestate{i});
fprintf(fid,'table Data: %s\n',controlState.tabledata{i});
fprintf(fid,'column name: %s\n',controlState.columnname{i});
fprintf(fid,'column width: %s\n\n',controlState.columnwidth{i});
fprintf(fid,'Other info\n');
fprintf(fid,'enter State: %s\n',controlState.enterstate{i});
fprintf(fid,'userInput State: %s\n',controlState.userinputstate{i});
fprintf(fid,'enter Name: %s\n',controlState.entername{i});
fprintf(fid,'userInput Name: %s\n',controlState.userinputname{i});
fprintf(fid,'iteration: %s\n',controlState.iteration{i});
fprintf(fid,'slider State: %s\n',controlState.sliderstate{i});
fprintf(fid,'prompt String: %s\n',controlState.promptstring{i});
fprintf(fid,'listbox State: %s\n',controlState.listboxstate{i});
fprintf(fid,'mainAxes State: %s\n',controlState.mainaxesstate{i});
fprintf(fid,'subAxes1 State: %s\n',controlState.subaxes1state{i});
fprintf(fid,'subAxes2 State: %s\n',controlState.subaxes2state{i});
fprintf(fid,'\n\n');
end

fclose(fid);