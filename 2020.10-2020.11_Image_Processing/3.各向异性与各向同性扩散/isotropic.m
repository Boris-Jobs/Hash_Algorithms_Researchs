clc,clear

p1=imread('quan.jpg');%原图
subplot(221),imshow(p1,[]),title('【original】');
p3=imnoise(p1,'gaussian',0,0.1);%原图加高斯噪声
[m,n,o]=size(p1);
error1=norm(double(p3(m,n,1))-double(p1(m,n,1)),'fro')/norm(double(p1(m,n,1)),'fro')+norm(double(p3(m,n,2))-double(p1(m,n,2)),'fro')/norm(double(p1(m,n,2)),'fro')+norm(double(p3(m,n,3))-double(p1(m,n,3)),'fro')/norm(double(p1(m,n,3)),'fro');
subplot(223),imshow(p3,[]),title({'【gaussian】',['error=',num2str(error1),'【compared to "original"】']});
x=zeros(m+2,n+2,o);
L=100;%迭代次数

x(2:m+1,2:n+1,1:o)=p1;
x2=x;
for k=1:L
    for o=1:3
        for i=1:m
            for j=1:n
                x(i+1,j+1,o)=x2(i+1,j+1,o)+(x2(i+1,j,o)+x2(i+1,j+2,o)+x2(i,j+1,o)+x2(i+2,j+1,o)-4*x2(i+1,j+1,o))/50;
                %参数——steplength=1/50——k=1
            end
        end
    end
    x2=x;
end
x3=x(2:m+1,2:n+1,1:o);
error5=norm(double(x3(m,n,1))-double(p1(m,n,1)),'fro')/norm(double(p1(m,n,1)),'fro')+norm(double(x3(m,n,2))-double(p1(m,n,2)),'fro')/norm(double(p1(m,n,2)),'fro')+norm(double(x3(m,n,3))-double(p1(m,n,3)),'fro')/norm(double(p1(m,n,3)),'fro');
subplot(222),imshow(uint8(x3)),title({'【diffusion】',['error=',num2str(error5),'【compared to original】']});

x(2:m+1,2:n+1,1:o)=p3;
x2=x;
for k=1:L
    for o=1:3
        for i=1:m
            for j=1:n
                x(i+1,j+1,o)=x2(i+1,j+1,o)+(x2(i+1,j,o)+x2(i+1,j+2,o)+x2(i,j+1,o)+x2(i+2,j+1,o)-4*x2(i+1,j+1,o))/50;
                %参数——steplength=1/50——k=1
            end
        end
    end
    x2=x;
end
x3=x(2:m+1,2:n+1,1:o);
error2=norm(double(x3(m,n,1))-double(p1(m,n,1)),'fro')/norm(double(p1(m,n,1)),'fro')+norm(double(x3(m,n,2))-double(p1(m,n,2)),'fro')/norm(double(p1(m,n,2)),'fro')+norm(double(x3(m,n,3))-double(p1(m,n,3)),'fro')/norm(double(p1(m,n,3)),'fro');
subplot(224),imshow(uint8(x3)),title({'【denoising】',['error=',num2str(error2),'【compared to "original"】'],['error=',num2str(abs(error2-error5)),'【compared to "diffusion"】']});
