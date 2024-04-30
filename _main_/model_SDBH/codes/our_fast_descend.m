clear; close

dataset='cifar_10_gist.mat';
load(['C:\Users\13225\Desktop\major\SRTP模型\模型m文件\testbed\',dataset]);
traindata = double(traindata);   %59000×512
testdata = double(testdata);     %1000×512



traingnd = traingnd - 1;   %59000×1
testgnd = testgnd - 1;     %1000×1


traindata_all = traindata';            %512×59000
X=traindata_all(:,20001:30000);             %512×选择数据
trainlabel_all = double(traingnd)';  %1×59000
trainlabel_all_selected=trainlabel_all(:,20001:30000);    %1×选择数据

%获取模型生成的哈希码等参数：
[W, hash_model, L, S , Y, Y1, Y2, Y3, a1, M, H] = RobustPCA(X, trainlabel_all_selected);


fs=norm(S,1)+dot(Y1,(X-L-S))+norm(X-L-S,'fro')^2;
g=diff(fs,S); %求梯度
S0=S;
eps=1e-2;
v=S;
v1=S0;
g0=subs(g,v,v1);%求[x0,y0]的梯度值
n=0;
while fs>eps && n<=1000 %梯度值大于0或者n小于等于1000时，进行循环
    d=-g0;
    fval=subs(f,v,v1);%求[x0,y0]的梯度值
    ft=subs(f,v,v1+t*d);
    dft=diff(ft);
    v1=v1+double(solve(dft))*d; %求下一个迭代点
    g0=subs(g,v,v1);
    n=n+1;
    if (n==0) || (mod(n, 10) == 0) || (fval <=eps)
        fprintf(1, 'iter: %04d\terr: %f\n', ...
            n, fval);
    end
end
disp(v1) %最优解
disp(fval) %f在v1处的最优值
