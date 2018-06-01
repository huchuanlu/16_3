function W = geodesicaffmtx(segim,seglab,theta)

spnum = max(segim(:));
% adjcMatrix = GetAdjMatrix(segim, spnum);
adjcMatrix=AdjcProcloop(segim,spnum);
edges = findedges(adjcMatrix);
bdIds = GetBndPatchIds(segim);
adjcMatrix_lb = LinkBoundarySPs(adjcMatrix, bdIds);
adjcMatrix_lb = adjcMatrix_lb-diag(diag(adjcMatrix_lb));
colDistM = GetDistanceMatrix(seglab);
edgeWeight = colDistM(adjcMatrix_lb > 0);
% clip_value = getparameter(adjcMatrix_lb,spnum,colDistM);
% edgeWeight = max(0, edgeWeight - clip_value);
geoDist = graphallshortestpaths(sparse(adjcMatrix_lb), 'directed', false, 'Weights', edgeWeight);
weights = [];
for i = 1 : length(edges)
    temp =  geoDist(edges(i,1),edges(i,2));
    weights = [weights;temp];
end
weights = exp(-theta*weights);
W = adjacency(edges,weights,spnum);
% W = (W-min(W(:)))/(max(W(:))-min(W(:)));
% W = (W-min(W(:)))/(max(W(:))-min(W(:)));