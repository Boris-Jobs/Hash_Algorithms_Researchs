%video RobustPCA example: separates background and foreground
addpath('../');%�����ô���

% ! the movie will be downloaded from the internet !
movieFile = 'RobustPCA_video_demo.avi';


% open the movie
n_frames = 180;
movie = VideoReader(movieFile);
frate = movie.FrameRate;%֡��
height = movie.Height;
width = movie.Width;

% vectorize every frame to form matrix X
X = zeros(n_frames, height*width);%����һ����ÿһ֡Ϊ�������������,180��2304,2304=36��64
for i = (1:n_frames)
    frame = read(movie, i);
    frame = rgb2gray(frame);%ת��Ϊ�Ҷ���ɫͼ,rgbתgrayͼ�ı��ʾ���Ѱ��
    %һ����ά�ռ䵽һά�ռ��ӳ�䣬�������뵽�ľ�����Ӱ������rgb�ռ��һ������ֱ��R=G=B�����ߣ�
    %�����frame��ʵ��һ��36����64*3����RGBֵȻ��ӳ�䵽��gray�ϱ��36��64
    X(i,:) = reshape(frame,[],1);%�Զ���������������x�ĵ�i��
    %������û��ȡFֱ�Ӱ�X������F��ȥ������ȡ���ֽ⡿
end
%��ʱ��X��ÿһ�ж���������һ֡ͼ��������ĻҶ���ɫ��Ϣ
% apply Robust PCA
lambda = 1/sqrt(max(size(X)));%��RPCA��ȡ�ؼ�֡����Ҳ����ôȡ��
tic
[L,S] = RobustPCA(X, lambda/3, 10*lambda/3, 1e-5);
toc

% prepare the new movie file
vidObj = VideoWriter('RobustPCA_video_output.avi');
vidObj.FrameRate = frate;%֡��
open(vidObj);
range = 255;
map = repmat((0:range)'./range, 1, 3);%����ƽ�̱��256��3��0~1Ԫ�ط�Χ����
S = medfilt2(S, [5,1]); % median filter in time
% where each output pixel contains the median value
% in the m-by-n neighborhood
% around the corresponding pixel in the input
% image,��5��1�ٽ�ȡ��λ��/ȥ�룬SҲ���и�������ʱδ�������ͼ��

for i = (1:size(X, 1))
    %����r=size(A,1)����䷵�ص�ʱ����A������
    % c=size(A,2) ����䷵�ص�ʱ����A������
    %���Ƿ�����֡�ĸ���
    frame1 = reshape(X(i,:),height,[]);%height=36��X��һ�о���һ֡�����ھ��������֡
    frame2 = reshape(L(i,:),height,[]);%���Ⱦ���L������֡��С
    frame3 = reshape(abs(S(i,:)),height,[]);%ȥ���Ժ��S�����Ҵ�ʱȡ�˾���ֵ����������֡��С
    % median filter in space; threshold
    frame3 = (medfilt2(abs(frame3), [5,5]) > 7).*frame1;%Ϊʲôȡ5��5����ô���ģ���ȡ���������֣�����λ��Ϊ0��Ϊ��ɫ
    % stack X, L and S together
    frame = mat2gray([frame1, frame2, frame3]);%��һ������
    frame = gray2ind(frame,range);%ת��Ϊrange=255ɫ��ͼ
    frame = im2frame(frame,map);%ת��Ϊ֡
    writeVideo(vidObj,frame);
end
close(vidObj);
