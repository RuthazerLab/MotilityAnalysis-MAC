% this function updates the tableProps.mat and tableProps.txt files for
% customizing the table column widths for different screen resolutions

direc = '/Users/Robert/Documents/GUI/GUIcontrol/';
fileMAT = 'tableProps.mat';
fileTXT = 'tableProps.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%change these to existing or new index of tableProps.txt file
index = 23;  % index in text file
widthNum = 110;   % width of column for index
tag = 'BAtrendCol3';  % name of entry to be used in functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist([direc,fileMAT])
load([direc,fileMAT]);
L = length(tableProps.width);
    if index>L+1
        error(sprintf('Index is too large, please change to %d or less',L+1));
    else
        tableProps.width{index} = widthNum;
        tableProps.widthName{index} = tag;
        save([direc,fileMAT],'tableProps');
    end
else
   error('The tableProps.mat file is missing, cannot continue.'); 
end

fid = fopen([direc,fileTXT],'wt');
fprintf(fid,'%8s| %5s| %50s|\n\n','Index','Width','Tag');
for i = 1:length(tableProps.width)
fprintf(fid,'%8d| %5d| %50s|\n\n',i,tableProps.width{i},tableProps.widthName{i});    
end
fclose(fid);