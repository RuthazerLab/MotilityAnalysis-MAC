function [controlState] = sortStrucData(data)

% this function sorts the entries in data to be ordered like this:
% first sort t, then f, then p, then o, then so, then button


tN = data.Tnum;
fN = data.Fnum;
pN = data.Pnum;
oN = data.Onum;
soN = data.SOnum;
bN = data.Button;


counter = 1;

if length(tN)>1

    while length(tN)>0
        tNunique = unique(tN);
        t = tNunique(1);
        tempF = fN(tN==t);

        fNunique = unique(tempF);
        f = fNunique(1);
        tempP = pN(tN==t&fN==f);

        pNunique = unique(tempP);
        p = pNunique(1);
        tempO = oN(tN==t&fN==f&pN==p);

        oNunique = unique(tempO);
        o = oNunique(1);
        tempSO = soN(tN==t&fN==f&pN==p&oN==o);

        soNunique = unique(tempSO);
        so = soNunique(1);
        tempB = bN(tN==t&fN==f&pN==p&oN==o&soN==so);
        b = tempB{1};
        val = find(tN==t&fN==f&pN==p&oN==o&soN==so&strcmp(bN,b));

        controlState.Tnum(counter) = t;
        controlState.Fnum(counter) = f;
        controlState.Pnum(counter) = p;
        controlState.Onum(counter) = o;
        controlState.SOnum(counter) = so;
        controlState.Button{counter} = b;
        controlState.callFuncName{counter} = data.callFuncName{val};
        %taskdata
        controlState.task1name{counter} = data.task1name{val}; 
        controlState.task2name{counter}=data.task2name{val};
        controlState.task3name{counter}=data.task3name{val};
        controlState.task4name{counter}=data.task4name{val};
        controlState.task5name{counter}=data.task5name{val};
        controlState.whichtask(counter)=data.whichtask(val);
        %functiondata
        controlState.function1name{counter} = data.function1name{val};
        controlState.function2name{counter} = data.function2name{val};
        controlState.function3name{counter} = data.function3name{val};
        controlState.function4name{counter} = data.function4name{val};
        controlState.function5name{counter} = data.function5name{val};
        controlState.function6name{counter} = data.function6name{val};
        controlState.function7name{counter} = data.function7name{val};
        controlState.function1state{counter} = data.function1state{val}; 
        controlState.function2state{counter} = data.function2state{val};
        controlState.function3state{counter} = data.function3state{val};
        controlState.function4state{counter} = data.function4state{val};
        controlState.function5state{counter} = data.function5state{val};
        controlState.function6state{counter} = data.function6state{val};
        controlState.function7state{counter} = data.function7state{val};
        %optiondata
        controlState.option1name{counter} =data.option1name{val};
        controlState.option2name{counter} =data.option2name{val};
        controlState.option3name{counter} =data.option3name{val};
        controlState.option4name{counter} =data.option4name{val};
        controlState.option1state{counter} =data.option1state{val};
        controlState.option2state{counter} =data.option2state{val};
        controlState.option3state{counter} =data.option3state{val};
        controlState.option4state{counter} =data.option4state{val};
        controlState.option1value{counter} = data.option1value{val};
        controlState.option2value{counter} = data.option2value{val};
        controlState.option3value{counter} = data.option3value{val};
        controlState.option4value{counter} = data.option4value{val};
        %suboptiondata
        controlState.subOption1name{counter} = data.subOption1name{val};
        controlState.subOption2name{counter} = data.subOption2name{val};
        controlState.subOption3name{counter} = data.subOption3name{val};
        controlState.subOption4name{counter} = data.subOption4name{val};
        controlState.subOption1state{counter} = data.subOption1state{val};
        controlState.subOption2state{counter} = data.subOption2state{val};
        controlState.subOption3state{counter} = data.subOption3state{val};
        controlState.subOption4state{counter} = data.subOption4state{val};
        %plabeldata
        controlState.plabel1name{counter}=data.plabel1name{val};
        controlState.plabel2name{counter}=data.plabel2name{val};
        controlState.plabel3name{counter}=data.plabel3name{val};
        controlState.plabel4name{counter}=data.plabel4name{val};
        controlState.plabel5name{counter}=data.plabel5name{val};
        %parameter data
        controlState.parameter1name{counter} = data.parameter1name{val};
        controlState.parameter2name{counter} = data.parameter2name{val};
        controlState.parameter3name{counter} = data.parameter3name{val};
        controlState.parameter4name{counter} = data.parameter4name{val};
        controlState.parameter5name{counter} = data.parameter5name{val};
        controlState.parameter1state{counter} = data.parameter1state{val};
        controlState.parameter2state{counter} = data.parameter2state{val};
        controlState.parameter3state{counter} = data.parameter3state{val};
        controlState.parameter4state{counter} = data.parameter4state{val};
        controlState.parameter5state{counter} = data.parameter5state{val};
        %table data
        controlState.tablestate{counter} = data.tablestate{val};
        controlState.tabledata{counter} = data.tabledata{val};
        controlState.columnname{counter} = data.columnname{val};
        controlState.columnwidth{counter} = data.columnwidth{val};
        %enter/userinput data
        controlState.enterstate{counter} =data.enterstate{val};
        controlState.userinputstate{counter} =data.userinputstate{val};
        controlState.entername{counter} = data.entername{val};
        controlState.userinputname{counter} = data.userinputname{val};
        controlState.iteration{counter} = data.iteration{val};
        % slider data
        controlState.sliderstate{counter} = data.sliderstate{val};
        % prompt data
        controlState.promptstring{counter} = data.promptstring{val};
        % listbox data
        controlState.listboxstate{counter} = data.listboxstate{val};
        % axes data
        controlState.mainaxesstate{counter} = data.mainaxesstate{val};
        controlState.subaxes1state{counter} = data.subaxes1state{val};
        controlState.subaxes2state{counter} = data.subaxes2state{val};

        counter = counter+1;
        if length(tN)==1
            tN = ones(0);
        elseif val==1
            indarray = 2:length(tN);
        elseif val==length(tN)
            indarray = 1:length(tN)-1;
        else
            indarray = [1:val-1,val+1:length(tN)];
        end

        indarray = unique(indarray);
        if length(tN)>0
        tN = tN(indarray);
        fN = fN(indarray);
        pN = pN(indarray);
        oN = oN(indarray);
        soN = soN(indarray);
        bN = bN(indarray);
        data.callFuncName(indarray);
        data.callFuncName = data.callFuncName(indarray);
        %taskdata
        data.task1name = data.task1name(indarray); 
        data.task2name=data.task2name(indarray);
        data.task3name=data.task3name(indarray);
        data.task4name=data.task4name(indarray);
        data.whichtask=data.whichtask(indarray);
        %functiondata
        data.function1name = data.function1name(indarray);
        data.function2name = data.function2name(indarray);
        data.function3name = data.function3name(indarray);
        data.function4name = data.function4name(indarray);
        data.function5name = data.function5name(indarray);
        data.function6name = data.function6name(indarray);
        data.function7name = data.function7name(indarray);
        data.function1state = data.function1state(indarray); 
        data.function2state = data.function2state(indarray);
        data.function3state = data.function3state(indarray);
        data.function4state = data.function4state(indarray);
        data.function5state = data.function5state(indarray);
        data.function6state = data.function6state(indarray);
        data.function7state = data.function7state(indarray);
        %optiondata
        data.option1name =data.option1name(indarray);
        data.option2name =data.option2name(indarray);
        data.option3name =data.option3name(indarray);
        data.option4name =data.option4name(indarray);
        data.option1state =data.option1state(indarray);
        data.option2state =data.option2state(indarray);
        data.option3state =data.option3state(indarray);
        data.option4state =data.option4state(indarray);
        data.option1value = data.option1value(indarray);
        data.option2value = data.option2value(indarray);
        data.option3value = data.option3value(indarray);
        data.option4value = data.option4value(indarray);
        %suboptiondata
        data.subOption1name = data.subOption1name(indarray);
        data.subOption2name = data.subOption2name(indarray);
        data.subOption3name = data.subOption3name(indarray);
        data.subOption4name = data.subOption4name(indarray);
        data.subOption1state = data.subOption1state(indarray);
        data.subOption2state = data.subOption2state(indarray);
        data.subOption3state = data.subOption3state(indarray);
        data.subOption4state = data.subOption4state(indarray);
        %plabeldata
        data.plabel1name=data.plabel1name(indarray);
        data.plabel2name=data.plabel2name(indarray);
        data.plabel3name=data.plabel3name(indarray);
        data.plabel4name=data.plabel4name(indarray);
        data.plabel5name=data.plabel5name(indarray);
        %parameter data
        data.parameter1name = data.parameter1name(indarray);
        data.parameter2name = data.parameter2name(indarray);
        data.parameter3name = data.parameter3name(indarray);
        data.parameter4name = data.parameter4name(indarray);
        data.parameter5name = data.parameter5name(indarray);
        data.parameter1state = data.parameter1state(indarray);
        data.parameter2state = data.parameter2state(indarray);
        data.parameter3state = data.parameter3state(indarray);
        data.parameter4state = data.parameter4state(indarray);
        data.parameter5state = data.parameter5state(indarray);
        %table data
        data.tablestate = data.tablestate(indarray);
        data.tabledata = data.tabledata(indarray);
        data.columnname = data.columnname(indarray);
        data.columnwidth = data.columnwidth(indarray);
        %enter/userinput data
        data.enterstate =data.enterstate(indarray);
        data.userinputstate =data.userinputstate(indarray);
        data.entername = data.entername(indarray);
        data.userinputname = data.userinputname(indarray);
        data.iteration = data.iteration(indarray);
        % slider data
        data.sliderstate = data.sliderstate(indarray);
        % prompt data
        data.promptstring = data.promptstring(indarray);
        % listbox data
        data.listboxstate = data.listboxstate(indarray);
        % axes data
        data.mainaxesstate = data.mainaxesstate(indarray);
        data.subaxes1state = data.subaxes1state(indarray);
        data.subaxes2state = data.subaxes2state(indarray);
        end
    end
else
    controlState = data;
end
