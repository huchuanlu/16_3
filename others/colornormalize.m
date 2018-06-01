function imcolor = colornormalize(imcolor)
% color: N*P, N->pixel number, P->feature dimension
imcolor(:,1) = (imcolor(:,1)-min(imcolor(:,1)))/(max(imcolor(:,1))-min(imcolor(:,1)));
imcolor(:,2) = (imcolor(:,2)-min(imcolor(:,2)))/(max(imcolor(:,2))-min(imcolor(:,2)));
imcolor(:,3) = (imcolor(:,3)-min(imcolor(:,3)))/(max(imcolor(:,3))-min(imcolor(:,3)));
