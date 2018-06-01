function segim1 = segmentimage(para,input_im,imname)

segim1 = cell(para.multiscalenum,1);
for jj = 1 : para.multiscalenum
    [segim,spnum] = slicmex(input_im,para.seg(jj,1),para.seg(jj,2));
    segim = double(segim);
    spnum = double(spnum);
    segim = segim+1;
    segoutdir = fullfile(para.segdir,num2str(jj));
    filename = fullfile(segoutdir,[imname(1:end-4) '.mat']);
    save (filename,'segim'); 
    segim1{jj} = segim;
end