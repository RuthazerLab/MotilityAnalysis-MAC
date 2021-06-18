function [timeArea,timeDiffs,picArea,picDiffs,diffList] = sortIncludedPoints(timepointList,imStruc)

T = imStruc.T;

counter = 1;
timeArea = NaN;
for i = 1:T
   if timepointList(i)==1
      timeArea(counter) = (i-1)*imStruc.timestep; 
      picArea{counter} = imStruc.dilPics{i};
      counter = counter+1;
   end
end
if isnan(timeArea)
    picArea = NaN;
end
counter = 1;
timeDiffs = NaN;
for i = 1:T-1
   if timepointList(i)==1&&timepointList(i+1)==1
      timeDiffs(counter) = i*imStruc.timestep;
      picDiffs(counter).firstPic = imStruc.dilPics{i};
      picDiffs(counter).secondPic = imStruc.dilPics{i+1};
      diffList(i) = 1;
      counter = counter+1;
   else
      diffList(i) = 0;
   end
end

if isnan(timeDiffs)
   picDiffs = NaN;
   diffList = NaN;
end