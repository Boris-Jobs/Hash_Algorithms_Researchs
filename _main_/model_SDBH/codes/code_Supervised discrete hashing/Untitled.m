clear; close;clc


%addpath [liblinear-1.91/windows/] % for hinge loss
dataset = 'cifar_10_gist.mat';

% prepare_dataset(dataset);

load(['C:\Users\13225\Desktop\model\【matlab】SDH\testbed\',dataset]);
traindata = double(traindata);
testdata = double(testdata);


if sum(traingnd == 0)
    traingnd = traingnd + 1;
    testgnd = testgnd + 1;
end


Ntrain = size(traindata,1);%返回所对应的行数
% Use all the training data
X1 = traindata';
X=X1(:,1:5900);
label1 = double(traingnd)';
label=label1(:,1:5900);
[L, S, B, Y, Y1, Y2, Y3, W] = RobustPCA(X, 1, 1000, label);