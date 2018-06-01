function [texton] = BuildHistograms(para,center,samplefeature,dictionary)
% ndata : number of intersting points
% SIFTprop 4 * ndata
% SIFTfeature ndata * 58 --> SIFT feature

dictionarySize = size(dictionary,1);
ndata = size(samplefeature,1);
texton.data = zeros(ndata,1);
texton.x = center(:,1);
texton.y = center(:,2);

dist_mat = sp_dist2(samplefeature, dictionary);
[sort_dist,sort_ind] = sort(dist_mat,2);

data = cell(ndata,1);
for i = 1 : ndata
    data{i} = sort_ind(i,1:para.wordnum);
end
texton.data = data;