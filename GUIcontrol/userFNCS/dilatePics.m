function [] = dilatePics(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');
imStruc = get(handles.task2,'userdata');
fdata = get(handles.functionPanel,'userdata');
if strcmp(tag,'function4')||strcmp(tag,'function7')
    handles = initializeALL(handles,fdata); 
    set(handles.subOption1,'value',1);
    imStruc = get(handles.task2,'userdata');
    maxS = (imStruc.T-1)*imStruc.timestep;
    minS = 0;
    time = imStruc.currentTime;
    set(handles.slider,'max',maxS);
    set(handles.slider,'min',minS);
    set(handles.slider,'value',time);    
    set(handles.slider,'sliderstep',[imStruc.timestep/(maxS-minS) 5*imStruc.timestep/(maxS-minS)]);
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
        if fdata(1)==4
            set(handles.parameter2,'string',sprintf('%0.0f',imStruc.currentDilA));
        else
            set(handles.parameter2,'string',sprintf('%0.0f',imStruc.currentDilB));
        end
    else
        handles = updateParameters(handles,num,2,fdata);
    end
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
        if fdata(1)==4
            maxS = imStruc.maxDil;
        else
            maxS = imStruc.maxDil*imStruc.savedScale;
        end
        minS = 0;
        dil = str2double(get(handles.parameter2,'string'));
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',dil);
        set(handles.slider,'sliderstep',[1/(maxS-minS) 2/(maxS-minS)]);
    end
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
elseif strcmp(tag,'option2')
    if fdata(1)==4
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
    num = imStruc.savedScale;
    if fdata(1)==4
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
        if imStruc.posZoomScaled(3)+imStruc.posZoomScaled(1)-1>s(2)*imStruc.savedScale
             imStruc.posZoomScaled(3)=s(2)*imStruc.savedScale-imStruc.posZoomScaled(1)+1;
        end
        if imStruc.posZoomScaled(4)+imStruc.posZoomScaled(2)-1>s(1)*imStruc.savedScale
             imStruc.posZoomScaled(4)=s(1)*imStruc.savedScale-imStruc.posZoomScaled(2)+1;
        end
        minx = (imStruc.posZoomScaled(1)-1)/imStruc.savedScale+1;
        miny = (imStruc.posZoomScaled(2)-1)/imStruc.savedScale+1;
        widx = imStruc.posZoomScaled(3)/imStruc.savedScale;
        widy = imStruc.posZoomScaled(4)/imStruc.savedScale;
        imStruc.posZoom = [minx miny widx widy];
    end
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
    set(handles.task2,'userdata',imStruc);
    handles = updateAxes(handles,fdata);
elseif strcmp(tag,'option1')
    handles = turnOFFfuncButtons(handles);
    newpathA = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationA',handles.slash];
    newpathB = [imStruc.pathB4,handles.slash,'Processed_Images',handles.slash,'DilationB',handles.slash];
    if fdata(1)==4
        if ~isdir(newpathA)
            mkdir(newpathA);
        end
    else
        if ~isdir(newpathB)
            mkdir(newpathB);
        end
    end
    if fdata(1)==4
        dil = imStruc.currentDilA;
    else
        dil = imStruc.currentDilB;
    end
    for i = 1:imStruc.T
        if fdata(1)==4
            imEDGE = imStruc.edgeNoCropA{i}; 
            dilPic = dilateIMG(imEDGE,dil);
            dilPic = dilPic.*imStruc.crop_picsA{i};
            filename = [newpathA,sprintf('im%04.0f.png',i)];
            imwrite(dilPic,filename,'png');
            fid = fopen([newpathA,'parameters.txt'],'wt');
            fprintf(fid,'Parameters Used in DILATION A:\n\n\n');
            fprintf(fid,'Dilation : %0.0f\n',dil);
            fclose(fid);
            save([newpathA,'parameters.mat'],'dil');
        else
            imEDGE = imStruc.edgeNoCropB{i}; 
            dilPic = dilateIMG(imEDGE,dil);
            dilPic = dilPic.*imresize(imStruc.crop_picsB{i},imStruc.savedScale);
            filename = [newpathB,sprintf('im%04.0f.png',i)];
            imwrite(dilPic,filename,'png');
            fid = fopen([newpathB,'parameters.txt'],'wt');
            fprintf(fid,'Parameters Used in DILATION A:\n\n\n');
            fprintf(fid,'Dilation : %0.0f\n',dil);
            fclose(fid);
            save([newpathB,'parameters.mat'],'dil');
        end  
    end
    handles = turnONfuncButtons(handles);
    
    if fdata(1)==4
        set(handles.prompt,'string',sprintf('Dilation A files saved in %s.',newpathA)); 
    else
        set(handles.prompt,'string',sprintf('Dilation B files saved in %s.',newpathB));
    end
    set(handles.subOption1,'value',1);
    set(handles.option2,'enable','on');
    set(handles.option3,'enable','off');
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
if fdata(1)==4
    t = imStruc.currentTime;
    dil = imStruc.currentDilA;
else
    t = imStruc.currentTime;
    dil = imStruc.currentDilB*imStruc.savedScale;
end
set(handles.subOption1,'string',{'Slider-Time','Slider-Dilation'});
set(handles.parameter1,'string',sprintf('%0.2f',t));
set(handles.parameter2,'string',sprintf('%0.0f',dil));
set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption4,'value',1);
minx = (imStruc.posZoom(1)-1)*imStruc.savedScale+1;
miny = (imStruc.posZoom(2)-1)*imStruc.savedScale+1;
widx = imStruc.posZoom(3)*imStruc.savedScale;
widy = imStruc.posZoom(4)*imStruc.savedScale;
imStruc.posZoomScaled = [minx miny widx widy];
set(handles.task2,'userdata',imStruc);
handles = updateAxes(handles,fdata);

%_________________________________________
function [handles] = updateAxes(handles,fdata)
handles = turnOFFfuncButtons(handles);
imStruc = get(handles.task2,'userdata');
imRAW = imStruc.rawimage{imStruc.currentIndex};
if fdata(1)==4
    imEDGE = imStruc.edgeNoCropA{imStruc.currentIndex};
    dil = imStruc.currentDilA;
else
    imEDGE = imStruc.edgeNoCropB{imStruc.currentIndex};
    dil = imStruc.currentDilB;
end



imDIL = dilateIMG(imEDGE,dil); 
if fdata(1)==4
    imDIL = imDIL.*imStruc.crop_picsA{imStruc.currentIndex};
else
    cropResize = imresize(imStruc.crop_picsB{imStruc.currentIndex},imStruc.savedScale);    
    imDIL = imDIL.*cropResize;
end
imDIL  = imDIL>0;
imagesc(imDIL,'Parent',handles.mainAxes);

[handles,DILzoomed] = zoomin(handles,imDIL,2,fdata);
imagesc(DILzoomed,'Parent',handles.subAxes2);


h=imagesc('parent',handles.subAxes1);
set(handles.figure1,'currentaxes',handles.subAxes1);
[handles,RAWzoomed] = zoomin(handles,imRAW./max(imRAW(:)),1,fdata);
imagesc(RAWzoomed,[0.0,0.3]);
colormap(handles.cmap_colour);
set(handles.subAxes2,'xtick',[]);
set(handles.subAxes1,'xtick',[]);
set(handles.subAxes2,'ytick',[]);
set(handles.subAxes1,'ytick',[]);
handles = turnONfuncButtons(handles);

%________________________________________
function [handles,zoomed] = zoomin(handles,im,sAxes,fdata)
imStruc = get(handles.task2,'userdata');

if sAxes==1
        pos = int32(imStruc.posZoom);
        zoomed = im(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1);
else
    if fdata(1)==4
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
set(handles.option2,'enable','inactive');
set(handles.option3,'enable','off');
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
set(handles.slider,'enable','inactive');
set(handles.sliderClickL,'enable','inactive');
set(handles.sliderClickR','enable','inactive');
set(handles.prompt,'string','Processing...');
pause(0.01);
%______________________________________________________
function [handles] = turnONfuncButtons(handles)
imStruc = get(handles.task2,'userdata');
set(handles.option1,'enable','on');
set(handles.option2,'enable','on');
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
set(handles.slider,'enable','on');
set(handles.sliderClickL,'enable','on');
set(handles.sliderClickR','enable','on');
set(handles.prompt,'string','');
pause(0.01);

%________________________________________
function [handles] = updateParameters(handles,num,whichP,fdata)

imStruc = get(handles.task2,'userdata');
sliderState = get(handles.subOption1,'value');
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
        if fdata(1)==4
            maxD = imStruc.maxDil;
            if num>maxD
                imStruc.currentDilA = maxD;
            elseif num<0
                imStruc.currentDilA = 0;
            else
                imStruc.currentDilA = round(num);
            end      
            set(handles.parameter2,'string',sprintf('%0.0f',imStruc.currentDilA));
            if sliderState==2
                set(handles.slider,'value',imStruc.currentDilA);
            end  
        else
            maxD = imStruc.maxDil*imStruc.savedScale;
            if num>maxD
                imStruc.currentDilB = maxD;
            elseif num<0
                imStruc.currentDilB = 0;
            else
                imStruc.currentDilB = round(num);
            end      
            set(handles.parameter2,'string',sprintf('%0.0f',imStruc.currentDilB));
            if sliderState==2
                set(handles.slider,'value',imStruc.currentDilB);
            end
        end
end
set(handles.task2,'userdata',imStruc);
handles = updateAxes(handles,fdata);

%_______________________________________
function [handles] = move_slider(handles,whichS,fdata)
whichP = get(handles.subOption1,'value');
slideStep = get(handles.slider,'sliderStep');
maxslide = get(handles.slider,'max');
minslide = get(handles.slider,'min');
maxMin = maxslide-minslide;
if whichP==1
    oldVal = str2double(get(handles.parameter1,'string'));
elseif whichP==2
    oldVal = str2double(get(handles.parameter2,'string'));    
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
