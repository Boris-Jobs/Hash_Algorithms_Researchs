%video RobustPCA example: separates background and foreground
addpath('../');%这个怎么解读

% ! the movie will be downloaded from the internet !
movieFile = 'RobustPCA_video_demo.avi';


% open the movie
n_frames = 180;
movie = VideoReader(movieFile);
frate = movie.FrameRate;%帧率
height = movie.Height;
width = movie.Width;

% vectorize every frame to form matrix X
X = zeros(n_frames, height*width);%返回一个以每一帧为行向量的零矩阵,180×2304,2304=36×64
for i = (1:n_frames)
    frame = read(movie, i);
    frame = rgb2gray(frame);%转化为灰度颜色图,rgb转gray图的本质就是寻找
    %一个三维空间到一维空间的映射，最容易想到的就是射影（即过rgb空间的一个点向直线R=G=B做垂线）
    %这里的frame其实是一个36×（64*3）的RGB值然后映射到了gray上变成36×64
    X(i,:) = reshape(frame,[],1);%自动适配行数、赋给x的第i行
    %【这里没有取F直接把X赋给了F拿去特征提取并分解】
end
%此时的X是每一行都被赋予了一帧图像的拉长的灰度颜色信息
% apply Robust PCA
lambda = 1/sqrt(max(size(X)));%见RPCA提取关键帧论文也是这么取的
tic
[L,S] = RobustPCA(X, lambda/3, 10*lambda/3, 1e-5);
toc

% prepare the new movie file
vidObj = VideoWriter('RobustPCA_video_output.avi');
vidObj.FrameRate = frate;%帧率
open(vidObj);
range = 255;
map = repmat((0:range)'./range, 1, 3);%复制平铺变成256×3的0~1元素范围矩阵
S = medfilt2(S, [5,1]); % median filter in time
% where each output pixel contains the median value
% in the m-by-n neighborhood
% around the corresponding pixel in the input
% image,在5×1临近取中位数/去噪，S也会有负数，此时未参与输出图像

for i = (1:size(X, 1))
    %其中r=size(A,1)该语句返回的时矩阵A的行数
    % c=size(A,2) 该语句返回的时矩阵A的列数
    %就是返回了帧的个数
    frame1 = reshape(X(i,:),height,[]);%height=36，X的一行就是一帧，现在就是在输出帧
    frame2 = reshape(L(i,:),height,[]);%低秩矩阵L拉成了帧大小
    frame3 = reshape(abs(S(i,:)),height,[]);%去噪以后的S，并且此时取了绝对值，并拉成了帧大小
    % median filter in space; threshold
    frame3 = (medfilt2(abs(frame3), [5,5]) > 7).*frame1;%为什么取5，5是怎么来的？提取出显著部分，其他位置为0，为黑色
    % stack X, L and S together
    frame = mat2gray([frame1, frame2, frame3]);%归一化操作
    frame = gray2ind(frame,range);%转化为range=255色的图
    frame = im2frame(frame,map);%转化为帧
    writeVideo(vidObj,frame);
end
close(vidObj);
