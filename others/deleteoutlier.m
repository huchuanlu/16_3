function [seedlabel,salseednum] = deleteoutlier(segim,seedlabel,salseednum,seglab,para)

spnum = max(segim(:));
bands = 5;
segll = unique(segim(:,1:bands));
segrr = unique(segim(:,end-bands+1:end));
segtt = unique(segim(1:bands,:));
segbb = unique(segim(end-bands+1:end,:));
boudlabel = unique([segll;segrr;segtt;segbb]);
boudnum = length(boudlabel);
boudlab = seglab(boudlabel,:);
    
% find nearest neighbor of salseed among boundary label
nnb = [];
for jj = 1 : salseednum
    sallab = seglab(seedlabel(jj),:);
    different = sum((repmat(sallab,[boudnum,1])-boudlab).^2,2);
    nnb = [nnb;min(different)];
end
outlier = find(nnb<max(nnb)*0.2);
seedlabel(outlier) = [];
salseednum = length(seedlabel);
