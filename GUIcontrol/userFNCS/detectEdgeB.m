function [Ifinal] = detectEdgeB(im,level,radius,min_area,maxvalue,scale)

im = im./maxvalue;
imnew = imresize(im,scale);
Ifinal = im2bw(imnew,level);
s = size(Ifinal);
cc = bwconncomp(Ifinal,8);
counter = 1;
check_area = 0;
for i = 1:cc.NumObjects
    meas_area = length(cc.PixelIdxList{i});
    if meas_area>min_area
        newPixlist{counter} = cc.PixelIdxList{i};
        counter = counter+1;
    end
end
cc.NumObjects = counter-1;
cc.PixelIdxList = newPixlist;
Ithresholded = zeros(s(1),s(2));
for i = 1:cc.NumObjects
    Ithresholded(cc.PixelIdxList{i}) =Ifinal(cc.PixelIdxList{i});
end
edgebw = edge(Ithresholded,'sobel');

r = radius;
st = zeros(2*r+1, 2*r+1);
[stx,sty] = find(st==0);
coords = [stx sty];
d = coords - (r+1);
dist = sqrt(sum(d'.^2)');
st(find(dist<=r))=1;

I2 = imdilate(edgebw,st);
Ifinal = Ithresholded+I2*2;
% vals = Ifinal>1;
% Ifinal(vals) = 2;
