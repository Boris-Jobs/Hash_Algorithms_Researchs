clc
clear

lambda=240;
riven=imread('riven.jpg');
subplot(1,3,1),imshow(riven),title('original');
h=fspecial('gaussian',10,200);
blur=imfilter(riven,h,'circular');
%blur=imnoise(riven,'gaussian',0.002);
subplot(1,3,2),imshow(uint8(blur)),title('imfilter');
[m,n,o]=size(riven);
H=psf2otf(h, [m,n,o]);
HTH=conj(H).*H;
HTg=conj(H).*fft2(blur);
riven1=255*ifft2(HTg./(HTH+lambda));
subplot(1,3,3),imshow(uint8(riven1)),title('result');

% originalRGB = imread('riven.jpg');
% subplot(1,2,1)
% imshow(originalRGB)
% h = fspecial('motion', 50, 45);%创建一个滤波器
% filteredRGB = imfilter(originalRGB, h);
% subplot(1,2,2),imshow(filteredRGB)