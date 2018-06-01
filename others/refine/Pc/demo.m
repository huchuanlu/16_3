function demo()
im1=imread('0008.jpg');
im2=imread('0009.jpg');
im3=imread('0010.jpg');
d1=im2-im1;
figure,
subplot(1,2,1)
imshow(im);
subplot(1,2,2)
imshow(BW);