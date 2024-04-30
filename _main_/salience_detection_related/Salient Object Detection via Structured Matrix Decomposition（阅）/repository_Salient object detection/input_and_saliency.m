clear all;clc
close all;
input_video = VideoReader('clip_3.avi');
saliency_video =  VideoReader('VIDEO_SAL_MAP/sal_map.avi');
% figure(1);
skipFrames = 20;

% for x = 1:skipFrames:max(input_video.NumberOfFrames, saliency_video.NumberOfFrames)
%     if x <= input_video.NumberOfFrames
%         img = read(input_video,x);
%         subplot(2,2,1), p1 = imshow(img);
%         title('Input frames');
%     end
%     if x <= saliency_video.NumberOfFrames
%         f = read(saliency_video,x);
%         subplot(2,2,2), p2 = imshow(f);
%         title('Saliency map');
%         subplot(2,2,3), p3 = imcontour(rgb2gray(f));
%         title('Contour map');
%         bw_s = im2bw(rgb2gray(f),0.4);
%         colorsalmap(:,:,1) = double(img(:,:,1)).*double(bw_s);
%         colorsalmap(:,:,2) = double(img(:,:,2)).*double(bw_s);
%         colorsalmap(:,:,3) = double(img(:,:,3)).*double(bw_s);
%         subplot(2,2,4), p4 = imshow(uint8(colorsalmap));
%         title('Saliency in video');
%     end
%     refreshdata(p2)
%     refreshdata(p4)
%     refreshdata(p1)
% end

for x = 1:skipFrames:max(input_video.NumberOfFrames, saliency_video.NumberOfFrames)
    img = read(input_video,x);
    f = read(saliency_video,x);
    bw_s = im2bw(rgb2gray(f),0.4);
    colorsalmap(:,:,1) = double(img(:,:,1)).*double(bw_s);
    colorsalmap(:,:,2) = double(img(:,:,2)).*double(bw_s);
    colorsalmap(:,:,3) = double(img(:,:,3)).*double(bw_s);
    subplot(2,2,1), p1 = imshow(img);
    title('Input frames');
    subplot(2,2,2), p2 = imshow(f);
    title('Saliency map');
    subplot(2,2,3), p3 = imcontour(rgb2gray(f));
    title('Contour map');
    subplot(2,2,4), p4 = imshow(uint8(colorsalmap));
    title('Saliency in video');
end
pause
close all
