function [L, S, B] = RobustPCA(X,tol, max_iter, Y, Y1, Y2, Y3, lambda1, lambda2, lambda3,alpha,mu)
% - X 是将要被分解的N×M的数据矩阵
%   X can also contain NaN's for unobserved values
% - lambda - regularization parameter, default = 1/sqrt(max(N,M))
% - mu - the augmented lagrangian parameter, default = 10*lambda
% - tol - reconstruction error tolerance, default = 1e-6
% - max_iter - maximum number of iterations, default = 1000
%X=L+S, lambda, Y, mu, ρ=1.5
%当前模型的X就是Cifar 10数据集的特征矩阵

[M, N] = size(X);%这是特征矩阵的大小
unobserved = isnan(X);%返回一个与A相同维数的数组
%若A的元素为NaN（非数值），在对应位置上返回逻辑1（真），否则返回逻辑0（假）
X(unobserved) = 0;
normX = norm(X, 'fro');

if nargin < 2
    tol = 1e-6;
end
if nargin < 3
    max_iter = 1000;
end
if nargin < 5
    Y1=zeros(M,N);
end
if nargin < 6
    Y2=zeros(M,N);
end
if nargin < 7
    Y3=zeros(M,N);
end
if nargin < 8
    lambda1=1;
end
if nargin < 9
    lambda2=1;
end
if nargin < 10
    lambda3=1;
end
if nargin < 11
    alpha=1;
end
if nargin < 12
    mu=1;
end
%以下为1000×n大小的矩阵
S = zeros(M, N);
M=zeros(M,N);
N=zeros(M,N);
%以下为L×n大小的矩阵
L=32;
B = zeros(L,N);
Z = zeros(L,N);
%以下为投影矩阵
%其他矩阵
I=eye(N);
J=I-(1/N)*eye(N);


for iter = (1:max_iter)
    W=(B*B')^-1*B*Y';
    L = Do(lambda2/mu, X - S + (1/mu)*Y1);
    S = So(lambda3/mu, X - L + (2/mu)*Y1);
    B=sign(W*Y+lambda1*Z*H'*M+alpha*Z);
    Z=Sch(J*(lambda1*B*M'*H+alpha*B));
    M=Sch(J*(lambda1*H*Z'*B+mu/2*(S+H-Y2-Y3)));
    H=Sch(J*(lambda1*M*B'*Z+mu/2*(M+Y3/mu)));
    mu=1.5*mu;%【原程序增加项，加了这项以后速度加了个数量级，但sparse就不那么明显】
    err = norm(Z, 'fro') / normX;%用误差值的二范数来衡量分解程度的
    if (iter == 1) || (mod(iter, 10) == 0) || (err < tol)
        fprintf(1, 'iter: %04d\terr: %f\trank(L): %d\tcard(S): %d\n', ...
            iter, err, rank(L), nnz(S(~unobserved)));
        %Number of nonzero matrix elements
    end%第一次||每10次||误差满足时，fprintf一次
    
    if (err < tol)
        break;
    end
    
end
end

function r = So(tau, X)
% shrinkage operator
r = sign(X) .* max(abs(X) - tau, 0);%返回X的阈值函数取值
%S单变量时就是取这个
end

function r = Do(tau, X)
% shrinkage operator for singular values
[U, S, V] = svd(X, 'econ');%economy size,
%For m < n, only the first m columns of V arecomputed and S is m-by-m.
r = U*So(tau, S)*V';
%L单变量时就是取这个
end

function r=Sch(X)
[U,~,V]=svd(X,'econ');
r=sqrt(N)*V*U';
end
