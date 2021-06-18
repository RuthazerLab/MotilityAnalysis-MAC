function [handles] = blankTheAxes(handles,whichaxis)
blankpic = zeros(100,100);
if whichaxis==1
set(handles.figure1,'currentaxes',handles.mainAxes);  %blank the initial axes
subimage(blankpic,handles.cmap_blank);
box on;
set(gca,'xtick',[]);
set(gca,'ytick',[]);
elseif whichaxis==2
set(handles.figure1,'currentaxes',handles.subAxes1);  %blank the sub axes1
subimage(blankpic,handles.cmap_blank);
box on;
set(gca,'xtick',[]);
set(gca,'ytick',[]);
else
set(handles.figure1,'currentaxes',handles.subAxes2);  %blank the sub axes2
subimage(blankpic,handles.cmap_blank);
box on;
set(gca,'xtick',[]);
set(gca,'ytick',[]);
end
