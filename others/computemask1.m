function mask = computemask1(segim,segsal,regions_pixel)
spnum = max(segim(:));
mask = zeros(size(segim,1),size(segim,2));
for i = 1 : spnum
    pixind = regions_pixel(i).PixelIdxList;
    mask(pixind) = segsal(i);
end
mask = mat2gray(mask);