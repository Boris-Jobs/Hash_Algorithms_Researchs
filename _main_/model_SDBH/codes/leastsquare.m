function [B, W]=leastsquare(X)
%【哈希码长度】
hash_b=32;%原文中【l-bits】

%初始化特征矩阵
[m,~]=size(X);

randn('seed',7);
lambda=1;
W=randn(m,hash_b);
B=sign(W'*X);
unobserved = isnan(X);
X(unobserved) = 0;
I=eye(m);
a1=[];
a2=[];
for iter=1:4
    W=(X*X'+ lambda*I)^(-1)*X*B';%W有一些列为0？
    B1=B;
    B=sign(W'*X);
    error=norm(B-B1,'fro')^2;
    fprintf(1, 'iter: %04d\t err: %f\n', iter, error);
    model=norm(B-W'*X,'fro')^2+lambda*norm(W,'fro')^2;
    a1=[a1,model];
    a2=[a2,iter];
%     if (error ==0)
%         break;
%     end
end
figure
plot(a2,a1);
end