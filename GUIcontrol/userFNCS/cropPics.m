function [] = cropPics(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');
imStruc = get(handles.task2,'userdata');
fdata = get(handles.functionPanel,'userdata');
if strcmp(tag,'function3')||strcmp(tag,'function6')
    handles = initializeALL(handles,fdata); 
    set(handles.subOption1,'value',1);
    set(handles.subOption2,'value',1);
    set(handles.subOption3,'value',1);
    set(handles.subOption4,'value',1);
    imStruc = get(handles.task2,'userdata');
    maxS = (imStruc.T-1)*imStruc.timestep;
    minS = 0;
    time = imStruc.currentTime;
    set(handles.slider,'max',maxS);
    set(handles.slider,'min',minS);
    set(handles.slider,'value',time);    
    set(handles.slider,'sliderstep',[imStruc.timestep/(maxS-minS) 5*imStruc.timestep/(maxS-minS)]);
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
elseif strcmp(tag,'parameter1')
    num = str2double(get(handles.parameter1,'string'));
    if isnan(num)==1
        set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentTime));
    else
        handles = updateParameters(handles,num,1,fdata);
    end
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
elseif strcmp(tag,'slider')
    handles = move_slider(handles,1,fdata);
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
elseif strcmp(tag,'sliderClickR')
    handles = move_slider(handles,2,fdata);
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
elseif strcmp(tag,'sliderClickL')
    handles = move_slider(handles,3,fdata);
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
elseif strcmp(tag,'option3')
    set(handles.subOption2,'value',1);
    if fdata(1)==3
        pos = imStruc.posZoom;
        imStruc.currentZoom = imrect(handles.mainAxes,pos);
        setColor(imStruc.currentZoom,'yellow');
    else
        pos = imStruc.posZoomScaled;
        imStruc.currentZoom = imrect(handles.mainAxes,pos);
        setColor(imStruc.currentZoom,'yellow');
    end
    set(handles.task2,'userdata',imStruc);
    set(handles.option3,'enable','off');
    set(handles.option4,'enable','on');
elseif strcmp(tag,'option4')
    num = imStruc.currentScale;
    if fdata(1)==3
        imStruc.posZoom = getPosition(imStruc.currentZoom);
        s = size(imStruc.rawimage{1});
        if imStruc.posZoom(1)<1
            imStruc.posZoom(1)=1;
        end
        if imStruc.posZoom(2)<1
            imStruc.posZoom(2)=1;
        end
        if imStruc.posZoom(3)+imStruc.posZoom(1)-1>s(1)
             imStruc.posZoom(3)=s(1)-imStruc.posZoom(1)+1;
        end
        if imStruc.posZoom(4)+imStruc.posZoom(2)-1>s(2)
             imStruc.posZoom(4)=s(2)-imStruc.posZoom(2)+1;
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
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
    set(handles.task2,'userdata',imStruc);
    handles = updateCrop(handles,fdata);
    handles = updateAxes(handles,fdata);
elseif strcmp(tag,'subOption1')
    val = get(handles.subOption1,'value');
    if val==3
        if ~strcmp(imStruc.cropHandle,'DNE')
            set(handles.option1,'string','Preview Crop/Enable Save');
        else
            set(handles.subOption1,'value',1);
            set(handles.option1,'string','Draw Mask');
            set(handles.prompt,'string','Cannot Preview Crop since it hasn''t yet been defined.  Please begin by drawing a mask');
        end
    else
        set(handles.option1,'string','Draw Mask');
        imStruc.cropPreviewA = 'DNE';
        imStruc.cropPreviewB = 'DNE';
        imStruc.cropHandle = 'DNE';
        imStruc.cropHandleZoom = 'DNE';
        set(handles.task2,'userdata',imStruc);
        handles = updateAxes(handles,fdata);
    end
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
elseif strcmp(tag,'option1')
    modeVal = get(handles.subOption1,'value');
    if modeVal==3
        handles = updateCrop(handles,fdata); 
        set(handles.option2,'enable','on');
    else
        handles = drawCrop(handles,fdata);
        set(handles.subOption1,'value',3);
        set(handles.option1,'string','Preview Crop/Enable Save');
        set(handles.option2,'enable','off');
    end
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
elseif strcmp(tag,'option2');
    val = get(handles.subOption3,'value');
    handles = turnOFFfuncButtons(handles,1);
    scale = imStruc.currentScale;
    index = imStruc.currentIndex;
    if val==1
            if fdata(1)==3
                if ~strcmp(imStruc.cropPreviewA,'DNE')
                    newCrop = imStruc.cropPreviewA.*imStruc.crop_picsA{index};
                    imStruc.crop_picsA{index} = newCrop;
                end
            else
                if ~strcmp(imStruc.cropPreviewB,'DNE')
                    newCrop = imresize(imStruc.cropPreviewB,1/scale).*imStruc.crop_picsB{index};
                    imStruc.crop_picsB{index} = newCrop;
                end
            end     
    else
        if fdata(1)==3
            if ~strcmp(imStruc.cropPreviewA,'DNE')
                for i = 1:imStruc.T
                    newCrop{i} = imStruc.cropPreviewA.*imStruc.crop_picsA{i};
                end
                imStruc.crop_picsA = newCrop;
            end
        else
            if ~strcmp(imStruc.cropPreviewB,'DNE')
                for i = 1:imStruc.T
                    newCrop{i} = imresize(imStruc.cropPreviewB,1/scale).*imStruc.crop_picsB{i};
                end
            end
            imStruc.crop_picsB = newCrop;
        end
    end
    if fdata(1)==3
       savePath = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'CropA']; 
    else
       savePath = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'CropB']; 
    end
    if ~isdir(savePath)
        mkdir(savePath);
    end
    
    imStruc.cropPreviewA = 'DNE';
    imStruc.cropPreviewB = 'DNE';
    imStruc.cropHandle = 'DNE';
    imStruc.cropHandleZoom = 'DNE';
    set(handles.subOption1,'value',1);
    set(handles.option1,'string','Draw Mask');
    set(handles.task2,'userdata',imStruc);
    handles = updateAxes(handles,fdata);
    handles = turnONfuncButtons(handles);
    set(handles.option3,'enable','on');
    set(handles.option4,'enable','off');
    set(handles.option2,'enable','off');
    if fdata(1)==3
        for i = 1:imStruc.T
           imwrite(imStruc.crop_picsA{i},[savePath,handles.slash,sprintf('im%04.0f.png',i)]); 
        end
        set(handles.prompt,'string',sprintf('Crops saved in %s',savePath));
    else
        for i = 1:imStruc.T
           imwrite(imStruc.crop_picsB{i},[savePath,handles.slash,sprintf('im%04.0f.png',i)]); 
        end
        set(handles.prompt,'string',sprintf('Crops saved in %s',savePath));
    end
elseif strcmp(tag,'subOption4')
    handles = updateAxes(handles,fdata);
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

%_________________________________________
function [handles] = initializeALL(handles,fdata)

imStruc = get(handles.task2,'userdata');
if fdata(1)==3
    t = imStruc.currentTime;
    thresh = imStruc.currentThreshA;
    rad = imStruc.currentRadiusA;
    area = imStruc.currentMinAreaA;
else
    t = imStruc.currentTime;
    thresh = imStruc.currentThreshB;
    rad = imStruc.currentRadiusB;
    area = imStruc.currentMinAreaB;
    scale = imStruc.currentScale;
end
set(handles.subOption1,'string',{'Draw Mode-Free','Draw Mode-Polygon','Draw Mode-Preview'});
set(handles.subOption2,'string',{'Location-Main Axis','Location-Sub-Axis'});
set(handles.subOption3,'string',{'Save-Current','Save-All'});
if fdata(1)==3
    if imStruc.dilAstate==1
        set(handles.subOption4,'string',{'Show-Edge Pics','Show-Dil Pics'});
    else
        set(handles.subOption4,'string',{'Show-Edge Pics'});
    end
else
    if imStruc.dilBstate==1
        set(handles.subOption4,'string',{'Show-Edge Pics','Show-Dil Pics'});
    else
        set(handles.subOption4,'string',{'Show-Edge Pics'});
    end
end

set(handles.parameter1,'string',sprintf('%0.2f',t));
imStruc.cropHandle = 'DNE';
imStruc.cropHandleZoom = 'DNE';
imStruc.cropPreviewA = 'DNE';
imStruc.cropPreviewB = 'DNE';
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);
set(handles.task2,'userdata',imStruc);
handles = updateAxes(handles,fdata);

%__________________________________________________
function [handles] = move_slider(handles,whichS,fdata)

slideStep = get(handles.slider,'sliderStep');
maxslide = get(handles.slider,'max');
minslide = get(handles.slider,'min');
maxMin = maxslide-minslide;
oldVal = str2double(get(handles.parameter1,'string'));
    
if whichS==1
    newVal = get(handles.slider,'value');
    updateParameters(handles,newVal,1,fdata);
elseif whichS==2
    newVal = oldVal+slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
    updateParameters(handles,newVal,1,fdata);
else
    newVal = oldVal-slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
    updateParameters(handles,newVal,1,fdata);
end

%________________________________________
function [handles] = updateParameters(handles,num,whichP,fdata)

imStruc = get(handles.task2,'userdata');
if whichP==1
    if fdata(1)==3
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
        set(handles.slider,'value',imStruc.currentTime);
    else
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
        set(handles.slider,'value',imStruc.currentTime);
    end
end
set(handles.task2,'userdata',imStruc);
handles = updateAxes(handles,fdata);

%________________________________________
function [handles] = updateAxes(handles,fdata)
handles = turnOFFfuncButtons(handles,1);
imStruc = get(handles.task2,'userdata');
imRAW = imStruc.currentRaw;
if fdata(1)==3
    imCROP = imStruc.cropPreviewA;
    s = size(imRAW)
    if strcmp(imCROP,'DNE');
        imCROP = ones(s(1),s(2));
        imStruc.cropPreviewA = imCROP;
    end
else
    imCROP = imStruc.cropPreviewB;
    s = size(imRAW);
    if strcmp(imCROP,'DNE');
        imCROP = ones(s(1),s(2));
        imStruc.cropPreviewB = imCROP;
    end
end
maxI = imStruc.maxI;

showVal = get(handles.subOption4,'value');
if fdata(1)==3
    thresh = imStruc.currentThreshA;
    radius = imStruc.currentRadiusA;
    minArea= imStruc.currentMinAreaA;
    dil = imStruc.currentDilA;
    savedCROP = imStruc.crop_picsA{imStruc.currentIndex};
    imEDGE = detectEdgeA(imRAW,thresh,radius,minArea,maxI); 
    if showVal==2
        imEDGE = dilateIMG(imEDGE,dil);   
    end
    imEDGE = imEDGE.*imCROP.*savedCROP;
else  
    thresh = imStruc.currentThreshB;
    radius = imStruc.currentRadiusB;
    minArea= imStruc.currentMinAreaB;
    scale = imStruc.currentScale;
    dil = imStruc.currentDilB;
    savedCROP = imStruc.crop_picsB{imStruc.currentIndex};
    s1=size(imRAW);
    s2 = size(imCROP);
    if s1(1)==s2(1)&&s1(2)==s2(2)
        imEDGE = detectEdgeB(imRAW,thresh,radius,minArea,maxI,scale); 
        if showVal==2
            imEDGE = dilateIMG(imEDGE,dil); 
        end
        imEDGE = imEDGE.*imresize(imCROP,scale).*imresize(savedCROP,scale);
    else
        imEDGE = detectEdgeB(imRAW,thresh,radius,minArea,maxI,scale);   
        if showVal==2
            imEDGE = dilateIMG(imEDGE,dil); 
        end
        imEDGE = imEDGE.*imCROP.*imresize(savedCROP,scale);
    end
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
handles = refreshCrop(handles,fdata);
handles = turnONfuncButtons(handles);

%________________________________________
function [handles,zoomed] = zoomin(handles,im,sAxes,fdata)
imStruc = get(handles.task2,'userdata');

if sAxes==1
        pos = int32(imStruc.posZoom);
        zoomed = im(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1);
else
    if fdata(1)==3
        pos = int32(imStruc.posZoom);
        zoomed = im(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1);
    else
        pos = int32(imStruc.posZoomScaled);     
        zoomed = im(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1);
    end
end
  
%______________________________________________________
function [handles] = turnOFFfuncButtons(handles,doString)
imStruc = get(handles.task2,'userdata');
set(handles.option1,'enable','inactive');
set(handles.option2,'enable','off');
set(handles.option3,'enable','inactive');
set(handles.option4,'enable','off');
set(handles.subOption1,'enable','inactive');
set(handles.subOption2,'enable','inactive');
set(handles.subOption3,'enable','inactive');
set(handles.subOption4,'enable','inactive');
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
set(handles.slider,'enable','inactive');
set(handles.sliderClickL,'enable','inactive');
set(handles.sliderClickR','enable','inactive');
if doString==1
set(handles.prompt,'string','Processing...');
end
pause(0.01);
%______________________________________________________
function [handles] = turnONfuncButtons(handles)
imStruc = get(handles.task2,'userdata');
set(handles.option1,'enable','on');
set(handles.option3,'enable','on');
set(handles.subOption1,'enable','on');
set(handles.subOption2,'enable','on');
set(handles.subOption3,'enable','on');
set(handles.subOption4,'enable','on');
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
set(handles.slider,'enable','on');
set(handles.sliderClickL,'enable','on');
set(handles.sliderClickR','enable','on');
set(handles.prompt,'string','');
pause(0.01);

%______________________________________________
function [handles] = drawCrop(handles,fdata)
imStruc = get(handles.task2,'userdata');
typeVal = get(handles.subOption1,'value');
locVal = get(handles.subOption2,'value');
if ~strcmp(imStruc.cropHandle,'DNE')
   delete(imStruc.cropHandle);
   delete(imStruc.cropHandleZoom);
end

if typeVal==2
    if locVal==1
        set(handles.prompt,'string','Please draw a mask in the Main Axes before continuing.');
        handles = turnOFFfuncButtons(handles,2);
        imStruc.cropHandle = impoly(handles.mainAxes);
        handles = turnONfuncButtons(handles);
        imStruc.cropHandleZoom = scaleCrop(handles,imStruc.cropHandle,1,fdata);
        imStruc.cropHandlePos = getPosition(imStruc.cropHandle);
    else
        set(handles.prompt,'string','Please draw a mask in the Bottom Right Axes before continuing.');
        handles = turnOFFfuncButtons(handles,2);
        imStruc.cropHandleZoom = impoly(handles.subAxes2);
        handles = turnONfuncButtons(handles);
        imStruc.cropHandle = scaleCrop(handles,imStruc.cropHandleZoom,2,fdata);  
        imStruc.cropHandleZoomPos = getPosition(imStruc.cropHandleZoom);
    end
else
    if locVal==1
        set(handles.prompt,'string','Please draw a mask in the Main Axes before continuing.');
        handles = turnOFFfuncButtons(handles,2);
        imStruc.cropHandle = imfreehand(handles.mainAxes);
        handles = turnONfuncButtons(handles);
        imStruc.cropHandleZoom = scaleCrop(handles,imStruc.cropHandle,1,fdata);
        imStruc.cropHandlePos = getPosition(imStruc.cropHandle);
    else
        set(handles.prompt,'string','Please draw a mask in the Bottom Right Axes before continuing.');
        handles = turnOFFfuncButtons(handles,2);
        imStruc.cropHandleZoom = imfreehand(handles.subAxes2);
        handles = turnONfuncButtons(handles);
        imStruc.cropHandle = scaleCrop(handles,imStruc.cropHandleZoom,2,fdata);  
        imStruc.cropHandleZoomPos = getPosition(imStruc.cropHandleZoom);
    end
end
set(handles.task2,'userdata',imStruc);
%_____________________________________________
function [outHandle] = scaleCrop(handles,inHandle,whichaxis,fdata)

imStruc = get(handles.task2,'userdata');

pos = getPosition(inHandle);
newPos = pos;
s = size(pos);
if fdata(1)==3
    zoomPos = imStruc.posZoom;
else
    zoomPos = imStruc.posZoomScaled;
end

if whichaxis==1
  for i = 1:s(1)
    newPos(i,1) = pos(i,1)-zoomPos(1)+1;
    newPos(i,2) = pos(i,2)-zoomPos(2)+1;
  end
  outHandle = impoly(handles.subAxes2,newPos);
else
  for i = 1:s(1)
      newPos(i,1) = pos(i,1)+zoomPos(1)-1;
      newPos(i,2) = pos(i,2)+zoomPos(2)-1;
  end
  outHandle = impoly(handles.mainAxes,newPos);  
end

%______________________________________________
function [handles] = updateCrop(handles,fdata)


imStruc = get(handles.task2,'userdata');
if ~strcmp(imStruc.cropHandle,'DNE')
    val = get(handles.subOption2,'value');
    if val==1
        cp = getPosition(imStruc.cropHandle);
        imStruc.cropHandlePos = cp;
        delete(imStruc.cropHandleZoom);
        imStruc.cropHandleZoom = scaleCrop(handles,imStruc.cropHandle,1,fdata);
        imStruc.cropHandleZoomPos = getPosition(imStruc.cropHandleZoom);

    else
        czp = getPosition(imStruc.cropHandleZoom);
        imStruc.cropHandleZoomPos = czp; 
        delete(imStruc.cropHandle);
        imStruc.cropHandle = scaleCrop(handles,imStruc.cropHandleZoom,2,fdata);
        imStruc.cropHandlePos = getPosition(imStruc.cropHandle);
    end
    BW = createMask(imStruc.cropHandle);
    if fdata(1)==3
        imStruc.cropPreviewA = BW==0;
    else
        imStruc.cropPreviewB = BW==0; 
    end
    set(handles.task2,'userdata',imStruc);
    handles = updateAxes(handles,fdata);

end

function [handles] = refreshCrop(handles,fdata)
imStruc = get(handles.task2,'userdata');
if ~strcmp(imStruc.cropHandle,'DNE')
   imStruc.cropHandle = impoly(handles.mainAxes,imStruc.cropHandlePos);
   imStruc.cropHandleZoom = impoly(handles.subAxes2,imStruc.cropHandleZoomPos);
end
set(handles.task2,'userdata',imStruc);
