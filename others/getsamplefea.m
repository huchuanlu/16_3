function [posfea,negfea,posind,negind] = getsamplefea(para,segim,segrgb,initialmap)

segsal = cell(para.multiscalenum,1);
posfea = cell(para.multiscalenum,1);
negfea = cell(para.multiscalenum,1);
posind = cell(para.multiscalenum,1);
negind = cell(para.multiscalenum,1);
for jj = 1 : para.multiscalenum
    region_pixel = regionprops(segim{jj},'PixelIdxList');
    nseg = max(segim{jj}(:));
    tempsal = zeros(nseg,1);
    for kk = 1 : nseg
        pixind = region_pixel(kk).PixelIdxList;
        tempsal(kk) = mean(initialmap(pixind));
    end
    tempsal = mat2gray(tempsal);
    segsal{jj} = tempsal;
        
    th1 = max(tempsal)*para.thresh1;
    th2 = max(tempsal)*para.thresh2;
    posind{jj} = find(tempsal >= th1);
    negind{jj} = find(tempsal < th1);
        
    posfea{jj} = segrgb{jj}(posind{jj},:);
    negfea{jj} = segrgb{jj}(negind{jj},:);
end