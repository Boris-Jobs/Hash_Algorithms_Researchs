function [L, S, B, Y, Y1, Y2, Y3, W] = RobustPCA(X,tol, max_iter,Y,Y1,Y2,Y3,lambda1,lambda2,lambda3,alpha,mu)
% - X �ǽ�Ҫ���ֽ��N��M�����ݾ���
%   X can also contain NaN's for unobserved values
% - lambda - regularization parameter, default = 1/sqrt(max(N,M))
% - mu - the augmented lagrangian parameter, default = 10*lambda
% - tol - reconstruction error tolerance, default = 1e-6
% - max_iter - maximum number of iterations, default = 1000
%X=L+S, lambda, Y, mu, ��=1.5
%��ǰģ�͵�X����Cifar 10���ݼ�����������

[P, N] = size(X);%������������Ĵ�С
unobserved = isnan(X);%����һ����A��ͬά��������
%��A��Ԫ��ΪNaN������ֵ�����ڶ�Ӧλ���Ϸ����߼�1���棩�����򷵻��߼�0���٣�
X(unobserved) = 0;
normX = norm(X, 'fro');

if nargin < 2
    tol=1e-6;
end
if nargin < 3
    max_iter=1000;
end
if nargin < 5
    Y1=zeros(P,N);
end
if nargin < 6
    Y2=zeros(P,N);
end
if nargin < 7
    Y3=zeros(P,N);
end
if nargin < 8
    lambda1=1;
end
if nargin < 9
    lambda2=2;
end
if nargin < 10
    lambda3=0.5;
end
if nargin < 11
    alpha=1;
end
if nargin < 12
    mu=1;
end
%����Ϊ1000��n��С�ľ���
S = zeros(P, N);
M=zeros(P, N);
H=zeros(P, N);
%����ΪL��n��С�ľ���
l=32;
B=zeros(l,N);
Z=zeros(l,N);
%����ΪͶӰ����
%��������
I=eye(N);
J=I-(1/N)*ones(N,N);


for iter = (1:max_iter)
    W=pinv(B*B')*B*Y';
    L = Do(lambda2/mu, X - S + (1/mu)*Y1);
    S = So(lambda3/mu, X - L + (2/mu)*Y1);
    B=sign(W*Y+lambda1*Z*H'*M+alpha*Z);
    Z=Sch(J*(lambda1*B*M'*H+alpha*B)');
    M=Sch(J*(lambda1*H*Z'*B+mu/2*(S+H-Y2-Y3))');
    H=Sch(J*(lambda1*M*B'*Z+mu/2*(M+Y3/mu))');
    mu=10*mu;%��ԭ������������������Ժ��ٶȼ��˸�����������sparse�Ͳ���ô���ԡ�
    err = norm(Y-W'*B, 'fro')^2+lambda1*norm(B'*Z-M'*H,'fro')^2+alpha*norm(B-Z,'fro')^2+mu/2*(norm(X-L-S,'fro')^2+norm(M-S,'fro')^2+norm(M-H,'fro')^2);
    if (iter == 1) || (mod(iter, 10) == 0) || (err < tol)
        fprintf(1, 'iter: %04d\terr: %f\trank(L): %d\tcard(S): %d\n', ...
            iter, err, rank(L), nnz(S(~unobserved)));
        %Number of nonzero matrix elements
    end
    
    if (err < tol)
        break;
    end
    
end
end

function r = So(tau, X)
unobserved = isnan(X);
X(unobserved) = 0;
% shrinkage operator
r = sign(X) .* max(abs(X) - tau, 0);%����X����ֵ����ȡֵ
%S������ʱ����ȡ���
end

function r = Do(tau, X)
unobserved = isnan(X);
X(unobserved) = 0;
% shrinkage operator for singular values
[U, S, V] = svd(X, 'econ');%economy size,
%For m < n, only the first m columns of V arecomputed and S is m-by-m.
r = U*So(tau, S)*V';
%L������ʱ����ȡ���
end

function r=Sch(X)
[~, N] = size(X);
unobserved = isnan(X);
X(unobserved) = 0;
[U,~,V]=svd(X,'econ');
r=sqrt(N)*V*U';
end
