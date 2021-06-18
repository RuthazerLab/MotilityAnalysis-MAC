function [sob1] = detectEdgeA(im,level,radius,min_area,maxvalue)

% Sobel edge detector  
  sh = fspecial('sobel');
  sv = -sh';  
  sob1h = conv2(im,sh,'same');
  sob1v = conv2(im,sv,'same');
  sobel_im = sqrt(sob1h.^2 + sob1v.^2);
 % thresholding the sobel image
  sob1h_thr = zeros(size(sob1h));
  sob1 = 1*(sobel_im >= level*maxvalue);
  % removing the outline border
  border = zeros(size(im));
  border(find(im<=2)) = 1;
  % Structuring element
  % A circular euclidian structuring element is used to dilate the image
  % Parameters:
 %   radius = radius of the circle
  st = zeros(2*radius+1, 2*radius+1);
  [stx,sty] = find(st==0);
  coords = [ stx sty];
  d = coords - (radius+1);
  dist = sqrt(sum(d'.^2)');
  st(find(dist<=radius))=1;
  lab_border = imdilate(border,st);
  sob1(find(lab_border==1)) = 0;
  % Connected components labelling and clearing
  %  - Removing small size componentes
  % Parameters:
  %    min_area = components whose size is below 
  %               min_area will be removed
  [sob1bw,n_ids] = bwlabel(sob1);
  for ind_id = 1:n_ids
     idd =find(sob1bw==ind_id);
     if (size(idd) < min_area)
          sob1(idd)=0;
     end
  end
  
