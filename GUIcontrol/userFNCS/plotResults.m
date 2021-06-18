function [] = plotResults(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');
dataCell = get(handles.task4,'userdata');
cellStruc = dataCell{1};
groupStruc = dataCell{2};
tabdata = get(handles.table,'userdata');
tabDataCell = tabdata{1};
tabDataGroup = tabdata{2};

if strcmp(tag,'function2')
   handles = initializeALL(handles); 
elseif strcmp(tag,'table')
   curMode = get(handles.subOption3,'value');
   plotType = get(handles.subOption2,'value');
   ind = eventdata.Indices;
   if ind(2)==1
       if curMode==1&&plotType==1
           curEntry = tabDataCell{ind(1),ind(2)};
           if strcmp(curEntry,'on')
               newEntry = 'off';
           else
               newEntry = 'on';
           end
           tabDataCell{ind(1),ind(2)} = newEntry;
           tabdata{1} = tabDataCell;
           set(handles.table,'data',tabDataCell);
           set(handles.table','userdata',tabdata);
           handles = updateAxes(handles);
       else
           curEntry = tabDataGroup{ind(1),ind(2)};
           if strcmp(curEntry,'on')
               newEntry = 'off';
           else
               newEntry = 'on';
           end
           tabDataGroup{ind(1),ind(2)} = newEntry;
           tabdata{2} = tabDataGroup;
           set(handles.table,'data',tabDataGroup);
           set(handles.table','userdata',tabdata);
           handles = updateAxes(handles);
       end
   else
       ind = eventdata.Indices(1);
       if curMode==1&&plotType==1
           projName = cellStruc(ind).projName;
           groupName = cellStruc(ind).groupName;
           cellName = cellStruc(ind).cellName;
           dilation = cellStruc(ind).dilation;
           dirpath = [handles.rootDirectory,handles.slash,projName,handles.slash,groupName,handles.slash,cellName];
           dirpath2 = [dirpath,handles.slash,'Results',handles.slash,'Dilation',dilation];
           loadListbox([],handles,[],dirpath2);
       else
           projName = groupStruc(ind).projName;
           groupName = groupStruc(ind).groupName;
           dirpath = [handles.rootDirectory,handles.slash,projName,handles.slash,groupName];
           loadListbox([],handles,[],dirpath);
       end
   end
elseif strcmp(tag,'subOption1');
    handles = updateAxes(handles);
elseif strcmp(tag,'subOption2')||strcmp(tag,'subOption3')
    set(handles.subOption1,'value',1);
    errorMessage =0;
    val = get(handles.subOption3,'value');
    plotType = get(handles.subOption2,'value');
    tabdata = get(handles.table,'userdata'); 
    load(handles.tableProps);
    if plotType==1
        varList = {'BoxCar','SumRedist','NormSumRedist','Area','CumulativeChange','BoxCarFilt',...
    'SumRedistFilt','NormSumRedistFilt','AreaFilt','CumulativeChangeFilt'}; 
        set(handles.subOption1,'string',varList);
        set(handles.table,'columnname',{'Plot','Dil','Cell','Group','Project'});
        tabDatCell = tabdata{1};
        col1 = tableProps.width{6};
        col2 = tableProps.width{7};
        col3 = tableProps.width{8};
        col4 = tableProps.width{9};
        col5 = tableProps.width{10};
        set(handles.table,'columnwidth',{col1,col2,col3,col4,col5});
        set(handles.table,'data',tabDatCell);
        set(handles.subOption3,'value',1);
        if val==2
           errorMessage = 1; 
        end
    else
        varList = {'meanBoxCar','meanSumRedist','meanNormSumRedist','meanArea','meanBoxCarFilt',...
    'meanSumRedistFilt','meanNormSumRedistFilt','meanAreaFilt'}; 
        set(handles.subOption1,'string',varList);
        set(handles.table,'columnname',{'Plot','Dil','Group','Project'});
        tabDatCell = tabdata{2};
        col1 = tableProps.width{11};
        col2 = tableProps.width{12};
        col3 = tableProps.width{13};
        col4 = tableProps.width{14};
        set(handles.table,'columnwidth',{col1,col2,col3,col4});
        set(handles.table,'data',tabDatCell);
    end
    handles = updateAxes(handles);
    if errorMessage ==1
        set(handles.prompt,'string','Cannot change to group mode when looking at time data');
    end
elseif strcmp(tag,'option1')
    handles = turnOFFbutton(handles);
    set(handles.userInput,'enable','on');
    set(handles.prompt,'string','Enter a comment for the export filenames and press enter when done.');
elseif strcmp(tag,'userInput')
    set(handles.userInput,'enable','off');
    sucExp = exportALL(handles);
    handles = turnONbutton(handles);
    set(handles.userInput,'string','');
    str1 = [handles.rootDirectory,handles.slash,'ExportedFigues'];
    str2 = [handles.rootDirectory,handles.slash,'ExportedData'];
    if sucExp==1
        set(handles.prompt,'string',sprintf('Files have been exported to %s and %s',str1,str2));
    else
       set(handles.prompt,'string','Error: You must select at least one cell for export.'); 
    end
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

%______________________________
function handles = initializeALL(handles)
tabdata = get(handles.table,'userdata');
tabDatCell = tabdata{1};
varList = {'BoxCar','SumRedist','NormSumRedist','Area','CumulativeChange','BoxCarFilt',...
    'SumRedistFilt','NormSumRedistFilt','AreaFilt','CumulativeChangeFilt'}; 
set(handles.table,'columnname',{'Plot','Dil','Cell','Group','Project'});
load(handles.tableProps);
col1 = tableProps.width{6};
col2 = tableProps.width{7};
col3 = tableProps.width{8};
col4 = tableProps.width{9};
col5 = tableProps.width{10};
set(handles.table,'columnwidth',{col1,col2,col3,col4,col5});
set(handles.table,'data',tabDatCell);

set(handles.table,'enable','on');
set(handles.option1,'enable','on');
set(handles.option2,'enable','off');
set(handles.option3,'enable','off');
set(handles.option4,'enable','off');
set(handles.subOption1,'enable','on');
set(handles.subOption2,'enable','on');
set(handles.subOption3,'enable','on');
set(handles.subOption4,'enable','off');
set(handles.parameter1,'enable','off');
set(handles.parameter2,'enable','off');
set(handles.parameter3,'enable','off');
set(handles.parameter4,'enable','off');
set(handles.parameter5,'enable','off');

set(handles.option1,'value',0);
set(handles.option2,'value',0);
set(handles.option3,'value',0);
set(handles.option4,'value',0);
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);

set(handles.option1,'string','Export');
set(handles.subOption1,'string',varList);
set(handles.subOption2,'string',{'Axis-Time Plots','Axis-Bar Means'});
set(handles.subOption3,'string',{'Mode-Cells','Mode-Groups'});
set(handles.subOption4,'string',{'--'});

set(handles.plabel1,'string','--');
set(handles.plabel2,'string','--');
set(handles.plabel3,'string','--');
set(handles.plabel4,'string','--');
set(handles.plabel5,'string','--');

set(handles.parameter1,'string','--');
set(handles.parameter2,'string','--');
set(handles.parameter3,'string','--');
set(handles.parameter4,'string','--');
set(handles.parameter5,'string','--');
handles = updateAxes(handles);
set(handles.prompt,'string','Choose from the different plot options in the pull down menus.  Export figures and data at any time, the output will be what is shown in the figure.');

%___________________________________________
function handles = updateAxes(handles)

dataCell = get(handles.task4,'userdata');
cellStruc = dataCell{1};
groupStruc = dataCell{2};
tabdata = get(handles.table,'data');
plotType = get(handles.subOption2,'value');
curMode = get(handles.subOption3,'value');
qVal = get(handles.subOption1,'value');
s = size(tabdata);
counter = 1;
keepInds = -1;
for i = 1:s(1)
   if strcmp(tabdata(i,1),'on')
       keepInds(counter) = i;
       counter = counter+1;
   end
end

imagesc(zeros(10,10),'parent',handles.mainAxes);
imagesc(zeros(10,10),'parent',handles.subAxes1);
imagesc(zeros(10,10),'parent',handles.subAxes2);
if plotType==1
    handles = plotTime(handles,keepInds,groupStruc,cellStruc,tabdata,curMode,qVal);
else
    handles = plotBar(handles,keepInds,groupStruc,cellStruc,tabdata,curMode,qVal);
end
set(handles.prompt,'string','');
%_____________________________________
function handles = plotBar(handles,keepInds,groupStruc,cellStruc,tabdata,curMode,qVal)
if keepInds~=-1
    if curMode==1
        Ncells = 0;
        for i = 1:length(keepInds)
            if groupStruc(keepInds(i)).Ncells>Ncells
                Ncells = groupStruc(keepInds(i)).Ncells;
            end
        end
        meanMat = ones(length(keepInds),Ncells).*NaN;
        stdMat = ones(length(keepInds),Ncells).*NaN;
        maxN = Ncells;
    else
        meanMat = zeros(length(keepInds),1);
        stdMat = zeros(length(keepInds),1);
        maxN = length(keepInds);
    end
    
    for i = 1:length(keepInds)
       if curMode==1
            Ncells = groupStruc(keepInds(i)).Ncells;
              startInd = groupStruc(keepInds(i)).cellStartInd;
              if qVal==1
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanBoxCar;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdBoxCar;
                  end
                  ystr = 'Box Car Motility';
              elseif qVal==2
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedist;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedist;
                  end
                  ystr = 'Sum Redist (pixels^2)';
              elseif qVal==3
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedistNorm;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedistNorm;
                  end
                  ystr = 'Norm Sum Redist';
              elseif qVal==4
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanArea;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdArea;
                  end
                  ystr = 'Area (pixels^2)';
              elseif qVal==5
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanBoxCarFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdBoxCarFiltered;
                  end
                  ystr = 'Box Car Motility Filtered';
              elseif qVal==6
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedistFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedistFiltered;
                  end
                  ystr = 'Sum Redist Filtered';
              elseif qVal==7
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedistNormFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedistNormFiltered;
                  end
                  ystr = 'Norm Sum Redist Filtered';
              elseif qVal==8
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanAreaFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdAreaFiltered;
                  end
                  ystr = 'Area Filtered (pixels^2)';
              end
        else
          if qVal==1
              meanMat(i) = groupStruc(i).mBoxCar;
              stdMat(i) = groupStruc(i).sBoxCar./sqrt(groupStruc(i).Ncells);
              ystr='Box Car Motility';
          elseif qVal==2
              meanMat(i) = groupStruc(i).mSumRedist;
              stdMat(i) = groupStruc(i).sSumRedist./sqrt(groupStruc(i).Ncells);
              ystr = 'Sum Redist (pixels^2)';
          elseif qVal==3
              meanMat(i) = groupStruc(i).mNSumRedist;
              stdMat(i) = groupStruc(i).sNSumRedist./sqrt(groupStruc(i).Ncells);
              ystr = 'Norm Sum Redist';
          elseif qVal==4
              meanMat(i) = groupStruc(i).mArea;
              stdMat(i) = groupStruc(i).sArea./sqrt(groupStruc(i).Ncells);
              ystr = 'Area (pixels^2)';
          elseif qVal==5
              meanMat(i) = groupStruc(i).mBoxCarF;
              stdMat(i) = groupStruc(i).sBoxCarF./sqrt(groupStruc(i).Ncells);
              ystr = 'Boxcar Motility Filtered';
          elseif qVal==6
              meanMat(i) = groupStruc(i).mSumRedistF;
              stdMat(i) = groupStruc(i).sSumRedistF./sqrt(groupStruc(i).Ncells);
              ystr = 'Sum Redist Filtered (pixels^2)';
          elseif qVal==7
              meanMat(i) = groupStruc(i).mNSumRedistF;
              stdMat(i) = groupStruc(i).sNSumRedistF./sqrt(groupStruc(i).Ncells);
              ystr = 'Norm Sum Redist Filtered';
          elseif qVal==8
              meanMat(i) = groupStruc(i).mAreaF;
              stdMat(i) = groupStruc(i).sAreaF./sqrt(groupStruc(i).Ncells);
              ystr = 'Area Filtered (pixels^2)';
          end
       end
    end
    set(handles.figure1,'currentAxes',handles.mainAxes);
    barweb(meanMat,stdMat,[],[],[],[],[],jet(maxN));
    if curMode==1
        set(handles.mainAxes,'xtick',[1 2 3]);
        set(handles.mainAxes,'xticklabel',{'1','2','3'});
    end
    ylabel(ystr);
    box on;    
else
    imagesc(zeros(10,10),'parent',handles.mainAxes);
    colormap([1 1 1]);
end
imagesc(zeros(10,10),'parent',handles.subAxes1);
imagesc(zeros(10,10),'parent',handles.subAxes2);
%_____________________________________
function handles = plotTime(handles,keepInds,groupStruc,cellStruc,tabdata,curMode,qVal)
if keepInds~=-1
    for i = 1:length(keepInds)
           timeArea = cellStruc(keepInds(i)).analysis.timeArea;
           timeDiff = cellStruc(keepInds(i)).analysis.timeDiffs;
           if qVal==1
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.boxCar]';
               ystr = 'BoxCar Motility';
           elseif qVal==2
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedist]';
               ystr = 'Sum Redist (pixels^2)';
           elseif qVal==3
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedistNorm]';
               ystr = 'Normalized Sum Redist';
           elseif qVal==4
               x{i} =  timeArea;
               y{i} =  [cellStruc(keepInds(i)).analysis.area]';
               ystr = 'Area (pixels^2)';
           elseif qVal==5
               x{i} =  timeArea(1:end-1);
               y{i} =  [cellStruc(keepInds(i)).analysis.cumuChange]';
               ystr = 'Cumulative Change (pixels^2)';
           elseif qVal==6
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.boxCarFiltered]';
               ystr = 'BoxCar Motility Filtered';
           elseif qVal==7
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedistFiltered]';
               ystr = 'Sum Redist Filtered (pixels^2)';
           elseif qVal==8
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedistNormFiltered]';
               ystr = 'Normalized Sum Redist Filtered';
           elseif qVal==9
               x{i} =  timeArea;
               y{i} =  [cellStruc(keepInds(i)).analysis.areaFiltered]';
               ystr = 'Area Filtered (pixels^2)';
           else 
               x{i} =  timeArea(1:end-1);
               y{i} =  [cellStruc(keepInds(i)).analysis.cumuChangeFiltered]';
               ystr = 'Cumulative Change Filtered (pixels^2)';
           end
       if i<=10
           subx{i} = NaN;
           suby{i} = i;
           legendcell{i} = sprintf('%d',keepInds(i));
       else
           subx2{i-10} = NaN;
           suby2{i-10} = i;
           legendcell2{i-10} = sprintf('%d',keepInds(i));
       end
    end

    cmap = jet(length(keepInds));

    for i = 1:length(keepInds)
        if i ==1
           minx = min(x{i});
           miny = min(y{i});
           maxx = max(x{i});
           maxy = max(y{i});
        else
           if min(x{i})<minx
               minx = min(x{i});
           end
           if min(y{i})<miny
               miny = min(y{i});
           end
           if max(x{i})>maxx
               maxx = max(x{i});
           end
           if max(y{i})>maxy
               maxy = max(y{i});
           end
        end
        set(handles.figure1,'currentAxes',handles.mainAxes);
        plot(handles.mainAxes,x{i},y{i},'-o','markerfacecolor',cmap(i,:),'color','k'); 
        hold on;
        xlabel('Time (min)');
        ylabel(ystr);
    end
    stepx = minx*0.001;
    stepy = miny*0.001;
    xlim(gca,[minx-stepx maxx+stepx]);
    ylim(gca,[miny-stepy maxy+stepy]);
else
    imagesc(zeros(10,10),'parent',handles.mainAxes);
    colormap([1 1 1]);
    imagesc(zeros(10,10),'parent',handles.subAxes1);
    colormap([1 1 1]);
    imagesc(zeros(10,10),'parent',handles.subAxes2);
    colormap([1 1 1]);
end

if keepInds~=-1
    if length(keepInds)<=10
        set(handles.figure1,'currentAxes',handles.subAxes1);
        hold on;
        for i = 1:length(keepInds)
            plot(handles.subAxes1,subx{i},suby{i},'o','markerfacecolor',cmap(i,:),'color','k');
        end
        legend(legendcell);
        hold off;
    else
        set(handles.figure1,'currentAxes',handles.subAxes1);
        hold on;
        for i = 1:10
            plot(handles.subAxes1,subx{i},suby{i},'o','markerfacecolor',cmap(i,:),'color','k');
        end
        legend(legendcell);
        hold off;
        
        set(handles.figure1,'currentAxes',handles.subAxes2);
        hold on;
        for i = 11:length(keepInds)
            plot(handles.subAxes2,subx2{i-10},suby2{i-10},'o','markerfacecolor',cmap(i,:),'color','k');
        end
        legend(legendcell2);
        hold off;
    end
    
end
set(handles.figure1,'currentAxes',handles.mainAxes);
hold off;

%__________________________________
function [sucExp] = exportALL(handles)

plotType = get(handles.subOption2,'value');
curMode = get(handles.subOption3,'value');
qVal = get(handles.subOption1,'value');
dataCell = get(handles.task4,'userdata');
cellStruc = dataCell{1};
groupStruc = dataCell{2};
tabdata = get(handles.table,'data');
s = size(tabdata);
counter = 1;
keepInds = -1;
for i = 1:s(1)
   if strcmp(tabdata(i,1),'on')
       keepInds(counter) = i;
       counter = counter+1;
   end
end

if plotType==1
   sucExp = exportTime(handles,qVal,keepInds,cellStruc);
else
   sucExp = exportBar(handles,qVal,curMode,keepInds,cellStruc,groupStruc); 
end

%_________________________________
function sucExp = exportBar(handles,qVal,curMode,keepInds,cellStruc,groupStruc)
outdir = [handles.rootDirectory,handles.slash,'ExportedFigures'];
outdir2 = [handles.rootDirectory,handles.slash,'ExportedResults'];
if keepInds~=-1
    if curMode==1
        Ncells = 0;
        for i = 1:length(keepInds)
            if groupStruc(keepInds(i)).Ncells>Ncells
                Ncells = groupStruc(keepInds(i)).Ncells;
            end
        end
        meanMat = ones(length(keepInds),Ncells).*NaN;
        stdMat = ones(length(keepInds),Ncells).*NaN;
        maxN = Ncells;
    else
        meanMat = zeros(length(keepInds),1);
        stdMat = zeros(length(keepInds),1);
        maxN = length(keepInds);
    end
    
    for i = 1:length(keepInds)
       if curMode==1
              Ncells = groupStruc(keepInds(i)).Ncells;
              startInd = groupStruc(keepInds(i)).cellStartInd;
              if qVal==1
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanBoxCar;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdBoxCar;
                  end
                  ystr = 'Box Car Motility';
              elseif qVal==2
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedist;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedist;
                  end
                  ystr = 'Sum Redist (pixels^2)';
              elseif qVal==3
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedistNorm;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedistNorm;
                  end
                  ystr = 'Norm Sum Redist';
              elseif qVal==4
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanArea;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdArea;
                  end
                  ystr = 'Area (pixels^2)';
              elseif qVal==5
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanBoxCarFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdBoxCarFiltered;
                  end
                  ystr = 'Box Car Motility Filtered';
              elseif qVal==6
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedistFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedistFiltered;
                  end
                  ystr = 'Sum Redist Filtered';
              elseif qVal==7
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanSumRedistNormFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdSumRedistNormFiltered;
                  end
                  ystr = 'Norm Sum Redist Filtered';
              elseif qVal==8
                  indArray = startInd:startInd+Ncells-1;
                  for j = 1:length(indArray)
                     meanMat(i,j) = cellStruc(indArray(j)).analysis.meanAreaFiltered;
                     stdMat(i,j) = cellStruc(indArray(j)).analysis.stdAreaFiltered;
                  end
                  ystr = 'Area Filtered (pixels^2)';
              end
        else
          if qVal==1
              meanMat(i) = groupStruc(i).mBoxCar;
              stdMat(i) = groupStruc(i).sBoxCar./sqrt(groupStruc(i).Ncells);
              ystr='Box Car Motility';
          elseif qVal==2
              meanMat(i) = groupStruc(i).mSumRedist;
              stdMat(i) = groupStruc(i).sSumRedist./sqrt(groupStruc(i).Ncells);
              ystr = 'Sum Redist (pixels^2)';
          elseif qVal==3
              meanMat(i) = groupStruc(i).mNSumRedist;
              stdMat(i) = groupStruc(i).sNSumRedist./sqrt(groupStruc(i).Ncells);
              ystr = 'Norm Sum Redist';
          elseif qVal==4
              meanMat(i) = groupStruc(i).mArea;
              stdMat(i) = groupStruc(i).sArea./sqrt(groupStruc(i).Ncells);
              ystr = 'Area (pixels^2)';
          elseif qVal==5
              meanMat(i) = groupStruc(i).mBoxCarF;
              stdMat(i) = groupStruc(i).sBoxCarF./sqrt(groupStruc(i).Ncells);
              ystr = 'Boxcar Motility Filtered';
          elseif qVal==6
              meanMat(i) = groupStruc(i).mSumRedistF;
              stdMat(i) = groupStruc(i).sSumRedistF./sqrt(groupStruc(i).Ncells);
              ystr = 'Sum Redist Filtered (pixels^2)';
          elseif qVal==7
              meanMat(i) = groupStruc(i).mNSumRedistF;
              stdMat(i) = groupStruc(i).sNSumRedistF./sqrt(groupStruc(i).Ncells);
              ystr = 'Norm Sum Redist Filtered';
          elseif qVal==8
              meanMat(i) = groupStruc(i).mAreaF;
              stdMat(i) = groupStruc(i).sAreaF./sqrt(groupStruc(i).Ncells);
              ystr = 'Area Filtered (pixels^2)';
          end
       end
    end
    h = figure;
    barweb(meanMat,stdMat,[],[],[],[],[],jet(maxN));
    box on; 
    ylabel(ystr,'fontsize',14);
    if curMode==1
        set(gca,'xtick',[1 2 3]);
        set(gca,'xticklabel',{'1','2','3'});
    end
    set(gca,'fontsize',14);
    date = clock();
    outstr1 = sprintf('%02.0f.%02.0f.%02.0f.%02.0f.%02.0f_',date(1),date(2),date(3),date(4),date(5));
    
    if qVal==1
        outstr2 = 'BoxCar';
    elseif qVal==2
        outstr2 = 'Redist';
    elseif qVal==3
        outstr2 = 'NRedist';
    elseif qVal==4
        outstr2 = 'Area';
    elseif qVal==5
        outstr2 = 'fBoxCar';
    elseif qVal==6
        outstr2 = 'fRedist';
    elseif qVal==7
        outstr2 = 'fNRedist';
    elseif qVal==8
        outstr2 = 'fArea';
    end
    if curMode==1
        outstr3 = ['BarC_',get(handles.userInput,'string')];
    else
        outstr3 = ['BarG_',get(handles.userInput,'string')];
    end
    outstr = [outstr1,outstr2,outstr3];
    saveas(h,[outdir,handles.slash,outstr,'.fig']);
    close(h);
    outstr = [outstr1,outstr2,outstr3];
    save([outdir2,handles.slash,outstr,'.mat'],'meanMat','stdMat');
    
    fid = fopen([outdir2,handles.slash,outstr,'.txt'],'wt');
    fprintf(fid,'Results of Bar Graph Export\n\n');
    fprintf(fid,'Quantity Exported:\t%s\n',outstr2);
    
    for i = 1:length(keepInds)
        projName = [groupStruc(keepInds(i)).projName,handles.slash];
        groupName = [groupStruc(keepInds(i)).groupName,handles.slash];
        dilation = groupStruc(keepInds(i)).dilation;
        groupPath = [projName,groupName,dilation];
        fprintf(fid,'Group %02.0f:\t%s\n',i,groupPath);
    end
    
    col1name = 'Group';
    col2name = 'Mean';
    col3name = 'StDev';
    col4name = 'StError';
    
    fprintf(fid,'\n\n%16s\t%16s\t%16s\t%16s\n',col1name,col2name,col3name,col4name);
    for i = 1:length(keepInds)
        if qVal==1
            mEnt = groupStruc(keepInds(i)).mBoxCar;
            sEnt = groupStruc(keepInds(i)).sBoxCar;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        elseif qVal==2
            mEnt = groupStruc(keepInds(i)).mSumRedist;
            sEnt = groupStruc(keepInds(i)).sSumRedist;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        elseif qVal==3
            mEnt = groupStruc(keepInds(i)).mNSumRedist;
            sEnt = groupStruc(keepInds(i)).sNSumRedist;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        elseif qVal==4
            mEnt = groupStruc(keepInds(i)).mArea;
            sEnt = groupStruc(keepInds(i)).sArea;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        elseif qVal==5
            mEnt = groupStruc(keepInds(i)).mBoxCarF;
            sEnt = groupStruc(keepInds(i)).sBoxCarF;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        elseif qVal==6
            mEnt = groupStruc(keepInds(i)).mSumRedistF;
            sEnt = groupStruc(keepInds(i)).sSumRedistF;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        elseif qVal==7
            mEnt = groupStruc(keepInds(i)).mNSumRedistF;
            sEnt = groupStruc(keepInds(i)).sNSumRedistF;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        elseif qVal==8
            mEnt = groupStruc(keepInds(i)).mAreaF;
            sEnt = groupStruc(keepInds(i)).sAreaF;
            Ncells = groupStruc(keepInds(i)).Ncells;
            s2Ent = sEnt/sqrt(Ncells);
        end
        gstr = sprintf('%02.0f',i);
        fprintf(fid,'%16s\t%16.12g\t%16.12g\t%16.12g\n',gstr,mEnt,sEnt,s2Ent);
    end
    fprintf(fid,'\n\n');
    col1name = 'Cell';
    for i = 1:length(keepInds)
        fprintf(fid,'-----\t-----\t-----\t-----\t-----\t-----\n');
        fprintf(fid,'Group %02.0f Cell Data:\n',i);
        fprintf(fid,'-----\t-----\t-----\t-----\t-----\t-----\n');  
        fprintf(fid,'%25s\t%16s\t%16s\t%16s\n',col1name,col2name,col3name,col4name);
        Ncells = groupStruc(keepInds(i)).Ncells;
        startInd = groupStruc(keepInds(i)).cellStartInd;
        indArray = startInd:startInd+Ncells-1;
        for j = 1:length(indArray)
            cellName = [cellStruc(indArray(j)).cellName,handles.slash];
            if qVal==1
                mEnt = cellStruc(indArray(j)).analysis.meanBoxCar;
                sEnt = cellStruc(indArray(j)).analysis.stdBoxCar;
                Ncells = length(cellStruc(indArray(j)).analysis.boxCar);
                s2Ent = sEnt/sqrt(Ncells);
            elseif qVal==2
                mEnt = cellStruc(indArray(j)).analysis.meanSumRedist;
                sEnt = cellStruc(indArray(j)).analysis.stdSumRedist;
                Ncells = length(cellStruc(indArray(j)).analysis.sumRedist);
                s2Ent = sEnt/sqrt(Ncells);
            elseif qVal==3
                mEnt = cellStruc(indArray(j)).analysis.meanSumRedistNorm;
                sEnt = cellStruc(indArray(j)).analysis.stdSumRedistNorm;
                Ncells = length(cellStruc(indArray(j)).analysis.sumRedistNorm);
                s2Ent = sEnt/sqrt(Ncells);
            elseif qVal==4
                mEnt = cellStruc(indArray(j)).analysis.meanArea;
                sEnt = cellStruc(indArray(j)).analysis.stdArea;
                Ncells = length(cellStruc(indArray(j)).analysis.area);
                s2Ent = sEnt/sqrt(Ncells);
            elseif qVal==5
                mEnt = cellStruc(indArray(j)).analysis.meanBoxCarFiltered;
                sEnt = cellStruc(indArray(j)).analysis.stdBoxCarFiltered;
                Ncells = length(cellStruc(indArray(j)).analysis.boxCarFiltered);
                s2Ent = sEnt/sqrt(Ncells);
            elseif qVal==6
                mEnt = cellStruc(indArray(j)).analysis.meanSumRedistFiltered;
                sEnt = cellStruc(indArray(j)).analysis.stdSumRedistFiltered;
                Ncells = length(cellStruc(indArray(j)).analysis.sumRedistFiltered);
                s2Ent = sEnt/sqrt(Ncells);
            elseif qVal==7
                mEnt = cellStruc(indArray(j)).analysis.meanSumRedistNormFiltered;
                sEnt = cellStruc(indArray(j)).analysis.stdSumRedistNormFiltered;
                Ncells = length(cellStruc(indArray(j)).analysis.sumRedistNormFiltered);
                s2Ent = sEnt/sqrt(Ncells);
            elseif qVal==8
                mEnt = cellStruc(indArray(j)).analysis.meanAreaFiltered;
                sEnt = cellStruc(indArray(j)).analysis.stdAreaFiltered;
                Ncells = length(cellStruc(indArray(j)).analysis.areaFiltered);
                s2Ent = sEnt/sqrt(Ncells);
            end
            fprintf(fid,'%25s\t%16.12g\t%16.12g\t%16.12g\n',cellName,mEnt,sEnt,s2Ent);
        end
    end
    fclose(fid);
    sucExp = 1;
else
    sucExp = 0;
end
imagesc(zeros(10,10),'parent',handles.subAxes1);
imagesc(zeros(10,10),'parent',handles.subAxes2);
%_________________________________
function [sucExp] = exportTime(handles,qVal,keepInds,cellStruc)

outdir = [handles.rootDirectory,handles.slash,'ExportedFigures'];
outdir2 = [handles.rootDirectory,handles.slash,'ExportedResults'];
if keepInds~=-1
    for i = 1:length(keepInds)
           timeArea = cellStruc(keepInds(i)).analysis.timeArea;
           timeDiff = cellStruc(keepInds(i)).analysis.timeDiffs;
           if qVal==1
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.boxCar]';
               ystr = 'BoxCar Motility';
           elseif qVal==2
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedist]';
               ystr = 'Sum Redist (pixels^2)';
           elseif qVal==3
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedistNorm]';
               ystr = 'Normalized Sum Redist';
           elseif qVal==4
               x{i} =  timeArea;
               y{i} =  [cellStruc(keepInds(i)).analysis.area]';
               ystr = 'Area (pixels)';
           elseif qVal==5
               x{i} =  timeArea(1:end-1);
               y{i} =  [cellStruc(keepInds(i)).analysis.cumuChange]';
               ystr = 'Cumulative Change (pixels^2)';
           elseif qVal==6
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.boxCarFiltered]';
               ystr = 'BoxCar Motility Filtered';
           elseif qVal==7
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedistFiltered]';
               ystr = 'Sum Redist Filtered (pixels^2)';
           elseif qVal==8
               x{i} =  timeDiff;
               y{i} =  [cellStruc(keepInds(i)).analysis.sumRedistNormFiltered]';
               ystr = 'Normalized Sum Redist Filtered';
           elseif qVal==9
               x{i} =  timeArea;
               y{i} =  [cellStruc(keepInds(i)).analysis.areaFiltered]';
               ystr = 'Area Filtered (pixels^2)';
           else 
               x{i} =  timeArea(1:end-1);
               y{i} =  [cellStruc(keepInds(i)).analysis.cumuChangeFiltered]';
               ystr = 'Cumulative Change Filtered (pixels^2)';
           end
           legendcell{i} = sprintf('%d',i);
    end

    if length(keepInds)<=5
        cmap = [0 0 1; 1 0 0; 0 1 0;1 1 0;1 0 1];
    else
        cmap = jet(length(keepInds));
    end
    
    h=figure;
    for i = 1:length(keepInds)
        if i ==1
           minx = min(x{i});
           miny = min(y{i});
           maxx = max(x{i});
           maxy = max(y{i});
        else
           if min(x{i})<minx
               minx = min(x{i});
           end
           if min(y{i})<miny
               miny = min(y{i});
           end
           if max(x{i})>maxx
               maxx = max(x{i});
           end
           if max(y{i})>maxy
               maxy = max(y{i});
           end
        end
        plot(x{i},y{i},'-o','markerfacecolor',cmap(i,:),'color','k','markersize',8); 
        hold on;
        xlabel('Time (min)','fontsize',14);
        ylabel(ystr,'fontsize',14);
    end
    set(gca,'fontsize',14);
    legend(legendcell);
    date = clock();
    outstr1 = sprintf('%02.0f.%02.0f.%02.0f.%02.0f.%02.0f_',date(1),date(2),date(3),date(4),date(5));
    stepx = minx*0.001;
    stepy = miny*0.001;
    xlim(gca,[minx-stepx maxx+stepx]);
    ylim(gca,[miny-stepy maxy+stepy]);
    if qVal==1
        outstr2 = 'BoxCar';
    elseif qVal==2
        outstr2 = 'Redist';
    elseif qVal==3
        outstr2 = 'NRedist';
    elseif qVal==4
        outstr2 = 'Area';
    elseif qVal==5
        outstr2 = 'fCumuChange';
    elseif qVal==6
        outstr2 = 'fBoxCar';
    elseif qVal==7
        outstr2 = 'fRedist';
    elseif qVal==8
        outstr2 = 'fNRedist';
    elseif qVal==9
        outstr2 = 'fArea';
    elseif qVal==10
        outstr2 = 'fCumuChange';
    end
    outstr3 = ['VsT_',get(handles.userInput,'string')];
    outstr = [outstr1,outstr2,outstr3];
    saveas(h,[outdir,handles.slash,outstr,'.fig']);
    close(h);
    outstr = [outstr1,outstr2,outstr3];
    save([outdir2,handles.slash,outstr,'.mat'],'x','y');
    
    fid = fopen([outdir2,handles.slash,outstr,'.txt'],'wt');
    fprintf(fid,'Results of Time Export\n\n');
    fprintf(fid,'Quantity Exported:\t%s\n',outstr2);
    for i = 1:length(keepInds)
        projName = [cellStruc(keepInds(i)).projName,handles.slash];
        groupName = [cellStruc(keepInds(i)).groupName,handles.slash];
        cellName = [cellStruc(keepInds(i)).cellName,handles.slash];
        dilation = [cellStruc(keepInds(i)).dilation];
        cellpath = [projName,groupName,cellName,dilation];
        fprintf(fid,'Cell %02.0f:\t%s\n',i,cellpath);
    end
    fprintf(fid,'\n\n');
    for i = 1:length(keepInds)
       fprintf(fid,'%16s\t','Time (min)');
       colname = sprintf('Cell %02.0f',i); 
       fprintf(fid,'%16s\t',colname);
       if i ==1
          T = length(x{i});
       else
          if length(x{i})>T
              T = length(x{i});
          end
       end
    end
    blank = '            ';
    fprintf(fid,'\n');
    for t = 1:T
        for i = 1:length(keepInds)
            if t<=length(x{i})
               fprintf(fid,'%16.12g\t',x{i}(t),y{i}(t)); 
            else
               fprintf(fid,'%16s\t',blank,blank); 
            end
        end
        fprintf(fid,'\n');
    end    
    fclose(fid);
    sucExp = 1;
else
    sucExp = 0;
end

%________________________
function handles = turnOFFbutton(handles)

set(handles.option1,'enable','off');
set(handles.subOption1,'enable','off');
set(handles.subOption2,'enable','off');
set(handles.subOption3,'enable','off');
set(handles.table,'enable','off');

%________________________
function handles = turnONbutton(handles)

set(handles.option1,'enable','on');
set(handles.subOption1,'enable','on');
set(handles.subOption2,'enable','on');
set(handles.subOption3,'enable','on');
set(handles.table,'enable','on');
