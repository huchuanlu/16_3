function A = normalize(B)
A = (B-min(B(:)))/(max(B(:))-min(B(:)));