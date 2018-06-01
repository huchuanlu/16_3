function lbp_vals = computeLBP(input_im,STA,spnum)

[A,~] = LBP_uniform(rgb2gray(input_im));
lbp_vals=zeros(spnum,1,59);
% STA=regionprops(segim,'all');
for i=1:spnum
    temp=A(STA(i).PixelIdxList);
    lbp_vals(i,1,:)=hist(temp,1:59);
end
lbp_vals=reshape(lbp_vals,spnum,59);  