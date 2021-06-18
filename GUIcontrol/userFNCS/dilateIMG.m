function [dilated] = dilateIMG(im,dil)

im = im>0;
r = dil;
st = zeros(2*r+1, 2*r+1);
[stx,sty] = find(st==0);
coords = [stx sty];
d = coords - (r+1);
dist = sqrt(sum(d'.^2)');
st(find(dist<=r))=1;
dilated = imdilate(im, st);