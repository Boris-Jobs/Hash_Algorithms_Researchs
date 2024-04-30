workingDir = 'VIDEO_SAL_MAP';
video_input = VideoReader('clip_3.avi');

imageNames = dir(fullfile(workingDir,'*.png'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'sal_map.avi'));
outputVideo.FrameRate = video_input.FrameRate;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo)

out_sal_vid = VideoReader(fullfile(workingDir,'sal_map.avi'));

ii = 1;
while hasFrame(out_sal_vid)
   mov(ii) = im2frame(readFrame(out_sal_vid));
   ii = ii+1;
end

f = figure;
f.Position = [150 150 out_sal_vid.Width out_sal_vid.Height];

ax = gca;
ax.Units = 'pixels';
ax.Position = [0 0 out_sal_vid.Width out_sal_vid.Height];

image(mov(1).cdata,'Parent',ax)
axis off

movie(mov,1,out_sal_vid.FrameRate)
