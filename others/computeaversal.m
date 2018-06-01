function aver = computeaversal(segim,spnum,mask)
aver = zeros(spnum,1);
for jj = 1 : spnum
    ind = find(segim==jj);
    aver(jj) = sum(mask(ind))/length(ind);
end