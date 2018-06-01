function edges = findedges(adjcMatrix)
spnum = size(adjcMatrix,1);
edges=[];
for i=1:spnum
    indext=[];
    ind=find(adjcMatrix(i,:)==1);
    for j=1:length(ind)
        indj=find(adjcMatrix(ind(j),:)==1);
        indext=[indext,indj];
    end
    indext=[indext,ind];
    indext=indext((indext>i));
    indext=unique(indext);
    if(~isempty(indext))
        ed=ones(length(indext),2);
        ed(:,2)=i*ed(:,2);
        ed(:,1)=indext;
        edges=[edges;ed];
    end
end