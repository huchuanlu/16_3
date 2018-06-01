function diffaversal = propogationprocess_single(para,imname,oh,ow,width,segim,seglab,seedlabel)

alpha = 0.1;
beta = 0.01;
theta = 10;
mu = 0.01;
spnum = max(segim(:));
map1 = im2double(imread(fullfile(para.omrootdir,para.omdir{1},[imname(1:end-4) para.suffix{1}])));
map1 = map1(width+1:oh-width,width+1:ow-width);
   
% average sal
aversal = computeaversal(segim,spnum,map1);

seglab = [seglab aversal];
diffaversal = randomwalk(segim,seglab,seedlabel,aversal,theta,mu);
% % diffaversal = randomwalk_new(segim,seglab,seedlabel,aversal,alpha,beta,theta);
