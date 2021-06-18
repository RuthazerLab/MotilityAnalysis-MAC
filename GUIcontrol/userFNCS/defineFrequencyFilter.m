function [] = defineFrequencyFilter(hObject,handles,eventdata,extraData)


% do function
tag = get(hObject,'tag');
imStruc = get(handles.task3,'userdata');
if strcmp(tag,'function4')
    handles = initializeALL(handles);
elseif strcmp(tag,'parameter1')
    num = str2double(get(handles.parameter1,'string'));
    unitVal = get(handles.subOption3,'value');
    if isnan(num)==1
        if unitVal==1
            set(handles.parameter1,'string',sprintf('%0.2f',(1/imStruc.currentHigh)/60));
        else
            set(handles.parameter1,'string',sprintf('%0.2f',imStruc.currentLow*1000));
        end
    else
        handles = updateParameters(handles,num,1);
    end
elseif strcmp(tag,'parameter2')
    num = str2double(get(handles.parameter2,'string'));
    unitVal = get(handles.subOption3,'value');
    if isnan(num)==1
        if unitVal==1
            set(handles.parameter2,'string',sprintf('%0.2f',(1/imStruc.currentLow)/60));
        else
            set(handles.parameter2,'string',sprintf('%0.2f',imStruc.currentHigh*1000));
        end
    else
        handles = updateParameters(handles,num,2);
    end
elseif strcmp(tag,'parameter3')
    num = str2double(get(handles.parameter3,'string'));
    if isnan(num)==1
        set(handles.parameter2,'string',sprintf('%0.2f',imStruc.currentThresh));
    else
        handles = updateParameters(handles,num,3);
    end
elseif strcmp(tag,'parameter4')
    num = str2double(get(handles.parameter4,'string'));
    if isnan(num)==1
        set(handles.parameter4,'string',sprintf('%0.0f',imStruc.jCurrent));
    else
        handles = updateParameters(handles,num,4);
    end   
elseif strcmp(tag,'parameter5')
    num = str2double(get(handles.parameter5,'string'));
    if isnan(num)==1
            set(handles.parameter5,'string',sprintf('%0.0f',imStruc.iCurrent));
    else
        handles = updateParameters(handles,num,5);
    end
elseif strcmp(tag,'option2')
    imStruc = get(handles.task3,'userdata');
    unitVal= get(handles.subOption3,'value');
    set(handles.prompt,'string','Click anywhere on the main axes image to measure a pixel frequency.  You may click as many pixels as you''d like to, each click will be saved in the table.  Double click on the last pixel you''d like to check to exit measuring mode.  At any time you make click any row in the table to review the pixel data.');
    [x,y] = getpts(handles.mainAxes); 
    x = round(x);
    y = round(y);
    if strcmp(imStruc.tableFreqData,'DNE')
        starti = 1;
    else
        tabdata = imStruc.tableFreqData;
        s = size(tabdata);
        starti = s(1)+1;
    end
    
    for i = 1:length(x)
       imStruc.col3Freq(i+starti-1) = 1000*imStruc.centerFreq(y(i),x(i));
       imStruc.col3Period(i+starti-1) = 1/(imStruc.centerFreq(y(i),x(i))*60);
       tabdata{i+starti-1,1} = sprintf('%0.0f',x(i)); 
       tabdata{i+starti-1,2} = sprintf('%0.0f',y(i));
       if unitVal==1
        tabdata{i+starti-1,3} = sprintf('%0.2f',imStruc.col3Period(i+starti-1));
       else
        tabdata{i+starti-1,3} = sprintf('%0.2f',imStruc.col3Freq(i+starti-1));   
       end
       tabdata{i+starti-1,4} = sprintf('%0.2f',imStruc.amplitude(y(i),x(i)));
    end
    set(handles.table,'enable','on');
    if unitVal==1
        set(handles.table,'columnname',{'x','y','Period (min)','Amplitude'});
    else
        set(handles.table,'columnname',{'x','y','Freq (mHz)','Amplitude'});
    end
    imStruc.tableFreqData = tabdata;
    set(handles.table,'data',tabdata);
    load(handles.tableProps);
    set(handles.table,'columnwidth',{tableProps.width{3},tableProps.width{3},tableProps.width{4},tableProps.width{5}});
    imStruc.jCurrent = round(x(end));
    imStruc.iCurrent = round(y(end));
    set(handles.task3,'userdata',imStruc);
    handles = updateParameters(handles,round(x(end)),4);
    handles = updateParameters(handles,round(y(end)),5);
elseif strcmp(tag,'subOption2')
    handles = updateAxes(handles);
elseif strcmp(tag,'subOption3')
    val = get(handles.subOption3,'value');
    imStruc = get(handles.task3,'userdata');
    if val==1
        handles = updateParameters(handles,(1/imStruc.currentHigh)/60,1);
        handles = updateParameters(handles,(1/imStruc.currentLow)/60,2);
        set(handles.plabel1,'string','Low Cutoff (Minutes)');
        set(handles.plabel2,'string','High Cutoff (Minutes)');
        tabdata = imStruc.tableFreqData;
        if ~strcmp(tabdata,'DNE');
            s = size(tabdata);
            for i = 1:s(1)
                tabdata{i,3} = sprintf('%0.2f',imStruc.col3Period(i)); 
            end
            set(handles.table,'data',tabdata);
            set(handles.table,'columnname',{'x','y','Period (min)','Amplitude'});
        end
    else
        handles = updateParameters(handles,imStruc.currentLow*1000,1);
        handles = updateParameters(handles,imStruc.currentHigh*1000,2);
        set(handles.plabel1,'string','Low Cutoff (mHz)');
        set(handles.plabel2,'string','High Cutoff (mHz)');
        tabdata = imStruc.tableFreqData;
        if ~strcmp(tabdata,'DNE')
            s = size(tabdata);
            for i = 1:s(1)
                tabdata{i,3} = sprintf('%0.2f',imStruc.col3Freq(i)); 
            end
            set(handles.table,'data',tabdata);
            set(handles.table,'columnname',{'x','y','Freq (mHz)','Amplitude'});
        end
    end
elseif strcmp(tag,'table')
    index = eventdata.Indices(1);
    imStruc = get(handles.task3,'userdata');
    tabdata = imStruc.tableFreqData;
    xstr = tabdata{index,1};
    ystr = tabdata{index,2};
    x = str2double(xstr);
    y = str2double(ystr);
    imStruc.jCurrent = x;
    imStruc.iCurrent = y;
    set(handles.task3,'userdata',imStruc);
    handles = updateParameters(handles,x,4);
    handles = updateParameters(handles,y,5);
elseif strcmp(tag,'slider')
    handles = move_slider(handles,1);
elseif strcmp(tag,'sliderClickR')
    handles = move_slider(handles,2);
elseif strcmp(tag,'sliderClickL')
    handles = move_slider(handles,3);
elseif strcmp(tag,'subOption1')
    sliderMenu = get(handles.subOption1,'value');
    unitVal = get(handles.subOption3,'value');
    curHigh = imStruc.currentHigh;
    curLow = imStruc.currentLow;
    if sliderMenu==1
        maxS = length(imStruc.freq);
        minS = 1;
        if unitVal==1
            index = find(imStruc.freq==curHigh);
            newIndex = maxS-index+1;
        else
            newIndex = find(imStruc.freq==curLow);
        end
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',newIndex);    
        set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
    elseif sliderMenu==2
        maxS = length(imStruc.freq);
        minS = 1;
        if unitVal==1
            index = find(imStruc.freq==curLow);
            newIndex = maxS-index+1;
        else
            newIndex = find(imStruc.freq==curHigh);
        end
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',newIndex);    
        set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
    elseif sliderMenu==3
        maxS = imStruc.maxThresh;
        minS = 0;
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',imStruc.currentThresh);    
        set(handles.slider,'sliderstep',[0.001 0.01]);
    elseif sliderMenu==4
        maxS = imStruc.sizePic(2);
        minS = 1;
        slideVal = imStruc.jCurrent;
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',slideVal);
        set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
    elseif sliderMenu==5
        maxS = imStruc.sizePic(1);
        minS = 1;
        slideVal = imStruc.iCurrent;
        set(handles.slider,'max',maxS);
        set(handles.slider,'min',minS);
        set(handles.slider,'value',slideVal);
        set(handles.slider,'sliderstep',[1/(maxS-minS) 5/(maxS-minS)]);
    end
elseif strcmp(tag,'option1')
    [handles] = turn_off_buttons(handles);
    imStruc = get(handles.task3,'userdata');
    freqMAP = imStruc.centerFreq;
    amplitude = imStruc.amplitude;
    filt1 = freqMAP>=imStruc.currentLow&freqMAP<=imStruc.currentHigh;
    filt2 = amplitude>imStruc.currentThresh;
    filt = filt1.*filt2;
    if ~isdir([imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter']);
        mkdir([imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter']);
    end
    dirpath = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter'];
    load([dirpath,handles.slash,'freqInfo.mat']);
    freqInfo.currentLow = imStruc.currentLow;
    freqInfo.currentHigh = imStruc.currentHigh;
    freqInfo.currentThresh = imStruc.currentThresh;
    freqInfo.iCurrent = imStruc.iCurrent;   
    freqInfo.jCurrent = imStruc.jCurrent;  
    save([dirpath,handles.slash,'freqInfo.mat'],'freqInfo');
    imwrite(filt,[dirpath,handles.slash,'filter.png'],'png');
    set(handles.task3,'userdata',imStruc);
    [handles] = turn_on_buttons(handles);
    set(handles.prompt,'string',sprintf('Filter saved in %s',dirpath));
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

%_____________________________________________
function [handles] = initializeALL(handles)

set(handles.subOption1,'value',1);
set(handles.subOption2,'value',1);
set(handles.subOption3,'value',1);
set(handles.subOption1,'string',{'Slider-Low Cutoff','Slider-High Cuttoff','Slider-Threshold','Slider-Pix X','Slider - Pix Y'});
set(handles.subOption2,'string',{'View-Inclusive','View-Exclusive'});
set(handles.subOption3,'string',{'Units-Minutes','Units-mHz'});
set(handles.plabel1,'string','Low Cutoff (Minutes)');
set(handles.plabel2,'string','High Cutoff (Minutes)');

set(handles.prompt,'string','Loading Data ...');
pause(0.1);
imStruc = get(handles.task3,'userdata');

handles = updateParameters(handles,(1/imStruc.currentHigh)/60,1);
handles = updateParameters(handles,(1/imStruc.currentLow)/60,2);
handles = updateParameters(handles,imStruc.currentThresh,3);
handles = updateParameters(handles,imStruc.jCurrent,4);
handles = updateParameters(handles,imStruc.iCurrent,5);
slideVal = find(imStruc.currentHigh==imStruc.freq);
newVal = length(imStruc.freq)-slideVal+1;
set(handles.slider,'max',length(imStruc.freq));
set(handles.slider,'min',1);
set(handles.slider,'value',newVal);
set(handles.slider,'sliderstep',[1/(length(imStruc.freq)-1) 5/(length(imStruc.freq)-1) ]);
imStruc.tableFreqData = 'DNE';
set(handles.task3,'userdata',imStruc);
%________________________________________
function [handles] = updateParameters(handles,num,whichP)

imStruc = get(handles.task3,'userdata');
sliderState = get(handles.subOption1,'value');
unitVal = get(handles.subOption3,'value');


if whichP==1       
        curHigh = imStruc.currentHigh;
        curLow = imStruc.currentLow;
        maxFreq = imStruc.maxFreq;
        fstep = imStruc.freqStep;
        freqarray = imStruc.freq;
        if unitVal==2
            num = num/1000;
            diffarray = abs(freqarray-num);
            minval = find(diffarray==min(diffarray));
            minval = minval(1);
            if num>curHigh
                curLow = curHigh-fstep;
                if curLow <0
                    curLow=0;
                end
            elseif num<0
                curLow=0;
            else
                curLow = freqarray(minval);        
            end
            if curLow==curHigh
                curLow=curHigh-fstep;
            end
            imStruc.currentLow = curLow;
            set(handles.parameter1,'string',sprintf('%0.2f',curLow*1000));
            if sliderState==1
                newVal = find(imStruc.freq==curLow);
                set(handles.slider,'value',newVal);
            end
        else
            num = 1/(num*60);
            diffarray = abs(freqarray-num);
            minval = find(diffarray==min(diffarray));
            minval = minval(1);
            if num>maxFreq||num<0
                curHigh = maxFreq;
            elseif num<curLow||(num>curLow&&num<=curLow+fstep)
                curHigh=curLow+fstep;
                if curHigh>maxFreq
                    curHigh=maxFreq; 
                end
            else
                curHigh=freqarray(minval);   
            end
            if curLow==curHigh
                curHigh=curLow+fstep;
            end
            imStruc.currentHigh = curHigh;
            set(handles.parameter1,'string',sprintf('%0.2f',(1/curHigh)/60));
            if sliderState==1
                val = find(imStruc.freq==curHigh);
                newVal = length(imStruc.freq)-val+1;
                set(handles.slider,'value',newVal);
            end
        end
        
elseif whichP==2
        curHigh = imStruc.currentHigh;
        curLow = imStruc.currentLow;
        maxFreq = imStruc.maxFreq;
        fstep = imStruc.freqStep;
        freqarray = imStruc.freq;
        if unitVal==1
            num = 1/(num*60);
            diffarray = abs(freqarray-num);
            minval = find(diffarray==min(diffarray));
            minval = minval(1);
            if num>curHigh||num<0
                curLow = curHigh-fstep;
                if curLow <0
                    curLow=0;
                end
            else
                curLow = freqarray(minval);     
            end
            if curLow==curHigh
                curLow=curHigh-fstep;
            end
            imStruc.currentLow = curLow;
            set(handles.parameter2,'string',sprintf('%0.2f',(1/curLow)/60));
            if sliderState==2
                val = find(imStruc.freq==curLow);
                newVal = length(imStruc.freq)-val+1;
                set(handles.slider,'value',newVal);
            end
        else
            num = num/1000;
            diffarray = abs(freqarray-num);
            minval = find(diffarray==min(diffarray));
            minval = minval(1);
            if num>maxFreq
                curHigh = maxFreq;
            elseif num<curLow
                curHigh=curLow+fstep;
                if curHigh>maxFreq
                    curHigh=maxFreq; 
                end
            else
                curHigh=freqarray(minval);          
            end
            if curLow==curHigh
                curHigh=curLow+fstep;
            end
            imStruc.currentHigh = curHigh;
            set(handles.parameter2,'string',sprintf('%0.2f',curHigh*1000));
            if sliderState==2
                newVal = find(imStruc.freq==curHigh);
                set(handles.slider,'value',newVal);
            end
        end
elseif whichP==3
        if num>imStruc.maxThresh
            imStruc.currentThresh =imStruc.maxThresh;
        elseif num<0
            imStruc.currentThresh = 0;
        else
            imStruc.currentThresh = num;
        end      
        set(handles.parameter3,'string',sprintf('%0.4f',imStruc.currentThresh));
        if sliderState==3
            set(handles.slider,'value',imStruc.currentThresh);
        end
elseif whichP==4
        maxJ= imStruc.sizePic(2);
        if num>maxJ
            imStruc.jCurrent = maxJ;
        elseif num<1
            imStruc.jCurrent = 1;
        else
            imStruc.jCurrent = round(num);
        end
        set(handles.parameter4,'string',sprintf('%0.0f',imStruc.jCurrent));
        if sliderState==4
            set(handles.slider,'value',imStruc.jCurrent);
        end
elseif whichP==5
        maxI = imStruc.sizePic(1);
        if num>maxI
            imStruc.iCurrent = maxI;
        elseif num<1
            imStruc.iCurrent = 1;
        else
            imStruc.iCurrent = round(num);
        end
        set(handles.parameter5,'string',sprintf('%0.0f',imStruc.iCurrent));
        if sliderState==5
            set(handles.slider,'value',imStruc.iCurrent);
        end
end

set(handles.task3,'userdata',imStruc);
handles = updateAxes(handles);

%_______________________________________________
function [handles] = updateAxes(handles)
[handles] = turn_off_buttons(handles);
imStruc = get(handles.task3,'userdata');
freqMAP = imStruc.centerFreq;
amplitude = imStruc.amplitude;
imStruc.currentLow;
imStruc.currentHigh;
viewVal = get(handles.subOption2,'value');
if viewVal==1
    filt1 = freqMAP>=imStruc.currentLow&freqMAP<=imStruc.currentHigh;
    filt2 = amplitude>imStruc.currentThresh;
    filt = filt1.*filt2;
else
    filt1 = freqMAP>=imStruc.currentLow&freqMAP<=imStruc.currentHigh;
    filt2 = amplitude>imStruc.currentThresh;
    filt = filt1.*filt2;
    filt = not(filt);
end
pix = imStruc.pix;
FFT = imStruc.FFT;
time = imStruc.time;
freq = imStruc.freq;
iCur = imStruc.iCurrent;
jCur = imStruc.jCurrent;
unitVal = get(handles.subOption3,'value');
set(handles.figure1,'currentAxes',handles.mainAxes);
filtMAP = freqMAP.*filt;
filtMAP = filtMAP./max(filtMAP(:));
imagesc(filtMAP,[0 1]);
colormap([0 0 0;jet(length(unique(filtMAP(:)))-1)]);
if unitVal==1
    entry1 = 'High';
    entry2 = 'Cutoff';
    entry3 = 'Low';
    entry4 = 'Cutoff';
    colorbar('Ytick',[0.0 0.05 0.95 1],'YtickLabel',{entry1,entry2,entry3,entry4},'Ydir','reverse');
else
    entry1 = 'High';
    entry2 = 'Cutoff';
    entry3 = 'Low';
    entry4 = 'Cutoff';
    colorbar('Ytick',[0.0 0.05 0.95 1],'YtickLabel',{entry4,entry3,entry2,entry1});
end

hold on;
plot(handles.mainAxes,jCur,iCur,'s','color','w','markersize',8,'markerfacecolor','k');
hold off;
set(handles.figure1,'currentAxes',handles.subAxes1);
hold off;
if unitVal==1
    plot(handles.subAxes1,1./(freq*60),FFT{iCur,jCur},'.-');
    hold on;
    plot(handles.subAxes1,1/(freqMAP(iCur,jCur)*60),amplitude(iCur,jCur),'s','color','r','markersize',5);
    hold off;
    xlabel('Period (minutes)');   
else
    plot(handles.subAxes1,freq*1000,FFT{iCur,jCur},'.-');
    hold on;
    plot(handles.subAxes1,1000*freqMAP(iCur,jCur),amplitude(iCur,jCur),'s','color','r','markersize',5);
    hold off;
    xlabel('Frequency (mHz)');
end
ylabel('FFT Amplitude');
axis tight;
set(handles.figure1,'currentAxes',handles.subAxes2);
plot(handles.subAxes2,time/60,pix{iCur,jCur},'.-');
xlabel('Time (min)');
ylabel('Pixel Intensity');
axis tight;
[handles] = turn_on_buttons(handles);
set(handles.prompt,'string','');
%_______________________________________
function [handles] = move_slider(handles,whichS,fdata)

whichP = get(handles.subOption1,'value');
slideStep = get(handles.slider,'sliderStep');
maxslide = get(handles.slider,'max');
minslide = get(handles.slider,'min');
maxMin = maxslide-minslide;
imStruc = get(handles.task3,'userdata');
unitVal = get(handles.subOption3,'value');

if whichP==1
    if unitVal==1
        val = find(imStruc.freq==imStruc.currentHigh);
        oldVal = length(imStruc.freq)-val+1;
    else
        oldVal = find(imStruc.freq==imStruc.currentLow);
    end
elseif whichP==2
    if unitVal==1
        val = find(imStruc.freq==imStruc.currentLow);
        oldVal = length(imStruc.freq)-val+1;
    else
        oldVal = find(imStruc.freq==imStruc.currentHigh);
    end    
elseif whichP==3
    oldVal = imStruc.currentThresh;
elseif whichP==4
    oldVal = imStruc.jCurrent;
elseif whichP==5
    oldVal = imStruc.iCurrent;
end

if whichS==1
    newVal = get(handles.slider,'value');
elseif whichS==2
    newVal = oldVal+slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
else
    newVal = oldVal-slideStep(1)*maxMin;
    if newVal>maxslide
        newVal=maxslide;
    end
    if newVal<minslide
        newVal=minslide;
    end
    set(handles.slider,'value',newVal);
end

if newVal==4||newVal==5
       newVal = round(newVal); 
end

if whichP==1||whichP==2
    if unitVal==1
        freqVal = length(imStruc.freq)-newVal+1;
        newVal = 1/(imStruc.freq(freqVal)*60);
    else
        newVal  = 1000*imStruc.freq(newVal);
    end
end
handles = updateParameters(handles,newVal,whichP); 


%____________________________________
function [handles] = turn_off_buttons(handles)

set(handles.function1,'enable','inactive');
set(handles.function2,'enable','inactive');
set(handles.function3,'enable','inactive');
set(handles.function4,'enable','inactive');
set(handles.option1,'enable','inactive');
set(handles.option2,'enable','inactive');
set(handles.subOption1,'enable','inactive');
set(handles.subOption2,'enable','inactive');
set(handles.subOption3,'enable','inactive');
set(handles.table,'enable','inactive');
set(handles.slider,'enable','inactive');
set(handles.sliderClickL,'enable','inactive');
set(handles.sliderClickR,'enable','inactive');
set(handles.parameter1,'enable','inactive');
set(handles.parameter2,'enable','inactive');
set(handles.parameter3,'enable','inactive');
set(handles.parameter4,'enable','inactive');
set(handles.parameter5,'enable','inactive');
set(handles.prompt,'string','Processing...');
pause(0.01);

%____________________________________
function [handles] = turn_on_buttons(handles)

set(handles.function1,'enable','on');
set(handles.function2,'enable','on');
set(handles.function3,'enable','on'); 
set(handles.function4,'enable','on');
set(handles.option1,'enable','on');
set(handles.option2,'enable','on');
set(handles.subOption1,'enable','on');
set(handles.subOption2,'enable','on');
set(handles.subOption3,'enable','on');
set(handles.table,'enable','on');
set(handles.slider,'enable','on');
set(handles.sliderClickL,'enable','on');
set(handles.sliderClickR,'enable','on');
set(handles.parameter1,'enable','on');
set(handles.parameter2,'enable','on');
set(handles.parameter3,'enable','on');
set(handles.parameter4,'enable','on');
set(handles.parameter5,'enable','on');

pause(0.01);