function [] = measurePixFrequency(hObject,handles,eventdata,extraData)


% do function
imStruc = get(handles.task3,'userdata');
imStruc.filterDefined = 0;
set(handles.task3,'userdata',imStruc);

handles = turn_off_buttons(handles);
handles = measure_frequencies(handles);
handles = turn_on_buttons(handles);
% define new control variables
tdata = get(handles.taskPanel,'userdata');
fdata = get(handles.functionPanel,'userdata');
odata = get(handles.optionPanel,'userdata');
tdata.task = tdata.task;
f = fdata(1);
p = fdata(2);
o = odata(1);
so = odata(2);
tdata.button = tdata.button;
set(handles.taskPanel,'userdata',tdata);
set(handles.functionPanel,'userdata',[f,p]);
set(handles.optionPanel,'userdata',[o,so]);

% update GUI
guidata(handles.figure1,handles);

%____________________________________
function [handles] = turn_off_buttons(handles)

set(handles.function1,'enable','off');
set(handles.function2,'enable','off');
set(handles.function3,'enable','off');
set(handles.function4,'enable','off');
set(handles.function5,'enable','off');
set(handles.prompt,'string','Processing... This may take a while.');
pause(0.01);

%____________________________________
function [handles] = turn_on_buttons(handles)
imStruc = get(handles.task3,'userdata');
set(handles.function1,'enable','on');
set(handles.function2,'enable','on');
if imStruc.filterDefined==1
   set(handles.function4,'enable','on'); 
end
set(handles.function3,'enable','on');
set(handles.function5,'enable','on');
pause(0.01);

%____________________________________
function [handles] = measure_frequencies(handles)


imStruc = get(handles.task3,'userdata');
whichInds = find(imStruc.timepointList==0);
T = imStruc.T; % number of timepoints
if T<=4
    set(handles.prompt,'string',sprintf('Cannot compute frequencies because T=%d timepoints are not sufficient for frequency definition',T));
else
    dt = imStruc.timestep*60;  %timestep in seconds
    fs = 1/dt;  % sampling frequency in Hz
    time = (0:T-1)*dt;  % time array 
    time(whichInds) = NaN;
    n = pow2(nextpow2(T));  % next power of two greater or equal to window length
    freq = linspace(0,1,n/2+1)*(fs/2);  % frequency range
    freqStep = freq(2)-freq(1);  % frequency step size
    s = size(imStruc.dilPics{1});
    pix = cell(s(1),s(2));
    FFT = cell(s(1),s(2));
    centerFreq = zeros(s(1),s(2));
    amplitude = zeros(s(1),s(2));
    
    for t = 1:T
        for i = 1:s(1)
            for j = 1:s(2)
                if isnan(time(t)) 
                    pix{i,j}(t) = NaN;      % time domain pixel intensity function
                else
                    pix{i,j}(t) = imStruc.dilPics{t}(i,j);
                end
            end
        end
        fprintf('Done t = %d\n',t);
    end
    
    for i = 1:s(1)
        for j = 1:s(2)
            sig = pix{i,j}(:)- nanmean(pix{i,j}(:));   % subtract DC offset
            test = isnan(sig);
            if sum(test)==0
                y = fft(sig,n)/T;
            else
                y = EDFT(sig,n)/T;
            end
            amparray = 2*abs(y(1:(n/2+1)));   % power spectrum amplitude 
            FFT{i,j} = amparray;
            peakval = find(amparray==max(amparray));  % index of max freq
            centerFreq(i,j) = freq(peakval(1));         % center frequency of pixel (i,j)
            amplitude(i,j) = amparray(peakval(1));      % amplitude of center frequency
        end
        fprintf('Done pixel [i,j] = [%d,%d]\n',i,j);
    end
    imStruc.fs = fs;                    % sampling frequency
    imStruc.freq = freq;                % frequency array
    imStruc.amplitude = amplitude;      % amplitude power spectra matrix  
    imStruc.centerFreq = centerFreq;    % center frequency matrix
    imStruc.pix = pix;                  % pixel intensity cell
    imStruc.time = time;                % time cell
    imStruc.maxFreq  = max(freq);
    imStruc.freqStep = freqStep;
    imStruc.FFT = FFT;
    imStruc.currentLow = 0;
    imStruc.currentHigh = imStruc.maxFreq;
    imStruc.currentThresh = 0;
    imStruc.maxThresh = max(amplitude(:));
    imStruc.iCurrent = round(s(2)/2);   % initial starting pixel i to display FFT results
    imStruc.jCurrent = round(s(1)/2);   % initial starting pixel j to display FFT results
    imStruc.maxI = s(1);
    imStruc.maxJ = s(2);
    
    freqInfo.fs = fs;                    % sampling frequency
    freqInfo.freq = freq;                % frequency array
    freqInfo.amplitude = amplitude;      % amplitude power spectra matrix  
    freqInfo.centerFreq = centerFreq;    % center frequency matrix
    freqInfo.pix = pix;                  % pixel intensity cell
    freqInfo.time = time;                % time cell
    freqInfo.maxFreq  = max(freq);
    freqInfo.freqStep = freqStep;
    freqInfo.FFT = FFT;
    freqInfo.currentLow = 0;
    freqInfo.currentHigh = imStruc.maxFreq;
    freqInfo.currentThresh = 0;
    freqInfo.maxThresh = max(amplitude(:));
    freqInfo.iCurrent = round(s(2)/2);   % initial starting pixel i to display FFT results
    freqInfo.jCurrent = round(s(1)/2);   % initial starting pixel j to display FFT results
    freqInfo.maxI = s(1);
    freqInfo.maxJ = s(2); 
    
    set(handles.function4,'enable','on');
    set(handles.prompt,'string','Analysis Complete.  You may proceed to define a filter.');
    set(handles.task3,'userdata',imStruc);
    if ~isdir([imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter']);
        mkdir([imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter']);
    end
    dirpath = [imStruc.pathB4,handles.slash,'Results',handles.slash,imStruc.whichDil,handles.slash,'Filter'];
    save([dirpath,handles.slash,'freqInfo.mat'],'freqInfo');
end
