function [] = loadDilatedImages(hObject,handles,eventdata,extraData)



% do function
tag = get(hObject,'tag');
if strcmp(tag,'function1')
    set(handles.subOption1,'value',1);
    set(handles.subOption2,'value',1);
    set(handles.subOption3,'value',1);
    set(handles.subOption4,'value',1);
    iteration = get(handles.enter,'userdata');
    if iteration==0  
       loadListbox([],handles,[],handles.rootDirectory);
       handles = refreshTable(handles);
       set(handles.prompt,'string','Navigate to the Dilated Image files you''d like to work with using the table.');
       set(handles.function2,'enable','off');
       set(handles.function3,'enable','off');
       set(handles.function4,'enable','off');
       set(handles.function5,'enable','off');
       set(handles.function6,'enable','off');
       set(handles.function7,'enable','off');
    else
       set(handles.prompt,'string','Warning, reloading images before saving the current work will result in losing all unsaved data.  If are sure you want to reload, click Continue in the option panel above.  If you would like to keep working with this file, click Cancel.'); 
       set(handles.option1,'string','Continue');
       set(handles.option1,'enable','on');
       set(handles.option2,'string','Cancel');
       set(handles.option2,'enable','on');
       set(handles.table,'data','');
       set(handles.table,'columnname',{'Table Data'});
       load(handles.tableProps);
       set(handles.table,'columnwidth',{tableProps.width{1}});
    end
elseif strcmp(tag,'table')
    handles = changeFolders(handles,extraData);
elseif strcmp(tag,'option1')
    set(handles.task2,'userdata','');
    loadListbox([],handles,[],handles.rootDirectory);
    handles = refreshTable(handles);
    set(handles.enter,'userdata',0);
    set(handles.prompt,'string','Navigate to the Dilated Image files you''d like to work with using the table.');
    handles = blankTheAxes(handles,1);
    handles = blankTheAxes(handles,2);
    handles = blankTheAxes(handles,3);
    set(handles.function2,'enable','off');
    set(handles.function3,'enable','off');
    set(handles.function4,'enable','off');
    set(handles.function5,'enable','off');
    set(handles.function6,'enable','off');
    set(handles.function7,'enable','off');
elseif strcmp(tag,'option2')
    set(handles.prompt,'string','');
elseif strcmp(tag,'userInput')   
    num = str2double(get(handles.userInput,'string'));
    if isnan(num)
        set(handles.prompt,'string','Error:  The input is not a number.  Please re-enter the timestep in minutes, without units');
    else
        imStruc = get(handles.task3,'userdata');
        imStruc.timestep = num;
        set(handles.task3,'userdata',imStruc);
        dirpath = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter',handles.slash,'freqInfo.mat'];
        dirpath2 = [imStruc.pathB4,handles.slash,'Results',handles.slash,'timepointList.mat'];
        if exist(dirpath2,'file')
            load(dirpath2);
            imStruc.timepointList = timepointList;
            for i = 1:length(timepointList)
                tlistTable{i,1} = sprintf('%0.3f',(i-1)*imStruc.timestep);
               if timepointList(i)==1
                  tlistTable{i,2} = 'on';
               else
                  tlistTable{i,2} = 'OFF'; 
               end
            end
        else
            timepointList = ones(imStruc.T,1);
            imStruc.timepointList = timepointList;
            save(dirpath2,'timepointList');
            for i = 1:length(timepointList)
                tlistTable{i,1} = sprintf('%0.3f',(i-1)*imStruc.timestep);
               if timepointList(i)==1
                  tlistTable{i,2} = 'on';
               else
                  tlistTable{i,2} = 'OFF'; 
               end
            end
        end
        imStruc.tlistTable = tlistTable;
        [timeArea,timeDiffs,picArea,picDiffs,diffList] = sortIncludedPoints(timepointList,imStruc);
        imStruc.diffList = diffList;
        imStruc.currentTime = timeDiffs(1);
        imStruc.timeArea = timeArea;
        imStruc.timeDiffs = timeDiffs;
        imStruc.picArea = picArea;
        imStruc.picDiffs = picDiffs;
        if exist(dirpath,'file');
            set(handles.prompt,'string','Loading Data ...');
            pause(0.1);
            load(dirpath);
            imStruc.fs = freqInfo.fs;                    % sampling frequency
            imStruc.freq = freqInfo.freq;                  % frequency array
            imStruc.amplitude = freqInfo.amplitude;             % amplitude power spectra matrix  
            imStruc.centerFreq = freqInfo.centerFreq;            % center frequency matrix
            imStruc.pix = freqInfo.pix;                    % pixel intensity cell
            imStruc.time = freqInfo.time;                  % time cell
            imStruc.maxFreq = freqInfo.maxFreq;
            imStruc.freqStep = freqInfo.freqStep;
            imStruc.FFT = freqInfo.FFT;
            imStruc.currentLow = freqInfo.currentLow;
            imStruc.currentHigh = freqInfo.currentHigh;
            imStruc.currentThresh = freqInfo.currentThresh;
            imStruc.maxThresh = freqInfo.maxThresh;
            imStruc.iCurrent = freqInfo.iCurrent;
            imStruc.jCurrent = freqInfo.jCurrent;
            imStruc.maxI = freqInfo.maxI;
            imStruc.maxJ = freqInfo.maxJ;
            set(handles.function4,'enable','on');
        else
           set(handles.function4,'enable','off'); 
        end
        set(handles.task3,'userdata',imStruc);
        set(handles.function2,'enable','on');
        set(handles.function3,'enable','on');
        set(handles.function5,'enable','on');
        set(handles.enter,'userdata',1);
        set(handles.prompt,'string','You may begin by measuring pixel frequencies and then defining a frequency filter.  You may also proceed immediately to calculate the results without a filter.  NOTE: DEFINING A FILTER WITH TOO FEW TIMEPOINTS WILL RESULT IN A BAD FILTER.  For this reason, all results will be saved without the filter applied, and the filtered images will be saved separately.');
        set(handles.userInput,'string','');
        set(handles.userInput,'enable','off');
        set(handles.enter,'enable','off');
    end
end


% define new control variables
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
tdata.task = tdata.task;
f = fdata(1);
p = fdata(2);
if strcmp(tag,'option1')||strcmp(tag,'option2')
    o = 0;
else
    o = odata(1);
end
so = odata(2);
tdata.button = tdata.button;
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);

%_______________________________________

function [handles] = refreshTable(handles)

colname = 'Sub-directory';
excludeList = {'.','..','.DS_Store','ExportedResults','ExportedFigures','EdgeA','EdgeB','Global_Data','Raw_Images','Results','Figures','Movies'};
dirData = dir();
dirIndex = [dirData.isdir];
dirList = {dirData(dirIndex).name};
validIndex = ~ismember(dirList,excludeList);
keepDirs = dirList(validIndex)';
if ~strcmp(pwd,handles.rootDirectory)
    finDirs = cell(length(keepDirs)+1,1);
    finDirs(1) = {'Move Back One Folder'};
    finDirs(2:length(keepDirs)+1,1)= keepDirs;
else
    finDirs = keepDirs;
end
set(handles.table,'data',finDirs);
set(handles.table,'columnname',colname);

%_________________________________________

function [handles] = changeFolders(handles,extraData)

if strcmp(extraData,'Move Back One Folder')
    cd('..');
    loadListbox([],handles,[],pwd);
    handles = refreshTable(handles);
else
    testDilA = strcmp(extraData,'DilationA');
    testDilB = strcmp(extraData,'DilationB');
    cd([pwd,handles.slash,extraData]);
    if testDilA==1||testDilB==1
        imStruc.path = pwd;
        if testDilA==1
            imStruc.whichDil = 'DilationA';
        else
            imStruc.whichDil = 'DilationB';
        end
        cd('..');
        cd('..');
        imStruc.pathB4 = pwd;
        pathRAW = [imStruc.pathB4,handles.slash,'Raw_Images',handles.slash,'RawPictures',handles.slash];
        cd(pathRAW);
        dirRAW = dir('*.tif');
        cd(imStruc.path);
        dirPNG = dir('*.png');
        if length(dirPNG)==0
            set(handles.prompt,'string','Error:  Picture Files Missing!');
            cd(handles.rootDirectory);
            loadListbox([],handles,[],pwd);
            handles = refreshTable(handles);
        else
            L = length(dirPNG);
            imStruc.T = L;
            imStruc.dilPics = cell(L,1);
            for i = 1:L
                imStruc.dilPics{i} = double(imread(dirPNG(i).name))/255;   
            end
            imStruc.calcsDone = 0;
            imStruc.currentIndex = 1;
            imStruc.currentBoxPicT1 = 1;
            imStruc.currentBoxPicT2 = 2;
            imStruc.currentDiffPicT1 = 1;
            imStruc.currentDiffPicT2 = 2;
            imStruc.currentIndex = 1;
            imStruc.filtON = 0;
            s = size(imStruc.dilPics{1});
            imStruc.sizePic = s;
            set(handles.figure1,'currentAxes',handles.mainAxes);
            imagesc(imStruc.dilPics{1},'Parent',handles.mainAxes);
            colormap(handles.mainAxes,handles.cmap_colour);
            loadListbox([],handles,[],pwd);
            set(handles.task3,'userdata',imStruc);
            set(handles.table,'enable','off');
            set(handles.table,'data','');
            set(handles.table,'columnname',{'Table Data'});
            set(handles.userInput,'enable','on');
            set(handles.enter,'enable','on');
            set(handles.prompt,'string','Please input the timestep in minutes and click/press enter when done');
        end
    else
        loadListbox([],handles,[],pwd);
        handles = refreshTable(handles);
    end
end
