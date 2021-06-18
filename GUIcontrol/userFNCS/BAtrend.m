function [] = BAtrend(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');
dataCell = get(handles.task4,'userdata');
groupStruc = dataCell{2};
if strcmp(tag,'function3')
    handles = initializeALL(handles);
elseif strcmp(tag,'subOption1')||strcmp(tag,'subOption2')||strcmp(tag,'subOption3')
    handles = updateAxes(handles);
elseif strcmp(tag,'option1')
    handles = turnOFFbutton(handles);
    set(handles.userInput,'enable','on');
    set(handles.prompt,'string','Enter a comment for the export filenames and press enter when done.');
elseif strcmp(tag,'userInput')
    set(handles.userInput,'enable','off');
    exportALL(handles);
    handles = turnONbutton(handles);
    set(handles.userInput,'string','');
elseif strcmp(tag,'table')
    ind = eventdata.Indices(1);
    projName = groupStruc(ind).projName;
    groupName = groupStruc(ind).groupName;
    dirpath = [handles.rootDirectory,handles.slash,projName,handles.slash,groupName];
    loadListbox([],handles,[],dirpath);
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
tabDatGroup = tabdata{2};
tabDatGroup = tabDatGroup(:,2:4);
varList = {'meanBoxCar','meanSumRedist','meanNormSumRedist','meanArea','meanBoxCarFilt',...
    'meanSumRedistFilt','meanNormSumRedistFilt','meanAreaFilt'}; 
set(handles.subOption1,'string',varList);
set(handles.table,'columnname',{'Dil','Group','Project'});
load(handles.tableProps);
col1 = tableProps.width{21};
col2 = tableProps.width{22};
col3 = tableProps.width{23};
set(handles.table,'columnwidth',{col1,col2,col3});
set(handles.table,'data',tabDatGroup);

set(handles.option1,'value',0);
set(handles.option2,'value',0);
set(handles.option3,'value',0);
set(handles.option4,'value',0);
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);

set(handles.subOption1,'string',varList);
s = size(tabDatGroup);
L = s(1);
for i = 1:L
   bgrouplist{i} = sprintf('Before-Group %02.0f',i); 
   agrouplist{i} = sprintf('After-Group %02.0f',i); 
end
set(handles.subOption2,'string',bgrouplist);
set(handles.subOption3,'string',agrouplist);

handles = updateAxes(handles);

%____________________________
function handles = exportALL(handles)

outdir = [handles.rootDirectory,handles.slash,'ExportedFigures'];
outdir2 = [handles.rootDirectory,handles.slash,'ExportedResults'];

dataCell = get(handles.task4,'userdata');
cellStruc = dataCell{1};
groupStruc = dataCell{2};
qVal = get(handles.subOption1,'value');
bVal = get(handles.subOption2,'value');
aVal = get(handles.subOption3,'value');

Nb = groupStruc(bVal).Ncells;
Na = groupStruc(aVal).Ncells;

if Na==Nb
    startIndB = groupStruc(bVal).cellStartInd;
    indArrayB = startIndB:startIndB+Nb-1;
    startIndA = groupStruc(aVal).cellStartInd;
    indArrayA = startIndA:startIndA+Na-1;
    mMat = zeros(Na,2);
    sMat = zeros(Na,2);
    s2Mat = zeros(Na,2);
    cmap = jet(Na);
    for i = 1:length(indArrayB)
        if qVal==1
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanBoxCar; 
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdBoxCar;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.boxCar));
        elseif qVal==2
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedist;
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdSumRedist;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.sumRedist));
        elseif qVal==3
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedistNorm;
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdSumRedistNorm;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.sumRedistNorm));
        elseif qVal==4
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanArea;
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdArea;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.area));
        elseif qVal==5
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanBoxCarFiltered; 
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdBoxCarFiltered;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.boxCarFiltered));
        elseif qVal==6
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedistFiltered;
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdSumRedistFiltered;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.sumRedistFiltered));
        elseif qVal==7
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedistNormFiltered;
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdSumRedistNormFiltered;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.sumRedistNormFiltered));
        elseif qVal==8
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanAreaFiltered;
            sMat(i,1) = cellStruc(indArrayB(i)).analysis.stdAreaFiltered;
            s2Mat(i,1) = sMat(i,1)/sqrt(length(cellStruc(indArrayB(i)).analysis.areaFiltered));
        end
    end
    
    for i = 1:length(indArrayA)
        if qVal==1
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanBoxCar; 
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdBoxCar;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.boxCar));
        elseif qVal==2
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedist;
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdSumRedist;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.sumRedist));
        elseif qVal==3
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedistNorm;
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdSumRedistNorm;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.sumRedistNorm));
        elseif qVal==4
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanArea;
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdArea;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.area));
        elseif qVal==5
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanBoxCarFiltered; 
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdBoxCarFiltered;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.boxCarFiltered));
        elseif qVal==6
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedistFiltered;
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdSumRedistFiltered;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.sumRedistFiltered));
        elseif qVal==7
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedistNormFiltered;
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdSumRedistNormFiltered;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.sumRedistNormFiltered));
        elseif qVal==8
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanAreaFiltered;
            sMat(i,2) = cellStruc(indArrayA(i)).analysis.stdAreaFiltered;
            s2Mat(i,2) = sMat(i,2)/sqrt(length(cellStruc(indArrayA(i)).analysis.areaFiltered));
        end
    end
    h = figure;
    for i = 1:Na
        plot([1,2],mMat(i,:),'-o','markerfacecolor',cmap(i,:),'color','k','markersize',8); 
        hold on;
    end
    meanB = mean(mMat(:,1));
    meanA = mean(mMat(:,2));
    stdB = std(mMat(:,1));
    stdA = std(mMat(:,2));
    miny = min(mMat(:))-0.01*min(mMat(:));
    maxy = max(mMat(:))+0.01*max(mMat(:));
    line([1,2],[meanB,meanA],'color','k','linewidth',3);
    axis([0.99 2.01 miny maxy]);
    set(gca,'xtick',[1,2]);
    set(gca,'xticklabel',{'Before','After'});
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
    outstr3 = ['Trend_',get(handles.userInput,'string')];
    set(handles.prompt,'string',sprintf('Files have been exported to %s and %s',outdir,outdir2));
    outstr = [outstr1,outstr2,outstr3];
    saveas(h,[outdir,handles.slash,outstr,'.fig']);
    close(h);
    outstr = [outstr1,outstr2,outstr3];
    save([outdir2,handles.slash,outstr,'.mat'],'mMat','meanB','meanA');
    
    fid = fopen([outdir2,handles.slash,outstr,'.txt'],'wt');
    fprintf(fid,'Results of Before/After Trend Export\n\n');
    fprintf(fid,'Quantity Exported:\t%s\n',outstr2);
    
    projName1 = [groupStruc(bVal).projName,handles.slash];
    groupName1 = [groupStruc(bVal).groupName,handles.slash];
    dilation1 = groupStruc(bVal).dilation;
    groupPath1 = [projName1,groupName1,dilation1];
    fprintf(fid,'Before Group:\t%s\n',groupPath1);
   
    projName2 = [groupStruc(aVal).projName,handles.slash];
    groupName2= [groupStruc(aVal).groupName,handles.slash];
    dilation2 = groupStruc(aVal).dilation;
    groupPath2 = [projName2,groupName2,dilation2];
    fprintf(fid,'After Group:\t%s\n',groupPath2);
    
    col1name = 'Group';
    col2name = 'Mean';
    col3name = 'StDev';
    col4name = 'StError';
    
    
    gstr{1}  = sprintf('%s','Before');
    gstr{2}  = sprintf('%s','After');
    fprintf(fid,'\n\n%16s\t%16s\t%16s\t%16s\n',col1name,col2name,col3name,col4name);
    fprintf(fid,'%16s\t%16.12g\t%16.12g\t%16.12g\n',gstr{1},meanB,stdB,stdB/sqrt(Nb));
    fprintf(fid,'%16s\t%16.12g\t%16.12g\t%16.12g\n',gstr{2},meanA,stdA,stdA/sqrt(Na));
    fprintf(fid,'\n\n');
    col1name = 'Cell';
    fprintf(fid,'-----\t-----\t-----\t-----\t-----\t-----\n');
    fprintf(fid,'Before Group Cell Data:\n',i);
    fprintf(fid,'-----\t-----\t-----\t-----\t-----\t-----\n');  
    fprintf(fid,'%25s\t%16s\t%16s\t%16s\n',col1name,col2name,col3name,col4name);
    startInd = groupStruc(bVal).cellStartInd;
    indArray = startInd:startInd+Nb-1;
    for j = 1:length(indArray)
        cellName = [cellStruc(indArray(j)).cellName,handles.slash];
        fprintf(fid,'%25s\t%16.12g\t%16.12g\t%16.12g\n',cellName,mMat(j,1),sMat(j,1),s2Mat(j,1));
    end 
    fprintf(fid,'-----\t-----\t-----\t-----\t-----\t-----\n');
    fprintf(fid,'After Group Cell Data:\n',i);
    fprintf(fid,'-----\t-----\t-----\t-----\t-----\t-----\n');  
    fprintf(fid,'%25s\t%16s\t%16s\t%16s\n',col1name,col2name,col3name,col4name);
    startInd = groupStruc(aVal).cellStartInd;
    indArray = startInd:startInd+Na-1;
    for j = 1:length(indArray)
        cellName = [cellStruc(indArray(j)).cellName,handles.slash];
        fprintf(fid,'%25s\t%16.12g\t%16.12g\t%16.12g\n',cellName,mMat(j,2),sMat(j,2),s2Mat(j,2));
    end
    fclose(fid);
else
    set(handles.prompt,'string','Cannot compare groups, since there are different numbers of cells in the defined before and after groups.');   
end

set(handles.figure1,'currentAxes',handles.mainAxes);
hold off;
%____________________________
function handles = updateAxes(handles)

dataCell = get(handles.task4,'userdata');
cellStruc = dataCell{1};
groupStruc = dataCell{2};
qVal = get(handles.subOption1,'value');
bVal = get(handles.subOption2,'value');
aVal = get(handles.subOption3,'value');

Nb = groupStruc(bVal).Ncells;
Na = groupStruc(aVal).Ncells;

if Na==Nb
    set(handles.prompt,'string','Choose the before and after groups using the pulldown menus.  Export figures and data at any time, the output will be what is shown in the figure.'); 
    startIndB = groupStruc(bVal).cellStartInd;
    indArrayB = startIndB:startIndB+Nb-1;
    startIndA = groupStruc(aVal).cellStartInd;
    indArrayA = startIndA:startIndA+Na-1;
    mMat = zeros(Na,2);
    cmap = jet(Na);
    for i = 1:length(indArrayB)
        if qVal==1
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanBoxCar; 
        elseif qVal==2
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedist;
        elseif qVal==3
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedistNorm;
        elseif qVal==4
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanArea;
        elseif qVal==5
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanBoxCarFiltered; 
        elseif qVal==6
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedistFiltered;
        elseif qVal==7
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanSumRedistNormFiltered;
        elseif qVal==8
            mMat(i,1) = cellStruc(indArrayB(i)).analysis.meanAreaFiltered;
        end
    end
    
    for i = 1:length(indArrayA)
        if qVal==1
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanBoxCar; 
        elseif qVal==2
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedist;
        elseif qVal==3
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedistNorm;
        elseif qVal==4
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanArea;
        elseif qVal==5
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanBoxCarFiltered; 
        elseif qVal==6
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedistFiltered;
        elseif qVal==7
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanSumRedistNormFiltered;
        elseif qVal==8
            mMat(i,2) = cellStruc(indArrayA(i)).analysis.meanAreaFiltered;
        end
    end
    imagesc(zeros(10,10),'parent',handles.mainAxes);
    set(handles.figure1,'currentAxes',handles.mainAxes);
    
    for i = 1:Na
       plot(handles.mainAxes,[1,2],mMat(i,:),'-o','markerfacecolor',cmap(i,:),'color','k','markersize',8); 
        hold on;
    end
    meanB = mean(mMat(:,1));
    meanA = mean(mMat(:,2));
    miny = min(mMat(:))-0.01*min(mMat(:));
    maxy = max(mMat(:))+0.01*max(mMat(:));
    line([1,2],[meanB,meanA],'color','k','linewidth',3);
    axis([0.99 2.01 miny maxy]);
    set(handles.mainAxes,'xtick',[1,2]);
    set(handles.mainAxes,'xticklabel',{'Before','After'});
else
    set(handles.prompt,'string','Cannot compare groups, since there are different numbers of cells in the defined before and after groups.');   
end

set(handles.figure1,'currentAxes',handles.mainAxes);
hold off;

%________________________
function handles = turnOFFbutton(handles)

set(handles.option1,'enable','off');
set(handles.subOption1,'enable','off');
set(handles.subOption2,'enable','off');
set(handles.subOption3,'enable','off');


%________________________
function handles = turnONbutton(handles)

set(handles.option1,'enable','on');
set(handles.subOption1,'enable','on');
set(handles.subOption2,'enable','on');
set(handles.subOption3,'enable','on');

