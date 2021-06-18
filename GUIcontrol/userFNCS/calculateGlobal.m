function [] = calculateGlobal(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');
imStruc = get(handles.task3,'userdata');
if strcmp(tag,'function5')
   handles = initializeALL(handles);
elseif strcmp(tag,'parameter1')
    num = str2double(get(handles.parameter1,'string'));
    if isnan(num)==1
        set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentTime));
    else
        handles = updateParameters(handles,num,1);
    end
elseif strcmp(tag,'parameter2')
    num = str2double(get(handles.parameter2,'string'));
    if isnan(num)==1
        set(handles.parameter2,'string',sprintf('%0.0f',imStruc.currentBoxcar));
    else
        handles = updateParameters(handles,num,2);
    end
elseif strcmp(tag,'slider')
    handles = move_slider(handles,1);
elseif strcmp(tag,'sliderClickR')
    handles = move_slider(handles,2);
elseif strcmp(tag,'sliderClickL')
    handles = move_slider(handles,3);
elseif strcmp(tag,'subOption1')
    sliderMenu = get(handles.subOption1,'value');
    if sliderMenu==1
        maxS = length(imStruc.timeDiffs);
        minS = 1;
        if maxS==minS
            set(handles.slider,'max',10);
            set(handles.slider,'min',0);
            set(handles.slider,'value',1);    
            set(handles.slider,'sliderstep',[0.01 0.01]); 
            set(handles.slider,'enable','off');
            set(handles.sliderClickL,'enable','off');
            set(handles.sliderClickR,'enable','off');
            imStruc.sliderOn = 0;
        else
            set(handles.slider,'enable','on');
            set(handles.sliderClickL,'enable','on');
            set(handles.sliderClickR,'enable','on');
            imStruc.sliderOn = 1;
            time = imStruc.currentIndex;
            set(handles.slider,'max',maxS);
            set(handles.slider,'min',minS);
            set(handles.slider,'value',time);    
            set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);     
        end
    elseif sliderMenu==2
        set(handles.slider,'enable','on');
        set(handles.sliderClickL,'enable','on');
        set(handles.sliderClickR,'enable','on');
        imStruc.sliderOn = 1;
        maxS = min(imStruc.sizePic);
        minS = 0;
        boxcar = str2double(get(handles.parameter2,'string'));
        set(handles.slider,'max',maxS+1);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',boxcar);
        set(handles.slider,'sliderstep',[2/(maxS-minS) 6/(maxS-minS)]);
    end
    set(handles.task3,'userdata',imStruc);
elseif strcmp(tag,'subOption2')
    val = get(handles.subOption2,'value');
    if val==2
        set(handles.subOption1,'string',{'Slider-Time Interval','Slider-Boxcar'});
        set(handles.parameter2,'enable','on');
    else
        set(handles.subOption1,'string',{'Slider-Time Interval'});
        set(handles.subOption1,'value',1);
        set(handles.parameter2,'enable','off');
        maxS = length(imStruc.timeDiffs);
        minS = 1;
        if maxS==minS
            maxS = 10;
            minS = 0;
            set(handles.slider,'max',maxS);
            set(handles.slider,'min',minS);
            set(handles.slider,'value',1);    
            set(handles.slider,'sliderstep',[0.01 0.01]);
            imStruc.sliderOn=0;
        else
            time = imStruc.currentIndex;
            set(handles.slider,'max',maxS);
            set(handles.slider,'min',minS);
            set(handles.slider,'value',time);    
            set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
            imStruc.sliderOn=1;
        end
    end
    set(handles.task3,'userdata',imStruc);
    handles = updateAxes(handles);
elseif strcmp(tag,'subOption3')
    val = get(handles.subOption3,'value');
    if val==1
        imStruc.filtON=0;
    else
        imStruc.filtON=1;
    end
    set(handles.task3,'userdata',imStruc);
    handles = updateAxes(handles);
elseif strcmp(tag,'option1')
    handles = turnOFFfuncButtons(handles);
    handles = calculateQuantities(handles);
    dirpath=writeOutput(handles);
    handles = turnONfuncButtons(handles);
    set(handles.prompt,'string',sprintf('Results saved in %s',dirpath));
end
% define new control variables
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
tdata.task = tdata.task;
f = fdata(1);
p = fdata(2);
o = 0;
so = 0;
tdata.button = tdata.button;
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);

%___________________________________________________
function [handles] = initializeALL(handles)

imStruc = get(handles.task3,'userdata');
dirpath = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter',handles.slash,'filter.png'];
if exist(dirpath,'file')
    imStruc.filterDefined=1;
    filt = double(imread(dirpath));
    imStruc.filterPIC = filt;
    set(handles.subOption3,'enable','on');
    set(handles.subOption3,'string',{'Filter-Off','Filter-On'});
else
    imStruc.filterDefined=0;
    set(handles.subOption3,'enable','inactive');
    set(handles.subOption3,'string',{'No Filter'});
end
dirpath = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter',handles.slash,'freqInfo.mat'];
if exist(dirpath,'file')    
    imStruc.pixFreqDefined=1;
else
    imStruc.pixFreqDefined=0; 
end
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);
set(handles.parameter2,'enable','off');
set(handles.subOption1,'string',{'Slider-Time Interval'});
set(handles.subOption2,'string',{'Main-Redistribution','Main-Boxcared','Main-Connected'});
set(handles.subOption4,'string',{'--'});
if imStruc.filtON==0
    set(handles.subOption3,'value',1);
else
    set(handles.subOption3,'value',1);
end
imStruc.currentBoxcar = 9;
set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentTime));
set(handles.parameter2,'string',sprintf('%0.0f',imStruc.currentBoxcar));
maxS = length(imStruc.timeDiffs);
minS = 1;
if maxS~=minS
    time = imStruc.currentIndex;
    set(handles.slider,'max',maxS);
    set(handles.slider,'min',minS);
    set(handles.slider,'value',time);    
    set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
    imStruc.sliderOn = 1;
else
    set(handles.slider,'max',10);
    set(handles.slider,'min',0);
    set(handles.slider,'value',1);    
    set(handles.slider,'sliderstep',[0.01 0.01]);
    set(handles.slider,'enable','off');
    set(handles.sliderClickL,'enable','off');
    set(handles.sliderClickR,'enable','off');
    imStruc.sliderOn = 0;
end
set(handles.task3,'userdata',imStruc);

set(handles.table,'enable','inactive');
halfdat = imStruc.tlistTable;
for i = 1:imStruc.T
   tabdat{i,1} = halfdat{i,1};
   if i==1
       tabdat{i,3} = 'N/A';
       tabdat{i,4} = 'N/A';
   else
       tabdat{i,3} = sprintf('%0.3f',(i-1)*imStruc.timestep);
       if imStruc.diffList(i-1)==1
          tabdat{i,4} = 'on'; 
       else
          tabdat{i,4} = 'OFF'; 
       end
   end
   tabdat{i,2} = halfdat{i,2};  
end
set(handles.table,'data',tabdat);
load(handles.tableProps);
set(handles.table,'columnwidth',{tableProps.width{17},tableProps.width{18},tableProps.width{19},tableProps.width{20}});
set(handles.table,'columnname',{'Time (min)','State','Interval (min)','State'});

handles = updateAxes(handles);
set(handles.prompt,'string',...
    'You may look at the redistributed pixels in different ways, by selecting the Main menu, which controls what type of analysis is shown in the main axes.  If you have created a filter, you can turn the filter on and off using the filter menu.  When viewing the boxcar averaged analysis, you may change the boxcar window size either directly in the paramters or by using the slider and slider menu.  When done, click Save Results.');
%________________________________________
function [handles] = updateParameters(handles,num,whichP)
imStruc = get(handles.task3,'userdata');
sliderState = get(handles.subOption1,'value');
if whichP==1
        tmax = max(imStruc.timeDiffs);
        tmin = min(imStruc.timeDiffs);
        tarray = imStruc.timeDiffs;
        diffarray = abs(tarray-num);
        minval = find(diffarray==min(diffarray));
        minval = minval(1);
        if num>tmax
            imStruc.currentTime = tmax;
        elseif num<tmin
            imStruc.currentTime =tmin;
        else
            imStruc.currentTime = tarray(minval);         
        end
        imStruc.currentIndex = minval;
        set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentTime));
        if sliderState==1&&imStruc.sliderOn==1
            set(handles.slider,'value',imStruc.currentIndex);
        end
elseif whichP==2
        num = round(num);
        if rem(num,2)==0
            num=num+1;
        end
        if num>min(imStruc.sizePic)
            num = round(min(imStruc.sizePic));
            if rem(num,2)==0
                num=num+1;
            end
            imStruc.currentBoxcar = num;
        elseif num<3
            imStruc.currentBoxcar = 3;
        else
            
            imStruc.currentBoxcar = num;
        end      
        set(handles.parameter2,'string',sprintf('%0.0f',imStruc.currentBoxcar));
        if sliderState==2
            set(handles.slider,'value',imStruc.currentBoxcar);
        end
end
set(handles.task3,'userdata',imStruc);
handles = updateAxes(handles);

function [handles] = move_slider(handles,whichS)
imStruc = get(handles.task3,'userdata');
whichP = get(handles.subOption1,'value');
slideStep = get(handles.slider,'sliderStep');
maxslide = get(handles.slider,'max');
minslide = get(handles.slider,'min');
maxMin = maxslide-minslide;
maxT = length(imStruc.timeDiffs);
minT = 1;
if whichP==1
    oldVal = imStruc.currentIndex;
elseif whichP==2
    oldVal = str2double(get(handles.parameter2,'string'));    
end

if whichS==1
    newVal = get(handles.slider,'value');
    if whichP==1
        if newVal>maxT
            newVal=maxT;
        elseif newVal<1
            newVal=1;
        else
            newVal = round(newVal);
        end
        newVal = imStruc.timeDiffs(newVal);
        updateParameters(handles,newVal,whichP);
    else
        updateParameters(handles,newVal,whichP);
    end
elseif whichS==2
    newVal = oldVal+slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
    if whichP==1
        if newVal>maxT
            newVal=maxT;
        elseif newVal<1
            newVal=1;
        else
            newVal = round(newVal);
        end
        newVal = imStruc.timeDiffs(newVal);
        updateParameters(handles,newVal,whichP);
    else
        updateParameters(handles,newVal,whichP);
    end
else
    newVal = oldVal-slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
    if whichP==1
        if newVal>maxT
            newVal=maxT;
        elseif newVal<1
            newVal=1;
        else
            newVal = round(newVal);
        end
        newVal = imStruc.timeDiffs(newVal);
        updateParameters(handles,newVal,whichP);
    else
        updateParameters(handles,newVal,whichP);
    end
end

%________________________________________
function [handles] = updateAxes(handles)
handles = turnOFFfuncButtons(handles);
imStruc = get(handles.task3,'userdata');
mainVal = get(handles.subOption2,'value');
filtVal = get(handles.subOption3,'value');
index = imStruc.currentIndex;
pic1 = imStruc.picDiffs(index).firstPic;
pic2 = imStruc.picDiffs(index).secondPic;
if imStruc.filterDefined==1
   filterPIC = imStruc.filterPIC; 
else
   filterPIC = 1; 
end
if mainVal==1
    change = (pic1-pic2);
    vals = change<0;
    change(vals)=2;
    filtChange = change.*filterPIC;
    if filtVal==1
        imagesc(change,'Parent',handles.mainAxes);
        subfilt = 1;
    else
        imagesc(filtChange,'Parent',handles.mainAxes);
        subfilt = filterPIC;
    end
    imagesc(imStruc.dilPics{index}.*subfilt,'Parent',handles.subAxes1);
    imagesc(imStruc.dilPics{index+1}.*subfilt,'Parent',handles.subAxes2);
    set(handles.figure1,'currentAxes',handles.subAxes1);
    xlabel('Time T');
    set(handles.figure1,'currentAxes',handles.subAxes2);
    xlabel('Time T+1');
    colormap([1 1 1;0 0 1; 1 0 0]);
elseif mainVal==2
    change = abs(pic1-pic2);
    boxsize = imStruc.currentBoxcar;
    if filtVal==1
        boxchange = fastrunmean(change,[boxsize boxsize],'zeros').*change;
        imagesc(boxchange,'Parent',handles.mainAxes);
        subfilt = 1;
    else
        change = change.*filterPIC;
        boxChangeFilt = fastrunmean(change,[boxsize boxsize],'zeros').*change;
        imagesc(boxChangeFilt,'Parent',handles.mainAxes);
        subfilt = filterPIC;
    end
    imagesc(imStruc.dilPics{index}.*subfilt,'Parent',handles.subAxes1);
    imagesc(imStruc.dilPics{index+1}.*subfilt,'Parent',handles.subAxes2);
    set(handles.figure1,'currentAxes',handles.subAxes1);
    xlabel('Time T');
    set(handles.figure1,'currentAxes',handles.subAxes2);
    xlabel('Time T+1');
    colormap([handles.cmap_colour2;1 0 0]);
elseif mainVal==3
    change = abs(pic1-pic2);
    subfilt = 1;
    if filtVal==2
        change = change.*filterPIC;
        subfilt = filterPIC;
    end
    cc = bwconncomp(change,8);
    labeled = labelmatrix(cc);
    RGB_label = label2rgb(labeled, @jet, [0 0 0], 'shuffle');
    hImg = imagesc(RGB_label,'Parent',handles.mainAxes); set(hImg, 'AlphaData', 1);
    imagesc(imStruc.dilPics{index}.*subfilt,'Parent',handles.subAxes1);
    imagesc(imStruc.dilPics{index+1}.*subfilt,'Parent',handles.subAxes2);
    set(handles.figure1,'currentAxes',handles.subAxes1);
    xlabel('Time T');
    set(handles.figure1,'currentAxes',handles.subAxes2);
    xlabel('Time T+1');
    colormap([handles.cmap_colour2;1 0 0]);
end

handles = turnONfuncButtons(handles);
  
%______________________________________________________
function [handles] = turnOFFfuncButtons(handles)
imStruc = get(handles.task3,'userdata');
set(handles.option1,'enable','inactive');
set(handles.subOption1,'enable','inactive');
set(handles.subOption2,'enable','inactive');
set(handles.subOption3,'enable','inactive');
set(handles.function1,'enable','inactive');
set(handles.function2,'enable','inactive');
set(handles.function3,'enable','inactive');
if imStruc.pixFreqDefined==1
    set(handles.function4,'enable','inactive');
else
    set(handles.function4,'enable','off');
end
set(handles.function5,'enable','inactive');
set(handles.parameter1,'enable','inactive');

val = get(handles.subOption2,'value');
if val==2
  set(handles.parameter2,'enable','inactive');
else
  set(handles.parameter2,'enable','off');  
end
if imStruc.sliderOn==0
    set(handles.slider,'enable','off');
    set(handles.sliderClickL,'enable','off');
    set(handles.sliderClickR','enable','off');
else
    set(handles.slider,'enable','inactive');
    set(handles.sliderClickL,'enable','inactive');
    set(handles.sliderClickR','enable','inactive');
end
set(handles.prompt,'string','Processing...');
pause(0.01);
%______________________________________________________
function [handles] = turnONfuncButtons(handles)
imStruc = get(handles.task3,'userdata');
set(handles.option1,'enable','on');
set(handles.subOption1,'enable','on');
set(handles.subOption2,'enable','on');
set(handles.function1,'enable','on');
set(handles.function2,'enable','on');
set(handles.function3,'enable','on');
if imStruc.pixFreqDefined==1
    set(handles.function4,'enable','on');
else
    set(handles.function4,'enable','off');
end
if imStruc.filterDefined==1
    set(handles.subOption3,'enable','on');
else
    set(handles.subOption3,'enable','inactive');
end
set(handles.function5,'enable','on');
set(handles.parameter1,'enable','on');

val = get(handles.subOption2,'value');
if val==2
  set(handles.parameter2,'enable','on');
else
  set(handles.parameter2,'enable','off');  
end
if imStruc.sliderOn==0
    set(handles.slider,'enable','off');
    set(handles.sliderClickL,'enable','off');
    set(handles.sliderClickR','enable','off');
else
    set(handles.slider,'enable','on');
    set(handles.sliderClickL,'enable','on');
    set(handles.sliderClickR','enable','on');
end
set(handles.prompt,'string','');
pause(0.01);

%________________________________________________
function [handles] = calculateQuantities(handles)
imStruc=get(handles.task3,'userdata');
dirpath = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil];
if ~isdir(dirpath);
        mkdir(dirpath);
end
globalAnalysis.timeArea = imStruc.timeArea;
globalAnalysis.timeDiffs = imStruc.timeDiffs;
Tarea = length(imStruc.timeArea);
Tdiff = length(imStruc.timeDiffs);
picArea = imStruc.picArea;
picDiff = imStruc.picDiffs;
if imStruc.filterDefined==1
    filterPIC = (imStruc.filterPIC)./max(imStruc.filterPIC(:));
    globalAnalysis.filterDefined = 1;
else
    filterPIC = 1;
    globalAnalysis.filterDefined = 0;
end


globalAnalysis.area = zeros(Tarea,1);
globalAnalysis.areaFiltered = zeros(Tarea,1);
for i = 1:Tarea
   globalAnalysis.area(i) = sum(picArea{i}(:));
   globalAnalysis.areaFiltered(i) = sum(sum(picArea{i}.*filterPIC));
end
globalAnalysis.redistPics = cell(Tdiff,1);
globalAnalysis.boxcarPics = cell(Tdiff,1);
globalAnalysis.redistPicsFiltered = cell(Tdiff,1);
globalAnalysis.boxcarPicsFiltered = cell(Tdiff,1);
globalAnalysis.sumRedist = zeros(Tdiff,1);
globalAnalysis.sumRedistFiltered = zeros(Tdiff,1);
globalAnalysis.sumRedistNorm = zeros(Tdiff,1);
globalAnalysis.sumRedistNormFiltered = zeros(Tdiff,1);
globalAnalysis.boxCar = zeros(Tdiff,1);
globalAnalysis.boxCarFiltered = zeros(Tdiff,1);
globalAnalysis.boxSize = imStruc.currentBoxcar;
globalAnalysis.cumuChange = zeros(Tarea-1,1); 
globalAnalysis.cumuChangeFiltered = zeros(Tarea-1,1); 

for i = 1:Tarea-1
    globalAnalysis.cumuChange(i) = sum(sum(abs(picArea{i+1}-picArea{1})));
    globalAnalysis.cumuChangeFiltered(i) = sum(sum(abs(picArea{i+1}-picArea{1}).*filterPIC)); 
end

for i = 1:Tdiff
    % image data
    pic1 = picDiff(i).firstPic;
    pic2 = picDiff(i).secondPic;
    filtpic1 = pic1.*filterPIC;
    filtpic2 = pic2.*filterPIC;
    meanArea = mean([sum(pic1(:));sum(pic2(:))]);
    meanAreaF = mean([sum(filtpic1(:));sum(filtpic2(:))]);
    globalAnalysis.redistPics{i} = pic2-pic1;
    globalAnalysis.boxcarPics{i} = fastrunmean(abs(globalAnalysis.redistPics{i}),...
        [globalAnalysis.boxSize,globalAnalysis.boxSize],'zeros').*abs(globalAnalysis.redistPics{i});
    globalAnalysis.redistPicsFiltered{i} = (pic2-pic1).*filterPIC;
    globalAnalysis.boxcarPicsFiltered{i} = fastrunmean(abs(globalAnalysis.redistPicsFiltered{i}),...
        [globalAnalysis.boxSize,globalAnalysis.boxSize],'zeros').*abs(globalAnalysis.redistPicsFiltered{i});
    % cc data
    globalAnalysis.cc(i) = bwconncomp(globalAnalysis.redistPics{i},8);
    globalAnalysis.ccFiltered(i) = bwconncomp(globalAnalysis.redistPics{i}.*filterPIC,8);
    % redist data
    globalAnalysis.sumRedist(i) = sum(sum(abs(globalAnalysis.redistPics{i})));
    globalAnalysis.sumRedistFiltered(i) = sum(sum(abs(globalAnalysis.redistPicsFiltered{i})));
    globalAnalysis.sumRedistNorm(i) = globalAnalysis.sumRedist(i)./meanArea;
    globalAnalysis.sumRedistNormFiltered(i) = globalAnalysis.sumRedistFiltered(i)./meanAreaF;
    % boxcar data
    boxCartemp = globalAnalysis.boxcarPics{i};
    boxCartemp = boxCartemp(boxCartemp>0);
    globalAnalysis.boxCar(i) = mean(boxCartemp);
    boxCartemp = globalAnalysis.boxcarPicsFiltered{i};
    boxCartemp = boxCartemp(boxCartemp>0);
    globalAnalysis.boxCarFiltered(i) = mean(boxCartemp);
    
    % cc organized
    for j = 1:globalAnalysis.cc(i).NumObjects
        globalAnalysis.connectedLocalAreas(i).area(j) = length(globalAnalysis.cc(i).PixelIdxList{j});
    end
    
    for j = 1:globalAnalysis.ccFiltered(i).NumObjects
        globalAnalysis.connectedLocalAreasFiltered(i).area(j) = length(globalAnalysis.ccFiltered(i).PixelIdxList{j});
    end
end

% means and standard deviations
% connected areas
runningTot = [];
runningTotFilt = [];
runningTotInd = [];
runningTotIndFilt = [];
for i = 1:Tdiff
   runningTot = [runningTot globalAnalysis.connectedLocalAreas(i).area];
   runningTotInd = [runningTotInd ones(1,length(globalAnalysis.connectedLocalAreas(i).area))*i];
   runningTotFilt = [runningTotFilt globalAnalysis.connectedLocalAreasFiltered(i).area];
   runningTotIndFilt = [runningTotIndFilt ones(1,length(globalAnalysis.connectedLocalAreasFiltered(i).area))*i];
end
globalAnalysis.meanConnectedArea = mean(runningTot);
globalAnalysis.stdConnectedArea = std(runningTot);
globalAnalysis.allConnectedAreas = runningTot;
globalAnalysis.allConnectedAreasInd = runningTotInd;
globalAnalysis.meanConnectedAreaFiltered = mean(runningTotFilt);
globalAnalysis.stdConnectedAreaFiltered = std(runningTotFilt);
globalAnalysis.allConnectedAreasFiltered = runningTotFilt;
globalAnalysis.allConnectedAreasIndFiltered = runningTotIndFilt;
% total areas
globalAnalysis.meanArea = mean(globalAnalysis.area);
globalAnalysis.stdArea = std(globalAnalysis.area);
globalAnalysis.meanAreaFiltered = mean(globalAnalysis.areaFiltered);
globalAnalysis.stdAreaFiltered = std(globalAnalysis.areaFiltered);
% redists
globalAnalysis.meanSumRedist = mean(globalAnalysis.sumRedist);
globalAnalysis.stdSumRedist = std(globalAnalysis.sumRedist);
globalAnalysis.meanSumRedistFiltered = mean(globalAnalysis.sumRedistFiltered);
globalAnalysis.stdSumRedistFiltered = std(globalAnalysis.sumRedistFiltered);
globalAnalysis.meanSumRedistNorm = mean(globalAnalysis.sumRedistNorm);
globalAnalysis.stdSumRedistNorm = std(globalAnalysis.sumRedistNorm);
globalAnalysis.meanSumRedistNormFiltered = mean(globalAnalysis.sumRedistNormFiltered);
globalAnalysis.stdSumRedistNormFiltered = std(globalAnalysis.sumRedistNormFiltered);
% boxcars
globalAnalysis.meanBoxCar = mean(globalAnalysis.boxCar);
globalAnalysis.stdBoxCar = std(globalAnalysis.boxCar);
globalAnalysis.meanBoxCarFiltered = mean(globalAnalysis.boxCarFiltered);
globalAnalysis.stdBoxCarFiltered = std(globalAnalysis.boxCarFiltered);

save([dirpath,handles.slash,'globalAnalysis.mat'],'globalAnalysis');
set(handles.task3,'userdata',imStruc);

%______________________________
function [dirpath] = writeOutput(handles)


imStruc = get(handles.task3,'userdata');
dirpath = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil];
load([dirpath,handles.slash,'globalAnalysis.mat']);
filterDefined = globalAnalysis.filterDefined;

writePics(imStruc,globalAnalysis,handles);
writeAreas(dirpath,imStruc,filterDefined,globalAnalysis,handles);
writeRedist(dirpath,imStruc,filterDefined,globalAnalysis,handles);
writeBoxcar(dirpath,imStruc,filterDefined,globalAnalysis,handles);
writeConnected(dirpath,imStruc,filterDefined,globalAnalysis,handles);

%_____________________________________________
function [] = writePics(imStruc,globalAnalysis,handles)

dirRedistPics = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Images',handles.slash,'Redistributions',handles.slash,'noFilter'];
dirBoxCarPics = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Images',handles.slash,'Boxcar_Redistributions',handles.slash,'noFilter'];
dirConnectedPics = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Images',handles.slash,'Connected_Regions',handles.slash,'noFilter'];
dirRedistPicsFiltered = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Images',handles.slash,'Redistributions',handles.slash,'Filtered'];
dirBoxCarPicsFiltered = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Images',handles.slash,'Boxcar_Redistributions',handles.slash,'Filtered'];
dirConnectedPicsFiltered = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Images',handles.slash,'Connected_Regions',handles.slash,'Filtered'];
if ~isdir(dirRedistPics);
    mkdir(dirRedistPics);
end
if ~isdir(dirBoxCarPics);
    mkdir(dirBoxCarPics);
end
if ~isdir(dirConnectedPics);
    mkdir(dirConnectedPics);
end

if globalAnalysis.filterDefined==1
    if ~isdir(dirRedistPicsFiltered);
        mkdir(dirRedistPicsFiltered);
    end
    if ~isdir(dirBoxCarPicsFiltered);
        mkdir(dirBoxCarPicsFiltered);
    end
    if ~isdir(dirConnectedPicsFiltered);
        mkdir(dirConnectedPicsFiltered);
    end
end

T = length(imStruc.timeDiffs);
for i = 1:T
    filename = [dirRedistPics,handles.slash,sprintf('redist_%0.3fmin.png',imStruc.timeDiffs(i))];
    grayimg = mat2gray(globalAnalysis.redistPics{i});
    indimg = gray2ind(grayimg,3);
    RGB = ind2rgb(indimg,[0 0 1;1 1 1; 1 0 0]);
    imwrite(RGB,filename,'png');
    
    filename = [dirBoxCarPics,handles.slash,sprintf('boxcar_%0.3fmin.png',imStruc.timeDiffs(i))];
    grayimg = mat2gray(globalAnalysis.boxcarPics{i});
    indimg = gray2ind(grayimg,50);
    RGB = ind2rgb(indimg,[1 1 1; jet(49)]); 
    imwrite(RGB,filename,'png');
    
    filename = [dirConnectedPics,handles.slash,sprintf('connected_%0.3fmin.png',imStruc.timeDiffs(i))];
    labeled = labelmatrix(globalAnalysis.cc(i));
    RGB = label2rgb(labeled, @jet, [0 0 0], 'shuffle');
    imwrite(RGB,filename,'png');
    if globalAnalysis.filterDefined==1
        filename = [dirRedistPicsFiltered,handles.slash,sprintf('redistF_%0.3fmin.png',imStruc.timeDiffs(i))];
        grayimg = mat2gray(globalAnalysis.redistPicsFiltered{i});
        indimg = gray2ind(grayimg,3);
        RGB = ind2rgb(indimg,[0 0 1;1 1 1; 1 0 0]);
        imwrite(RGB,filename,'png');

        filename = [dirBoxCarPicsFiltered,handles.slash,sprintf('boxcarF_%0.3fmin.png',imStruc.timeDiffs(i))];
        grayimg = mat2gray(globalAnalysis.boxcarPicsFiltered{i});
        indimg = gray2ind(grayimg,50);
        RGB = ind2rgb(indimg,[1 1 1; jet(49)]); 
        imwrite(RGB,filename,'png');

        filename = [dirConnectedPicsFiltered,handles.slash,sprintf('connectedF_%0.3fmin.png',imStruc.timeDiffs(i))];
        labeled = labelmatrix(globalAnalysis.ccFiltered(i));
        RGB = label2rgb(labeled, @jet, [0 0 0], 'shuffle');
        imwrite(RGB,filename,'png');
    end
end

%__________________________________________________________
function [] = writeAreas(dirpath,imStruc,filterDefined,globalAnalysis,handles)

T = length(imStruc.timeArea);
time = imStruc.timeArea;
timestep = imStruc.timestep;
dashstr = '------------';
if filterDefined==1
    Ndashes = 4;
else
    Ndashes = 3;
end
fid = fopen([dirpath,handles.slash,'Areas.txt'],'wt');
fprintf(fid,'Global Area Results\n\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time Averaged Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'N Included Timepoints= \t%d\n',T);
fprintf(fid,'N Excluded Timepoints= \t%d\n\n',imStruc.T-T);
fprintf(fid,'Unfiltered:\n');
fprintf(fid,'Mean Area= \t%0.10g\n',globalAnalysis.meanArea);
fprintf(fid,'Stdev Area= \t%0.10g\n\n',globalAnalysis.stdArea);
if filterDefined==1
    fprintf(fid,'Frequency filtered:\n');
    fprintf(fid,'Mean Area= \t%0.10g\n',globalAnalysis.meanAreaFiltered);
    fprintf(fid,'Stdev Area= \t%0.10g\n',globalAnalysis.stdAreaFiltered);
end
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time dependant Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);

col1name = 'Time Index';
col2name = 'Time (min)';
col3name = 'Area (pix^2)';
col4name = 'Filt Area (pix^2)';

if filterDefined ==0
    fprintf(fid,'%12s\t%12s\t%12s\n',col1name,col2name,col3name);
else
    fprintf(fid,'%12s\t%12s\t%12s\t%17s\n',col1name,col2name,col3name,col4name);
end
for i = 1:T
   if filterDefined==0
    fprintf(fid,'%12d\t%12.8g\t%12d\n',round(time(i)/timestep),time(i),globalAnalysis.area(i));   
   else
    fprintf(fid,'%12d\t%12.8g\t%12d\t%17d\n',round(time(i)/timestep),time(i),globalAnalysis.area(i),globalAnalysis.areaFiltered(i)); 
   end
end
fclose(fid);
    
%________________________________________________________________________
function [] = writeRedist(dirpath,imStruc,filterDefined,globalAnalysis,handles)
dashstr = '------------';
T = length(imStruc.timeDiffs);
timestep = imStruc.timestep;
time = imStruc.timeDiffs;
if filterDefined==1
    Ndashes = 4;
else
    Ndashes = 3;
end
fid = fopen([dirpath,handles.slash,'Redistributions.txt'],'wt');
fprintf(fid,'Global Redistribution Results\n\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time Averaged Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'N Included Time Intervals = \t%d\n',T);
fprintf(fid,'N Excluded Time Intervals = \t%d\n\n',imStruc.T-T-1);
fprintf(fid,'Unfiltered:\n');
fprintf(fid,'Mean Redistribution= \t%0.10g\n',globalAnalysis.meanSumRedist);
fprintf(fid,'Stdev Redistribution= \t%0.10g\n',globalAnalysis.stdSumRedist);
fprintf(fid,'Mean Norm Redistribution= \t%0.10g\n',globalAnalysis.meanSumRedistNorm);
fprintf(fid,'Stdev Norm Redistribution= \t%0.10g\n\n',globalAnalysis.stdSumRedistNorm);
if filterDefined==1
    fprintf(fid,'Frequency filtered:\n');
    fprintf(fid,'Mean Redistribution= \t%0.10g\n',globalAnalysis.meanSumRedistFiltered);
    fprintf(fid,'Stdev Redistribution= \t%0.10g\n',globalAnalysis.stdSumRedistFiltered);
    fprintf(fid,'Mean Norm Redistribution= \t%0.10g\n',globalAnalysis.meanSumRedistNormFiltered);
    fprintf(fid,'Stdev Norm Redistribution= \t%0.10g\n\n',globalAnalysis.stdSumRedistNormFiltered);
end
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time dependant Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);

col1name = 'Time Index';
col2name = 'Interval (min)';
col3name = 'Redist (pix^2)';
col4name = 'Norm Redist';
col5name = 'Filt Redist (pix^2)';
col6name = 'Filt Norm Redist';

if filterDefined ==0
    fprintf(fid,'%12s\t%12s\t%14s\t%12s\n',col1name,col2name,col3name,col4name);
else
    fprintf(fid,'%12s\t%12s\t%14s\t%12s\t%19s\t%16s\n',col1name,col2name,col3name,col4name,col5name,col6name);
end
for i = 1:T
   if filterDefined ==0
    fprintf(fid,'%12d\t%12.8g\t%14d\t%12.10g\n',round(time(i)/timestep),time(i),globalAnalysis.sumRedist(i),globalAnalysis.sumRedistNorm(i)); 
   else
    fprintf(fid,'%12d\t%12.8g\t%14d\t%12.10g\t%19d\t%16.10g\n',round(time(i)/timestep),time(i),globalAnalysis.sumRedist(i),globalAnalysis.sumRedistNorm(i),globalAnalysis.sumRedistFiltered(i),globalAnalysis.sumRedistNormFiltered(i));    
   end
end
fclose(fid);

%_____________________________________________________________________
function [] = writeBoxcar(dirpath,imStruc,filterDefined,globalAnalysis,handles)
dashstr = '------------';
T = length(imStruc.timeDiffs);
timestep = imStruc.timestep;
time = imStruc.timeDiffs;
if filterDefined==1
    Ndashes = 4;
else
    Ndashes = 3;
end
fid = fopen([dirpath,handles.slash,'Boxcar_Redistributions.txt'],'wt');
fprintf(fid,'Global Boxcar Averaged Redistribution Results\n\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time Averaged Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'N Included Time Intervals = \t%d\n',T);
fprintf(fid,'N Excluded Time Intervals = \t%d\n',imStruc.T-T-1);
fprintf(fid,'Boxcar size = \t%d\n\n',globalAnalysis.boxSize);
fprintf(fid,'Unfiltered:\n');
fprintf(fid,'Mean Motility=\t%0.10g\n',globalAnalysis.meanBoxCar);
fprintf(fid,'Stdev Motility=\t%0.10g\n\n',globalAnalysis.stdBoxCar);
if filterDefined==1
    fprintf(fid,'Frequency filtered:\n');
    fprintf(fid,'Mean Motility=\t%0.10g\n',globalAnalysis.meanBoxCarFiltered);
    fprintf(fid,'Stdev Motility=\t%0.10g\n\n',globalAnalysis.stdBoxCarFiltered);
end
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time dependant Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);

col1name = 'Time Index';
col2name = 'Interval (min)';
col3name = 'Motility';
col4name = 'Filt Motility';


if filterDefined ==0
    fprintf(fid,'%12s\t%12s\t%12s\n',col1name,col2name,col3name);
else
    fprintf(fid,'%12s\t%12s\t%12s\t%13s\n',col1name,col2name,col3name,col4name);
end
for i = 1:T
   if filterDefined ==0
    fprintf(fid,'%12d\t%12.8g\t%12.10g\n',round(time(i)/timestep),time(i),globalAnalysis.boxCar(i));
   else
    fprintf(fid,'%12d\t%12.8g\t%12.10g\t%13.10g\n',round(time(i)/timestep),time(i),globalAnalysis.boxCar(i),globalAnalysis.boxCarFiltered(i));
   end
end
fclose(fid);

%_________________________________________________
function [] = writeConnected(dirpath,imStruc,filterDefined,globalAnalysis,handles)
dashstr = '------------';
T = length(imStruc.timeDiffs);
timestep = imStruc.timestep;
time = imStruc.timeDiffs;
if filterDefined==1
    Ndashes = 4;
else
    Ndashes = 3;
end
fid = fopen([dirpath,handles.slash,'ConnectedRegionsResults.txt'],'wt');
fprintf(fid,'Global Connected Region Results\n\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time Averaged Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'N Included Time Intervals = \t%d\n',T);
fprintf(fid,'N Excluded Time Intervals = \t%d\n',imStruc.T-T-1);
fprintf(fid,'Unfiltered:\n');
fprintf(fid,'N regions = \t%d\n',length(globalAnalysis.allConnectedAreas));
fprintf(fid,'Mean Connected Area= \t%0.10g\n',globalAnalysis.meanConnectedArea);
fprintf(fid,'Stdev Connected Area= \t%0.10g\n\n',globalAnalysis.stdConnectedArea);
if filterDefined==1
    fprintf(fid,'Frequency filtered:\n');
    fprintf(fid,'N regions = \t%d\n',length(globalAnalysis.allConnectedAreasFiltered));
    fprintf(fid,'Mean Connected Area= \t%0.10g\n',globalAnalysis.meanConnectedAreaFiltered);
    fprintf(fid,'Stdev Connected Area= \t%0.10g\n\n',globalAnalysis.stdConnectedAreaFiltered);
end
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Time dependant Results:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);

col1name = 'Time Index';
col2name = 'Interval (min)';
col3name = 'Nregions';
col4name = 'Mean Con Area(pix^2)';
col5name = 'Std Con Area (pix^2)';
col6name = 'Filt Nregions';
col7name = 'Filt Mean Con Area (pix^2)';
col8name = 'Filt Std Con Area (pix^2)';

if filterDefined ==0
    fprintf(fid,'%12s\t%12s\t%12s\t%20s\t%19s\n',col1name,col2name,col3name,col4name,col5name);
else
    fprintf(fid,'%12s\t%12s\t%12s\t%20s\t%19s\t%13s\t%25s\t%24s\n',col1name,col2name,col3name,col4name,col5name,col6name,col7name,col8name);
end
for i = 1:T
   if filterDefined==0
    fprintf(fid,'%12d\t%12.8g\t%12d\t%20.16g\t%19.16g\n',round(time(i)/timestep),time(i),globalAnalysis.cc(i).NumObjects,mean(globalAnalysis.connectedLocalAreas(i).area),std(globalAnalysis.connectedLocalAreas(i).area)); 
   else
    fprintf(fid,'%12d\t%12.8g\t%12d\t%20.16g\t%19.16g\t%13d\t%25.16g\t%24.16g\n',round(time(i)/timestep),time(i),globalAnalysis.cc(i).NumObjects,mean(globalAnalysis.connectedLocalAreas(i).area),std(globalAnalysis.connectedLocalAreas(i).area),globalAnalysis.ccFiltered(i).NumObjects,mean(globalAnalysis.connectedLocalAreasFiltered(i).area),std(globalAnalysis.connectedLocalAreasFiltered(i).area));    
   end
end
fclose(fid);

fid = fopen([dirpath,handles.slash,'ConnectedRegionsListNoFilter.txt'],'wt');
fprintf(fid,'Global Connected Region List of all connected Regions with no frequency filter\n\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);
fprintf(fid,'Individual Connected Regions:\n');
for i = 1:Ndashes-1
    fprintf(fid,'%s\t',dashstr);
end
fprintf(fid,'%s\n',dashstr);

col1name = 'Index';
col2name = 'Time Index';
col3name = 'Interval (min)';
col4name = 'Con Area (pix^2)';
fprintf(fid,'%12s\t%12s\t%12s\t%16s\n',col1name,col2name,col3name,col4name);

for i = 1:length(globalAnalysis.allConnectedAreasInd)
    i
    fprintf(fid,'%12d\t%12d\t%12.8g\t%16.15g\n',i,round(time(globalAnalysis.allConnectedAreasInd(i))/timestep),time(globalAnalysis.allConnectedAreasInd(i)),globalAnalysis.allConnectedAreas(i)); 
end

fclose(fid);

if filterDefined==1
    fid = fopen([dirpath,handles.slash,'ConnectedRegionsListFiltered.txt'],'wt');
    fprintf(fid,'Global Connected Region List of all connected Regions with frequency filter applied\n\n');
    for i = 1:Ndashes-1
        fprintf(fid,'%s\t',dashstr);
    end
    fprintf(fid,'%s\n',dashstr);
    fprintf(fid,'Individual Connected Regions:\n');
    for i = 1:Ndashes-1
        fprintf(fid,'%s\t',dashstr);
    end
    fprintf(fid,'%s\n',dashstr);

    col1name = 'Index';
    col2name = 'Time Index';
    col3name = 'Interval (min)';
    col4name = 'Con Area (pix^2)';
    fprintf(fid,'%12s\t%12s\t%12s\t%16s\n',col1name,col2name,col3name,col4name);

    for i = 1:length(globalAnalysis.allConnectedAreasIndFiltered)
        fprintf(fid,'%12d\t%12d\t%12.8g\t%16.15g\n',i,round(time(globalAnalysis.allConnectedAreasIndFiltered(i))/timestep),time(globalAnalysis.allConnectedAreasIndFiltered(i)),globalAnalysis.allConnectedAreasFiltered(i)); 
    end

    fclose(fid);
end