function diffiltermask = refinement(diffmask)

diffiltermask= guidedfilter(diffmask,diffmask,7,0.1);
diffiltermask = (diffiltermask-min(diffiltermask(:)))/(max(diffiltermask(:))-min(diffiltermask(:)));
