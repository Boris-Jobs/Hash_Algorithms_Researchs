clc;clear;
close all;

% Add path of the video file - CAS Grad Research Lab File Directory
% addpath(genpath(fullfile('C:\Users\raviraj4\Downloads\ERB3_Stimuli','ERB3_Stimuli')));

%% Path settings
inputImgPath = 'INPUT_FRAMES';                 % input image path
resSalPath = 'VIDEO_SAL_MAP';                     % result path

if ~exist(inputImgPath, 'file')
    mkdir(inputImgPath);
end

if ~exist(resSalPath, 'file')
    mkdir(resSalPath);
end
% addpath

vid = VideoReader('clip6_.avi');
n = vid.NumberOfFrames;

% Creating the frames from the video
k = 1;
cd ./INPUT_FRAMES;
pwd

for i = 1:1:n
    frames = read(vid,i);
    imwrite(frames,['Image' num2str(k,'%03d'), '.jpg']);
    k = k+1;
end
cd ..
