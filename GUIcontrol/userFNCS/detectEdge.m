function [] = detectEdge(hObject,handles,eventdata,extraData)

% this function faciliates edge detection by the user

% do function
tag = get(hObject,'tag');
imStruc = get(handles.task2,'userdata'); % load the image data structure 
fdata = get(handles.functionPanel,'userdata'); % to be used in conditional statements below

if strcmp(tag,'function2')||strcmp(tag,'function5')   
    % intialize
    handles = initializeALL(handles,fdata);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');    
elseif strcmp(tag,'parameter1')
    num = str2double(get(handles.parameter1,'string'));
    if isnan(num)==1
        set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentTime));
    else
        handles = updateParameters(handles,num,1,fdata);
    end
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'parameter2')
    num = str2double(get(handles.parameter2,'string'));
    if isnan(num)==1
        if fdata(1)==2
            set(handles.parameter2,'string',sprintf('%0.2f',imStruc.currentThreshA));
        else
            set(handles.parameter2,'string',sprintf('%0.2f',imStruc.currentThreshB));    
        end
    else
        handles = updateParameters(handles,num,2,fdata);
    end
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'parameter3')
    num = str2double(get(handles.parameter3,'string'));
    if isnan(num)==1
        if fdata(1)==2
            set(handles.parameter3,'string',sprintf('%d',imStruc.currentRadiusA));
        else
            set(handles.parameter3,'string',sprintf('%d',imStruc.currentRadiusB));
        end
    else
        handles = updateParameters(handles,num,3,fdata);
    end
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'parameter4')
    num = str2double(get(handles.parameter4,'string'));
    if isnan(num)==1
        if fdata(1)==2
            set(handles.parameter4,'string',sprintf('%d',imStruc.currentMinAreaA));
        else
            set(handles.parameter4,'string',sprintf('%d',imStruc.currentMinAreaB));    
        end
    else
        handles = updateParameters(handles,num,4,fdata);
    end
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'parameter5')
    num = str2double(get(handles.parameter5,'string'));
    if isnan(num)==1
            set(handles.parameter5,'string',sprintf('%d',imStruc.currentScale));    
    else
        if fdata(1)==5
            if num>5
                num=5;
            end
            if num<1
                num=1;
            end
            minx = (imStruc.posZoom(1)-1)*num+1;
            miny = (imStruc.posZoom(2)-1)*num+1;
            widx = imStruc.posZoom(3)*num;
            widy = imStruc.posZoom(4)*num;
            imStruc.posZoomScaled = [minx miny widx widy];
            set(handles.task2,'userdata',imStruc);
        end
    end
    handles = updateParameters(handles,num,5,fdata);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'slider')
    handles = move_slider(handles,1,fdata);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'sliderClickR')
    handles = move_slider(handles,2,fdata);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'sliderClickL')
    handles = move_slider(handles,3,fdata);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'option1')
    handles = saveEdge(handles,imStruc,fdata);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'option2')
    % show the zoom box
    if fdata(1)==2
        pos = imStruc.posZoom;
        imStruc.currentZoom = imrect(handles.mainAxes,pos);
    else
        pos = imStruc.posZoomScaled;
        imStruc.currentZoom = imrect(handles.mainAxes,pos);
    end
    set(handles.task2,'userdata',imStruc);
    set(handles.option2,'enable','off');
    set(handles.option3,'enable','on');
elseif strcmp(tag,'option3')
    % update the zoom box after it has been resized
    handles = resizeZoomBox(handles,imStruc,fdata);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'subOption1')
    sliderMenu = get(handles.subOption1,'value');
    if sliderMenu==1
        maxS = (imStruc.T-1)*imStruc.timestep;
        minS = 0;
        time = str2double(get(handles.parameter1,'string'));
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',time);    
        set(handles.slider,'sliderstep',[imStruc.timestep/(maxS-minS) 5*imStruc.timestep/(maxS-minS)]);
    elseif sliderMenu==2
        maxS = 1;
        minS = 0;
        thresh = str2double(get(handles.parameter2,'string'));
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',thresh);
        set(handles.slider,'sliderstep',[0.001 0.05]);
    elseif sliderMenu==3
        if fdata(1)==2
            maxS = imStruc.maxRadiusA;
        else
            maxS = imStruc.maxRadiusB;
        end
        minS = 0;
        radius = str2double(get(handles.parameter3,'string'));
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',radius);
        set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
    elseif sliderMenu==4
        if fdata(1)==2
            maxS = imStruc.maxMinAreaA;
        else
            maxS = imStruc.maxMinAreaB;
        end
        minS = 0;
        area = str2double(get(handles.parameter4,'string'));
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',area);
        set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
    elseif sliderMenu==5
        maxS = imStruc.maxScaleB;
        minS = 1;
        scale = str2double(get(handles.parameter5,'string'));
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',scale);
        set(handles.slider,'sliderstep',[1/(maxS-minS) 1/(maxS-minS)]);
    end
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
end
% define new control variables
tdata = get(handles.taskPanel,'userdata');
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

%_________________________________________
function [handles] = initializeALL(handles,fdata)
% intializes the GUI after detect_edge has been selected
imStruc = get(handles.task2,'userdata');
if fdata(1)==2
    t = imStruc.currentTime;
    thresh = imStruc.currentThreshA;
    rad = imStruc.currentRadiusA;
    area = imStruc.currentMinAreaA;
    set(handles.subOption1,'string',{'Slider-Time','Slider-Threshold','Slider-Radius','Slider-Area'});
else
    t = imStruc.currentTime;
    thresh = imStruc.currentThreshB;
    rad = imStruc.savedRadiusB;
    area = imStruc.savedMinAreaB;
    scale = imStruc.savedScale;
    set(handles.subOption1,'string',{'Slider-Time','Slider-Threshold','Slider-Radius','Slider-Area','Slider-Axis Scale'});
end
set(handles.parameter1,'string',sprintf('%0.2f',t));
set(handles.parameter2,'string',sprintf('%0.4f',thresh));
set(handles.parameter3,'string',sprintf('%d',rad));
set(handles.parameter4,'string',sprintf('%d',area));
imStruc.cropPreviewA = 'DNE';
imStruc.cropPreviewB = 'DNE';
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);
set(handles.task2,'userdata',imStruc);
if fdata(1)==5
    set(handles.parameter5,'string',sprintf('%d',scale));
end
handles = updateAxes(handles,fdata);
maxS = (imStruc.T-1)*imStruc.timestep;
minS = 0;
time = imStruc.currentTime;
set(handles.slider,'max',maxS);
set(handles.slider,'min',minS);
set(handles.slider,'value',time);    
set(handles.slider,'sliderstep',[imStruc.timestep/(maxS-minS) 5*imStruc.timestep/(maxS-minS)]);

%_______________________________________
function [handles] = move_slider(handles,whichS,fdata)

% this function changes the parameter after the slider have been used
% the function checks which paramter is currently being controlled by the
% slider, and then makes a step and then calls the function
% updateParameters
whichP = get(handles.subOption1,'value');
slideStep = get(handles.slider,'sliderStep');
maxslide = get(handles.slider,'max');
minslide = get(handles.slider,'min');
maxMin = maxslide-minslide;
if whichP==1
    oldVal = str2double(get(handles.parameter1,'string'));
elseif whichP==2
    oldVal = str2double(get(handles.parameter2,'string'));    
elseif whichP==3
    oldVal = str2double(get(handles.parameter3,'string'));
elseif whichP==4
    oldVal = str2double(get(handles.parameter4,'string'));
elseif whichP==5
    oldVal = str2double(get(handles.parameter5,'string'));
end

if whichS==1
    newVal = get(handles.slider,'value');
    updateParameters(handles,newVal,whichP,fdata);
elseif whichS==2
    newVal = oldVal+slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
    updateParameters(handles,newVal,whichP,fdata);
else
    newVal = oldVal-slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
    updateParameters(handles,newVal,whichP,fdata);
end

   
%________________________________________
function [handles] = updateParameters(handles,num,whichP,fdata)

% this function changes the parameter whichP to its new value num
% the function checks if num is an allowed value
% if num is forbidden, the function forces the value to be the closest
% allowed value
% if num is not a number, the output is the previous value
% the conditions for allowed values depend on fdata

imStruc = get(handles.task2,'userdata');
sliderState = get(handles.subOption1,'value');
if fdata(1)==2
    if whichP==1
            T = imStruc.T;
            timestep = imStruc.timestep;
            tmax = (T-1)*timestep;
            tarray = (0:T-1)*timestep;
            diffarray = abs(tarray-num);
            minval = find(diffarray==min(diffarray));
            minval = minval(1);
            if num>tmax
                imStruc.currentTime = tmax;
            elseif num<0
                imStruc.currentTime=0;
            else
                imStruc.currentTime = (minval-1)*timestep;          
            end
            imStruc.currentRaw = imStruc.rawimage{minval};
            imStruc.currentIndex = minval;
            set(handles.task2,'userdata',imStruc);
            set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentTime));
            if sliderState==1
                set(handles.slider,'value',imStruc.currentTime);
            end
    elseif whichP==2
            if num>1
                imStruc.currentThreshA = 1;
            elseif num<0
                imStruc.currentThreshA = 0;
            else
                imStruc.currentThreshA = num;
            end      
            set(handles.parameter2,'string',sprintf('%0.4f',imStruc.currentThreshA));
            if sliderState==2
                set(handles.slider,'value',imStruc.currentThreshA);
            end
    elseif whichP==3
            maxR = imStruc.maxRadiusA;
            if num>maxR
                imStruc.currentRadiusA = maxR;
            elseif num<0
                imStruc.currentRadiusA = 0;
            else
                imStruc.currentRadiusA = round(num);
            end
            set(handles.parameter3,'string',sprintf('%0.0f',imStruc.currentRadiusA));
            if sliderState==3
                set(handles.slider,'value',imStruc.currentRadiusA);
            end
    elseif whichP==4
            maxR = imStruc.maxMinAreaA;
            if num>maxR
                imStruc.currentMinAreaA = maxR;
            elseif num<0
                imStruc.currentMinAreaA = 0;
            else
                imStruc.currentMinAreaA = round(num);
            end
            set(handles.parameter4,'string',sprintf('%0.0f',imStruc.currentMinAreaA));
            if sliderState==4
                set(handles.slider,'value',imStruc.currentMinAreaA);
            end
    end
else
    if whichP==1
            T = imStruc.T;
            timestep = imStruc.timestep;
            tmax = (T-1)*timestep;
            tarray = (0:T-1)*timestep;
            diffarray = abs(tarray-num);
            minval = find(diffarray==min(diffarray));
            minval = minval(1);
            if num>tmax
                imStruc.currentTime = tmax;
            elseif num<0
                imStruc.currentTime=0;
            else
                imStruc.currentTime = (minval-1)*timestep;          
            end
            imStruc.currentIndex = minval;
            imStruc.currentRaw = imStruc.rawimage{minval};
            set(handles.task2,'userdata',imStruc);
            set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentTime));
            if sliderState==1
                set(handles.slider,'value',imStruc.currentTime);
            end
    elseif whichP==2
            if num>1
                imStruc.currentThreshB = 1;
            elseif num<0
                imStruc.currentThreshB = 0;
            else
                imStruc.currentThreshB = num;
            end      
            set(handles.parameter2,'string',sprintf('%0.4f',imStruc.currentThreshB));
            if sliderState==2
                set(handles.slider,'value',imStruc.currentThreshB);
            end
    elseif whichP==3
            maxR = imStruc.maxRadiusB;
            if num>maxR
                imStruc.currentRadiusB = maxR;
            elseif num<0
                imStruc.currentRadiusB = 0;
            else
                imStruc.currentRadiusB = round(num);
            end
            set(handles.parameter3,'string',sprintf('%d',imStruc.currentRadiusB));
            if sliderState==3
                set(handles.slider,'value',imStruc.currentRadiusB);
            end
    elseif whichP==4
            maxR = imStruc.maxMinAreaB;
            if num>maxR
                imStruc.currentMinAreaB = maxR;
            elseif num<0
                imStruc.currentMinAreaB = 0;
            else
                imStruc.currentMinAreaB = round(num);
            end
            set(handles.parameter4,'string',sprintf('%d',imStruc.currentMinAreaB));
            if sliderState==4
                set(handles.slider,'value',imStruc.currentMinAreaB);
            end
    elseif whichP==5
            maxR = imStruc.maxScaleB;
            oldScale = imStruc.currentScale;
            if num>maxR
                imStruc.currentScale = maxR;
            elseif num<1
                imStruc.currentScale = 1;
            else
                imStruc.currentScale = round(num);
            end
            newScale = imStruc.currentScale;
            set(handles.parameter5,'string',sprintf('%d',imStruc.currentScale));
            imStruc.maxRadiusB = round(imStruc.maxS*newScale/5);
            imStruc.maxMinAreaB = imStruc.maxS*newScale^2;
            imStruc.currentRadiusB = round(imStruc.currentRadiusB*newScale/oldScale);
            imStruc.currentMinAreaB = round(imStruc.currentMinAreaB*newScale^2/oldScale^2);
            set(handles.parameter3,'string',sprintf('%d',imStruc.currentRadiusB));
            set(handles.parameter4,'string',sprintf('%d',imStruc.currentMinAreaB));
            if sliderState==5
                set(handles.slider,'value',imStruc.currentScale);
            end
    end
end
set(handles.task2,'userdata',imStruc);
handles = updateAxes(handles,fdata);

%________________________________________
function [handles] = updateAxes(handles,fdata)
% this function updates the axes with the current defined parameters
% if crops have been defined, they are applied to the images
% if the zoom box has been changed, the sub-axes are adjusted

handles = turnOFFfuncButtons(handles);
imStruc = get(handles.task2,'userdata');
imRAW = imStruc.currentRaw;
if fdata(1)==2
    imCROP = imStruc.crop_picsA{imStruc.currentIndex};
else
    imCROP = imStruc.crop_picsB{imStruc.currentIndex};
end
maxI = imStruc.maxI;

if fdata(1)==2
    thresh = imStruc.currentThreshA;
    radius = imStruc.currentRadiusA;
    minArea= imStruc.currentMinAreaA;
    imEDGE = detectEdgeA(imRAW,thresh,radius,minArea,maxI); 
    imEDGE = imEDGE.*imCROP;
else  
    thresh = imStruc.currentThreshB;
    radius = imStruc.currentRadiusB;
    minArea= imStruc.currentMinAreaB;
    scale = imStruc.currentScale;
    imEDGE = detectEdgeB(imRAW,thresh,radius,minArea,maxI,scale);
    imEDGE = imEDGE.*imresize(imCROP,scale);
end
    
imagesc(imEDGE,'Parent',handles.mainAxes);

[handles,EDGEzoomed] = zoomin(handles,imEDGE,2,fdata);
imagesc(EDGEzoomed,'Parent',handles.subAxes2);


h=imagesc('parent',handles.subAxes1);
set(handles.figure1,'currentaxes',handles.subAxes1);
[handles,RAWzoomed] = zoomin(handles,imRAW./max(imRAW(:)),1,fdata);
imagesc(RAWzoomed,[0.0,0.3]);
colormap(handles.cmap_colour);
set(handles.subAxes2,'xtick',[]);
set(handles.subAxes1,'xtick',[]);
set(handles.subAxes2,'ytick',[]);
set(handles.subAxes1,'ytick',[]);
handles = turnONfuncButtons(handles,fdata);

%________________________________________
function [handles,zoomed] = zoomin(handles,im,sAxes,fdata)
% this function converts between the main axes and sub axes coordinates
% using the current size and location of the user defined zoom box

imStruc = get(handles.task2,'userdata');

if sAxes==1
        pos = int32(imStruc.posZoom);
        zoomed = im(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1);
else
    if fdata(1)==2
        pos = int32(imStruc.posZoom); 
        zoomed = im(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1);
    else
        pos = int32(imStruc.posZoomScaled);
        zoomed = im(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1);
    end
end
  
%______________________________________________________
function [handles] = turnOFFfuncButtons(handles)
imStruc = get(handles.task2,'userdata');
set(handles.option1,'enable','inactive');
set(handles.subOption1,'enable','inactive');
set(handles.function1,'enable','inactive');
set(handles.function2,'enable','inactive');
set(handles.function3,'enable','inactive');
if imStruc.dilAstate==1
    set(handles.function4,'enable','inactive');
else
    set(handles.function4,'enable','off');
end
set(handles.function5,'enable','inactive');
set(handles.function6,'enable','inactive');
if imStruc.dilBstate==1
    set(handles.function7,'enable','inactive');
else
    set(handles.function7,'enable','off');
end
set(handles.parameter1,'enable','inactive');
set(handles.parameter2,'enable','inactive');
set(handles.parameter3,'enable','inactive');
set(handles.parameter4,'enable','inactive');
set(handles.parameter3,'enable','inactive');
set(handles.slider,'enable','inactive');
set(handles.sliderClickL,'enable','inactive');
set(handles.sliderClickR','enable','inactive');
set(handles.prompt,'string','Processing...');
pause(0.01);
%______________________________________________________
function [handles] = turnONfuncButtons(handles,fdata)
imStruc = get(handles.task2,'userdata');
set(handles.option1,'enable','on');
set(handles.subOption1,'enable','on');
set(handles.function1,'enable','on');
set(handles.function2,'enable','on');
set(handles.function3,'enable','on');
if imStruc.dilAstate==0
set(handles.function4,'enable','off');    
else
set(handles.function4,'enable','on');
end
set(handles.function5,'enable','on');
set(handles.function6,'enable','on');
if imStruc.dilBstate==0
set(handles.function7,'enable','off');    
else
set(handles.function7,'enable','on');
end
set(handles.parameter1,'enable','on');
set(handles.parameter2,'enable','on');
set(handles.parameter3,'enable','on');
set(handles.parameter4,'enable','on');
if fdata(1)==5
set(handles.parameter5,'enable','on');
end
set(handles.slider,'enable','on');
set(handles.sliderClickL,'enable','on');
set(handles.sliderClickR','enable','on');
set(handles.prompt,'string','');
pause(0.01);

%___________________________
function handles = saveEdge(handles,imStruc,fdata)

% this function saves the edge detection to the appropriate folder using
% the user defined parameters 

handles = turnOFFfuncButtons(handles);
newpathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'EdgeA',handles.slash];
newpathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'EdgeB',handles.slash];
dilpathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationA',handles.slash];
dilpathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationB',handles.slash];

if fdata(1)==2
    if ~isdir(newpathA)
        mkdir(newpathA);
    end
    imStruc.dilAstate = 1;
    set(handles.function4,'enable','on');
    if isdir(dilpathA)
       rmdir(dilpathA,'s'); 
    end
else
    if ~isdir(newpathB)
        mkdir(newpathB);
    end
    imStruc.dilBstate = 1;
    set(handles.function7,'enable','on');
    if isdir(dilpathB)
       rmdir(dilpathB,'s'); 
    end
end
if fdata(1)==2
    thresh = imStruc.currentThreshA;
    radius = imStruc.currentRadiusA;
    minArea = imStruc.currentMinAreaA;
else
    thresh = imStruc.currentThreshB;
    radius = imStruc.currentRadiusB;
    minArea = imStruc.currentMinAreaB;
    scale = imStruc.currentScale;
end
maxI = imStruc.maxI;
for i = 1:imStruc.T
    imRAW = imStruc.rawimage{i};
    if fdata(1)==2
        imEDGE = detectEdgeA(imRAW,thresh,radius,minArea,maxI); 
        imStruc.edge_picsA{i} = imEDGE.*imStruc.crop_picsA{i};
        imStruc.edgeNoCropA{i} = imEDGE;
        filename = [newpathA,sprintf('im%04.0f.png',i)];
        imwrite(imStruc.edge_picsA{i},filename,'png');
        fid = fopen([newpathA,'parameters.txt'],'wt');
        fprintf(fid,'Parameters Used in EDGE A detection:\n\n\n');
        fprintf(fid,'Threshold:              %0.4f\n',thresh);
        fprintf(fid,'Structuring Radius:     %4.0f\n',radius);
        fprintf(fid,'Minimum Connected Area: %4.0f\n',minArea);
        fclose(fid);
        save([newpathA,'parameters.mat'],'thresh','radius','minArea');
    else
        imEDGE = detectEdgeB(imRAW,thresh,radius,minArea,maxI,scale);   
        cropResize = imresize(imStruc.crop_picsB{i},scale);
        imStruc.edge_picsB{i} = imEDGE.*cropResize;
        imStruc.edgeNoCropB{i} = imEDGE;
        imStruc.savedRadiusB = imStruc.currentRadiusB;
        imStruc.savedMinAreaB = imStruc.currentMinAreaB;
        imStruc.savedScale = imStruc.currentScale;
        filename = [newpathB,sprintf('im%04.0f.png',i)];
        grayimg = mat2gray(imStruc.edge_picsB{i});
        indimg = gray2ind(grayimg,50);
        RGB = ind2rgb(indimg,hot(50));
        imwrite(RGB,filename,'png');
        fid = fopen([newpathB,'parameters.txt'],'wt');
        fprintf(fid,'Parameters Used in EDGE B detection:\n\n\n');
        fprintf(fid,'Threshold:              %0.4f\n',thresh);
        fprintf(fid,'Structuring Radius:     %4.0f\n',radius);
        fprintf(fid,'Minimum Connected Area: %4.0f\n',minArea);
        fprintf(fid,'Axis Scale Factor:      %4.0f\n',scale);
        fclose(fid);
        save([newpathB,'parameters.mat'],'thresh','radius','minArea','scale');
    end  
end
set(handles.task2,'userdata',imStruc);
handles = turnONfuncButtons(handles,fdata);

if fdata(1)==2
    set(handles.prompt,'string',sprintf('Edge A files saved in %s.',newpathA)); 
else
    set(handles.prompt,'string',sprintf('Edge B files saved in %s.',newpathB));
end
set(handles.subOption1,'value',1);

%____________________________________
function handles = resizeZoomBox(handles,imStruc,fdata)

% this function redefines the coordiates of the zoom box
% if the user moves the zoom box outside of the main axes ranges, the
% endpoints of the zoom box are adjusted to stay inside the limits of the
% image

num = imStruc.currentScale;
if fdata(1)==2
    imStruc.posZoom = getPosition(imStruc.currentZoom);
    s = size(imStruc.rawimage{1});
    if imStruc.posZoom(1)<1
        imStruc.posZoom(1)=1;
    end
    if imStruc.posZoom(2)<1
        imStruc.posZoom(2)=1;
    end
    if imStruc.posZoom(3)+imStruc.posZoom(1)-1>s(2)
         imStruc.posZoom(3)=s(2)-imStruc.posZoom(1)+1;
    end
    if imStruc.posZoom(4)+imStruc.posZoom(2)-1>s(1)
         imStruc.posZoom(4)=s(1)-imStruc.posZoom(2)+1;
    end
    minx = (imStruc.posZoom(1)-1)*num+1;
    miny = (imStruc.posZoom(2)-1)*num+1;
    if minx<1
        minx=1;
    end
    if miny<1
        miny=1;
    end
    widx = imStruc.posZoom(3)*num;
    widy = imStruc.posZoom(4)*num;
    imStruc.posZoomScaled = [minx miny widx widy];
else
    imStruc.posZoomScaled = getPosition(imStruc.currentZoom);
    s = size(imStruc.rawimage{1});
    if imStruc.posZoomScaled(1)<1
        imStruc.posZoomScaled(1)=1;
    end
    if imStruc.posZoomScaled(2)<1
        imStruc.posZoomScaled(2)=1;
    end
    if imStruc.posZoomScaled(3)+imStruc.posZoomScaled(1)-1>s(2)*imStruc.currentScale
         imStruc.posZoomScaled(3)=s(2)*imStruc.currentScale-imStruc.posZoomScaled(1)+1;
    end
    if imStruc.posZoomScaled(4)+imStruc.posZoomScaled(2)-1>s(1)*imStruc.currentScale
         imStruc.posZoomScaled(4)=s(1)*imStruc.currentScale-imStruc.posZoomScaled(2)+1;
    end
    minx = (imStruc.posZoomScaled(1)-1)/imStruc.currentScale+1;
    miny = (imStruc.posZoomScaled(2)-1)/imStruc.currentScale+1;
    widx = imStruc.posZoomScaled(3)/imStruc.currentScale;
    widy = imStruc.posZoomScaled(4)/imStruc.currentScale;
    imStruc.posZoom = [minx miny widx widy];
end
set(handles.task2,'userdata',imStruc);
handles = updateAxes(handles,fdata);