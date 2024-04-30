clc;clear;
close all;

% Add path of the video file
addpath(genpath('Dependencies'));

%% Path settings
% ====== For video frames ======
% inputImgPath = 'INPUT_FRAMES';                 % input image path
% resSalPath = 'VIDEO_SAL_MAP';                     % result path


% ====== For image frames ======
inputImgPath = 'INPUT_IMG';
resSalPath = 'SAL_MAP';

if ~exist(inputImgPath, 'file')
    mkdir(inputImgPath);
end

if ~exist(resSalPath, 'file')
    mkdir(resSalPath);
end

%% ====== Convert video into frames ======
% vid = VideoReader('clip_6.avi'); 
% n = vid.NumberOfFrames;
% 
% % Creating the frames from the video
% k = 1;
% 
% for i = 1:1:n
%     frames = read(vid,i);
%     inpPath = fullfile(inputImgPath, strcat(['Image' num2str(k,'%03d'), '.jpg']));
%     imwrite(frames,inpPath);
%     k = k+1;
% end

%% Parameter settings
paras.alpha = 1.1;
paras.beta = 0.35;   
paras.delta = 0.05;
setting.postProc = true; % perform the context-based propagation technique metioned in Sec. 4.1 (Step 4). 

%% Calculate saliency using Structured Matrix Fractorization (SMF)
imgFiles = imdir(inputImgPath);

skip_frames = 1;
for indImg = 1:skip_frames:length(imgFiles)    
    % read image
    imgPath = fullfile(inputImgPath, imgFiles(indImg).name);
    img.RGB = imread(imgPath);
    img.name = imgPath((strfind(imgPath,'\')+1):end);
    
    % calculate saliency map via structured matrix decomposition
    salMap = ComputeSaliency(img, paras, setting);
    if(mod(indImg, 1) == 0)
        sal_figure = figure(2);
        subplot(1,2,1);imshow(img.RGB,[]);title('Input RGB Image');
        subplot(1,2,2);imshow(salMap,[]);title('Saliency Map of Our SMD Method');
        pause;
        % close(sal_figure)
    end
        
    % save saliency map    
    salPath = fullfile(resSalPath, strcat(img.name(1:end-4), '.png'));  
    % imwrite(salMap,salPath);
    
    fprintf('The saliency map: %s is saved in the file: SAL_MAP \n', img.name);
    fprintf('%s/%s images have been processed ... Press any key to continue ...\n', num2str(indImg), num2str(length(imgFiles)) );   
    close all;    
end

%% Evaluation
gtPath = 'GROUND_TRUTH';  
gtSuffix = '.png';
resPath = 'results';
if ~exist(resPath,'file')
    mkdir(resPath);
end

% compute Precison-recall curve
[rec, pre] = DrawPRCurve(resSalPath, '.png', gtPath, gtSuffix, true, true, 'r');
PRPath = fullfile(resPath, ['PR.mat']);
save(PRPath, 'rec', 'pre');
fprintf('The precison-recall curve is saved in the file: %s \n', resPath);

% compute ROC curve
thresholds = [0:1:255]./255;
[TPR, FPR] = CalROCCurve(resSalPath, '.png', gtPath, gtSuffix, thresholds, 'b');    
ROCPath = fullfile(resPath, ['ROC.mat']);
save(ROCPath, 'TPR', 'FPR');
fprintf('The ROC curve is saved in the file: %s \n', resPath);

% compute F-measure curve
setCurve = true;
[meanP, meanR, meanF] = CalMeanFmeasure(resSalPath, '.png', gtPath, gtSuffix, setCurve, 'g');
FmeasurePath = fullfile(resPath, ['FmeasureCurve.mat']);
save(FmeasurePath, 'meanF');
fprintf('The F-measure curve is saved in the file: %s \n', resPath);

% compute MAE
MAE = CalMeanMAE(resSalPath, '.png', gtPath, gtSuffix);
MAEPath = fullfile(resPath, ['MAE.mat']);
save(MAEPath, 'MAE');
fprintf('MAE: %s\n', num2str(MAE'));

% compute WF
Betas = [1];
WF = CalMeanWF(resSalPath, '.png', gtPath, gtSuffix, Betas);
WFPath = fullfile(resPath, ['WF.mat']);
save(WFPath, 'WF');
fprintf('WF: %s\n', num2str(WF'));

% compute AUC
AUC = CalAUCScore(resSalPath, '.png', gtPath, gtSuffix);
AUCPath = fullfile(resPath, ['AUC.mat']);
save(AUCPath, 'AUC');
fprintf('AUC: %s\n', num2str(AUC'));

% compute Overlap ratio
setCurve = false;
overlapRatio = CalOverlap_Batch(resSalPath, '.png', gtPath, gtSuffix, setCurve, '0');
overlapFixedPath = fullfile(resPath, ['ORFixed.mat']);
save(overlapFixedPath, 'overlapRatio');
fprintf('overlapRatio: %s\n', num2str(overlapRatio'));
