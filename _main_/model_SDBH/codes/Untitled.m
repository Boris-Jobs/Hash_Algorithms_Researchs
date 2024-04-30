clear; close
%文章中的所有数据矩阵均采用【d*n】型数据大小，d为长度，n为数据个数
%m为测试数据个数
%X为训练数据，Y为训练标签，Xt为测试数据，Yt为测试标签
%A为哈希函数，W为投影矩阵，B为训练哈希码，Bt为测试哈希码，Bc为转换进制后的哈希码
dataset='cifar_10_gist.mat';
load(['C:\Users\13225\Desktop\major\SRTP模型\模型m文件\testbed\',dataset]);
traindata = double(traindata);%原始数据集【n*p】，n=59000，p=512
testdata = double(testdata);%测试数据集【n*d】，m=1000，d=512



traingnd = traingnd - 1;%所有标签【n*c】，n=59000，c=1
testgnd = testgnd - 1;%测试标签【m*c】，m=1000，c=1


X_all = traindata';%将原始训练数据转置
X_selected=X_all(:,15001:30000);%参与实验的X大小【p*n】，p=512，n=选择数据
Y_all = double(traingnd)';%将原始标签转置
Y_selected=Y_all(:,15001:30000);%参与实验的Y大小【c*n】，c=1，n=选择数据
%选择的Y大小【c*n】，c=1，n=选择数据
Xt_all=testdata';%把原始测试数据转置
Yt_all=double(testgnd)';%把原始测试标签转置

Xt_selected=Xt_all(:,1:500);%测试数据大小【p*m】，p=512，m=选择数据
Yt_selected=Yt_all(:,1:500);%测试标签【c*m】，c=1，m=选择数据

%获取模型生成的哈希码等参数：（a1为每次迭代的模型数值大小构成的数组）
[W, B_model, L, S , Y, Y1, a1] = RobustPCA(X_selected, Y_selected);
%获取普通哈希函数生成的哈希码和投影矩阵：
[B_normal, W1]=leastsquare(X_selected);



%计算模型生成哈希码的mAP：
A=(X_selected*X_selected')^-1*X_selected*B_model';
%模型哈希函数矩阵A【p*l】，A^T【l*p】
B_model=(B_model+1)/2;
Bt_model=(sign(A'*Xt_selected)+1)/2;%将模型哈希的测试数据哈希码变成0和1
%A^TX的大小和B一样【l*n】
Bc_model=compactbit(B_model')';
Btc_model=compactbit(Bt_model')';
Dh1=hammingDist(Bc_model',Btc_model');
[~,HammingRank1]=sort((Dh1'),1);
ap1=cal_map(Y_selected',Yt_selected', Dh1);



%计算最小二乘生成哈希码的mAP：
A=(X_selected*X_selected')^-1*X_selected*B_normal';
%模型哈希函数矩阵A【p*l】，A^T【l*p】
B_normal=(B_normal+1)/2;
Bt_normal=(sign(A'*Xt_selected)+1)/2;%将模型哈希的测试数据哈希码变成0和1
%A^TX的大小和B一样【l*n】
Bc_normal=compactbit(B_normal')';
Btc_normal=compactbit(Bt_normal')';
Dh2=hammingDist(Bc_normal',Btc_normal') ;%问题出在这里，全部矩阵都是255，有问题
[~,HammingRank2]=sort((Dh2'),1);
ap2=cal_map(Y_selected',Yt_selected', Dh2);


%1.【模型】完善论文、改一改模型（最小二乘……、RPCA元素、RPCA意味着什么、M和H的比较）
%1.【模型】Z、S、L的梯度下降求解（陈哲、小熊猫）

%2.【实验】（不同哈希码长度，32bit、64bit、96bit）map值、模型数值图像（次要）
%2.【实验】与最小二乘、LSH、SH、SCDH（孙、包、莫）
%2.【实验】测试不同数据集在哈希的表现（莫）








