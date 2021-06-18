function [] = loadRawImage(hObject,handles,eventdata,extraData)

% this function loads a raw image file into the GUI for image processing

% do function
tag = get(hObject,'tag');
if strcmp(tag,'function1')
    % initialize the function
    handles = initializeALL(handles);
elseif strcmp(tag,'table')
    % navigate to the desired folder and load Data when done
    handles = changeFolders(handles,extraData);
elseif strcmp(tag,'option1')
    % if the user wants to load a new image, do these steps to reset the
    % function to initial state
    set(handles.task2,'userdata','');
    loadListbox([],handles,[],handles.rootDirectory);
    handles = refreshTable(handles);
    set(handles.enter,'userdata',0);
    set(handles.prompt,'string','Navigate to the Raw Image file you''d like to work with using the table.');
    handles = blankTheAxes(handles,1);
    handles = blankTheAxes(handles,2);
    handles = blankTheAxes(handles,3);
    set(handles.prompt,'string','Navigate to the Raw Image file you''d like to work with using the table.');
    set(handles.function2,'enable','off');
    set(handles.function3,'enable','off');
    set(handles.function4,'enable','off');
    set(handles.function5,'enable','off');
    set(handles.function6,'enable','off');
    set(handles.function7,'enable','off');
elseif strcmp(tag,'option2')
    % if the user wants to cancel loading a new image, do nothing
    set(handles.prompt,'string','');
elseif strcmp(tag,'userInput')
    % check that the input timestep is a number and then check if data
    % analysis has already been performed on this cell
    handles = checkForData(handles);
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
so = 0;
tdata.button = tdata.button;
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);

%_______________________________________
function [handles] = initializeALL(handles)
% initialize after function button click
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);
set(handles.subOption1,'enable','off');
set(handles.subOption1,'string','--');
set(handles.option3,'string','--');
set(handles.option4,'string','--');
set(handles.option3,'enable','off');
set(handles.option4,'enable','off');
iteration = get(handles.enter,'userdata'); 
if iteration==0
   loadListbox([],handles,[],handles.rootDirectory);
   handles = refreshTable(handles);
   set(handles.prompt,'string','Navigate to the Raw Image file you''d like to work with using the table.');
   set(handles.function2,'enable','off');
   set(handles.function3,'enable','off');
   set(handles.function4,'enable','off');
   set(handles.function5,'enable','off');
   set(handles.function6,'enable','off');
   set(handles.function7,'enable','off');
else
   set(handles.prompt,'string','Warning, reloading a Raw image before saving the current work will result in losing all unsaved data.  If are sure you want to reload, click Continue in the option panel above.  If you would like to keep working with this file, click Cancel.'); 
   set(handles.option1,'string','Continue');
   set(handles.option1,'enable','on');
   set(handles.option2,'string','Cancel');
   set(handles.option2,'enable','on');
   imStruc = get(handles.task2,'userdata');
   imStruc.cropPreviewA = 'DNE';
   imStruc.cropPreviewB = 'DNE';
   set(handles.task2,'userdata',imStruc);
end
%_______________________________________

function [handles] = refreshTable(handles)

colname = 'Sub-directory';
excludeList = {'.','..','.DS_Store','ExportedResults','ExportedFigures'};
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

% this function navigates to the raw image folder 
% the user is only allowed to stay within the bounds of the project folder
% root directory
% the user is forced to choose the correct file
% an data structure is created and initialized with default values to be
% used in the remaining functions for task 2

if strcmp(extraData,'Move Back One Folder')
    cd('..');
    loadListbox([],handles,[],pwd);
    handles = refreshTable(handles);
else
    cd([pwd,handles.slash,extraData]);
    dirData = dir();
    testRaw = strcmp({dirData.name},'Raw_Images');
    if sum(testRaw)==1
        dirpath = pwd;
        cd('Raw_Images');
        dirTiff = dir('*.tif');
        if length(dirTiff)>1
            set(handles.prompt,'string','Error:  Too many tif files in the Raw Folder.  Please remove all but one');
            cd(handles.rootDirectory);
            loadListbox([],handles,[],pwd);
            handles = refreshTable(handles);
        else
            test = imfinfo(dirTiff(1).name);
            L = length(test);
            imdata = cell(L,1);
            imStruc.crop_picsA = cell(L,1);
            imStruc.crop_picsB = cell(L,1);
            imStruc.edge_picsA = cell(L,1);
            imStruc.edge_picsB = cell(L,1);
            mkdir([pwd,handles.slash,'RawPictures']);
            for i = 1:L
                imdata{i} = double(imread(dirTiff(1).name,'index',i));   
                s = size(imdata{i});
                imStruc.crop_picsA{i} = ones(s(1),s(2));
                imStruc.crop_picsB{i} = ones(s(1),s(2));
                imStruc.edge_picsA{i} = zeros(s(1),s(2));
                imStruc.edge_picsB{i} = zeros(s(1),s(2));
                grayimg = mat2gray(imdata{i});
                indimg = gray2ind(grayimg,50);
                RGB = ind2rgb(indimg,jet(50));
                filename = [pwd,handles.slash,'RawPictures',handles.slash,sprintf('im%04.0f.tif',i)];
                imwrite(RGB,filename,'tif');
            end
            imStruc.pathB4 = dirpath;
            imStruc.path = pwd;
            imStruc.rawimage = imdata;
            imStruc.T = L;   
            imStruc.currentIndex = 1;
            imStruc.currentTime = 0;
            imStruc.currentThreshA = 0.05;
            imStruc.currentRadiusA = 7;
            imStruc.currentMinAreaA = 30;
            imStruc.currentTimeB = 0;
            imStruc.currentThreshB = 0.05;
            imStruc.currentRadiusB = 1;
            imStruc.currentMinAreaB = 30;
            imStruc.currentScale = 1;
            imStruc.dilAstate =0;
            imStruc.dilBstate =0;
            imStruc.currentDilA = 6;
            imStruc.currentDilB = 6; 
            imStruc.savedScale = 1;
            imStruc.savedRadiusB = 1;
            imStruc.savedMinAreaB = 30;
            maxI = zeros(imStruc.T,1);
            for i = 1:imStruc.T
                 maxI(i) = max(imStruc.rawimage{i}(:));
            end
            imStruc.maxI = max(maxI);
            imStruc.currentRaw = imStruc.rawimage{1};


            s = size(imStruc.currentRaw);
            imStruc.maxS = max(s);
            imStruc.maxRadiusB = max(s)/5;
            imStruc.maxMinAreaB = max(s);
            imStruc.maxScaleB = 5;
            imStruc.maxRadiusA = max(s)/5;
            imStruc.maxMinAreaA = max(s);
            imStruc.maxDil = 10;
            imStruc.cropPreviewA = 'DNE';
            imStruc.cropPreviewB = 'DNE';
            imStruc.currentEdgeA = imStruc.edge_picsA{1};
            imStruc.currentEdgeB = imStruc.edge_picsB{1};
            edgePathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'EdgeA',handles.slash];
            edgePathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'EdgeB',handles.slash];
            dilPathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationA',handles.slash];
            dilPathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationB',handles.slash];
            cropPathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'CropA',handles.slash]; 
            cropPathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'CropB',handles.slash]; 
            
            if isdir(edgePathA)||isdir(edgePathB)||isdir(dilPathA)||isdir(dilPathB)||isdir(cropPathA)||isdir(cropPathB)
                set(handles.subOption1,'string',{'Start Over','Load Previous'});
                set(handles.subOption1,'value',2);
            else
                set(handles.subOption1,'string',{'Start Over'});
            end
            set(handles.subOption1,'enable','on');
            
            set(handles.figure1,'currentAxes',handles.mainAxes);
            imagesc(imdata{1},'Parent',handles.mainAxes);
            colormap(handles.mainAxes,handles.cmap_colour);
            currentZoom = imrect(handles.mainAxes,[15 15 s(2)-29 s(1)-29]);
            imStruc.posZoom = getPosition(currentZoom);
            imStruc.posZoomScaled = imStruc.posZoom;
            delete(currentZoom);
            loadListbox([],handles,[],pwd);
            set(handles.task2,'userdata',imStruc);
            set(handles.table,'enable','off');
            set(handles.table,'data','');
            set(handles.table,'columnname',{'Table Data'});
            set(handles.userInput,'enable','on');
            set(handles.enter,'enable','on');
            set(handles.prompt,'string','Please input the timestep in minutes and click/press enter when done.  You may select whether to load a previous analysis or to start from scratch using the pulldown menu.');
        end
    else
        loadListbox([],handles,[],pwd);
        handles = refreshTable(handles);
    end
end

%_________________________________
function handles = checkForData(handles)

% check that the input is a number
% if number, check if an existing edge detection/crop/dilation exists for
% this raw image
% if it does initialize the parameters so that the user starts at the same
% state they left off

numstr = get(handles.userInput,'string');
num = str2double(numstr);

if isnan(num)
    set(handles.prompt,'string','Error:  The input is not a number.  Please re-enter the timestep in minutes, without units');
else
    imStruc = get(handles.task2,'userdata');
    imStruc.timestep = num;
    startVal = get(handles.subOption1,'value');
    set(handles.function2,'enable','on');
    set(handles.function3,'enable','on');
    set(handles.function5,'enable','on');
    set(handles.function6,'enable','on');
    set(handles.enter,'userdata',1);
    set(handles.prompt,'string','Begin by edge detecting or cropping out areas.  You can use either edge detection Method A or B.  Note you can perform both types individually and both results will be saved.  Once you are finished edge detecting dilation becomes possible.');    
    set(handles.userInput,'string','');
    set(handles.userInput,'enable','off');
    set(handles.enter,'enable','off');
    set(handles.subOption1,'value',1);
    set(handles.subOption1,'enable','off');
    set(handles.subOption1,'string','--');
    edgePathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'EdgeA',handles.slash];
    edgePathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'EdgeB',handles.slash];
    dilPathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationA',handles.slash];
    dilPathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationB',handles.slash];
    cropPathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'CropA',handles.slash]; 
    cropPathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'CropB',handles.slash]; 
    if startVal==2
        if exist([edgePathA,'parameters.mat'],'file')
           load([edgePathA,'parameters.mat']);
           imStruc.currentThreshA = thresh;
           imStruc.currentRadiusA = radius;
           imStruc.currentMinAreaA = minArea;
        end
        if exist([edgePathB,'parameters.mat'],'file')
           load([edgePathB,'parameters.mat']);
           imStruc.currentThreshB = thresh;
           imStruc.currentRadiusB = radius;
           imStruc.currentMinAreaB = minArea;
           imStruc.currentScale = scale;
           imStruc.savedRadiusB = radius;
           imStruc.savedMinAreaB = minArea;
           imStruc.savedScale = scale;
        end
        if exist([dilPathA,'parameters.mat'],'file')
           load([dilPathA,'parameters.mat']);
           imStruc.currentDilA = dil;
        end
        if exist([dilPathB,'parameters.mat'],'file')
           load([dilPathB,'parameters.mat']);
           imStruc.currentDilB = dil/imStruc.savedScale;
        end
        if isdir(cropPathA)
           for i = 1:imStruc.T
               im = imread([cropPathA,sprintf('im%04.0f.png',i)]);
               im = double(im);
               im = im./max(im(:));
               imStruc.crop_picsA{i} = im;
           end
        end
        if isdir(cropPathB)
           for i = 1:imStruc.T
               im = imread([cropPathB,sprintf('im%04.0f.png',i)]);
               im = double(im);
               im = im./max(im(:));
               imStruc.crop_picsB{i} = im;
           end
        end
    end
    set(handles.task2,'userdata',imStruc);
end