function diffaversal = propogationprocess_mul(para,imname,oh,ow,width,segim,seglab,seedlabel)

spnum = max(segim(:));
theta = 10;
alpha = 0.1;
beta = 0.01;
mu = 0.01;
map1 = im2double(imread(fullfile(para.mapdir{1},[imname(1:end-4) para.suffix{1}])));
map2 = im2double(imread(fullfile(para.mapdir{2},[imname(1:end-4) para.suffix{2}])));
map3 = im2double(imread(fullfile(para.mapdir{3},[imname(1:end-4) para.suffix{3}])));
map1 = map1(width+1:oh-width,width+1:ow-width);
map2 = map2(width+1:oh-width,width+1:ow-width);
map3 = map3(width+1:oh-width,width+1:ow-width);
combmap = (map1+map2+map3)/3;
   
% average sal
aversal = computeaversal(segim,spnum,combmap);
seglab = [seglab aversal];

diffaversal = randomwalk(segim,seglab,seedlabel,aversal,theta,mu);

