function [W, B, L, S, Y, Y1, a1] = RobustPCA(X,Y)
%{
��1��Variables��:
Y, W, B, Z
L, S, Y1, Y2, Y3, M, H

(known)inputs:F, Y
(unknown)W, B, L, S, Y1, Y2, Y3

��2��Initialize��:
Z=randn(b,N), B=sgn(Z)
S=zeros(M,N)
H=zeros(M,N)
���������ӡ����������ʼ��4������
Y1=Y2=Y3=sgn(F)/max(F�׷���, ��2*F�����/��3)
��=0.1, ��=1.25*F�׷���, ��=1.5
��1=10, ��2=1, ��3=1/sqrt(max(size(F)))

��3��repeat until convergence��:
       repeat until convergence:
         W=(BB')^-1BY
         L=Do(��2/��, X-S+Y1/��)
         S=So(��3/��, X-L+2Y1/��)
         M=Sch(J(��1HZ'B+��/2(S+H-Y2-Y3))')
         H=Sch(J(��1MB'Z+��/2(M+Y3/��))')
         Z=Sch(J(��1BM'H+��B)')
         B=sgn(WY+��1ZH'M+��Z)
       Y1=Y1+��(F-L-S)
       Y2=Y2+��(M-S)
       Y3=Y3+��(M-H)
       ��=�Ѧ�

��4��outputs��:
W, B, L, S, Y1, Y2, Y3
%}

%����ϣ�볤�ȡ�
hash_b=32;%ԭ���С�l-bits��

%��ʼ����������
[m,N] = size(X);
unobserved = isnan(X);
X(unobserved) = 0;
%��ʼ��ģ�͸�����
lambda1=0.0001;
lambda2=1;
lambda3=1/(sqrt(max(size(X))));
alpha=0.1;
mu=1.25*max(svd(X));
Y1=sign(X)/(max(max(svd(X)),max(max(abs(X)))/lambda3));
%��ʼ��B��Z
randn('seed',7);
Z=randn(hash_b,N);
B=sign(Z);
%��ʼ��S���ݶ��½�����
S=zeros(m,N);
t=1;


a1=[];
a2=[];

for iter = 1:3 %iter�ﵽ4ʱmodel�ͻ����
    W=pinv(B*B')*B*Y';
    L = Do(lambda2/mu, X - S + (1/mu)*Y1);
    
    %�ݶ��½��������ܳ���3�����Է��֣�S�Ǵ�i=1ʱ��ϡ��䵽e+05��������
    S1=S-t*(4*lambda1*S*(S'*S-B'*Z)-Y1+mu*(S+L-X));
    S=S1.*max(0,1-(lambda3*t)./abs(S1));

    Z=Sch(lambda1*B*S'*S+alpha*B);
    B1=B;
    B=sign(W*Y+lambda1*Z*S'*S+alpha*Z);
    % mu=1.5*mu;
    err = norm(B-B1, 'fro')^2;
    fprintf(1, 'iter: %04d\terr: %f\trank(L): %d\n',iter, err, rank(L));
    model=norm(Y-W'*B,'fro')^2+lambda1*norm(B'*Z-(S'*S),'fro')^2+alpha*norm(B-Z,'fro')^2+lambda2*sum(svd(L))+lambda3*norm(S,1);
    a1=[a1,model];
    a2=[a2,iter];
    if (err <=100)
        break;
    end
end
figure
plot(a2,a1);
end


function r = So(tau, X)
unobserved = isnan(X);
X(unobserved) = 0;
% shrinkage operator
r = sign(X) .* max(abs(X) - tau, 0);
end

function r = Do(tau, X)
unobserved = isnan(X);
X(unobserved) = 0;
% shrinkage operator for singular values
[U, S, V] = svd(X, 'econ');%economy size,
%For m < n, only the first m columns of V arecomputed and S is m-by-m.
r = U*So(tau, S)*V';
end

function r=Sch(X)
[~, N] = size(X);
unobserved = isnan(X);
X(unobserved) = 0;
I=eye(N);
J=I-(1/N)*ones(N,N);
product=X*J*X';
[u1,s1,v1]=svd(product,'econ');%����U=V
s1=sqrt(s1);
u=J*X'*v1/s1;
r=sqrt(N)*v1*u';
end


