function seedlabel = findseedlabel(para,imname,segim,node,nodecenter,ih,iw)
% ini_SOD;
seedpos = zeros(length(node),2);
seedpos(:,1) = round(nodecenter(:,2));
seedpos(:,2) = round(nodecenter(:,1));
seedmap = zeros(ih,iw);
for ff = 1 : length(node)
    sind = sub2ind(size(seedmap),seedpos(ff,1),seedpos(ff,2)); 
    seedmap(sind) =1;
end
[seedlabel seedind] = unique(segim.*seedmap);
seedlabel = seedlabel(2:end);
% save seed label(segment label)
filename = fullfile(para.seedlabeldir,[imname(1:end-4) '.mat']);
save(filename,'seedlabel');